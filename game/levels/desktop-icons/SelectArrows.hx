import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import game.Paths;
import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedAxes;

var leftArrow:FlxSprite;
var rightArrow:FlxSprite;
var arrowsnotLeaving:Bool;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-play')
	{
		arrowsnotLeaving = true;
		leftArrow = new FlxSprite();
		leftArrow.loadGraphic(Paths.getImagePath('levels/desktop-icons/select-arrow'));
		leftArrow.flipX = true;

		leftArrow.scale.set(.25, .25);
		leftArrow.updateHitbox();

		leftArrow.screenCenter(FlxScriptedAxes.Y);
		leftArrow.x = 32;

		leftArrow.scrollFactor.set(0, 0);

		rightArrow = new FlxSprite();
		rightArrow.loadGraphic(Paths.getImagePath('levels/desktop-icons/select-arrow'));

		rightArrow.scale.set(.25, .25);
		rightArrow.updateHitbox();

		rightArrow.scrollFactor.set(0, 0);

		leftArrow.alpha = 0;
		rightArrow.alpha = 0;

		FlxTween.tween(leftArrow, {alpha: 1}, 1, {
			ease: FlxEase.sineInOut
		});
		FlxTween.tween(rightArrow, {alpha: 1}, 1, {
			ease: FlxEase.sineInOut
		});

		FlxG.state.add(leftArrow);
		FlxG.state.add(rightArrow);
	}
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-play')
	{
		if (leftArrow != null && rightArrow != null)
		{
			leftArrow.scale.set(.25, .25);
			rightArrow.scale.set(.25, .25);

			if (arrowsnotLeaving)
			{
				if (DesktopPlay.instance.curSel - 1 < 0)
					leftArrow.alpha = .5;
				else
					leftArrow.alpha = 1;
				if (DesktopPlay.instance.curSel + 1 >= DesktopPlay.instance.levels.length)
					rightArrow.alpha = .5;
				else
					rightArrow.alpha = 1;
			}

			if (Controls.getControlPressed('ui_left') && arrowsnotLeaving)
			{
				if (DesktopPlay.instance.curSel > 0)
					leftArrow.scale.set(.3, .15);
				else
					leftArrow.scale.set(.15, .3);
			}
			if (Controls.getControlPressed('ui_right') && arrowsnotLeaving)
			{
				if (DesktopPlay.instance.curSel < DesktopPlay.instance.levels.length - 1)
					rightArrow.scale.set(.3, .15);
				else
					rightArrow.scale.set(.15, .3);
			}
			if (arrowsnotLeaving && Controls.getControlJustReleased('ui_leave'))
			{
				arrowsnotLeaving = false;

				FlxTween.tween(leftArrow, {alpha: 0}, 1, {
					ease: FlxEase.sineInOut
				});
				FlxTween.tween(rightArrow, {alpha: 0}, 1, {
					ease: FlxEase.sineInOut
				});
			}
			if (arrowsnotLeaving)
			{
				rightArrow.screenCenter(FlxScriptedAxes.Y);
				rightArrow.x = FlxG.width - rightArrow.width - 32;
			}
		}
	}
}
