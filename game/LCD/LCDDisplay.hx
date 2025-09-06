import flixel.FlxG;
import flixel.FlxSprite;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var scanlines:FlxSprite;
var acceptedStates = ['desktop-main', 'desktop-play'];

function onCreate(event:CreateEvent)
{
	scanlines = new FlxSprite();
	scanlines.loadGraphic(Paths.getImagePath('LCD/scanlines'));
	scanlines.screenCenter();

	if (acceptedStates.contains(event.state))
		FlxG.state.add(scanlines);
}

function onUpdate(event:UpdateEvent)
{
	if (scanlines != null)
	{
		scanlines.alpha = FlxG.random.float(0.05, 0.1);
	}
}
