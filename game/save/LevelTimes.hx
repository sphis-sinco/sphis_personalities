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
var level_paused:Bool;

function onCreate(event:CreateEvent)
{
	level_paused = false;
	levelTime = 0;
	levelTimer = new FlxTimer();

	levelTimerText = new FlxText();
	levelTimerText.size = 16;
	levelTimerText.x = 32;
	levelTimerText.y = levelTimerText.x;
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
				if (levelTime > FlxG.save.data.levelTimes.level1)
					FlxG.save.data.levelTimes.level1 = levelTime;
			}
		}, 0);

		FlxG.state.add(levelTimerText);
	}
}

function onUpdate(event:UpdateEvent)
{
	levelTimerText.text = 'Time survived: ' + levelTime;

	if (levelTimer.active)
	{
		if (event.state == 'level1')
		{
			if (FlxG.save.data.levelTimes.level1 != null)
			{
				levelTimerText.text += ' (best: ' + FlxG.save.data.levelTimes.level1 + ')';
			}
		}

		if (Controls.getControlJustReleased('ui_leave') && level_paused)
		{
			FlxG.save.flush();
		}
		if (Controls.getControlJustReleased('game_pause'))
		{
			level_paused = !level_paused;
		}
	}
}
