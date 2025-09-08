import flixel.FlxG;
import game.modding.ModMenu;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (Controls.getControlJustReleased('general_openModMenu'))
		if (event.state == 'desktop-main' || event.state == 'desktop-play' && !ScriptManager.isWeb)
			FlxG.switchState(() -> new ModMenu());
}
