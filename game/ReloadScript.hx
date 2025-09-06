import flixel.FlxG;
import game.scripts.ScriptManager;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (FlxG.keys.justReleased.R)
	{
		ScriptManager.checkForUpdatedScripts();
	}
}
