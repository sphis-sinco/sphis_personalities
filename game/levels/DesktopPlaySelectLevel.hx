import flixel.FlxG;
import game.desktop.DesktopPlay;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedColor;

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-play')
	{
		if (DesktopPlay.instance.savedSelection != null)
			return;

		if (Controls.getControlJustReleased('ui_accept'))
		{
			if (DesktopPlay.instance.levelMetas[DesktopPlay.instance.curSel].unlocked)
			{
				FlxG.sound.play(Paths.getSoundPath('level_select', 'levels'));
				DesktopPlay.instance.savedSelection = DesktopPlay.instance.curSel;

				var id = '';
				var levelID = '';
				if (DesktopPlay.instance.levelMetas[DesktopPlay.instance.curSel].id != null)
					id = DesktopPlay.instance.levelMetas[DesktopPlay.instance.curSel].id;
				if (DesktopPlay.instance.levelMetas[DesktopPlay.instance.curSel].displayName != null)
					levelID = DesktopPlay.instance.levelMetas[DesktopPlay.instance.curSel].displayName;

				if (FlxG.save != null && FlxG.save.data.newlevels != null)
					if (FlxG.save.data.newlevels.contains(id))
						FlxG.save.data.newlevels.remove(id);

				FlxG.camera.fade(FlxScriptedColor.BLACK, 1, false, () ->
				{
					FlxG.switchState(() -> new LevelStateBase(id, levelID));
				});
			}
			else
			{
				FlxG.sound.play(Paths.getSoundPath('locked_level', 'levels'));
			}
		}
	}
}
