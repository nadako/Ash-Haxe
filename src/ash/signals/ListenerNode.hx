package ash.signals;

/**
 * A node in the list of listeners in a signal.
 */
class ListenerNode<TListener>
{
    public var previous:ListenerNode<TListener>;
    public var next:ListenerNode<TListener>;
    public var listener:TListener;
    public var once:Bool;

    public function new()
    {
    }
}
