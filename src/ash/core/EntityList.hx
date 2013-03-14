package ash.core;

import ash.GenericListIterator;

/**
 * An internal class for a linked list of entities. Used inside the framework for
 * managing the entities.
 */
class EntityList
{
    public var head(default, null):Entity;
    public var tail(default, null):Entity;

    public function new()
    {
    }

    public function add(entity:Entity):Void
    {
        if (head == null)
        {
            head = tail = entity;
            entity.next = entity.previous = null;
        }
        else
        {
            tail.next = entity;
            entity.previous = tail;
            entity.next = null;
            tail = entity;
        }
    }

    public function remove(entity:Entity):Void
    {
        if (head == entity)
            head = head.next;
        if (tail == entity)
            tail = tail.previous;
        if (entity.previous != null)
            entity.previous.next = entity.next;
        if (entity.next != null)
            entity.next.previous = entity.previous;
        // N.B. Don't set entity.next and entity.previous to null because that will break the list iteration if entity is the current entity in the iteration.
    }

    public function removeAll():Void
    {
        while (head != null)
        {
            var entity:Entity = head;
            head = head.next;
            entity.previous = null;
            entity.next = null;
        }
        tail = null;
    }

    public function iterator():Iterator<Entity>
    {
        return new GenericListIterator(head);
    }
}
