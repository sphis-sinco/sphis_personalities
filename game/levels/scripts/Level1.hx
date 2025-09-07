import flixel.FlxG;
import flixel.FlxSprite;
import game.desktop.DesktopPlay;
import game.desktop.play.LevelModule;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedColor;

var level_one:LevelModule;
var is_level_one:Bool;
var level_paused:Bool;
var level_one_bg_sky:FlxSprite;
var level_one_haxen:FlxSprite;
var level_one_bg_ground:FlxSprite;
var pauseBG:FlxSprite;

function onCreate(event:CreateEvent)
{
	is_level_one = (event.state == 'level1');
	level_paused = false;
	if (is_level_one)
	{
		level_one = new LevelModule(event.state);
		FlxG.camera.fade(FlxScriptedColor.BLACK, 1, true, () -> {});

		level_one_bg_sky = new FlxSprite();
		level_one_bg_sky.loadGraphic(level_one.getGeneralAsset('sky'));
		level_one_bg_sky.screenCenter();

		level_one_bg_ground = new FlxSprite();
		level_one_bg_ground.loadGraphic(level_one.getGeneralAsset('ground'));
		level_one_bg_ground.screenCenter();

		level_one_haxen = new FlxSprite();
		level_one_haxen.loadGraphic(level_one.getHaxenAsset('idle'));
		level_one_haxen.screenCenter();
		level_one_haxen.y += (level_one_haxen.height / 4);

		pauseBG = new FlxSprite();
		pauseBG.makeGraphic(FlxG.width, FlxG.height, FlxScriptedColor.BLACK);
		pauseBG.screenCenter();

		BlankState.instance.add(level_one_bg_sky);
		BlankState.instance.add(level_one_haxen);
		BlankState.instance.add(level_one_bg_ground);
		BlankState.instance.add(pauseBG);
	}
}

function onUpdate(event:UpdateEvent)
{
	if (is_level_one)
	{
		pauseBG.alpha = (level_paused) ? 0.5 : 0.0;

		if (Controls.getControlJustReleased('ui_leave') && level_paused && !level_pausing)
		{
			FlxG.camera.fade(FlxScriptedColor.BLACK, 1, false, () ->
			{
				FlxG.switchState(() -> new DesktopPlay());
			});
		}
		if (Controls.getControlJustReleased('game_pause'))
		{
			level_paused = !level_paused;
		}
	}
}
