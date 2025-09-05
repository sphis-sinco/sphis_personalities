import flixel.FlxG;
import game.Mouse;
import game.MouseStates;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	Mouse.setMouseState(MouseStates.IDLE);

	if (event.state == 'desktop-main')
	{
		if (FlxG.mouse.overlaps(DesktopMain.instance.option_play))
			Mouse.setMouseState(MouseStates.CAN_SELECT);
		if (FlxG.mouse.overlaps(DesktopMain.instance.haxen))
			Mouse.setMouseState(MouseStates.CAN_SELECT);

		if (FlxG.mouse.overlaps(DesktopMain.instance.option_options))
			Mouse.setMouseState(MouseStates.CANT_SELECT);
	}

	if (FlxG.mouse.pressed && Mouse.state == MouseStates.CAN_SELECT)
	{
		Mouse.setMouseState(MouseStates.SELECTED);
	}
}
