package ash.tick;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.Lib;

import ash.signals.Signal1;

/**
 * Uses the enter frame event to provide a frame tick where the frame duration is the time since the previous frame.
 * There is a maximum frame time parameter in the constructor that can be used to limit
 * the longest period a frame can be.
 */
class FrameTickProvider implements ITickProvider
{
    private var displayObject:DisplayObject;
    private var previousTime:Float;
    private var maximumFrameTime:Float;
    private var signal:Signal1<Float>;

    public var playing(default, null):Bool;

    /**
     * Applies a time adjustment factor to the tick, so you can slow down or speed up the entire engine.
     * The update tick time is multiplied by this value, so a value of 1 will run the engine at the normal rate.
     */
    public var timeAdjustment:Float = 1;

    public function new(displayObject:DisplayObject, maximumFrameTime:Float = 9999999999999999.0)
    {
        playing = false;
        signal = new Signal1<Float>();
        this.displayObject = displayObject;
        this.maximumFrameTime = maximumFrameTime;
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
        previousTime = Lib.getTimer();
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
        var temp:Float = previousTime;
        previousTime = Lib.getTimer();
        var frameTime:Float = ( previousTime - temp ) / 1000;
        if (frameTime > maximumFrameTime)
            frameTime = maximumFrameTime;
        signal.dispatch(frameTime * timeAdjustment);
    }
}
