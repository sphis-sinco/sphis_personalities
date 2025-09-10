package game.modding;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.desktop.DesktopMain;
import game.modding.ModList;
import game.modding.PolymodHandler;
import openfl.display.BitmapData;
import thx.semver.Version;

class ModMenu extends State
{
	public static var savedSelection:Int = 0;

	public var curSelected:Int = 0;

	public static var instance:ModMenu;

	public var modText:FlxText;
	public var modIcon:FlxSprite;

	override public function new()
	{
		super('modmenu');

		if (instance != null)
			instance = null;
		instance = this;
	}

	override function create()
	{
		curSelected = savedSelection;

		var menuBG:FlxSprite;

		menuBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height);
		menuBG.color = 0xfff0b368;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		super.create();

		modIcon = new FlxSprite();
		modIcon.loadGraphic(Paths.getImagePath('default-mod-icon'));
		modIcon.scale.set(0.5, 0.5);
		modIcon.setPosition(FlxG.width - modIcon.width, 325);
		add(modIcon);

		modText = new FlxText(0, 0, FlxG.width, 'Template Description', 16);
		modText.scrollFactor.set();
		add(modText);

		if (PolymodHandler.metadataArrays.length < 1)
		{
			modText.text = 'No mods';
			modText.alignment = CENTER;
		}

		var leText:String = 'Press ' + Controls.getControlKeys('ui_accept') + ' to enable / disable the currently selected mod.\nPress [R] to reload mods';

		var text:FlxText = new FlxText(0, FlxG.height - 42, FlxG.width, leText, 16);
		text.scrollFactor.set();
		add(text);

		updateSel();
	}

	public var curModId = '';

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.getControlJustReleased('ui_left'))
		{
			curSelected -= 1;
			updateSel();
		}

		if (Controls.getControlJustReleased('ui_right'))
		{
			curSelected += 1;
			updateSel();
		}

		if (Controls.getControlJustReleased('ui_leave'))
		{
			if (FlxG.save != null)
				FlxG.save.flush();
			PolymodHandler.loadMods();
			FlxG.switchState(() -> new DesktopMain());
		}

		if (Controls.getControlJustReleased('general_reload'))
		{
			PolymodHandler.loadMods();
		}

		if (Controls.getControlJustReleased('ui_accept'))
		{
			savedSelection = curSelected;
			ModList.setModEnabled(curModId, !ModList.getModEnabled(curModId));
		}

		var leftTxt = '< ';
		var rightTxt = ' >';

		if (curSelected <= 0)
		{
			curSelected = 0;
			leftTxt = '| ';
			updateSel();
		}

		if (curSelected >= PolymodHandler.metadataArrays.length - 1)
		{
			curSelected = PolymodHandler.metadataArrays.length - 1;
			rightTxt = ' |';
			updateSel();
		}

		if (PolymodHandler.metadataArrays.length >= 1)
		{
			modText.alpha = ModList.getModEnabled(curModId) ? 1.0 : 0.6;

			var outdatedText:String = '';
			modText.color = FlxColor.WHITE;

			if (PolymodHandler.outdatedMods.contains(curModId))
			{
				// Commented out code is from Dreamland

				var higherVersion = ModList.modMetadatas.get(curModId).apiVersion.greaterThan(PolymodHandler.MAXIMUM_MOD_VERSION);

				outdatedText = ' \n%Outdated ';

				if (higherVersion)
					outdatedText += '\n@* Troll@';

				outdatedText += '%';
			}

			// #region mod text stuff
			modText.text = '@' + leftTxt + '@' + ModList.modMetadatas.get(curModId).title + '@' + rightTxt + '@' + '\nid (folder): '
				+ ModList.modMetadatas.get(curModId).id + '\n\n' + ModList.modMetadatas.get(curModId).description + '\n\nContributors:\n';

			var len = ModList.modMetadatas.get(curModId).contributors.length - 1;
			for (contributor in ModList.modMetadatas.get(curModId).contributors)
				modText.text += '  *  ' + contributor.name + ' (' + contributor.role + ')\n';

			modText.text += '\n\nAPI Version: ' + ModList.modMetadatas.get(curModId).apiVersion + outdatedText + '\nMod Version: '
				+ ModList.modMetadatas.get(curModId).modVersion + '\n';
			modText.applyMarkup(modText.text, [
				new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.BLACK, true, true), '@'),
				new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.YELLOW, true, true), '%'),
				new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.ORANGE, true, true), '$')
			]);
			// #endregion
		}
		else
		{
			modText.alpha = 1.0;
			modText.text = 'No mods';
		}
	}

	function updateSel()
	{
		modIcon.loadGraphic(Paths.getImagePath('default-mod-icon'));
		if (PolymodHandler.metadataArrays.length < 1)
			return;

		curModId = PolymodHandler.metadataArrays[curSelected];
		var modMeta = ModList.modMetadatas.get(curModId);

		try
		{
			if (modMeta.icon != null)
				modIcon.loadGraphic(BitmapData.fromBytes(modMeta.icon));
		}
		catch (e)
		{
			modIcon.loadGraphic(Paths.getImagePath('default-mod-icon'));
		}
	}
}
