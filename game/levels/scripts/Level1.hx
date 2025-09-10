import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.desktop.DesktopPlay;
import game.levels.LevelModule;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedColor;

var lvl:LevelModule;
var level_paused:Bool;
var lvl1_bg_sky:FlxSprite;
var lvl1_bg_ground:FlxSprite;
var haxen:FlxSprite;
var haxen_pos:Int;
var op:FlxSprite;
var op_attacking:Bool;
var hands:FlxTypedGroup<FlxSprite>;
var pauseBG:FlxSprite;
var tick = 0;

function onCreate(event:CreateEvent)
{
	level_paused = false;

	FlxTimer.globalManager.active = !level_paused;
	FlxTween.globalManager.active = !level_paused;

	if (event.state == 'level1')
	{
		lvl = new LevelModule(event.state);
		FlxG.camera.fade(FlxScriptedColor.BLACK, 1, true, () -> {});

		lvl1_bg_sky = new FlxSprite();
		lvl1_bg_sky.loadGraphic(lvl.getGeneralAsset('sky'));
		lvl1_bg_sky.screenCenter();

		lvl1_bg_ground = new FlxSprite();
		lvl1_bg_ground.loadGraphic(lvl.getGeneralAsset('ground'));
		lvl1_bg_ground.screenCenter();

		haxen = new FlxSprite();
		haxen.loadGraphic(lvl.getHaxenAsset('idle'));
		haxen.screenCenter();
		haxen.y += (haxen.height / 4);

		op = new FlxSprite();
		op.loadGraphic(lvl.getGeneralAsset('op'));
		op.screenCenter();
		op.y -= op.height / 10;
		var op_resting_YPos = op.getPosition().y;
		op.y = FlxG.height * 2;

		hands = new FlxTypedGroup();

		pauseBG = new FlxSprite();
		pauseBG.makeGraphic(FlxG.width, FlxG.height, FlxScriptedColor.BLACK);
		pauseBG.screenCenter();

		BlankState.instance.add(lvl1_bg_sky);

		BlankState.instance.add(op);

		BlankState.instance.add(lvl1_bg_ground);

		BlankState.instance.add(haxen);
		BlankState.instance.add(hands);

		BlankState.instance.add(pauseBG);

		op_attacking = false;
		FlxTween.tween(op, {y: op_resting_YPos}, 2, {
			ease: FlxEase.sineOut,
			onComplete: twn ->
			{
				if (tick < 175)
					tick = FlxG.random.int(175, 200);
				op_attacking = true;
			}
		});

		haxen_pos = 0;
	}
}

function onUpdate(event:UpdateEvent)
{
	if (tick == null)
		tick = -1;
	tick += 1;

	FlxG.watch.addQuick('tick', tick);

	if (event.state == 'level1')
	{
		haxen.screenCenter();
		haxen.y += (haxen.height / 2);
		switch (haxen_pos)
		{
			case 1:
				haxen.x += haxen.width;
			case -1:
				haxen.x -= haxen.width;
		}

		if (Controls.getControlPressed('game_left') && !level_paused)
		{
			haxen.loadGraphic(lvl.getHaxenAsset('left'));
		}

		if (Controls.getControlPressed('game_right') && !level_paused)
		{
			haxen.loadGraphic(lvl.getHaxenAsset('right'));
		}

		if (Controls.getControlJustReleased('game_left') && !level_paused)
		{
			haxen_pos -= 1;
			haxen_pos = (haxen_pos < -1) ? -1 : haxen_pos;

			haxen.loadGraphic(lvl.getHaxenAsset('idle'));
			FlxG.sound.play(Paths.getSoundPath('player_move', 'levels/assets'));
		}

		if (Controls.getControlJustReleased('game_right') && !level_paused)
		{
			haxen_pos += 1;
			haxen_pos = (haxen_pos > 1) ? 1 : haxen_pos;

			haxen.loadGraphic(lvl.getHaxenAsset('idle'));
			FlxG.sound.play(Paths.getSoundPath('player_move', 'levels/assets'));
		}

		pauseBG.alpha = (level_paused) ? 0.5 : 0.0;

		if (op_attacking && !level_paused)
		{
			if ((tick >= 200 && !FlxG.random.bool(FlxG.random.float(0, 10))) && hands.members.length < 3)
			{
				var newTickMin = 0;

				switch (hands.members.length)
				{
					case 3:
						newTickMin = 0;
					case 2:
						newTickMin = 50;
					case 1:
						newTickMin = 125;
					case 0:
						newTickMin = 175;
				}

				tick = FlxG.random.int(newTickMin, 300);
				trace('spawn lvl 1 hand');

				var hand = new FlxSprite();
				hand.loadGraphic(lvl.getHandAsset('clench'));
				hand.setPosition(haxen.x, haxen.y);
				hand.alpha = 0;

				FlxTween.tween(hand, {alpha: 1, y: hand.y - (hand.height * 2)}, .25, {
					ease: FlxEase.sineOut,
					onComplete: twn ->
					{
						new FlxTimer().start(.25, tmr ->
						{
							FlxTween.tween(hand, {y: haxen.y}, .25, {
								ease: FlxEase.sineIn,
								onComplete: twn ->
								{
									FlxG.sound.play(Paths.getSoundPath('damage_enemy', 'levels/assets'));
									new FlxTimer().start(.25, tmr ->
									{
										FlxTween.tween(hand, {alpha: 0}, .25, {
											ease: FlxEase.sineOut,
											onComplete: twn ->
											{
												hand.destroy();
												hands.members.remove(hand);
											}
										});
									});
								},
								onUpdate: twn ->
								{
									if (hand.overlaps(haxen))
									{
										FlxG.sound.play(Paths.getSoundPath('damage_player', 'levels/assets'));
										FlxG.switchState(() -> new DesktopPlay());
									}
								}
							});
						});
					}
				});

				hands.add(hand);
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

			FlxTimer.globalManager.active = !level_paused;
			FlxTween.globalManager.active = !level_paused;
		}
	}
}
