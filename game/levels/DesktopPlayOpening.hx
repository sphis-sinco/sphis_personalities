import flixel.FlxG;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-play')
	{
		DesktopPlay.instance.reloadLevels((levelsGrp, levelsTextGrp) ->
		{
			var newLevelIndexes:Array<Int> = [];

			var i = 0;
			for (obj in levelsGrp.members)
			{
				obj.levelIcon.alpha = 0;
				FlxTween.tween(obj.levelIcon, {alpha: obj.targAlpha}, 1, {
					ease: FlxEase.sineInOut
				});
				if (FlxG.save != null && FlxG.save.data.newlevels != null)
					if (FlxG.save.data.newlevels.contains(obj.levelID))
						newLevelIndexes.push(i);
				obj.lock.alpha = 0;
				FlxTween.tween(obj.lock, {alpha: 1}, 1, {
					ease: FlxEase.sineInOut
				});
				i++;
			}
			i = 0;
			for (obj in levelsTextGrp.members)
			{
				if (newLevelIndexes.contains(i))
					obj.text += ' (new)';

				obj.alpha = 0;
				FlxTween.tween(obj, {alpha: 1}, 1, {
					ease: FlxEase.sineInOut
				});

				i++;
			}
		});
	}
}
