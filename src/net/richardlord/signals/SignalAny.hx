/*
 * Based on ideas used in Robert Penner's AS3-signals - https://github.com/robertpenner/as3-signals
 */
package net.richardlord.signals;

/**
 * Provides a fast signal for use where any number of any parameters are dispatched with the signal.
 */
class SignalAny extends SignalBase<Dynamic>
{
    public var dispatch(default, null):Dynamic;

    public function new()
    {
        super();
        dispatch = Reflect.makeVarArgs(_dispatch);
    }

    private function _dispatch(args:Array<Dynamic>):Void
    {
        startDispatch();
        var node:ListenerNode<Dynamic> = head;
        while (node != null)
        {
            Reflect.callMethod(null, node.listener, args);
            if (node.once)
                remove(node.listener);
            node = node.next;
        }
        endDispatch();
    }
}
