import flixel.FlxSprite;
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

			leftArrow.x = 32;

			leftArrow.scrollFactor.set(0, 0);
		}
		if (rightArrow == null)
		{
			rightArrow = new FlxSprite();
			rightArrow.loadGraphic(Paths.getImagePath('levels/desktop-icons/select-arrow'));

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
