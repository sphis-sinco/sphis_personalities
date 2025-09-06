import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.scripts.events.UpdateEvent;

var transitioning = false;

function onUpdate(event:UpdateEvent)
{
	if (!transitioning && (FlxG.keys.justReleased.F1 || (FlxG.keys.pressed.SHIFT && FlxG.keys.justReleased.ONE)))
	{
		transitioning = true;
		if (event.state != 'z-easter-egg')
		{
			if (event.state == 'desktop-main')
			{
				var state = DesktopMain.instance;

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
