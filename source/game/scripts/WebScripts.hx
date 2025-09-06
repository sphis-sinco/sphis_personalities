package game.scripts;

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
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

class WebScripts
{
	static var desktopMain:DesktopMain = null;
	static var haxenIdleStates = [
		Paths.getImagePath('desktop/haxen/idle-left'),
		Paths.getImagePath('desktop/haxen/idle-right')
	];

	static var moving:Bool = false;

	static var scanlines:FlxSprite;
	static var acceptedStates = ['desktop-main'];

	static var desktopPlay:DesktopPlay;

	public static function onCreate(event:CreateEvent)
	{
		desktopMain = null;
		moving = false;
		if (event.state == 'desktop-main')
			desktopMain = DesktopMain.instance;

		scanlines = new FlxSprite();
		scanlines.loadGraphic(Paths.getImagePath('LCD/scanlines'));
		scanlines.screenCenter();

		if (acceptedStates.contains(event.state))
			FlxG.state.add(scanlines);
		if (event.state == 'desktop-play')
		{
			desktopPlay = DesktopPlay.instance;

			desktopPlay.levels.push('level1');
			desktopPlay.levels.push('level2');

			desktopPlay.reloadLevels();
		}
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
		if (scanlines != null)
		{
			scanlines.alpha = FlxG.random.float(0.05, 0.1);
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
		if (Mouse.pressed && Mouse.state == MouseStates.CAN_SELECT)
		{
			Mouse.setMouseState(MouseStates.SELECTED);
		}
	}
}
