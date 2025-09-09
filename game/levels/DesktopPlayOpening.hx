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
			for (obj in levelsGrp.members)
			{
				obj.levelIcon.alpha = 0;
				FlxTween.tween(obj.levelIcon, {alpha: obj.targAlpha}, 1, {
					ease: FlxEase.sineInOut
				});
				if (FlxG.save != null && FlxG.save.data.newlevels != null)
					if (FlxG.save.data.newlevels.contains(obj.levelID))
						obj.lock.visible = true;
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

			if (FlxG.save != null && FlxG.save.data.newlevels != null)
			{
				var newlevels:Array<String> = FlxG.save.data.newlevels;

				for (level in newlevels)
				{
					var levelGrp = DesktopPlay.instance.levelsGrp.getFirst(function(levelGrp:LevelSpriteGroup)
					{
						return levelGrp.levelID == level;
					});

					FlxTimer.wait(1 * (levelGrp.ID + 1), () ->
					{
						DesktopPlay.instance.camFollow.x = levelGrp.levelIcon.x;
						levelGrp.lock.loadGraphic(Paths.getImagePath('levels/desktop-icons/unlock'));
						FlxTimer.wait(.25, () ->
						{
							FlxFlicker.flicker(levelGrp.lock, 1, 0.04, false);
						});
					});
				}
			}
		});
	}
}
