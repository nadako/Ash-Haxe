/*
 * Based on ideas used in Robert Penner's AS3-signals - https://github.com/robertpenner/as3-signals
 */
package ash.signals;

/**
 * Provides a fast signal for use where three parameters are dispatched with the signal.
 */
class Signal3<T1, T2, T3> extends SignalBase<T1->T2->T3->Void>
{
    public function new()
    {
        super();
    }

    public function dispatch(object1:T1, object2:T2, object3:T3):Void
    {
        startDispatch();
        for (node in this)
        {
            node.listener(object1, object2, object3);
            if (node.once)
                remove(node.listener);
        }
        endDispatch();
    }
}
