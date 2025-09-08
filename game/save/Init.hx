import flixel.FlxG;
import game.modding.ModList;
import game.scripts.events.AddedEvent;
import lime.app.Application;

var levels = ['level1'];

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
	if (FlxG.save.data.levels == null)
	{
		FlxG.save.data.levels = levels;
	}
	if (FlxG.save.data.newlevels == null)
	{
		FlxG.save.data.newlevels = [];
	}
	if (FlxG.save.data.levels != levels)
	{
		for (level in levels)
		{
			if (!FlxG.save.data.levels.contains(level))
			{
				FlxG.save.data.newlevels.push(level);
				FlxG.save.data.levels.push(level);
			}
		}
	}

	trace('Save dump: ' + {modList: FlxG.save.data.modList, levelTimes: FlxG.save.data.levelTimes, volume: FlxG.save.data.volume});

	Application.current.onExit.add(l ->
	{
		FlxG.save.flush();
	});
}
