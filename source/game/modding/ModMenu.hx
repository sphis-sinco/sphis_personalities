package game.modding;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.desktop.DesktopMain;
import game.modding.ModList;
import game.modding.PolymodHandler;
import openfl.display.BitmapData;
import thx.semver.Version.SemVer;
import thx.semver.Version;

class ModMenu extends State
{
	public static var savedSelection:Int = 0;

	var curSelected:Int = 0;

	public static var instance:ModMenu;

	var descriptionText:FlxText;
	var descBg:FlxSprite;
	var descIcon:FlxSprite;

	override public function new()
	{
		super('modmenu');
	}

	override function create()
	{
		instance = this;

		#if polymod
		game.modding.PolymodHandler.loadMods();
		#end

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

		PolymodHandler.loadModMetadata();

		descIcon = new FlxSprite();
		descIcon.loadGraphic(Paths.getImagePath('default-mod-icon'));
		descIcon.scale.set(0.5, 0.5);
		descIcon.setPosition(FlxG.width - descIcon.width, 325);
		add(descIcon);

		descriptionText = new FlxText(0, 0, FlxG.width, 'Template Description', 16);
		descriptionText.scrollFactor.set();
		add(descriptionText);

		if (PolymodHandler.metadataArrays.length < 1)
		{
			descriptionText.text = 'No mods';
			descriptionText.alignment = CENTER;
		}

		var leText:String = 'Press ' + Controls.getControlKeys('ui_accept') + ' to enable / disable the currently selected mod.';

		var text:FlxText = new FlxText(0, FlxG.height - 22, FlxG.width, leText, 16);
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
			PolymodHandler.loadMods();
			savedSelection = 0;
			FlxG.switchState(() -> new DesktopMain());
		}

		if (Controls.getControlJustReleased('ui_accept'))
		{
			savedSelection = curSelected;
			ModList.setModEnabled(curModId, !ModList.getModEnabled(curModId));
			FlxG.resetState();
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
			descriptionText.alpha = ModList.getModEnabled(curModId) ? 1.0 : 0.6;

			var outdatedText:String = '';
			descriptionText.color = FlxColor.WHITE;

			if (PolymodHandler.outdatedMods.contains(curModId))
			{
				// Commented out code is from Dreamland

				/*
					var old_level_system_version = ModList.modMetadatas.get(curModId).apiVersion.lessThan(Version.arrayToVersion([0, 9, 0]));
					var old_player_results_version = !ModList.modMetadatas.get(curModId).apiVersion.lessThan(Version.arrayToVersion([1, 0, 0]));
				 */

				outdatedText = ' \n%Outdated ';

				/*
					if (old_player_results_version)
						outdatedText += '\n$* Custom player results assets won\'t work$';
					if (old_level_system_version)
						outdatedText += '\n$* Any new levels added won\'t work$';
				 */

				outdatedText += '%';
			}

			descriptionText.text = '@' + leftTxt + '@' + ModList.modMetadatas.get(curModId).title + '@' + rightTxt + '@' + '\nid (folder): '
				+ ModList.modMetadatas.get(curModId).id + '\n\n' + ModList.modMetadatas.get(curModId).description + '\n\nContributors:\n';

			var len = ModList.modMetadatas.get(curModId).contributors.length - 1;
			for (contributor in ModList.modMetadatas.get(curModId).contributors)
				descriptionText.text += '  *  ' + contributor.name + ' (' + contributor.role + ')\n';

			descriptionText.text += '\n\nAPI Version: ' + ModList.modMetadatas.get(curModId).apiVersion + outdatedText + '\nMod Version: '
				+ ModList.modMetadatas.get(curModId).modVersion + '\n';
			descriptionText.applyMarkup(descriptionText.text, [
				new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.BLACK, true, true), '@'),
				new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.YELLOW, true, true), '%'),
				new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.ORANGE, true, true), '$')
			]);
		}
		else
		{
			descriptionText.alpha = 1.0;
			descriptionText.text = 'No mods';
		}
	}

	function updateSel()
	{
		if (PolymodHandler.metadataArrays.length < 1)
			return;

		curModId = PolymodHandler.metadataArrays[curSelected];
		var modMeta = ModList.modMetadatas.get(curModId);

		try
		{
			if (modMeta.icon != null)
				descIcon.loadGraphic(BitmapData.fromBytes(modMeta.icon));
		}
		catch (e)
		{
			descIcon.loadGraphic(Paths.getImagePath('default-mod-icon'));
		}
	}
}
