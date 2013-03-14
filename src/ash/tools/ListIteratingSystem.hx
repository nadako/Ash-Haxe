package ash.tools;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

/**
 * A useful class for systems which simply iterate over a set of nodes, performing the same action on each node. This
 * class removes the need for a lot of boilerplate code in such systems. Extend this class and pass the node type and
 * a node update method into the constructor. The node update method will be called once per node on the update cycle
 * with the node instance and the frame time as parameters. e.g.
 *
 * <code>package;
 * class MySystem extends ListIteratingSystem<MyNode>
 * {
 *     public function new()
 *     {
 *         super(MyNode, updateNode);
 *     }
 *
 *     private function updateNode(node:MyNode, time:Float):Void
 *     {
 *         // process the node here
 *     }
 * }
 * </code>
 */
class ListIteratingSystem<TNode:Node<TNode>> extends System
{
    private var nodeList:NodeList<TNode>;
    private var nodeClass:Class<TNode>;
    private var nodeUpdateFunction:TNode->Float->Void;
    private var nodeAddedFunction:TNode->Void;
    private var nodeRemovedFunction:TNode->Void;

    public function new(nodeClass:Class<TNode>, nodeUpdateFunction:TNode->Float->Void, nodeAddedFunction:TNode->Void = null, nodeRemovedFunction:TNode->Void = null)
    {
        super();
        this.nodeClass = nodeClass;
        this.nodeUpdateFunction = nodeUpdateFunction;
        this.nodeAddedFunction = nodeAddedFunction;
        this.nodeRemovedFunction = nodeRemovedFunction;
    }

    override public function addToEngine(engine:Engine):Void
    {
        nodeList = engine.getNodeList(nodeClass);
        if (nodeAddedFunction != null)
        {
            for (node in nodeList)
                nodeAddedFunction(node);
            nodeList.nodeAdded.add(nodeAddedFunction);
        }
        if (nodeRemovedFunction != null)
        {
            nodeList.nodeRemoved.add(nodeRemovedFunction);
        }
    }

    override public function removeFromEngine(engine:Engine):Void
    {
        if (nodeAddedFunction != null)
        {
            nodeList.nodeAdded.remove(nodeAddedFunction);
        }
        if (nodeRemovedFunction != null)
        {
            nodeList.nodeRemoved.remove(nodeRemovedFunction);
        }
        nodeList = null;
    }

    override public function update(time:Float):Void
    {
        if (nodeUpdateFunction != null)
        {
            for (node in nodeList)
                nodeUpdateFunction(node, time);
        }
    }
}
