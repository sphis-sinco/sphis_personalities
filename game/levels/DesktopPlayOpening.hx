import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-play')
	{
		LevelStateBase.instance = null;

		DesktopPlay.instance.reloadLevels((levelsGrp, levelsTextGrp) ->
		{
			for (obj in levelsGrp.members)
			{
				obj.levelIcon.alpha = 0;
				FlxTween.tween(obj.levelIcon, {alpha: obj.targAlpha}, 1, {
					ease: FlxEase.sineInOut
				});
				obj.lock.alpha = 0;
				FlxTween.tween(obj.lock, {alpha: 1}, 1, {
					ease: FlxEase.sineInOut
				});
			}
			for (obj in levelsTextGrp.members)
			{
				obj.alpha = 0;
				FlxTween.tween(obj, {alpha: 1}, 1, {
					ease: FlxEase.sineInOut
				});
			}
		});
	}
}
