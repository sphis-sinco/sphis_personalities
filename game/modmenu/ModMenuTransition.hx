import flixel.FlxG;
import game.modding.ModMenu;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (FlxG.keys.justReleased.F4 || (FlxG.keys.pressed.SHIFT && FlxG.keys.justReleased.FOUR))
		if (event.state == 'desktop-main' || event.state == 'desktop-play')
			FlxG.switchState(() -> new ModMenu());
}
