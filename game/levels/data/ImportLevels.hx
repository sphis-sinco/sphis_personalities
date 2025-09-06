import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-play')
	{
		DesktopPlay.instance.levels.push('level1');
		DesktopPlay.instance.levels.push('level2');
	}
}
