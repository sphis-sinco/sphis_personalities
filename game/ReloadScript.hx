import flixel.FlxG;
import game.State;
import game.scripts.ScriptManager;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (FlxG.keys.anyJustReleased([State.reloadKey]))
	{
		ScriptManager.loadAllScripts();

		FlxG.resetState();
	}
}
