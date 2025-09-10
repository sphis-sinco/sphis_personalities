package game.levels;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.scripts.imports.FlxScriptedColor;

class LevelStateBase extends BlankState
{
	public var LevelName:String = 'Level 0';

	public static var instance:LevelStateBase = null;

	override public function new(state:String, levelName:String)
	{
		super(state);

		this.LevelName = levelName;

		if (instance != null)
			instance = null;
		instance = this;
	}

	public var pauseBG:FlxSprite;
	public var pauseText:FlxText;

	public var level_paused:Bool;

	override function create()
	{
		pauseBG = new FlxSprite();
		pauseBG.makeGraphic(FlxG.width, FlxG.height, FlxScriptedColor.BLACK);
		pauseBG.screenCenter();

		pauseText = new FlxText();
		pauseText.size = 16;

		pauseText.text = LevelName + '\n';
		pauseText.text += 'Paused';
		pauseText.text += '\n\n----------------\n\n';

		pauseText.alignment = 'left';

		pauseText.setPosition(16, 16);

		super.create();

		add(pauseBG);
		add(pauseText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		pauseBG.alpha = (level_paused) ? 0.5 : 0.0;
		pauseText.visible = level_paused;

		if (Controls.getControlJustReleased('game_pause'))
		{
			level_paused = !level_paused;

			FlxTimer.globalManager.active = !level_paused;
			FlxTween.globalManager.active = !level_paused;
		}
	}
}
