import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedColor;

var savedSelection:Int;

function onUpdate(event:UpdateEvent)
{
	if (savedSelection != null && DesktopPlay.instance.curSel != savedSelection)
		DesktopPlay.instance.curSel = savedSelection;

	if ((savedSelection == null) && event.state == 'desktop-play')
	{
		if (Controls.getControlJustReleased('ui_accept'))
		{
			savedSelection = DesktopPlay.instance.curSel;

			var id = '';
			if (DesktopPlay.instance.levelMetas[savedSelection].id != null)
				id = DesktopPlay.instance.levelMetas[savedSelection].id;
			else
				id = DesktopPlay.instance.levels[savedSelection];

			FlxG.camera.fade(FlxScriptedColor.BLACK, 1, false, () ->
			{
				FlxG.switchState(() -> new BlankState(id));
			});
		}
	}
}
