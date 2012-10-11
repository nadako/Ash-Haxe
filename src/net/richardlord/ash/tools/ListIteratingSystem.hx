package net.richardlord.ash.tools;

import net.richardlord.ash.core.Game;
import net.richardlord.ash.core.Node;
import net.richardlord.ash.core.NodeList;
import net.richardlord.ash.core.System;

/**
 * A useful class for systems which simply iterate over a set of nodes, performing the same action on each node. This
 * class removes the need for a lot of boilerplate code in such systems. Extend this class and pass the node type and
 * a node update method into the constructor. The node update method will be called once per node on the update cycle
 * with the node instance and the frame time as parameters. e.g.
 *
 * <code>package
 * {
 *   public class MySystem extends ListIteratingSystem
 *   {
 *     public function MySystem()
 *     {
 *       super( MyNode, updateNode );
 *     }
 *
 *     private function updateNode( node : MyNode, time : Number ) : void
 *     {
 *       // process the node here
 *     }
 *   }
 * }</code>
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
        this.nodeClass = nodeClass;
        this.nodeUpdateFunction = nodeUpdateFunction;
        this.nodeAddedFunction = nodeAddedFunction;
        this.nodeRemovedFunction = nodeRemovedFunction;
    }

    override public function addToGame(game:Game):Void
    {
        nodeList = game.getNodeList(nodeClass);
        if (nodeAddedFunction != null)
        {
            var node:TNode = nodeList.head;
            while (node != null)
            {
                nodeAddedFunction(node);
                node = node.next;
            }
            nodeList.nodeAdded.add(nodeAddedFunction);
        }
        if (nodeRemovedFunction != null)
        {
            nodeList.nodeRemoved.add(nodeRemovedFunction);
        }
    }

    override public function removeFromGame(game:Game):Void
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
        var node:TNode = nodeList.head;
        while (node != null)
        {
            nodeUpdateFunction(node, time);
            node = node.next;
        }
    }
}
