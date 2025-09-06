package game.desktop;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import game.desktop.play.LevelData;
import game.desktop.play.LevelSpriteGroup;
import haxe.Json;

class DesktopPlay extends State
{
	public static var instance:DesktopPlay = null;

	override public function new()
	{
		super('desktop-play');

		if (instance != null)
		{
			instance = null;
		}
		instance = this;
	}

	public var levels:Array<String> = [];
	public var levelMetas:Array<LevelData> = [];
	public var levelsGrp:FlxTypedGroup<LevelSpriteGroup>;
	public var levelsTextGrp:FlxTypedGroup<FlxText>;

	public var curSel:Int = 0;

	public var camFollow:FlxObject;

	public var scanlineLayer:FlxTypedGroup<FlxSprite>;

	override function create()
	{
		levelsGrp = new FlxTypedGroup<LevelSpriteGroup>();
		add(levelsGrp);
		levelsTextGrp = new FlxTypedGroup<FlxText>();
		add(levelsTextGrp);

		camFollow = new FlxObject(320, 240);
		add(camFollow);
		FlxG.camera.follow(camFollow, LOCKON, 0.1);

		scanlineLayer = new FlxTypedGroup<FlxSprite>();

		super.create();

		add(scanlineLayer);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (levelGrp in levelsGrp.members)
		{
			levelGrp.levelIcon.screenCenter(Y);
			levelsTextGrp.members[levelGrp.ID].y = levelGrp.levelIcon.y - levelsTextGrp.members[levelGrp.ID].height;

			levelGrp.update(elapsed);

			levelGrp.levelIcon.color = 0xFFFFFF;
			if (curSel == levelGrp.ID)
			{
				camFollow.x = levelGrp.levelIcon.getGraphicMidpoint().x;
				levelGrp.levelIcon.color = 0xFFFF00;
			}
			levelsTextGrp.members[levelGrp.ID].color = levelGrp.levelIcon.color;
		}

		if (Controls.getControlJustReleased('ui_left'))
			curSel--;
		if (Controls.getControlJustReleased('ui_right'))
			curSel++;

		if (curSel < 0)
			curSel = 0;
		if (curSel >= levels.length)
			curSel = levels.length - 1;
	}

	public function reloadLevels(onComplete:(levelsGrp:FlxTypedGroup<LevelSpriteGroup>, levelsTextGrp:FlxTypedGroup<FlxText>) -> Void = null)
	{
		for (level in levelsGrp.members)
		{
			level.destroy();
			levelsGrp.members.remove(level);
		}
		for (level in levelsTextGrp.members)
		{
			level.destroy();
			levelsTextGrp.members.remove(level);
		}

		levelMetas = [];

		var i = 0;

		for (level in levels)
		{
			var levelGrp = new LevelSpriteGroup();
			levelGrp.ID = i;
			levelsGrp.add(levelGrp);

			levelGrp.scale = .5;
			levelGrp.levelID = level;

			levelGrp.loadLevelAsset();

			levelMetas.push(Json.parse(Paths.getText(Paths.getGamePath('levels/data/' + level + '.json'))));
			levelGrp.locked = !levelMetas[i].unlocked;

			var textField = new FlxText();
			textField.text = levelMetas[i].displayName;
			textField.size = 32;
			levelsTextGrp.add(textField);

			levelGrp.levelIcon.screenCenter(XY);
			levelGrp.levelIcon.x += ((levelGrp.levelIcon.width) * levelGrp.ID) * 1.5;
			textField.x = levelGrp.levelIcon.x;
			textField.y = levelGrp.levelIcon.y - textField.height;

			FlxG.camera.x = levelGrp.levelIcon.getGraphicMidpoint().x;

			i++;
		}

		if (onComplete != null)
			onComplete(levelsGrp, levelsTextGrp);
	}
}
