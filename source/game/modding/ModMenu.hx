package game.modding;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
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

	public var page:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

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

		add(page);

		PolymodHandler.loadModMetadata();

		loadMods();

		descBg = new FlxSprite(0, FlxG.height - 160).makeGraphic(FlxG.width, 160, 0xFF000000);
		descBg.alpha = 0.6;
		add(descBg);

		descIcon = new FlxSprite();
		descIcon.loadGraphic(Paths.getImagePath('default-mod-icon'));
		descIcon.scale.set(0.5, 0.5);
		descIcon.setPosition(FlxG.width - descIcon.width, 325);
		add(descIcon);

		descriptionText = new FlxText(descBg.x, descBg.y + 4, FlxG.width, 'Template Description', 16);
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

	function loadMods()
	{
		page.forEachExists(function(option:FlxText)
		{
			page.remove(option);
			option.kill();
			option.destroy();
		});

		var optionLoopNum:Int = 0;

		if (PolymodHandler.metadataArrays.length < 1)
		{
			return;
		}

		for (modId in PolymodHandler.metadataArrays)
		{
			var modOption = new FlxText(10, 0, 0, ModList.modMetadatas.get(modId).title, 16);
			modOption.ID = optionLoopNum;
			page.add(modOption);
			optionLoopNum++;
		}
	}

	public var curModId = '';

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.getControlJustReleased('ui_up'))
		{
			curSelected -= 1;
			updateSel();
		}

		if (Controls.getControlJustReleased('ui_down'))
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

		if (curSelected < 0)
		{
			curSelected = page.length - 1;
			updateSel();
		}

		if (curSelected >= page.length)
		{
			curSelected = 0;
			updateSel();
		}

		var bruh = 0;

		if (PolymodHandler.metadataArrays.length >= 1)
		{
			for (x in page.members)
			{
				x.y = 10 + (bruh * 32);
				x.alpha = ModList.getModEnabled(PolymodHandler.metadataArrays[x.ID]) ? 1.0 : 0.6;
				x.color = (curSelected == x.ID) ? FlxColor.YELLOW : FlxColor.WHITE;

				if (curSelected == x.ID)
				{
					@:privateAccess
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

					descriptionText.text = ModList.modMetadatas.get(curModId).description + '\nContributors:\n';

					var i = 0;
					var len = ModList.modMetadatas.get(curModId).contributors.length - 1;
					for (contributor in ModList.modMetadatas.get(curModId).contributors)
					{
						i++;
						descriptionText.text += '  *' + contributor.name + '(' + contributor.role + ')';
					}

					descriptionText.text += '\nAPI Version: ' + ModList.modMetadatas.get(curModId).apiVersion + outdatedText + '\nMod Version: '
						+ ModList.modMetadatas.get(curModId).modVersion + '\n';
					descriptionText.applyMarkup(descriptionText.text, [
						new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.YELLOW, true, true), '%'),
						new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.ORANGE, true, true), '$')
					]);
				}

				bruh++;
			}
		}
	}

	function updateSel()
	{
		descIcon.loadGraphic(Paths.getImagePath('default-mod-icon'));

		if (PolymodHandler.metadataArrays.length < 1)
			return;

		curModId = PolymodHandler.metadataArrays[curSelected];
		var modMeta = ModList.modMetadatas.get(curModId);

		if (modMeta.icon != null)
			descIcon.loadGraphic(BitmapData.fromBytes(modMeta.icon));
	}
}
