/*
 * Based on ideas used in Robert Penner's AS3-signals - https://github.com/robertpenner/as3-signals
 */
package net.richardlord.signals;

import nme.ObjectHash;

/**
 * The base class for all the signal classes.
 */
class SignalBase<TListener>
{
    public var head:ListenerNode<TListener>;
    public var tail:ListenerNode<TListener>;

    private var nodes:ObjectHash<TListener, ListenerNode<TListener>>;
    private var listenerNodePool:ListenerNodePool<TListener>;
    private var toAddHead:ListenerNode<TListener>;
    private var toAddTail:ListenerNode<TListener>;
    private var dispatching:Bool;

    public function new()
    {
        nodes = new ObjectHash<TListener, ListenerNode<TListener>>();
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

    public function add(listener:TListener):Void
    {
        if (nodes.exists(listener))
            return;

        var node:ListenerNode<TListener> = listenerNodePool.get();
        node.listener = listener;
        nodes.set(listener, node);
        addNode(node);
    }

    public function addOnce(listener:TListener):Void
    {
        if (nodes.exists(listener))
            return;

        var node:ListenerNode<TListener> = listenerNodePool.get();
        node.listener = listener;
        node.once = true;
        nodes.set(listener, node);
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
        var node:ListenerNode<TListener> = nodes.get(listener);
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

            nodes.remove(listener);

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
}
