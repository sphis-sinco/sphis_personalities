package game;

import Xml.XmlType;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import haxe.Json;
import haxe.xml.Access;
import lime.utils.Assets;

class Controls
{
	public static var controls:Map<String, Array<FlxKey>> = [
		// game_
		'game_left' => [LEFT, A],
		'game_right' => [RIGHT, D],
		'game_jump' => [SPACE],
		'game_pause' => [ENTER],
		// ui_
		'ui_up' => [UP, W],
		'ui_left' => [LEFT, A],
		'ui_down' => [DOWN, S],
		'ui_right' => [RIGHT, D],
		'ui_accept' => [ENTER],
		'ui_leave' => [ESCAPE]
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
		#if sys
		trace('Saving controls to "' + path + '" preference file via Sys');

		if (path == null)
		{
			trace('PATH NULL! CANNOT SAVE!!');
			return;
		}

		sys.io.File.saveContent(path, '');
		#else
		trace('Not sys, cannot save.');
		#end
	}

	public function load(path:Null<String> = null)
	{
		if (!StringTools.endsWith(path, '.xml'))
		{
			trace('Not an XML');
			return;
		}
		if (!Paths.pathExists(path))
		{
			trace('Non-existant file');
			return;
		}

		var xml:Access = new Access(Xml.parse(Paths.getText(path)).firstElement());

		if (xml == null)
		{
			trace('Null XML');
			return;
		}

		var controls = [];

		for (grp in xml.elements)
			if (grp.name == 'control-group')
				for (control in grp.elements)
					if (control.name == 'control' && control.has.id)
						controls.push(control);

		var controls_map:Map<String, Array<FlxKey>> = [];
		var current_controls:Array<FlxKey> = [];

		for (control in controls)
		{
			current_controls = [];

			for (key in control.elements)
				if (key.name == 'key' && key.has.value)
				{
					trace('control(' + control.att.id + ') : ' + key.att.value);
					current_controls.push(FlxKey.fromString(key.att.value.toUpperCase()));
				}

			controls_map.set(control.att.id, current_controls);
		}

		Controls.controls = controls_map;
		trace('Updated Controls!');
	}
}
