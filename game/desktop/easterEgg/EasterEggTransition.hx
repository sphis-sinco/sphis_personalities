import flixel.FlxG;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedColor;

var transitioning = false;

function onCreate(event:CreateEvent)
{
	transitioning = false;

	if (event.state == 'z-easter-egg')
	{
		FlxG.camera.fade(FlxScriptedColor.BLACK, 1, true, null);
	}
}

function onUpdate(event:UpdateEvent)
{
	if (!transitioning && (Controls.getControlJustReleased('general_openEasterEggMenu')))
	{
		if (event.state != 'z-easter-egg')
		{
			transitioning = true;

			if (event.state == 'desktop-main' || event.state == 'desktop-play')
			{
				FlxG.camera.fade(FlxScriptedColor.BLACK, 1, false, () ->
				{
					FlxG.switchState(() -> new BlankState('z-easter-egg'));
				});
			}
			else
				FlxG.switchState(() -> new BlankState('z-easter-egg'));
		}
	}
}
