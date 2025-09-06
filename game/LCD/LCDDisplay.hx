import flixel.FlxG;
import flixel.FlxSprite;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var scanlines:FlxSprite;
var acceptedStates = ['desktop-main', 'desktop-play'];

function onCreate(event:CreateEvent)
{
	scanlines = new FlxSprite();
	scanlines.loadGraphic(Paths.getImagePath('LCD/scanlines'));
	scanlines.screenCenter();
	scanlines.scrollFactor.set(0, 0);

	if (acceptedStates.contains(event.state))
	{
		switch (event.state)
		{
			case 'desktop-main':
				DesktopMain.instance.scanlineLayer.add(scanlines);
			case 'desktop-play':
				DesktopPlay.instance.scanlineLayer.add(scanlines);
		}
	}
}

function onUpdate(event:UpdateEvent)
{
	if (scanlines != null)
	{
		scanlines.alpha = FlxG.random.float(0.15, 0.2);
	}
}
