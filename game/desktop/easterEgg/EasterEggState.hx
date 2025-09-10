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

		var links = ['a4NlCCWQeTE', 'dcxZIM9HDbY', 'dJEQTErpqTY'];
		var link = links[FlxG.random.int(0, links.length - 1)];

		FlxG.sound.play(Paths.getSoundPath(link, 'desktop/eaterEgg'), 1, false, null, true, () ->
		{
			FlxG.switchState(() -> new DesktopMain());
		});
	}
}

function onUpdate(event:UpdateEvent)
{
	if (Controls.getControlJustReleased('ui_leave') && event.state == 'z-easter-egg')
	{
		FlxG.switchState(() -> new DesktopMain());
	}
}
