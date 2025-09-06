import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.desktop.DesktopMain;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var msgText:FlxText;
var msgBG:FlxSprite;

function onCreate(event:CreateEvent)
{
	if (event.state == 'mod-menu')
	{
		msgText = new FlxText(0, 0, 0, 'Press [TAB] to move back to Desktop (Main)', 16);
		msgText.color = FlxColor.WHITE;

		msgBG = new FlxSprite();
		msgBG.makeGraphic(FlxG.width, 32, FlxColor.BLACK);
		msgBG.setPosition(msgText.x, msgText.y);

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
	}
}
