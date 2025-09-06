import flixel.FlxG;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (FlxG.keys.justReleased.F1 || (FlxG.keys.pressed.SHIFT && FlxG.keys.justReleased.ONE))
	{
		if (event.state != 'z-easter-egg')
			FlxG.switchState(() -> new BlankState('z-easter-egg'));
	}
}
