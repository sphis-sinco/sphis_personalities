import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.scripts.events.UpdateEvent;

var savedSelection:Null<Int>;

function onUpdate(event:UpdateEvent)
{
	if ((savedSelection == null) && event.state == 'desktop-play' && Controls.getControlJustReleased('ui_leave'))
	{
		savedSelection = DesktopPlay.instance.curSel;
		for (obj in DesktopPlay.instance.levelsGrp.members)
		{
			FlxTween.tween(obj.levelIcon, {alpha: 0}, 1, {
				ease: FlxEase.sineInOut
			});
			FlxTween.tween(obj.lock, {alpha: 0}, 1, {
				ease: FlxEase.sineInOut
			});
		}
		for (obj in DesktopPlay.instance.levelsTextGrp.members)
		{
			FlxTween.tween(obj, {alpha: 0}, 1, {
				ease: FlxEase.sineInOut
			});
		}

		FlxG.sound.play(Paths.getSoundPath('desktop-play-transition', 'desktop'));
		new FlxTimer().start(1, tmr ->
		{
			savedSelection = null;
			FlxG.switchState(() -> new DesktopMain());
		});
	}

	if (savedSelection != null && DesktopPlay.instance.curSel != savedSelection)
		DesktopPlay.instance.curSel = savedSelection;
}
