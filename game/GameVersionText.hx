import flixel.FlxG;
import flixel.text.FlxText;
import game.scripts.events.CreateEvent;
import game.scripts.imports.GameVersionScriptVersion;

function onCreate(event:CreateEvent)
{
	if (event.state == 'desktop-main' || event.state == 'desktop-play')
	{
		var gameVerTxt = new FlxText(0, 0, 0, GameVersionScriptVersion.get, 16);
		gameVerTxt.y = FlxG.height - gameVerTxt.height;
		gameVerTxt.scrollFactor.set();
		FlxG.state.add(gameVerTxt);
	}
}
