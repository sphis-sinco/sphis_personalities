import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;

var desktopPlay:DesktopPlay;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-play')
	{
		desktopPlay = DesktopPlay.instance;

		desktopPlay.levels.push('level1');
		desktopPlay.levels.push('level2');

		desktopPlay.reloadLevels();
	}
}
