package ash.signals;

/**
 * A node in the list of listeners in a signal.
 */
class ListenerNode<TListener>
{
    public var previous:ListenerNode<TListener>;
    public var next:ListenerNode<TListener>;

    #if (cpp && !haxe3) // see http://code.google.com/p/hxcpp/issues/detail?id=196
    public var listener(get_listener, set_listener):TListener;
    #else
    public var listener:TListener;
    #end

    public var once:Bool;

    public function new()
    {
    }

    #if (cpp && !haxe3) // see http://code.google.com/p/hxcpp/issues/detail?id=196
    private function get_listener():TListener
    {
        return listener;
    }
    private function set_listener(value:TListener):TListener
    {
        return listener = value;
    }
    #end
}
