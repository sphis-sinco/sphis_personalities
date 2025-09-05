import flixel.FlxG;
import flixel.util.FlxTimer;
import game.desktop.DesktopMain;

var desktopMain:DesktopMain = null;

function onCreate(state:String)
{
	desktopMain = null;

	if (state == 'desktop-main')
		desktopMain = DesktopMain.instance;
}

function onUpdate(state:String, elapsed:Float)
{
	if (desktopMain != null)
	{
		if (FlxG.mouse.overlaps(desktopMain.haxen) && FlxG.mouse.justReleased)
		{
			desktopMain.haxen_changeState('boop');
			new FlxTimer().start(1, function(tmr)
			{
				desktopMain.haxen_idle();
			});
		}
	}
}
