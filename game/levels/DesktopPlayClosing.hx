import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.scripts.events.UpdateEvent;

var savedSelection:Int;

function onUpdate(event:UpdateEvent)
{
	if ((savedSelection == null) && event.state == 'desktop-play' && Controls.getControlJustReleased('ui_leave'))
	{
		savedSelection = DesktopPlay.instance.curSel;
		for (obj in DesktopPlay.instance.levelsGrp.members)
		{
			obj.levelIcon.alpha = 1;
			FlxTween.tween(obj.levelIcon, {alpha: 0}, 1, {
				ease: FlxEase.sineInOut
			});
			obj.box.alpha = 1;
			FlxTween.tween(obj.box, {alpha: 0}, 1, {
				ease: FlxEase.sineInOut
			});
			obj.lock.alpha = 1;
			FlxTween.tween(obj.lock, {alpha: 0}, 1, {
				ease: FlxEase.sineInOut
			});
		}
		for (obj in DesktopPlay.instance.levelsTextGrp.members)
		{
			obj.alpha = 1;
			FlxTween.tween(obj, {alpha: 0}, 1, {
				ease: FlxEase.sineInOut
			});
		}

		new FlxTimer().start(1, tmr ->
		{
			savedSelection = null;
			FlxG.switchState(() -> new DesktopMain());
		});
	}

	if (savedSelection != null && DesktopPlay.instance.curSel != savedSelection)
		DesktopPlay.instance.curSel = savedSelection;
}
