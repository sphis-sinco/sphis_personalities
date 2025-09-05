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
		if (FlxG.mouse.overlaps(desktopMain.haxen))
		{
			Mouse.setMouseState(MouseStates.CAN_SELECT);

			if (FlxG.mouse.pressed)
				Mouse.setMouseState(MouseStates.SELECTED);
			if (FlxG.mouse.justReleased)
			{
				desktopMain.haxen_changeState('boop');
				new FlxTimer().start(1, function(tmr)
				{
					desktopMain.haxen_idle();
				});
			}
		}
	}
}
