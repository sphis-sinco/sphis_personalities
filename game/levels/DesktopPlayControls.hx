import flixel.FlxG;
import game.desktop.DesktopPlay;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-play' && DesktopPlay.instance.savedSelection == null)
	{
		if (Controls.getControlJustReleased('ui_left'))
			DesktopPlay.instance.curSel--;
		if (Controls.getControlJustReleased('ui_right'))
			DesktopPlay.instance.curSel++;

		if (DesktopPlay.instance.curSel < 0)
		{
			DesktopPlay.instance.curSel = 0;
			FlxG.sound.play(Paths.getSoundPath('ui_select_2', 'desktop'));
		}
		else
		{
			if (Controls.getControlJustReleased('ui_left'))
				FlxG.sound.play(Paths.getSoundPath('ui_select_1', 'desktop'));
		}

		if (DesktopPlay.instance.curSel >= DesktopPlay.instance.levels.length)
		{
			DesktopPlay.instance.curSel = DesktopPlay.instance.levels.length - 1;
			FlxG.sound.play(Paths.getSoundPath('ui_select_2', 'desktop'));
		}
		else
		{
			if (Controls.getControlJustReleased('ui_right'))
				FlxG.sound.play(Paths.getSoundPath('ui_select_1', 'desktop'));
		}
	}
}
