package net.richardlord.asteroids;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

class Main extends Sprite
{
	public function new()
	{
		super();
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame(event:Event):Void
	{
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        
		var asteroids = new Asteroids( this, stage.stageWidth, stage.stageHeight );
        asteroids.start();
	}
	
    private static function main()
    {
		Lib.current.addChild(new Main());
    }
}
