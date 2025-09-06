import flixel.FlxG;
import flixel.text.FlxText;
import game.desktop.DesktopMain;
import game.scripts.events.AddedEvent;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var msgText:FlxText;

function onAdded(event:AddedEvent)
{
	msgText = new FlxText(0, 0, 0, 'Press [TAB] to move to the Mod Menu', 16);
	msgText.y = FlxG.height - msgText.height;
}

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-main')
	{
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
