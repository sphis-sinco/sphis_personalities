package game.desktop.play;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class LevelSpriteGroup extends FlxTypedGroup<FlxSprite>
{
	public static var unknownSprPath:String = Paths.getImagePath('levels/desktop-icons/level-unknown');
	public static var sprPath:String;

	public var levelID:String = 'unknown';
	public var locked(default, set):Bool = false;

	function set_locked(value:Bool):Bool
	{
		if (lock != null)
			lock.visible = value;

		return value;
	}

	public var box:FlxSprite;
	public var lock:FlxSprite;
	public var levelIcon:FlxSprite;

	override public function new(id:String = 'unknown')
	{
		super();
		levelID = id;

		box = new FlxSprite();
		box.loadGraphic(Paths.getImagePath('levels/desktop-icons/box'));

		lock = new FlxSprite();
		lock.loadGraphic(Paths.getImagePath('levels/desktop-icons/lock'));

		levelIcon = new FlxSprite();
		loadLevelAsset();

		add(box);
		add(levelIcon);
		add(lock);
	}

	public function loadLevelAsset()
	{
		sprPath = Paths.getImagePath('levels/desktop-icons/level-' + levelID);
		if (!Paths.pathExists(sprPath))
		{
			trace('Level icon path: ' + sprPath + ' doesn\'t exist');
			sprPath = unknownSprPath;
		}

		levelIcon.loadGraphic(sprPath);
		levelIcon.updateHitbox();
		box.updateHitbox();
		lock.updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		box.setPosition(levelIcon.x, levelIcon.y);
		lock.setPosition(box.x, box.y);

		box.scale.set(levelIcon.scale.x, levelIcon.scale.y);
		lock.scale.set(levelIcon.scale.x, levelIcon.scale.y);
	}
}
