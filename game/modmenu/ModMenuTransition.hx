import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.modding.ModMenu;
import game.scripts.ScriptManager;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedColor;

var transitioning = false;

function onCreate(event:UpdateEvent)
{
	transitioning = false;

	if (event.state == 'modmenu')
	{
		FlxG.camera.fade(FlxScriptedColor.BLACK, 1, true, null);
	}
}

function onUpdate(event:UpdateEvent)
{
	if (!transitioning && (FlxG.keys.justReleased.F4 || (FlxG.keys.pressed.SHIFT && FlxG.keys.justReleased.FOUR)))
	{
		if (event.state == 'desktop-main' || event.state == 'desktop-play')
		{
			transitioning = true;

			FlxG.camera.fade(FlxScriptedColor.BLACK, 1, false, () ->
			{
				FlxG.switchState(() -> new ModMenu());
			});
		}
	}
}
