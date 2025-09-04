package game;

import flixel.FlxState;
import game.scripts.ScriptManager;
import haxe.PosInfos;

class State extends FlxState
{
        public var state:String;

        override public function new(?stateID:String, ?posInfos:PosInfos) {
                super();

                if (stateID != null)
                        this.state = stateID;
                else 
                        this.state = '${posInfos.fileName}${posInfos.className}';
        }

        override function create() {
                super.create();

		ScriptManager.call('onCreate', [state]);
        }

        override function update(elapsed:Float) {
                super.update(elapsed);

		ScriptManager.call('onUpdate', [state, elapsed]);
        }
        
}