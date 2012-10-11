package ;

/**
 * An iterator class for any linked lists that
 * has "next" variable in its elements.
 **/
class GenericListIterator<TNode>
{
    public var head:TNode;

    public function new(head:TNode)
    {
        this.head = head;
    }

    public function hasNext():Bool
    {
        return head != null;
    }

    public function next():TNode
    {
        var node:TNode = head;
        head = untyped node.next;
        return node;
    }
}
