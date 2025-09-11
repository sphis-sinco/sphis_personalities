package game;

import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.levels.LevelStateBase;
import game.scripts.ScriptManager;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import haxe.PosInfos;

class State extends FlxState
{
	public var state:String;

	override public function new(?stateID:String, ?posInfos:PosInfos)
	{
		super();

		if (stateID != null)
			this.state = stateID;
		else
			this.state = posInfos.fileName + posInfos.className;
	}

	override function create()
	{
		super.create();

		ScriptManager.call('onCreate', [new CreateEvent(state)]);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		ScriptManager.call('onUpdate', [new UpdateEvent(state, elapsed)]);

		if (!FlxTimer.globalManager.active && LevelStateBase.instance == null)
		{
			FlxTimer.globalManager.active = true;
			FlxTween.globalManager.active = true;
		}
	}
}
