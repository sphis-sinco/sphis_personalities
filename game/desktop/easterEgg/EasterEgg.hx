import flixel.FlxG;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (FlxG.keys.justReleased.F1 || (FlxG.keys.pressed.SHIFT && FlxG.keys.justReleased.ONE))
	{
		FlxG.switchState(() -> new BlankState('z-easter-egg'));
	}
}
