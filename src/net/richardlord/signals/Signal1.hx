/*
 * Based on ideas used in Robert Penner's AS3-signals - https://github.com/robertpenner/as3-signals
 */

package net.richardlord.signals;

/**
 * Provides a fast signal for use where one parameter is dispatched with the signal.
 */
class Signal1<T1> extends SignalBase<T1 -> Void>
{
    public function new()
    {
        super();
    }

    public function dispatch(object:T1):Void
    {
        startDispatch();
        var node:ListenerNode<T1 -> Void> = head;
        while (node != null)
        {
            node.listener(object);
            if (node.once)
                remove(node.listener);
            node = node.next;
        }
        endDispatch();
    }
}
