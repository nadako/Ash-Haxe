package net.richardlord.ash.tick;

import flash.display.DisplayObject;
import flash.events.Event;

import net.richardlord.signals.Signal1;

/**
 * Provides a frame tick with a fixed frame duration. This tick ignores the length of
 * the frame and dispatches the same time period for each tick.
 */
class FixedTickProvider implements ITickProvider
{
    private var displayObject:DisplayObject;
    private var frameTime:Float;
    private var signal:Signal1<Float>;

    /**
     * Applies a time adjustement factor to the tick, so you can slow down or speed up the entire game.
     * The update tick time is multiplied by this value, so a value of 1 will run the game at the normal rate.
     */
    public var timeAdjustment:Float = 1;

    public function new(displayObject:DisplayObject, frameTime:Float)
    {
        signal = new Signal1<Float>();
        this.displayObject = displayObject;
        this.frameTime = frameTime;
    }

    public function add(listener:Float->Void):Void
    {
        signal.add(listener);
    }

    public function remove(listener:Float->Void):Void
    {
        signal.remove(listener);
    }

    public function start():Void
    {
        displayObject.addEventListener(Event.ENTER_FRAME, dispatchTick);
    }

    public function stop():Void
    {
        displayObject.removeEventListener(Event.ENTER_FRAME, dispatchTick);
    }

    private function dispatchTick(event:Event):Void
    {
        signal.dispatch(frameTime * timeAdjustment);
    }
}
