import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.desktop.DesktopPlay;
import game.desktop.play.LevelModule;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedColor;

var level_one:LevelModule;
var is_level_one:Bool;
var level_paused:Bool;
var level_one_bg_sky:FlxSprite;
var level_one_bg_ground:FlxSprite;
var level_one_haxen:FlxSprite;
var level_one_op:FlxSprite;
var level_one_op_attacking:Bool;
var level_one_hands:FlxTypedGroup<FlxSprite>;
var pauseBG:FlxSprite;
var level_one_tick = 0;

function onCreate(event:CreateEvent)
{
	is_level_one = (event.state == 'level1');
	level_paused = false;
	if (is_level_one)
	{
		level_one = new LevelModule(event.state);
		FlxG.camera.fade(FlxScriptedColor.BLACK, 1, true, () -> {});

		level_one_bg_sky = new FlxSprite();
		level_one_bg_sky.loadGraphic(level_one.getGeneralAsset('sky'));
		level_one_bg_sky.screenCenter();

		level_one_bg_ground = new FlxSprite();
		level_one_bg_ground.loadGraphic(level_one.getGeneralAsset('ground'));
		level_one_bg_ground.screenCenter();

		level_one_haxen = new FlxSprite();
		level_one_haxen.loadGraphic(level_one.getHaxenAsset('idle'));
		level_one_haxen.screenCenter();
		level_one_haxen.y += (level_one_haxen.height / 4);

		level_one_op = new FlxSprite();
		level_one_op.loadGraphic(level_one.getGeneralAsset('op'));
		level_one_op.screenCenter();
		level_one_op.y -= level_one_op.height / 10;
		var op_resting_YPos = level_one_op.getPosition().y;
		level_one_op.y = FlxG.height * 2;

		level_one_hands = new FlxTypedGroup();

		pauseBG = new FlxSprite();
		pauseBG.makeGraphic(FlxG.width, FlxG.height, FlxScriptedColor.BLACK);
		pauseBG.screenCenter();

		BlankState.instance.add(level_one_bg_sky);

		BlankState.instance.add(level_one_op);

		BlankState.instance.add(level_one_bg_ground);

		BlankState.instance.add(level_one_haxen);
		BlankState.instance.add(level_one_hands);

		BlankState.instance.add(pauseBG);

		level_one_op_attacking = false;
		FlxTween.tween(level_one_op, {y: op_resting_YPos}, 2, {
			ease: FlxEase.sineOut,
			onComplete: twn ->
			{
				if (level_one_tick < 175)
					level_one_tick = FlxG.random.int(175, 200);
				level_one_op_attacking = true;
			}
		});
	}
}

function onUpdate(event:UpdateEvent)
{
	if (level_one_tick == null)
		level_one_tick = -1;
	level_one_tick += 1;

	FlxG.watch.addQuick('level_one_tick', level_one_tick);

	if (is_level_one)
	{
		level_one_haxen.screenCenter();
		level_one_haxen.y += (level_one_haxen.height / 2);

		pauseBG.alpha = (level_paused) ? 0.5 : 0.0;

		if (level_one_op_attacking && !level_paused)
		{
			if ((level_one_tick >= 200 && !FlxG.random.bool(FlxG.random.float(0, 10))) && level_one_hands.members.length < 3)
			{
				level_one_tick = FlxG.random.int(0, 200);
				trace('spawn lvl 1 hand');

				var hand = new FlxSprite();
				hand.loadGraphic(level_one.getHandAsset('clench'));
				hand.setPosition(level_one_haxen.x, level_one_haxen.y);
				hand.alpha = 0;

				FlxTween.tween(hand, {alpha: 1, y: hand.y - (hand.height * 2)}, 1, {
					onComplete: twn ->
					{
						new FlxTimer().start(1, tmr ->
						{
							FlxTween.tween(hand, {y: level_one_haxen.y}, 1, {
								ease: FlxEase.sineInOut,
								onComplete: twn ->
								{
									new FlxTimer().start(1, tmr ->
									{
										FlxTween.tween(hand, {alpha: 0}, 1, {
											onComplete: twn ->
											{
												hand.destroy();
												level_one_hands.members.remove(hand);
											}
										});
									});
								}
							});
						});
					}
				});

				level_one_hands.add(hand);
			}
		}

		if (Controls.getControlJustReleased('ui_leave') && level_paused)
		{
			FlxG.camera.fade(FlxScriptedColor.BLACK, 1, false, () ->
			{
				FlxG.switchState(() -> new DesktopPlay());
			});
		}
		if (Controls.getControlJustReleased('game_pause'))
		{
			level_paused = !level_paused;
		}
	}
}
