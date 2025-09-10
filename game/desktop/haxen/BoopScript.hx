import flixel.FlxG;
import flixel.util.FlxTimer;
import game.Paths;
import game.desktop.DesktopMain;
import game.scripts.events.AddedEvent;
import game.scripts.events.UpdateEvent;

var haxenIdleStates = [];
var haxenSelected = false;

function onAdded(event:AddedEvent)
{
	haxenIdleStates.push(Paths.getImagePath('desktop/haxen/idle-left'));
	haxenIdleStates.push(Paths.getImagePath('desktop/haxen/idle-right'));
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-main')
	{
		if (DesktopMain.instance.haxen.y == DesktopMain.instance.haxenStartingYPosition && !haxenSelected)
			DesktopMain.instance.haxen.alpha = 0.75;

		if (Mouse.overlaps(DesktopMain.instance.haxen) && DesktopMain.instance.haxen.y == DesktopMain.instance.haxenStartingYPosition)
		{
			if (!haxenSelected)
			{
				haxenSelected = true;
				FlxG.sound.play(Paths.getSoundPath('ui_select_1', 'desktop'));
			}
			DesktopMain.instance.haxen.alpha = 1;

			if (Mouse.justReleased && haxenIdleStates.contains(DesktopMain.instance.haxen.graphic.key))
			{
				DesktopMain.instance.haxen_changeState('boop');
				FlxG.sound.play(Paths.getSoundPath('little-old-lady', 'desktop/haxen'));
				new FlxTimer().start(1, function(tmr)
				{
					DesktopMain.instance.haxen_idle();
				});
			}
		}
		else
		{
			haxenSelected = false;
		}
	}
}
