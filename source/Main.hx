package;

import flixel.FlxGame;
import openfl.display.Sprite;
#if flixelModding
import flixel.system.FlxBaseMetadataFormat;
import flixel.system.FlxModding;
#end

class Main extends Sprite
{
	public function new()
	{
		super();

		#if flixelModding
		FlxModding.init(null, PersonalitiesMetaDataFormat, null, null, 'game');
		FlxModding.scripting = true;
		#end

		addChild(new FlxGame(0, 0, game.InitState));
	}
}

#if flixelModding
@:buildMetadata('meta.json', 'icon.png')
class PersonalitiesMetaDataFormat extends FlxBaseMetadataFormat {}
#end
