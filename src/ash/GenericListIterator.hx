package ash;

/**
 * An iterator class for any linked lists that
 * has "next" variable in its elements.
 **/
class GenericListIterator<TNode#if haxe3 :HasNext<TNode> #end>
{
    private var previous:HasNext<TNode>;

    public function new(head:TNode)
    {
        this.previous = {next: head};
    }

    public function hasNext():Bool
    {
        return previous.next != null;
    }

    public function next():TNode
    {
        var node:TNode = previous.next;
        previous = #if !haxe3 untyped #end node;
        return node;
    }
}

private typedef HasNext<T> =
{
    var next:T;
}
