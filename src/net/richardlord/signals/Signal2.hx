/*
 * Based on ideas used in Robert Penner's AS3-signals - https://github.com/robertpenner/as3-signals
 */
package net.richardlord.signals;

/**
 * Provides a fast signal for use where two parameters are dispatched with the signal.
 */
class Signal2<T1, T2> extends SignalBase<T1->T2->Void>
{
    public function new()
    {
        super();
    }

    public function dispatch(object1:T1, object2:T2):Void
    {
        startDispatch();
        var node:ListenerNode<T1->T2->Void> = head;
        while (node != null)
        {
            node.listener(object1, object2);
            if (node.once)
                remove(node.listener);
            node = node.next;
        }
        endDispatch();
    }
}
