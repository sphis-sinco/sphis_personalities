package game;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import haxe.xml.Access;

class Controls
{
	public static var controls:Map<String, Array<FlxKey>> = [];

	public static var save:ControlsSave;

	// #region control checks
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

	// #endregion

	public static function getControlKeys(controlKey:String):Array<String>
	{
		var grp = controls.get(controlKey);
		var array = [];
		for (key in grp)
		{
			array.push(key.toString().toUpperCase());
		}
		return array;
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
		if (path == null)
		{
			trace('Null path');
			return;
		}

		var xml = Xml.createElement('controls');

		// #region generate save xml
		var groups:Array<String> = ['game_', 'ui_', 'general_'];
		var keys:Array<String> = ['left', 'down', 'up', 'right', 'jump', 'accept', 'leave'];

		for (grp in groups)
		{
			var addGrp = true;

			var controlGrp = Xml.createElement('control-group');
			controlGrp.set('id', StringTools.replace(grp, '_', ''));

			for (key in keys)
			{
				if (Controls.controls.exists(grp + key))
				{
					var controlElement = Xml.createElement('control');
					controlElement.set('id', key);

					for (controlKey in Controls.controls.get(grp + key))
					{
						var keyElement = Xml.createElement('key');
						keyElement.set('value', controlKey);

						controlElement.addChild(keyElement);
					}

					controlGrp.addChild(controlElement);
				}
			}

			if (addGrp)
				xml.addChild(controlGrp);
		}
		// #endregion
		#if sys
		trace('Saving controls to "' + path + '" preference file via Sys');

		sys.io.File.saveContent(path, '<!DOCTYPE personalities-controls-xml>\n' + xml.toString());
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

		// #region parse save xml
		var controls = [];

		for (grp in xml.elements)
			if (grp.name == 'control-group' && grp.has.id)
			{
				for (control in grp.elements)
					if (control.name == 'control' && control.has.id)
					{
						control.att.grp = grp.att.id;
						controls.push(control);
					}
			}

		var controls_map:Map<String, Array<FlxKey>> = [];
		var current_controls:Array<FlxKey> = [];

		var i = 0;
		for (control in controls)
		{
			current_controls = [];

			try
			{
				for (key in control.elements)
					if (key.name == 'key' && key.has.value)
					{
						if (Defines.get('controls_loadExtraTraces'))
							trace('control(' + Ansi.fg('', ORANGE) + control.att.grp + '_' + control.att.id + Ansi.reset('') + ') : ' + key.att.value);
						current_controls.push(FlxKey.fromString(key.att.value.toUpperCase()));
					}

				if (current_controls.length > 0)
					controls_map.set(control.att.grp + '_' + control.att.id, current_controls);
			}
			catch (e)
			{
				trace(e.message);

				trace(control.innerHTML);
			}
			i++;
		}
		// #endregion

		Controls.controls = controls_map;
		trace('Updated Controls!');
	}
}
