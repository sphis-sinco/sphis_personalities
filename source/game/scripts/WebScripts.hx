package game.scripts;

import flixel.FlxG;
import flixel.util.FlxTimer;
import game.desktop.DesktopMain;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.Mouse;
import game.MouseStates;
import game.scripts.events.AddedEvent;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var desktopMain:DesktopMain = null;

function onCreate(event:CreateEvent)
{
	desktopMain = null;
	if (event.state == 'desktop-main')
		desktopMain = DesktopMain.instance;
}

function onUpdate(event:UpdateEvent)
{
	if (desktopMain != null && event.state == 'desktop-main')
	{
		desktopMain.haxen.alpha = 0.75;
		if (FlxG.mouse.overlaps(desktopMain.haxen))
		{
			desktopMain.haxen.alpha = 1;
			if (FlxG.mouse.pressed)
				Mouse.setMouseState(MouseStates.SELECTED);
			if (FlxG.mouse.justReleased)
			{
				desktopMain.haxen_changeState('boop');
				new FlxTimer().start(1, function(tmr)
				{
					desktopMain.haxen_idle();
				});
			}
		}
	}
}

var desktopMain:DesktopMain = null;

function onCreate(event:CreateEvent)
{
	desktopMain = null;
	if (event.state == 'desktop-main')
		desktopMain = DesktopMain.instance;
}

function onUpdate(event:UpdateEvent)
{
	if (desktopMain != null && event.state == 'desktop-main')
	{
		desktopMain.option_play.alpha = 0.5;
		desktopMain.option_options.alpha = 0.5;
		if (FlxG.mouse.overlaps(desktopMain.option_play))
		{
			desktopMain.option_play.alpha = 1;
		}
		else if (FlxG.mouse.overlaps(desktopMain.option_options))
		{
			desktopMain.option_options.alpha = 0.25;
		}
	}
}

function onUpdate(event:UpdateEvent)
{
	Mouse.setMouseState(MouseStates.IDLE);
	if (event.state == 'desktop-main')
	{
		if (FlxG.mouse.overlaps(DesktopMain.instance.option_play))
			Mouse.setMouseState(MouseStates.CAN_SELECT);
		if (FlxG.mouse.overlaps(DesktopMain.instance.haxen))
			Mouse.setMouseState(MouseStates.CAN_SELECT);
		if (FlxG.mouse.overlaps(DesktopMain.instance.option_options))
			Mouse.setMouseState(MouseStates.CANT_SELECT);
	}
	if (FlxG.mouse.pressed && Mouse.state == MouseStates.CAN_SELECT)
	{
		Mouse.setMouseState(MouseStates.SELECTED);
	}
}

function onAdded(event:AddedEvent) {}
function onCreate(event:CreateEvent) {}
function onUpdate(event:UpdateEvent) {}
