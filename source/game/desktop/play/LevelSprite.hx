package game.desktop.play;

import flixel.FlxSprite;

class LevelSprite extends FlxSprite
{
	public static var unknownSprPath:String = Paths.getImagePath('levels/desktop-icons/level-unknown');
	public static var sprPath:String;

	public var levelID:String = 'unknown';

	override public function new(id:String = 'unknown')
	{
		super();

		levelID = id;
		scale.set(.5, .5);

		loadLevelAsset();
	}

	public function loadLevelAsset()
	{
		sprPath = Paths.getImagePath('levels/desktop-icons/level-' + levelID);
		if (!Paths.pathExists(sprPath))
		{
			trace('Level icon path: ' + sprPath + ' doesn\'t exist');
			sprPath = unknownSprPath;
		}

		loadGraphic(sprPath);
		updateHitbox();
	}
}
