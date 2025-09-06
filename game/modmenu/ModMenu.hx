import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import game.desktop.DesktopMain;
import game.mods.ModManager;
import game.scripts.ScriptManager;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedAxes;
import game.scripts.imports.FlxScriptedColor;

var modText:FlxText;
var msgText:FlxText;
var msgBG:FlxSprite;
var curSel:Int = 0;

function onCreate(event:CreateEvent)
{
	if (event.state == 'mod-menu')
	{
		msgText = new FlxText(0, 0, 0, 'Press [TAB] to move back to Desktop (Main)', 16);
		msgText.color = FlxScriptedColor.WHITE;
		msgText.scrollFactor.set();

		msgBG = new FlxSprite();
		msgBG.makeGraphic(FlxG.width, 32, FlxScriptedColor.BLACK);
		msgBG.setPosition(msgText.x, msgText.y);
		msgBG.scrollFactor.set();

		modText = new FlxText(0, msgBG.height + 16, FlxG.width, '', 16);
		modText.x = 0;
		modText.alignment = 'center';
		BlankState.instance.add(modText);

		BlankState.instance.add(msgBG);
		BlankState.instance.add(msgText);

		trace(ModManager.MOD_IDS.toString());
	}
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'mod-menu')
	{
		if (FlxG.keys.justReleased.TAB)
		{
			FlxG.switchState(() -> new DesktopMain());
			ScriptManager.checkForUpdatedScripts();
		}

		if (ModManager.MOD_IDS.length > 0)
		{
			if (Controls.getControlJustReleased('ui_left'))
				curSel -= 1;

			if (Controls.getControlJustReleased('ui_right'))
				curSel += 1;

			if (Controls.getControlJustReleased('ui_accept'))
			{
				Paths.saveContent('mods/' + ModManager.MOD_IDS[curSel] + '/' + ModManager.MOD_DISABLE_FILE,
					(ModManager.MODS_DISABLED.contains(ModManager.MOD_IDS[curSel])) ? '' : 'disabled');
				ModManager.loadMods();
			}

			if (curSel < 0)
				curSel = 0;
			if (curSel > ModManager.MOD_IDS.length - 1)
				curSel = ModManager.MOD_IDS.length - 1;

			modText.text = ModManager.MOD_METAS.get(ModManager.MOD_IDS[curSel]).name
				+ ' (active: '
				+ ModManager.MODS_ENABLED.contains(ModManager.MOD_IDS[curSel])
				+ ', priority: '
				+ ModManager.MOD_METAS.get(ModManager.MOD_IDS[curSel]).priority
				+ ')';
		}
		else
		{
			modText.text = 'No mods downloaded.';
		}
		modText.screenCenter(FlxScriptedAxes.Y);
	}
}
