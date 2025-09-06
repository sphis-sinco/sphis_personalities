import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.desktop.DesktopMain;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var msgText:FlxText;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-main')
	{
		msgText = new FlxText(0, 0, 0, 'Press [TAB] to move to the Mod Menu', 16);
		msgText.color = FlxColor.WHITE;
		DesktopMain.instance.add(msgText);
	}
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-main')
	{
		if (FlxG.keys.justReleased.TAB)
		{
			FlxG.switchState(() -> new BlankState('mod-menu'));
		}
	}
}
