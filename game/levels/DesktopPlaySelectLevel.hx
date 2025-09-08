import flixel.FlxG;
import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedColor;

var savedSelection:Null<Int>;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-play')
		savedSelection = null;
}

function onUpdate(event:UpdateEvent)
{
	if (savedSelection != null && DesktopPlay.instance.curSel != savedSelection && event.state == 'desktop-play')
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
