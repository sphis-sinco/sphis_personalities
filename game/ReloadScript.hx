import flixel.FlxG;
import game.scripts.ScriptManager;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (Controls.getControlJustReleased('general_reload'))
	{
		ScriptManager.checkForUpdatedScripts();
	}
}
