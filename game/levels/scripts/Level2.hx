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
var haxen:FlxSprite;
var haxen_pos:Int;
var op_attacking:Bool;
var hands:FlxTypedGroup<FlxSprite>;
var tick = 0;
var max_tick = 150;

function onCreate(event:CreateEvent)
{
	lvl = null;

	max_tick = 150;

	if (event.state == 'level2')
	{
		lvl = new LevelModule('level2');
		FlxG.camera.fade(FlxScriptedColor.BLACK, 1, true, () -> {});

		var lvl2_bg_sky:FlxSprite;
		var lvl2_bg_skyGrad:FlxSprite;
		var lvl2_bg_ground:FlxSprite;

		lvl2_bg_sky = new FlxSprite();
		lvl2_bg_sky.loadGraphic(lvl.getGeneralAsset('sky'));
		lvl2_bg_sky.screenCenter();

		lvl2_bg_skyGrad = new FlxSprite();
		lvl2_bg_skyGrad.loadGraphic(lvl.getGeneralAsset('sky-gradient'));
		lvl2_bg_skyGrad.screenCenter();

		lvl2_bg_ground = new FlxSprite();
		lvl2_bg_ground.loadGraphic(lvl.getGeneralAsset('ground'));
		lvl2_bg_ground.scale.set(.75, .75);
		lvl2_bg_ground.updateHitbox();
		lvl2_bg_ground.screenCenter();
		lvl2_bg_ground.y += (lvl2_bg_ground.height / 4);

		haxen = new FlxSprite();
		haxen.loadGraphic(lvl.getHaxenAsset('idle'));
		haxen.scale.set(lvl2_bg_ground.scale.x - .25, lvl2_bg_ground.scale.y - .25);

		var op:FlxSprite;
		op = new FlxSprite();
		op.loadGraphic(lvl.getGeneralAsset('op'));
		op.scale.set(.75, .75);
		op.updateHitbox();
		op.screenCenter();
		op.y += op.height / 10;
		var op_resting_YPos = op.getPosition().y;
		op.y = FlxG.height * 2;

		hands = new FlxTypedGroup();

		LevelStateBase.instance.pauseText.text += 'Art: Sphis\n';
		LevelStateBase.instance.pauseText.text += 'Programming: Sphis\n';

		BlankState.instance.add(lvl2_bg_sky);
		BlankState.instance.add(lvl2_bg_skyGrad);

		BlankState.instance.add(op);

		BlankState.instance.add(lvl2_bg_ground);

		BlankState.instance.add(haxen);
		BlankState.instance.add(hands);

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

	if (event.state == 'level2')
	{
		haxen.updateHitbox();
		haxen.screenCenter();
		haxen.y += (haxen.height * 2.5);
		switch (haxen_pos)
		{
			case 1:
				haxen.x += (haxen.width * 2);
			case -1:
				haxen.x -= (haxen.width * 2);
		}

		if (Controls.getControlPressed('game_left') && !LevelStateBase.instance.level_paused)
		{
			haxen.loadGraphic(lvl.getHaxenAsset('left'));
		}

		if (Controls.getControlPressed('game_right') && !LevelStateBase.instance.level_paused)
		{
			haxen.loadGraphic(lvl.getHaxenAsset('right'));
		}

		if (Controls.getControlJustReleased('game_left') && !LevelStateBase.instance.level_paused)
		{
			haxen_pos -= 1;
			haxen_pos = (haxen_pos < -1) ? -1 : haxen_pos;

			haxen.loadGraphic(lvl.getHaxenAsset('idle'));
			FlxG.sound.play(Paths.getSoundPath('player_move', 'levels/assets'));
		}

		if (Controls.getControlJustReleased('game_right') && !LevelStateBase.instance.level_paused)
		{
			haxen_pos += 1;
			haxen_pos = (haxen_pos > 1) ? 1 : haxen_pos;

			haxen.loadGraphic(lvl.getHaxenAsset('idle'));
			FlxG.sound.play(Paths.getSoundPath('player_move', 'levels/assets'));
		}

		if (op_attacking && !LevelStateBase.instance.level_paused)
		{
			if ((tick >= max_tick && !FlxG.random.bool(FlxG.random.float(0, 10))) && hands.members.length < 5)
			{
				var newTickMin = 0;
				newTickMin = 125 - (25 * hands.members.length);

				tick = FlxG.random.int(newTickMin, max_tick);
				trace('spawn lvl 2 hand');

				var hand = new FlxSprite();
				hand.loadGraphic(lvl.getHandAsset('hand'), true, 160, 160);
				hand.animation.add('closed', [0], 12);
				hand.animation.add('open', [0, 0, 1, 1, 2, 2, 3, 4, 4], 12, false);
				hand.animation.play('closed');
				hand.scale.set(haxen.scale.x, haxen.scale.y);
				hand.updateHitbox();
				hand.update(0);
				hand.setPosition(haxen.x, haxen.y);
				hand.alpha = 0;

				FlxTween.tween(hand, {alpha: 1, y: hand.y - (hand.height * 2)}, .25, {
					ease: FlxEase.sineOut,
					onComplete: twn ->
					{
						hand.animation.play('open');
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

		if (Controls.getControlJustReleased('ui_leave') && LevelStateBase.instance.level_paused)
		{
			FlxG.camera.fade(FlxScriptedColor.BLACK, 1, false, () ->
			{
				FlxG.switchState(() -> new DesktopPlay());
			});
		}
	}
}
