import flixel.FlxG;
import game.Defines;
import game.modding.ModList;
import game.scripts.events.AddedEvent;
import lime.app.Application;

var levels = ['level1'];

function onAdded(event:AddedEvent)
{
	if (!Defines.get('blankSave'))
		FlxG.save.bind('PersonalitiesHAXEN', Application.current.meta.get('company'));
	else
		FlxG.save.bind('PersonalitiesHAXEN-blankSave', Application.current.meta.get('company'));

	if (FlxG.save.data.version == null)
	{
		FlxG.save.data.version = Application.current.meta.get('version');
	}

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
		FlxG.save.data.levels = [];
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

	trace('Save dump: ' + {
		newlevels: FlxG.save.data.newlevels,
		levels: FlxG.save.data.levels,
		modList: FlxG.save.data.modList,
		levelTimes: FlxG.save.data.levelTimes,
		volume: FlxG.save.data.volume
	});

	Application.current.onExit.add(l ->
	{
		FlxG.save.flush();
	});
}
