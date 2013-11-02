package ash;

/**
 * An iterator class for any linked lists that
 * has "next" variable in its elements.
 **/
class GenericListIterator<TNode:HasNext<TNode>>
{
    private var previous:HasNext<TNode>;

    public inline function new(head:TNode)
    {
        this.previous = {next: head};
    }

    public inline function hasNext():Bool
    {
        return previous.next != null;
    }

    public inline function next():TNode
    {
        var node:TNode = previous.next;
        previous = node;
        return node;
    }
}

private typedef HasNext<T> =
{
    var next:T;
}
