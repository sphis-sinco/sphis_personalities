package;

import flixel.FlxGame;
import game.scripts.ScriptManager;
import openfl.display.Sprite;
#if flixelModding
import flixel.system.FlxBaseMetadataFormat;
import flixel.system.FlxBaseModpack;
import flixel.system.FlxModding;
import flixel.util.FlxScriptUtil;
#end

class Main extends Sprite
{
	public function new()
	{
		super();

		#if flixelModding
		#if FLXMODDING_SCRIPTING
		FlxModding.scripting = true;

		@:privateAccess {
			for (cls in ScriptManager.clsList)
			{
				FlxScriptUtil.defaultGlobalClasses.push({
					cls: cls,
					name: '' + cls
				});
			}
		}
		#else
		FlxModding.scripting = false;
		#end
		FlxModding.init(PersonalitiesModpack, PersonalitiesMetaDataFormat, null, null, 'game');
		#end

		addChild(new FlxGame(0, 0, game.InitState));
	}
}

#if flixelModding
@:buildModpack(PersonalitiesMetaDataFormat)
class PersonalitiesModpack extends FlxBaseModpack<PersonalitiesMetaDataFormat> {}

@:buildMetadata('meta.json', 'icon.png')
class PersonalitiesMetaDataFormat extends FlxBaseMetadataFormat {}
#end
