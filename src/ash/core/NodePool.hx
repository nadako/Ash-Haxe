package ash.core;

/**
 * This internal class maintains a pool of deleted nodes for reuse by framework. This reduces the overhead
 * from object creation and garbage collection.
 */
class NodePool<TNode:Node<TNode>>
{
    private var tail:TNode;
    private var nodeClass:Class<TNode>;
    private var cacheTail:TNode;

    public function new(nodeClass:Class<TNode>)
    {
        this.nodeClass = nodeClass;
    }

    public function get():TNode
    {
        if (tail != null)
        {
            var node:TNode = tail;
            tail = tail.previous;
            node.previous = null;
            return node;
        }
        else
        {
            return Type.createInstance(nodeClass, []);
        }
    }

    public function dispose(node:TNode):Void
    {
        node.next = null;
        node.previous = tail;
        tail = node;
    }

    public function cache(node:TNode):Void
    {
        node.previous = cacheTail;
        cacheTail = node;
    }

    public function releaseCache():Void
    {
        while (cacheTail != null)
        {
            var node:TNode = cacheTail;
            cacheTail = node.previous;
            node.next = null;
            node.previous = tail;
            tail = node;
        }
    }
}
