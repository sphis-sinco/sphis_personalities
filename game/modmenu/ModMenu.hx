import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import game.desktop.DesktopMain;
import game.mods.ModManager;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
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

		modText = new FlxText(10, msgBG.height + 16, 0, '', 16);
		BlankState.instance.add(modText);

		BlankState.instance.add(msgBG);
		BlankState.instance.add(msgText);
	}
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'mod-menu')
	{
		if (FlxG.keys.justReleased.TAB)
		{
			FlxG.switchState(() -> new DesktopMain());
		}

		if (ModManager.MOD_IDS.length > 0)
		{
			if (Controls.getControlJustReleased('ui_up'))
				curSel--;

			if (Controls.getControlJustReleased('ui_down'))
				curSel++;

			if (Controls.getControlJustReleased('ui_accept'))
			{
				Paths.saveContent('mods/' + ModManager.MOD_IDS[curSel] + '/' + ModManager.MOD_DISABLE_FILE,
					(ModManager.MODS_DISABLED.contains(ModManager.MOD_IDS[curSel])) ? '' : 'disabled');
			}

			if (curSel < 0)
				curSel = 0;
			if (curSel >= ModManager.MOD_IDS.length)
				curSel = ModManager.MOD_IDS.length - 1;

			modText.text = ModManager.MOD_METAS.get(ModManager.MOD_IDS[curSel]).name
				+ ' (active: '
				+ !ModManager.MODS_DISABLED.contains(ModManager.MOD_IDS[curSel])
				+ ', priority: '
				+ ModManager.MOD_METAS.get(ModManager.MOD_IDS[curSel]).priority
				+ ')';
			modText.screenCenter();
		}
		else
		{
			modText.text = 'No mods downloaded.';
			modText.screenCenter();
		}
	}
}
