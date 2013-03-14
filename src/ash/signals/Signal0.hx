/*
 * Based on ideas used in Robert Penner's AS3-signals - https://github.com/robertpenner/as3-signals
 */
package ash.signals;

/**
 * Provides a fast signal for use where no parameters are dispatched with the signal.
 */
class Signal0 extends SignalBase<Void->Void>
{
    public function new()
    {
        super();
    }

    public function dispatch():Void
    {
        startDispatch();
        for (node in this)
        {
            node.listener();
            if (node.once)
                remove(node.listener);
        }
        endDispatch();
    }
}
