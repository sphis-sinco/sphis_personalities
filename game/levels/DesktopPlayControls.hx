import game.desktop.DesktopPlay;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-play')
	{
		if (Controls.getControlJustReleased('ui_left'))
			DesktopPlay.instance.curSel--;
		if (Controls.getControlJustReleased('ui_right'))
			DesktopPlay.instance.curSel++;

		if (DesktopPlay.instance.curSel < 0)
			DesktopPlay.instance.curSel = 0;
		if (DesktopPlay.instance.curSel >= DesktopPlay.instance.levels.length)
			DesktopPlay.instance.curSel = DesktopPlay.instance.levels.length - 1;
	}
}
