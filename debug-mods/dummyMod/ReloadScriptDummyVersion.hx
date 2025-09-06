import flixel.FlxG;
import game.scripts.ScriptManager;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (event.state != null)
		if (FlxG.keys.justReleased.ONE)
		{
			ScriptManager.checkForUpdatedScripts();
			trace('DummyMod dum');
		}
}
