import game.desktop.DesktopPlay;
import game.scripts.events.AddedEvent;

function onAdded(event:AddedEvent)
{
	trace('Initalizing all level modules');
	DesktopPlay.initalizeLevelModules('game/levels/data');
}
