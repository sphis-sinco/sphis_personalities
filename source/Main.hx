package;

import flixel.FlxGame;
import openfl.display.Sprite;
#if flixelModding
import flixel.system.FlxBaseMetadataFormat;
import flixel.system.FlxBaseModpack;
import flixel.system.FlxModding;
#end

class Main extends Sprite
{
	public function new()
	{
		super();

		#if flixelModding
		FlxModding.init(PersonalitiesModpack, PersonalitiesMetaDataFormat, null, null, 'game');
		FlxModding.scripting = true;
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
