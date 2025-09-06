import flixel.FlxG;
import flixel.FlxSprite;
import game.Paths;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var hisHead:FlxSprite;

function onCreate(event:CreateEvent)
{
	if (event.state == 'z-easter-egg')
	{
		hisHead = new FlxSprite();
		hisHead.loadGraphic(Paths.getImagePath('desktop/easterEgg/hisHead'));
		FlxG.state.add(hisHead);
	}
}

function onUpdate(event:UpdateEvent)
{
	if (FlxG.keys.justReleased.ESCAPE && event.state == 'z-easter-egg')
	{
		FlxG.switchState(() -> new DesktopMain());
	}
}
