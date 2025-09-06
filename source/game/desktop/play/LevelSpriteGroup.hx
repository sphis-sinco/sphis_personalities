package game.desktop.play;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class LevelSpriteGroup extends FlxTypedGroup<FlxSprite>
{
	public static var unknownSprPath:String = Paths.getImagePath('levels/desktop-icons/level-unknown');
	public static var sprPath:String;

	public var levelID:String = 'unknown';
	public var locked(default, set):Bool;

	function set_locked(value:Bool):Bool
	{
		if (lock != null)
			lock.visible = value;

		return value;
	}

	public var scale:Float;

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

		locked = false;
	}

	public function loadLevelAsset()
	{
		sprPath = Paths.getImagePath('levels/desktop-icons/level-' + levelID);
		if (!Paths.pathExists(sprPath))
		{
			trace(Ansi.fg('Level icon path: ', RED) + Ansi.fg(sprPath, WHITE) + Ansi.fg(' doesn\'t exist', RED));
			sprPath = unknownSprPath;
		}

		levelIcon.loadGraphic(sprPath);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		box.color = levelIcon.color;
		lock.color = levelIcon.color;

		box.setPosition(levelIcon.x, levelIcon.y);
		lock.setPosition(box.x, box.y);

		levelIcon.scale.set(scale, scale);
		box.scale.set(scale, scale);
		lock.scale.set(scale, scale);

		levelIcon.updateHitbox();
		box.updateHitbox();
		lock.updateHitbox();
	}
}
