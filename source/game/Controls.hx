package game;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import haxe.Json;
import lime.utils.Assets;

class Controls
{
	public static var controls:Map<String, Array<FlxKey>> = [
		// game_
		'game_left' => [LEFT, A],
		'game_right' => [RIGHT, D],
		'game_jump' => [SPACE],
		'game_pause' => [ESCAPE],
		// ui_
		'ui_up' => [UP, W],
		'ui_left' => [LEFT, A],
		'ui_down' => [DOWN, S],
		'ui_right' => [RIGHT, D],
		'ui_accept' => [ENTER]
	];

	public static var save:ControlsSave;

	public static function getControlPressed(controlKey:String):Bool
	{
		return FlxG.keys.anyPressed(controls.get(controlKey));
	}

	public static function getControlJustReleased(controlKey:String):Bool
	{
		return FlxG.keys.anyJustReleased(controls.get(controlKey));
	}

	public static function getControlJustPressed(controlKey:String):Bool
	{
		return FlxG.keys.anyJustPressed(controls.get(controlKey));
	}
}

class ControlsSave
{
	public var publicPath:Null<String>;

	public function new(pPath:Null<String> = null)
	{
		publicPath = pPath;
	}

	public function save(path:Null<String> = null)
	{
		var game_jump:Array<String> = [];
		var game_right:Array<String> = [];
		var game_left:Array<String> = [];
		var game_pause:Array<String> = [];

		var ui_up:Array<String> = [];
		var ui_left:Array<String> = [];
		var ui_down:Array<String> = [];
		var ui_right:Array<String> = [];
		var ui_accept:Array<String> = [];

		for (key in Controls.controls.get('game_jump'))
			game_jump.push(key.toString());
		for (key in Controls.controls.get('game_left'))
			game_left.push(key.toString());
		for (key in Controls.controls.get('game_right'))
			game_right.push(key.toString());
		for (key in Controls.controls.get('game_pause'))
			game_pause.push(key.toString());

		for (key in Controls.controls.get('ui_up'))
			ui_up.push(key.toString());
		for (key in Controls.controls.get('ui_left'))
			ui_left.push(key.toString());
		for (key in Controls.controls.get('ui_down'))
			ui_down.push(key.toString());
		for (key in Controls.controls.get('ui_right'))
			ui_right.push(key.toString());
		for (key in Controls.controls.get('ui_accept'))
			ui_accept.push(key.toString());

		#if sys
		trace('Saving controls to "' + path + '" preference file via Sys');

		var saveFile:ControlsPreferenceFile = {
			game_pause: game_pause,
			game_left: game_left,
			game_right: game_right,
			game_jump: game_jump,

			ui_right: ui_right,
			ui_down: ui_down,
			ui_left: ui_left,
			ui_up: ui_up,
			ui_accept: ui_accept,
		};

		if (path == null)
		{
			trace('PATH NULL! CANNOT SAVE!!');
			return;
		}

		sys.io.File.saveContent(path, Json.stringify(saveFile));
		#else
		trace('Not sys, cannot save.');
		#end
	}

	public function load(path:Null<String> = null)
	{
		if (!Paths.pathExists(path))
			save(path);

		if (Paths.pathExists(path))
		{
			trace('Loading "' + path + '" controls preference file');

			var saveFile:ControlsPreferenceFile;

			try
			{
				saveFile = Json.parse(Paths.getText(path));
			}
			catch (e)
			{
				saveFile = null;
				trace('LOADING ERROR: "' + e.message + '"');
			}

			if (saveFile != null)
			{
				var game_jump:Array<FlxKey> = [];
				var game_left:Array<FlxKey> = [];
				var game_right:Array<FlxKey> = [];
				var game_pause:Array<FlxKey> = [];

				var ui_up:Array<FlxKey> = [];
				var ui_left:Array<FlxKey> = [];
				var ui_down:Array<FlxKey> = [];
				var ui_right:Array<FlxKey> = [];
				var ui_accept:Array<FlxKey> = [];

				for (key in saveFile.game_jump)
					game_jump.push(FlxKey.fromString(key));
				for (key in saveFile.game_right)
					game_right.push(FlxKey.fromString(key));
				for (key in saveFile.game_left)
					game_left.push(FlxKey.fromString(key));
				for (key in saveFile.game_pause)
					game_pause.push(FlxKey.fromString(key));

				for (key in saveFile.ui_up)
					ui_up.push(FlxKey.fromString(key));
				for (key in saveFile.ui_left)
					ui_left.push(FlxKey.fromString(key));
				for (key in saveFile.ui_down)
					ui_down.push(FlxKey.fromString(key));
				for (key in saveFile.ui_right)
					ui_right.push(FlxKey.fromString(key));
				for (key in saveFile.ui_accept)
					ui_accept.push(FlxKey.fromString(key));

				Controls.controls.set('game_jump', game_jump);
				Controls.controls.set('game_right', game_right);
				Controls.controls.set('game_pause', game_pause);

				Controls.controls.set('ui_up', ui_up);
				Controls.controls.set('ui_left', ui_left);
				Controls.controls.set('ui_down', ui_down);
				Controls.controls.set('ui_right', ui_right);
				Controls.controls.set('ui_accept', ui_accept);

				save(path);
			}
		}
	}
}

typedef ControlsPreferenceFile =
{
	var game_left:Array<String>;
	var game_right:Array<String>;
	var game_jump:Array<String>;
	var game_pause:Array<String>;

	var ui_up:Array<String>;
	var ui_left:Array<String>;
	var ui_down:Array<String>;
	var ui_right:Array<String>;
	var ui_accept:Array<String>;
}
