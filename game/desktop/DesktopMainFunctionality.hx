import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var moving:Bool = false;

function onCreate(event:CreateEvent)
{
	moving = true;
	if (event.state == 'desktop-main')
	{
		var startingYPositions = [
			DesktopMain.instance.haxenStartingYPosition,
			DesktopMain.instance.option_play.getPosition().y,
			DesktopMain.instance.option_options.getPosition().y
		];

		DesktopMain.instance.haxen.y = FlxG.height + DesktopMain.instance.haxen.height;
		DesktopMain.instance.option_play.y = FlxG.height + DesktopMain.instance.option_play.height;
		DesktopMain.instance.option_options.y = FlxG.height + DesktopMain.instance.option_options.height;

		DesktopMain.instance.haxen.alpha = 0;
		DesktopMain.instance.option_play.alpha = 0;
		DesktopMain.instance.option_options.alpha = 0;

		FlxTween.tween(DesktopMain.instance.haxen, {alpha: 0.75, y: startingYPositions[0]}, 1, {
			ease: FlxEase.sineInOut,
			startDelay: 0.5,
			onComplete: _ ->
			{
				moving = false;
			}
		});

		FlxTween.tween(DesktopMain.instance.option_play, {alpha: 0.5, y: startingYPositions[1]}, 1, {
			ease: FlxEase.sineInOut,
			startDelay: 0.1,
		});
		FlxTween.tween(DesktopMain.instance.option_options, {alpha: 0.5, y: startingYPositions[2]}, 1, {
			ease: FlxEase.sineInOut
		});
	}
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-main')
	{
		if (!moving)
		{
			DesktopMain.instance.option_play.alpha = 0.5;
			DesktopMain.instance.option_options.alpha = 0.5;
		}

		if (Mouse.overlaps(DesktopMain.instance.option_play))
		{
			if (!moving)
				DesktopMain.instance.option_play.alpha = 1;

			if (Mouse.justReleased && !moving)
			{
				FlxTimer.globalManager.clear();
				DesktopMain.instance.haxen_changeState('accept');
				moving = true;
				DesktopMain.instance.haxen.x -= (DesktopMain.instance.haxen.width / 10);
				DesktopMain.instance.haxen.y -= (DesktopMain.instance.haxen.height / 20);

				FlxTween.tween(DesktopMain.instance.haxen, {alpha: 1, y: FlxG.height + DesktopMain.instance.haxen.height}, 1, {
					ease: FlxEase.sineInOut,
					startDelay: 0.5,
					onComplete: tween ->
					{
						FlxG.switchState(() -> new DesktopPlay());
					}
				});

				FlxTween.tween(DesktopMain.instance.option_play, {alpha: 1, y: FlxG.height + DesktopMain.instance.option_play.height}, 1, {
					ease: FlxEase.sineInOut,
					startDelay: 0.1,
				});
				FlxTween.tween(DesktopMain.instance.option_options, {alpha: 1, y: FlxG.height + DesktopMain.instance.option_options.height}, 1, {
					ease: FlxEase.sineInOut
				});
			}
		}
		else if (Mouse.overlaps(DesktopMain.instance.option_options))
		{
			if (!moving)
			{
				DesktopMain.instance.option_options.alpha = 0.25;

				if (Mouse.pressed)
				{
					DesktopMain.instance.option_options.alpha = 0.125;
				}
			}
		}
	}
}
