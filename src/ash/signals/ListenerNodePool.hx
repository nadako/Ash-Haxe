package ash.signals;

/**
 * This internal class maintains a pool of deleted listener nodes for reuse by framework. This reduces
 * the overhead from object creation and garbage collection.
 */
class ListenerNodePool<TListener>
{
    private var tail:ListenerNode<TListener>;
    private var cacheTail:ListenerNode<TListener>;

    public function new()
    {
    }

    public function get():ListenerNode<TListener>
    {
        if (tail != null)
        {
            var node:ListenerNode<TListener> = tail;
            tail = tail.previous;
            node.previous = null;
            return node;
        }
        else
        {
            return new ListenerNode<TListener>();
        }
    }

    public function dispose(node:ListenerNode<TListener>):Void
    {
        node.listener = null;
        node.once = false;
        node.next = null;
        node.previous = tail;
        tail = node;
    }

    public function cache(node:ListenerNode<TListener>):Void
    {
        node.listener = null;
        node.previous = cacheTail;
        cacheTail = node;
    }

    public function releaseCache():Void
    {
        while (cacheTail != null)
        {
            var node:ListenerNode<TListener> = cacheTail;
            cacheTail = node.previous;
            node.next = null;
            node.previous = tail;
            tail = node;
        }
    }
}
