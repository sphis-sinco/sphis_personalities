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
		desktopMain.haxen.alpha = 0.9;
		if (Mouse.overlaps(desktopMain.haxen))
		{
			desktopMain.haxen.alpha = 1;

			if (Mouse.pressed)
				Mouse.setMouseState(MouseStates.SELECTED);
			if (Mouse.justReleased)
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
