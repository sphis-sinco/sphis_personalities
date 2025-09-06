import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-play' && Controls.getControlJustReleased('ui_leave'))
	{
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
			FlxG.switchState(() -> new DesktopMain());
		});
	}
}
