import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedAxes;
import game.scripts.imports.FlxScriptedColor;
import game.scripts.imports.FlxTextScriptedBorderStyle;

var levelTime = 0;
var levelTimer:FlxTimer;
var levelTimerText:FlxText;

function onCreate(event:CreateEvent)
{
	levelTime = 0;
	levelTimer = new FlxTimer();

	levelTimerText = new FlxText();
	levelTimerText.size = 16;
	levelTimerText.screenCenter(FlxScriptedAxes.X);
	levelTimerText.y = 32;
	levelTimerText.color = FlxScriptedColor.WHITE;
	levelTimerText.setBorderStyle(FlxTextScriptedBorderStyle.OUTLINE, FlxScriptedColor.BLACK, 2);
	levelTimerText.alpha = 0.75;

	if (event.state == 'level1')
	{
		levelTimer.start(1, tmr ->
		{
			levelTime += 1;

			if (FlxG.save.data.levelTimes.level1 != null)
			{
				FlxG.save.data.levelTimes.level1 = levelTime;
			}
		}, 0);

		FlxG.state.add(levelTimerText);
	}
}

function onUpdate(event:UpdateEvent)
{
	levelTimerText.text = '' + levelTime;
}
