import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var desktopMain:DesktopMain = null;
var moving:Bool = false;

function onCreate(event:CreateEvent)
{
	desktopMain = null;
	if (moving)
	{
		if (event.state == 'desktop-play') {}
		else
		{
			moving = false;
		}
	}

	if (event.state == 'desktop-main')
		desktopMain = DesktopMain.instance;
}

function onUpdate(event:UpdateEvent)
{
	if (desktopMain != null && event.state == 'desktop-main')
	{
		if (!moving)
		{
			desktopMain.option_play.alpha = 0.5;
			desktopMain.option_options.alpha = 0.5;
		}

		if (Mouse.overlaps(desktopMain.option_play))
		{
			if (!moving)
				desktopMain.option_play.alpha = 1;

			if (Mouse.justReleased && !moving)
			{
				FlxTimer.globalManager.clear();
				desktopMain.haxen_changeState('accept');
				moving = true;
				desktopMain.haxen.x -= (desktopMain.haxen.width / 10);
				desktopMain.haxen.y -= (desktopMain.haxen.height / 20);

				FlxTween.tween(desktopMain.haxen, {alpha: 1, y: FlxG.height + desktopMain.haxen.height}, 1, {
					ease: FlxEase.sineInOut,
					startDelay: 0.5,
					onComplete: tween ->
					{
						FlxG.switchState(() -> new DesktopPlay());
					}
				});

				FlxTween.tween(desktopMain.option_play, {alpha: 1, y: FlxG.height + desktopMain.option_play.height}, 1, {
					ease: FlxEase.sineInOut,
					startDelay: 0.1,
				});
				FlxTween.tween(desktopMain.option_options, {alpha: 1, y: FlxG.height + desktopMain.option_options.height}, 1, {
					ease: FlxEase.sineInOut
				});
			}
		}
		else if (Mouse.overlaps(desktopMain.option_options))
		{
			if (!moving)
				desktopMain.option_options.alpha = 0.25;

			if (Mouse.pressed && !moving)
			{
				desktopMain.option_options.alpha = 0.125;
			}
		}
	}
}
