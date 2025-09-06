import flixel.FlxG;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var ZEasterEggProgress:Int = -1;

function onCreate(event:CreateEvent)
{
	ZEasterEggProgress = -1;
}

function onUpdate(event:UpdateEvent)
{
	var prevZEEP = ZEasterEggProgress;

	if (ZEasterEggProgress < 0)
		ZEasterEggProgress = 0;

	if (FlxG.keys.justReleased.ANY)
	{
		if (FlxG.keys.justReleased.UP && (ZEasterEggProgress == 0 || ZEasterEggProgress == 3))
			ZEasterEggProgress++;
		else if (FlxG.keys.justReleased.DOWN && ZEasterEggProgress == 1)
			ZEasterEggProgress++;
		else if (FlxG.keys.justReleased.LEFT && ZEasterEggProgress == 2)
			ZEasterEggProgress++;
		else if (FlxG.keys.justReleased.RIGHT && ZEasterEggProgress == 4)
			ZEasterEggProgress++;
		else
			ZEasterEggProgress = 0;
	}

	if (prevZEEP != ZEasterEggProgress)
		trace('' + ZEasterEggProgress);

	if (ZEasterEggProgress >= 5)
	{
		FlxG.switchState(() -> new BlankState('z-easter-egg'));
	}
}
