import flixel.FlxG;
import flixel.util.FlxTimer;
import game.desktop.DesktopMain;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var desktopMain:DesktopMain = null;

function onCreate(event:CreateEvent)
{
	desktopMain = null;

	if (event.state == 'desktop-main')
		desktopMain = DesktopMain.instance;
}

function onUpdate(event:UpdateEvent)
{
	if (desktopMain != null && event.state == 'desktop-main')
	{
		desktopMain.option_play.alpha = 0.5;
		desktopMain.option_options.alpha = 0.5;

		if (FlxG.mouse.overlaps(desktopMain.option_play))
		{
			desktopMain.option_play.alpha = 1;
			Mouse.setMouseState(MouseStates.CAN_SELECT);
		}
		else if (FlxG.mouse.overlaps(desktopMain.option_options))
		{
			desktopMain.option_play.alpha = 0.25;
			Mouse.setMouseState(MouseStates.CANT_SELECT);
		}
		else
		{
			Mouse.setMouseState(MouseStates.IDLE);
		}
	}
}
