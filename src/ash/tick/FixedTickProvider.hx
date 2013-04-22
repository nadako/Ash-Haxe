package ash.tick;

import flash.display.DisplayObject;
import flash.events.Event;

import ash.signals.Signal1;

/**
 * Uses the enter frame event to provide a frame tick with a fixed frame duration. This tick ignores the length of
 * the frame and dispatches the same time period for each tick.
 */
class FixedTickProvider implements ITickProvider
{
    private var displayObject:DisplayObject;
    private var frameTime:Float;
    private var signal:Signal1<Float>;

    public var playing(default, null):Bool;

    /**
     * Applies a time adjustment factor to the tick, so you can slow down or speed up the entire engine.
     * The update tick time is multiplied by this value, so a value of 1 will run the engine at the normal rate.
     */
    public var timeAdjustment:Float = 1;

    public function new(displayObject:DisplayObject, frameTime:Float)
    {
        playing = false;
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
        playing = true;
    }

    public function stop():Void
    {
        playing = false;
        displayObject.removeEventListener(Event.ENTER_FRAME, dispatchTick);
    }

    private function dispatchTick(event:Event):Void
    {
        signal.dispatch(frameTime * timeAdjustment);
    }
}
