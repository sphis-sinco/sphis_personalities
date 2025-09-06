import flixel.util.FlxTimer;
import game.Paths;
import game.desktop.DesktopMain;
import game.scripts.events.AddedEvent;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var haxenIdleStates = [];
var haxenStartingYPosition = 0.0;

function onAdded(event:AddedEvent)
{
	haxenIdleStates.push(Paths.getImagePath('desktop/haxen/idle-left'));
	haxenIdleStates.push(Paths.getImagePath('desktop/haxen/idle-right'));
}

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-main')
		haxenStartingYPosition = DesktopMain.instance.haxen.y;
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-main')
	{
		if (DesktopMain.instance.haxen.y == haxenStartingYPosition)
			DesktopMain.instance.haxen.alpha = 0.75;
		if (Mouse.overlaps(DesktopMain.instance.haxen) && DesktopMain.instance.haxen.y == haxenStartingYPosition)
		{
			DesktopMain.instance.haxen.alpha = 1;

			if (Mouse.pressed)
				Mouse.setMouseState(MouseStates.SELECTED);
			if (Mouse.justReleased && haxenIdleStates.contains(DesktopMain.instance.haxen.graphic.key))
			{
				DesktopMain.instance.haxen_changeState('boop');
				new FlxTimer().start(1, function(tmr)
				{
					DesktopMain.instance.haxen_idle();
				});
			}
		}
	}
}
