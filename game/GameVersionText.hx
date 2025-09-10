import flixel.FlxG;
import flixel.text.FlxText;
import game.scripts.events.CreateEvent;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-main' || event.state == 'desktop-play')
	{
		var gameVerTxt = new FlxText(0, 0, 0, GameVersion.get, 16);
		gameVerTxt.y = FlxG.height - gameVerTxt.height;
		FlxG.state.add(gameVerTxt);
	}
}
