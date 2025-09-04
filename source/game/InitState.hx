package game;

import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{

        override function create() {
                super.create();

                FlxG.switchState(() -> new game.desktop.DesktopMain());
        }
        
}