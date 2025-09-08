import flixel.FlxG;
import game.modding.ModList;
import game.scripts.events.AddedEvent;
import lime.app.Application;

function onAdded(event:AddedEvent)
{
	FlxG.save.bind('PersonalitiesHAXEN', 'Sphis');

	if (FlxG.save.data.levelTimes == null)
	{
		FlxG.save.data.levelTimes = {
			level1: 0
		}
	}
	if (FlxG.save.data.modList == null)
	{
		FlxG.save.data.modList = [];
	}
	ModList.load();

	trace('Save dump: ' + {modList: FlxG.save.data.modList, levelTimes: FlxG.save.data.levelTimes, volume: FlxG.save.data.volume});

	Application.current.onExit.add(l ->
	{
		FlxG.save.flush();
	});
}
