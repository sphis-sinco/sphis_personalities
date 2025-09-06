import flixel.FlxG;
import flixel.FlxSprite;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var scanlineLayerOne:FlxSprite;
var scanlineLayerTwo:FlxSprite;
var scanlineAcceptedStates = ['desktop-main', 'desktop-play'];
var scanlineAngle = FlxG.random.float(0, 360);

function onCreate(event:CreateEvent)
{
	scanlineLayerOne = new FlxSprite();
	scanlineLayerOne.loadGraphic('mods/dummyMod/dumbshit/Sprite-0001');
	scanlineLayerOne.screenCenter();
	scanlineLayerOne.scrollFactor.set(0, 0);

	scanlineLayerTwo = new FlxSprite();
	scanlineLayerTwo.loadGraphic('mods/dummyMod/dumbshit/Sprite-0001');
	scanlineLayerTwo.screenCenter();
	scanlineLayerTwo.scrollFactor.set(0, 0);

	if (scanlineAcceptedStates.contains(event.state))
	{
		switch (event.state)
		{
			case 'desktop-main':
				DesktopMain.instance.scanlineLayer.add(scanlineLayerOne);
				DesktopMain.instance.scanlineLayer.add(scanlineLayerTwo);
			case 'desktop-play':
				DesktopPlay.instance.scanlineLayer.add(scanlineLayerOne);
				DesktopPlay.instance.scanlineLayer.add(scanlineLayerTwo);
		}
	}
}

function onUpdate(event:UpdateEvent)
{
	if (scanlineLayerOne != null)
	{
		scanlineAngle += (1 / FlxG.random.int(10, 100));
		scanlineLayerOne.angle = scanlineAngle;
		scanlineLayerOne.alpha = FlxG.random.float(0, 0.2);
		scanlineLayerTwo.angle = scanlineAngle + 90;
		scanlineLayerTwo.alpha = scanlineLayerOne.alpha;
	}
}
