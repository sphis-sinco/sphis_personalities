import flixel.FlxG;
import game.desktop.play.LevelModule;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedColor;

var level_one:LevelModule;
var is_level_one:Bool;

function onCreate(event:CreateEvent)
{
	is_level_one = (event.state == 'level1');
	if (is_level_one)
	{
		level_one = new LevelModule(event.state);
		FlxG.camera.fade(FlxScriptedColor.BLACK, 1, true, () -> {});
	}
}

function onUpdate(event:UpdateEvent) {}
