import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-play')
	{
		var sysLoad = DesktopPlay.instance.sysLoadLevels('game/levels/data');

		if (!sysLoad)
		{
			DesktopPlay.instance.levels = ['level1', 'level2'];
		}
	}
}
