package ash.core;

/**
 * This internal class maintains a pool of deleted nodes for reuse by the framework. This reduces the overhead
 * from object creation and garbage collection.
 *
 * Because nodes may be deleted from a NodeList while in use, by deleting Nodes from a NodeList
 * while iterating through the NodeList, the pool also maintains a cache of nodes that are added to the pool
 * but should not be reused yet. They are then released into the pool by calling the releaseCache method.
 */
class NodePool<TNode:Node<TNode>>
{
    private var tail:TNode;
    private var nodeClass:Class<TNode>;
    private var cacheTail:TNode;

    /**
     * Creates a pool for the given node class.
     */
    public function new(nodeClass:Class<TNode>)
    {
        this.nodeClass = nodeClass;
    }

    /**
     * Fetches a node from the pool.
     */
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
            return Type.createEmptyInstance(nodeClass);
        }
    }

    /**
     * Adds a node to the pool.
     */
    public function dispose(node:TNode):Void
    {
        node.next = null;
        node.previous = tail;
        tail = node;
    }

    /**
     * Adds a node to the cache
     */
    public function cache(node:TNode):Void
    {
        node.previous = cacheTail;
        cacheTail = node;
    }

    /**
     * Releases all nodes from the cache into the pool
     */
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
