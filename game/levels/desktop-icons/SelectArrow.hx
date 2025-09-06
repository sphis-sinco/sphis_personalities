import flixel.FlxG;
import flixel.FlxSprite;
import game.desktop.DesktopPlay;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

var leftArrow:FlxSprite;
var rightArrow:FlxSprite;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-play')
	{
		if (leftArrow == null)
		{
			leftArrow = new FlxSprite();
			leftArrow.loadGraphic(Paths.getImagePath('levels/desktop-icons/select-arrow'));
			leftArrow.flipX = true;

			leftArrow.scale.set(.25, .25);
			leftArrow.updateHitbox();

			leftArrow.screenCenter(Y);
			leftArrow.x = 32;

			leftArrow.scrollFactor.set(0, 0);
		}
		if (rightArrow == null)
		{
			rightArrow = new FlxSprite();
			rightArrow.loadGraphic(Paths.getImagePath('levels/desktop-icons/select-arrow'));

			rightArrow.scale.set(.25, .25);
			rightArrow.updateHitbox();

			rightArrow.screenCenter(Y);
			rightArrow.x = FlxG.width - rightArrow.width - 32;

			rightArrow.scrollFactor.set(0, 0);
		}

		FlxG.state.add(leftArrow);
		FlxG.state.add(rightArrow);
	}
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'desktop-play') {}
}
