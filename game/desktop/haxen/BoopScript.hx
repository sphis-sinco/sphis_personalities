import flixel.util.FlxTimer;
import game.Paths;
import game.desktop.DesktopMain;
import game.scripts.events.AddedEvent;
import game.scripts.events.UpdateEvent;

var haxenIdleStates = [];

function onAdded(event:AddedEvent)
{
	haxenIdleStates.push(Paths.getImagePath('desktop/haxen/idle-left'));
	haxenIdleStates.push(Paths.getImagePath('desktop/haxen/idle-right'));
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-main')
	{
		if (DesktopMain.instance.haxen.y == DesktopMain.instance.haxenStartingYPosition)
			DesktopMain.instance.haxen.alpha = 0.75;
		if (Mouse.overlaps(DesktopMain.instance.haxen) && DesktopMain.instance.haxen.y == DesktopMain.instance.haxenStartingYPosition)
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
