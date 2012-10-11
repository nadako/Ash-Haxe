/*
 * Based on ideas used in Robert Penner's AS3-signals - https://github.com/robertpenner/as3-signals
 */

package net.richardlord.signals;

/**
 * Provides a fast signal for use where no parameters are dispatched with the signal.
 */
class Signal0 extends SignalBase<Void -> Void>
{
    public function new()
    {
        super();
    }

    public function dispatch():Void
    {
        startDispatch();
        var node:ListenerNode<Void -> Void> = head;
        while (node != null)
        {
            node.listener();
            if (node.once)
                remove(node.listener);
            node = node.next;
        }
        endDispatch();
    }
}
