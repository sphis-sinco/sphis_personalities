import flixel.FlxG;
import game.scripts.events.AddedEvent;

function onAdded(event:AddedEvent)
{
	FlxG.save.bind('PersonalitiesHAXEN', 'Sphis');

	if (FlxG.save.data.levelTimes == null)
	{
		FlxG.save.data.levelTimes = [];
	}
}
