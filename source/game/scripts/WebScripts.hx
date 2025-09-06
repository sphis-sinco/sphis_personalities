import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.Mouse;
import game.MouseStates;
import game.Paths;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.desktop.DesktopPlay;
import game.scripts.ScriptManager;
import game.scripts.events.AddedEvent;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

class WebScripts
{
	static var hisHead:FlxSprite;
	static var transitioning = false;
	static var moving:Bool = false;
	static var desktopMain:DesktopMain = null;
	static var haxenIdleStates = [];
	static var scanlineLayerOne:FlxSprite;
	static var scanlineLayerTwo:FlxSprite;
	static var scanlineAcceptedStates = ['desktop-main', 'desktop-play'];
	static var scanlineAngle = FlxG.random.float(0, 360);
	static var desktopPlay:DesktopPlay;
	static var leftArrow:FlxSprite;
	static var rightArrow:FlxSprite;

	public static function onCreate(event:CreateEvent)
	{
		if (event.state == 'z-easter-egg')
		{
			hisHead = new FlxSprite();
			hisHead.loadGraphic(Paths.getImagePath('desktop/easterEgg/hisHead'));
			FlxG.state.add(hisHead);
		}
		desktopMain = null;
		if (event.state == 'desktop-main')
			desktopMain = DesktopMain.instance;

		var previousY = 0.0;
		desktopMain = null;
		if (moving)
		{
			if (event.state == 'desktop-play')
			{
				for (obj in DesktopPlay.instance.levelsGrp.members)
				{
					previousY = obj.levelIcon.y;
					obj.levelIcon.y = -FlxG.height;
					FlxTween.tween(obj, {y: previousY}, 1, {ease: FlxEase.sineInOut});
				}
				for (obj in DesktopPlay.instance.levelsTextGrp.members)
				{
					previousY = obj.y;
					obj.y = -FlxG.height;
					FlxTween.tween(obj, {y: previousY}, 1, {ease: FlxEase.sineInOut});
				}
			}
			else
			{
				moving = false;
			}
		}
		if (event.state == 'desktop-main')
			desktopMain = DesktopMain.instance;
		scanlineLayerOne = new FlxSprite();
		scanlineLayerOne.loadGraphic(Paths.getImagePath('LCD/scanlines'));
		scanlineLayerOne.screenCenter();
		scanlineLayerOne.scrollFactor.set(0, 0);
		scanlineLayerTwo = new FlxSprite();
		scanlineLayerTwo.loadGraphic(Paths.getImagePath('LCD/scanlines'));
		scanlineLayerTwo.screenCenter();
		scanlineLayerTwo.scrollFactor.set(0, 0);
		if (scanlineAcceptedStates.contains(event.state))
		{
			switch (event.state)
			{
				case 'desktop-main':
					DesktopMain.instance.scanlineLayer.add(scanlineLayerOne);
					DesktopMain.instance.scanlineLayer.add(scanlineLayerTwo);
				case 'desktop-play':
					DesktopPlay.instance.scanlineLayer.add(scanlineLayerOne);
					DesktopPlay.instance.scanlineLayer.add(scanlineLayerTwo);
			}
		}
		if (event.state == 'desktop-play')
		{
			desktopPlay = DesktopPlay.instance;
			desktopPlay.levels.push('level1');
			desktopPlay.levels.push('level2');
			desktopPlay.reloadLevels();
		}
		if (event.state == 'desktop-play')
		{
			if (leftArrow == null)
			{
				leftArrow = new FlxSprite();
				leftArrow.loadGraphic(Paths.getImagePath('levels/desktop-icons/select-arrow'));
				leftArrow.flipX = true;

				leftArrow.scale.set(.25, .25);
				leftArrow.updateHitbox();

				leftArrow.screenCenter(XY);
				leftArrow.x = 32;

				leftArrow.scrollFactor.set(0, 0);
			}
			if (rightArrow == null)
			{
				rightArrow = new FlxSprite();
				rightArrow.loadGraphic(Paths.getImagePath('levels/desktop-icons/select-arrow'));

				rightArrow.scale.set(.25, .25);
				rightArrow.updateHitbox();

				rightArrow.scrollFactor.set(0, 0);
			}

			if ((ScriptManager.isWeb && moving)
				|| (!ScriptManager.isWeb && ScriptManager.getVariable('game/desktop/options/DesktopMainOptions.hx', 'moving') == true))
			{
				leftArrow.alpha = 0;
				rightArrow.alpha = 0;

				FlxTween.tween(leftArrow, {alpha: 1});
				FlxTween.tween(rightArrow, {alpha: 1});
			}

			FlxG.state.add(leftArrow);
			FlxG.state.add(rightArrow);
		}
		if (FlxG.keys.justReleased.ESCAPE && event.state == 'z-easter-egg')
		{
			FlxG.switchState(() -> new DesktopMain());
		}
		if (!transitioning && (FlxG.keys.justReleased.F1 || (FlxG.keys.pressed.SHIFT && FlxG.keys.justReleased.ONE)))
		{
			if (event.state != 'z-easter-egg')
			{
				transitioning = true;

				if (event.state == 'desktop-main')
				{
					var state = DesktopMain.instance;
					if (!ScriptManager.isWeb)
						ScriptManager.setVariable('game/desktop/options/DesktopMainOptions.hx', 'moving', true);
					else
						moving = true;

					FlxTween.tween(state.haxen, {alpha: 0}, 1, {
						onComplete: _ ->
						{
							FlxG.switchState(() -> new BlankState('z-easter-egg'));
						}
					});
					FlxTween.tween(state.option_play, {alpha: 0});
					FlxTween.tween(state.option_options, {alpha: 0});
				}
				else if (event.state == 'desktop-play')
				{
					var state = DesktopPlay.instance;

					for (obj in state.levelsGrp)
						FlxTween.tween(obj, {alpha: 0});
					for (obj in state.levelsTextGrp)
						FlxTween.tween(obj, {alpha: 0});

					FlxTimer.wait(1, () ->
					{
						FlxG.switchState(() -> new BlankState('z-easter-egg'));
					});
				}
				else
					FlxG.switchState(() -> new BlankState('z-easter-egg'));
			}
		}
	}

	public static function onAdded(event:AddedEvent)
	{
		haxenIdleStates.push(Paths.getImagePath('desktop/haxen/idle-left'));
		haxenIdleStates.push(Paths.getImagePath('desktop/haxen/idle-right'));
	}

	public static function onUpdate(event:UpdateEvent)
	{
		if (desktopMain != null && event.state == 'desktop-main')
		{
			desktopMain.haxen.alpha = 0.75;
			if (Mouse.overlaps(desktopMain.haxen))
			{
				desktopMain.haxen.alpha = 1;
				if (Mouse.pressed)
					Mouse.setMouseState(MouseStates.SELECTED);
				if (Mouse.justReleased && haxenIdleStates.contains(desktopMain.haxen.graphic.key))
				{
					desktopMain.haxen_changeState('boop');
					new FlxTimer().start(1, function(tmr)
					{
						desktopMain.haxen_idle();
					});
				}
			}
		}
		if (desktopMain != null && event.state == 'desktop-main')
		{
			desktopMain.option_play.alpha = 0.5;
			desktopMain.option_options.alpha = 0.5;
			if (Mouse.overlaps(desktopMain.option_play))
			{
				desktopMain.option_play.alpha = 1;
				if (Mouse.justReleased && !moving)
				{
					FlxTimer.globalManager.clear();
					desktopMain.haxen_changeState('accept');
					moving = true;
					desktopMain.haxen.x -= (desktopMain.haxen.width / 10);
					desktopMain.haxen.y -= (desktopMain.haxen.height / 20);
					FlxTween.tween(desktopMain.haxen, {y: FlxG.height + desktopMain.haxen.height}, 1, {
						ease: FlxEase.sineInOut,
						startDelay: 0.5,
						onComplete: tween ->
						{
							FlxG.switchState(() -> new DesktopPlay());
						}
					});
					FlxTween.tween(desktopMain.option_play, {y: FlxG.height + desktopMain.option_play.height}, 1, {ease: FlxEase.sineInOut, startDelay: 0.1,});
					FlxTween.tween(desktopMain.option_options, {y: FlxG.height + desktopMain.option_options.height}, 1, {ease: FlxEase.sineInOut});
				}
			}
			else if (Mouse.overlaps(desktopMain.option_options))
			{
				desktopMain.option_options.alpha = 0.25;
				if (Mouse.pressed && !moving)
				{
					desktopMain.option_options.alpha = 0.125;
				}
			}
		}
		if (scanlineLayerOne != null)
		{
			scanlineAngle += (1 / FlxG.random.int(10, 100));
			scanlineLayerOne.angle = scanlineAngle;
			scanlineLayerOne.alpha = FlxG.random.float(0, 0.2);
			scanlineLayerTwo.angle = scanlineAngle + 90;
			scanlineLayerTwo.alpha = scanlineLayerOne.alpha;
		}
		if (event.state == 'desktop-play')
		{
			leftArrow.scale.set(.25, .25);
			rightArrow.scale.set(.25, .25);
			if (Controls.getControlPressed('ui_left'))
			{
				if (DesktopPlay.instance.curSel > 0)
					leftArrow.scale.set(.3, .15);
				else
					leftArrow.scale.set(.15, .3);
			}
			if (Controls.getControlPressed('ui_right'))
			{
				if (DesktopPlay.instance.curSel < DesktopPlay.instance.levels.length - 1)
					rightArrow.scale.set(.3, .15);
				else
					rightArrow.scale.set(.15, .3);
			}
			rightArrow.screenCenter(XY);
			rightArrow.x = FlxG.width - rightArrow.width - 32;
		}
		Mouse.setMouseState(MouseStates.IDLE);
		if (event.state == 'desktop-main')
		{
			if (Mouse.overlaps(DesktopMain.instance.option_play))
				Mouse.setMouseState(MouseStates.CAN_SELECT);
			if (Mouse.overlaps(DesktopMain.instance.haxen))
				Mouse.setMouseState(MouseStates.CAN_SELECT);
			if (Mouse.overlaps(DesktopMain.instance.option_options))
				Mouse.setMouseState(MouseStates.CANT_SELECT);
		}
		if (event.state == 'desktop-play')
		{
			Mouse.setMouseState(MouseStates.BLANK);
		}
		if (Mouse.pressed && Mouse.state == MouseStates.CAN_SELECT)
		{
			Mouse.setMouseState(MouseStates.SELECTED);
		}
	}
}
