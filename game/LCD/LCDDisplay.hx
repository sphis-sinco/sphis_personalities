import flixel.FlxG;
import flixel.FlxSprite;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var scanlines:FlxSprite;

function onCreate(event:CreateEvent)
{
	if (scanlines == null)
	{
		scanlines = new FlxSprite();
		scanlines.loadGraphic(Paths.getImagePath('LCD/scanlines'));
		scanlines.screenCenter();
	}

	FlxG.state.add(scanlines);
}

function onUpdate(event:UpdateEvent)
{
	if (scanlines != null)
	{
		scanlines.alpha = FlxG.random.float(0, 1);
	}
}
