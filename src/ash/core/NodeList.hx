package ash.core;

import ash.GenericListIterator;
import ash.signals.Signal1;

/**
 * A collection of nodes.
 *
 * <p>Systems within the engine access the components of entities via NodeLists. A NodeList contains
 * a node for each Entity in the engine that has all the components required by the node. To iterate
 * over a NodeList, start from the head and step to the next on each loop, until the returned value
 * is null. Or just use for in syntax.</p>
 *
 * <p>for (node in nodeList)
 * {
 *   // do stuff
 * }</p>
 *
 * <p>It is safe to remove items from a nodelist during the loop. When a Node is removed form the
 * NodeList it's previous and next properties still point to the nodes that were before and after
 * it in the NodeList just before it was removed.</p>
 */
class NodeList<TNode:Node<TNode>>
{
    /**
    * The first item in the node list, or null if the list contains no nodes.
    */
    public var head(default, null):TNode;
    /**
     * The last item in the node list, or null if the list contains no nodes.
     */
    public var tail(default, null):TNode;

    /**
     * A signal that is dispatched whenever a node is added to the node list.
     *
     * <p>The signal will pass a single parameter to the listeners - the node that was added.</p>
     */
    public var nodeAdded(default, null):Signal1<TNode>;

    /**
     * A signal that is dispatched whenever a node is removed from the node list.
     *
     * <p>The signal will pass a single parameter to the listeners - the node that was removed.</p>
     */
    public var nodeRemoved(default, null):Signal1<TNode>;

    public function new()
    {
        nodeAdded = new Signal1<TNode>();
        nodeRemoved = new Signal1<TNode>();
    }

    public function add(node:TNode):Void
    {
        if (head == null)
        {
            head = tail = node;
            node.next = node.previous = null;
        }
        else
        {
            tail.next = node;
            node.previous = tail;
            node.next = null;
            tail = node;
        }
        nodeAdded.dispatch(node);
    }

    public function remove(node:TNode):Void
    {
        if (head == node)
            head = head.next;
        if (tail == node)
            tail = tail.previous;

        if (node.previous != null)
            node.previous.next = node.next;

        if (node.next != null)
            node.next.previous = node.previous;

        nodeRemoved.dispatch(node);
        // N.B. Don't set node.next and node.previous to null because that will break the list iteration if node is the current node in the iteration.
    }

    public function removeAll():Void
    {
        while (head != null)
        {
            var node:TNode = head;
            head = head.next;
            node.previous = null;
            node.next = null;
            nodeRemoved.dispatch(node);
        }
        tail = null;
    }

    /**
     * true if the list is empty, false otherwise.
     */
    public var empty(get_empty, never):Bool;

    private inline function get_empty():Bool
    {
        return head == null;
    }

    public function iterator():Iterator<TNode>
    {
        return new GenericListIterator(head);
    }

    /**
     * Swaps the positions of two nodes in the list. Useful when sorting a list.
     */

    public function swap(node1:TNode, node2:TNode):Void
    {
        if (node1.previous == node2)
        {
            node1.previous = node2.previous;
            node2.previous = node1;
            node2.next = node1.next;
            node1.next = node2;
        }
        else if (node2.previous == node1)
        {
            node2.previous = node1.previous;
            node1.previous = node2;
            node1.next = node2.next;
            node2.next = node1;
        }
        else
        {
            var temp:TNode = node1.previous;
            node1.previous = node2.previous;
            node2.previous = temp;
            temp = node1.next;
            node1.next = node2.next;
            node2.next = temp;
        }
        if (head == node1)
            head = node2;
        else if (head == node2)
            head = node1;
        if (tail == node1)
            tail = node2;
        else if (tail == node2)
            tail = node1;
        if (node1.previous != null)
            node1.previous.next = node1;
        if (node2.previous != null)
            node2.previous.next = node2;
        if (node1.next != null)
            node1.next.previous = node1;
        if (node2.next != null)
            node2.next.previous = node2;
    }


    /**
     * Performs an insertion sort on the node list. In general, insertion sort is very efficient with short lists
     * and with lists that are mostly sorted, but is inefficient with large lists that are randomly ordered.
     *
     * <p>The sort function takes two nodes and returns an Int.</p>
     *
     * <p><code>function sortFunction( node1 : MockNode, node2 : MockNode ) : Int</code></p>
     *
     * <p>If the returned number is less than zero, the first node should be before the second. If it is greater
     * than zero the second node should be before the first. If it is zero the order of the nodes doesn't matter
     * and the original order will be retained.</p>
     *
     * <p>This insertion sort implementation runs in place so no objects are created during the sort.</p>
     */

    public function insertionSort(sortFunction:SortFunction<TNode>):Void
    {
        if (head == tail)
            return;

        var remains:TNode = head.next;
        var node:TNode = remains;
        while (node != null)
        {
            remains = node.next;

            var other:TNode = node.previous;
            while (other != null)
            {
                if (sortFunction(node, other) >= 0)
                {
                    // move node to after other
                    if (node != other.next)
                    {
                        // remove from place
                        if (tail == node)
                            tail = node.previous;

                        node.previous.next = node.next;
                        if (node.next != null)
                            node.next.previous = node.previous;

                        // insert after other
                        node.next = other.next;
                        node.previous = other;
                        node.next.previous = node;
                        other.next = node;
                    }
                    break; // exit the inner for loop
                }

                other = other.previous;
            }

            if (other == null) // the node belongs at the start of the list
            {
                // remove from place
                if (tail == node)
                    tail = node.previous;
                node.previous.next = node.next;
                if (node.next != null)
                    node.next.previous = node.previous;
                // insert at head
                node.next = head;
                head.previous = node;
                node.previous = null;
                head = node;
            }

            node = remains;
        }
    }

    /**
     * Performs a merge sort on the node list. In general, merge sort is more efficient than insertion sort
     * with long lists that are very unsorted.
     *
     * <p>The sort function takes two nodes and returns an Int.</p>
     *
     * <p><code>function sortFunction( node1 : MockNode, node2 : MockNode ) : Int</code></p>
     *
     * <p>If the returned number is less than zero, the first node should be before the second. If it is greater
     * than zero the second node should be before the first. If it is zero the order of the nodes doesn't matter.</p>
     *
     * <p>This merge sort implementation creates and uses a single Vector during the sort operation.</p>
     */

    public function mergeSort(sortFunction:SortFunction<TNode>):Void
    {
        if (head == tail)
            return;

        var lists:Array<TNode> = [];

        // disassemble the list
        var start:TNode = head;
        var end:TNode;
        while (start != null)
        {
            end = start;
            while (end.next != null && sortFunction(end, end.next) <= 0)
                end = end.next;

            var next:TNode = end.next;
            start.previous = end.next = null;
            lists.push(start);
            start = next;
        }

        // reassemble it in order
        while (lists.length > 1)
            lists.push(merge(lists.shift(), lists.shift(), sortFunction));

        // find the tail
        tail = head = lists[0];
        while (tail.next != null)
            tail = tail.next;
    }

    private function merge(head1:TNode, head2:TNode, sortFunction:SortFunction<TNode>):TNode
    {
        var node:TNode;
        var head:TNode;
        if (sortFunction(head1, head2) <= 0)
        {
            head = node = head1;
            head1 = head1.next;
        }
        else
        {
            head = node = head2;
            head2 = head2.next;
        }
        while (head1 != null && head2 != null)
        {
            if (sortFunction(head1, head2) <= 0)
            {
                node.next = head1;
                head1.previous = node;
                node = head1;
                head1 = head1.next;
            }
            else
            {
                node.next = head2;
                head2.previous = node;
                node = head2;
                head2 = head2.next;
            }
        }
        if (head1 != null)
        {
            node.next = head1;
            head1.previous = node;
        }
        else
        {
            node.next = head2;
            head2.previous = node;
        }
        return head;
    }
}

typedef SortFunction<TNode:Node<TNode>> = TNode -> TNode -> Int;
