import game.desktop.DesktopPlay;
import game.scripts.events.AddedEvent;

function onAdded(event:AddedEvent)
{
	DesktopPlay.initalizeLevelModules('game/levels/data');
}
