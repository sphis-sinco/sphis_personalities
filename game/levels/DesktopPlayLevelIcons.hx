import flixel.FlxG;
import game.desktop.DesktopPlay;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedAxes;

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-play')
	{
		for (levelGrp in DesktopPlay.instance.levelsGrp.members)
		{
			levelGrp.levelIcon.screenCenter(FlxScriptedAxes.Y);
			DesktopPlay.instance.levelsTextGrp.members[levelGrp.ID].y = levelGrp.levelIcon.y - DesktopPlay.instance.levelsTextGrp.members[levelGrp.ID].height;

			levelGrp.update(event.elapsed);

			levelGrp.levelIcon.color = 0xFFFFFF;
			if (DesktopPlay.instance.curSel == levelGrp.ID)
			{
				DesktopPlay.instance.camFollow.x = levelGrp.levelIcon.getGraphicMidpoint().x;

				if (FlxG.save != null && FlxG.save.data.newlevels != null)
					if (FlxG.save.data.newlevels.contains(levelGrp.levelID))
						levelGrp.levelIcon.color = 0x00FF00;
					else
						levelGrp.levelIcon.color = 0xFFFF00;
				else
					levelGrp.levelIcon.color = 0xFFFF00;
			}

			DesktopPlay.instance.levelsTextGrp.members[levelGrp.ID].color = levelGrp.levelIcon.color;
		}
	}
}
