/*
 * Based on ideas used in Robert Penner's AS3-signals - https://github.com/robertpenner/as3-signals
 */
package ash.signals;

import ash.ObjectMap;
import ash.GenericListIterator;

/**
 * The base class for all the signal classes.
 */
class SignalBase<TListener>
{
    public var head:ListenerNode<TListener>;
    public var tail:ListenerNode<TListener>;

    #if !(cpp || neko)
    private var nodes:ObjectMap<TListener, ListenerNode<TListener>>;
    #end
    private var listenerNodePool:ListenerNodePool<TListener>;
    private var toAddHead:ListenerNode<TListener>;
    private var toAddTail:ListenerNode<TListener>;
    private var dispatching:Bool;

    public function new()
    {
        #if !(cpp || neko)
        nodes = new ObjectMap<TListener, ListenerNode<TListener>>();
        #end
        listenerNodePool = new ListenerNodePool();
    }

    private function startDispatch():Void
    {
        dispatching = true;
    }

    private function endDispatch():Void
    {
        dispatching = false;
        if (toAddHead != null)
        {
            if (head == null)
            {
                head = toAddHead;
                tail = toAddTail;
            }
            else
            {
                tail.next = toAddHead;
                toAddHead.previous = tail;
                tail = toAddTail;
            }
            toAddHead = null;
            toAddTail = null;
        }
        listenerNodePool.releaseCache();
    }

    private #if !(cpp || neko) inline #end function nodeExists(listener:TListener):Bool
    {
        #if (cpp || neko)
        var node:ListenerNode<TListener> = head;
        while (node != null)
        {
            if (node.listener == listener)
                return true;
            node = node.next;
        }
        node = toAddHead;
        while (node != null)
        {
            if (node.listener == listener)
                return true;
            node = node.next;
        }
        return false;
        #else
        return nodes.exists(listener);
        #end
    }


    public function add(listener:TListener):Void
    {
        if (nodeExists(listener))
            return;

        var node:ListenerNode<TListener> = listenerNodePool.get();
        node.listener = listener;
        #if !(cpp || neko)
        nodes.set(listener, node);
        #end
        addNode(node);
    }

    public function addOnce(listener:TListener):Void
    {
        if (nodeExists(listener))
            return;

        var node:ListenerNode<TListener> = listenerNodePool.get();
        node.listener = listener;
        node.once = true;
        #if !(cpp || neko)
        nodes.set(listener, node);
        #end
        addNode(node);
    }

    private function addNode(node:ListenerNode<TListener>):Void
    {
        if (dispatching)
        {
            if (toAddHead == null)
            {
                toAddHead = toAddTail = node;
            }
            else
            {
                toAddTail.next = node;
                node.previous = toAddTail;
                toAddTail = node;
            }
        }
        else
        {
            if (head == null)
            {
                head = tail = node;
            }
            else
            {
                tail.next = node;
                node.previous = tail;
                tail = node;
            }
        }
    }

    public function remove(listener:TListener):Void
    {
        var node:ListenerNode<TListener>;

        #if (cpp || neko)
        var foundNode:Bool = false;

        node = head;
        while (node != null)
        {
            if (node.listener == listener)
            {
                foundNode = true;
                break;
            }
            node = node.next;
        }

        if (!foundNode)
        {
            node = toAddHead;
            while (node != null)
            {
                if (node.listener == listener)
                {
                    foundNode = true;
                    break;
                }
                node = node.next;
            }
        }

        if (!foundNode)
            node = null;
        #else
        node = nodes.get(listener);
        #end

        if (node != null)
        {
            if (head == node)
                head = head.next;
            if (tail == node)
                tail = tail.previous;
            if (toAddHead == node)
                toAddHead = toAddHead.next;
            if (toAddTail == node)
                toAddTail = toAddTail.previous;
            if (node.previous != null)
                node.previous.next = node.next;
            if (node.next != null)
                node.next.previous = node.previous;

            #if !(cpp || neko)
            nodes.remove(listener);
            #end

            if (dispatching)
                listenerNodePool.cache(node);
            else
                listenerNodePool.dispose(node);
        }
    }

    public function removeAll():Void
    {
        while (head != null)
        {
            var listener:ListenerNode<TListener> = head;
            head = head.next;
            listener.previous = null;
            listener.next = null;
        }
        tail = null;
        toAddHead = null;
        toAddTail = null;
    }

    private function iterator():Iterator<ListenerNode<TListener>>
    {
        return new GenericListIterator(head);
    }
}
