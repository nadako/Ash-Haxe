package ash;

class ClassMap<K:Class<Dynamic>, V> implements Map.IMap<K, V>
{
    var h:haxe.ds.StringMap<V>;

    public inline function new():Void
    {
        h = new haxe.ds.StringMap<V>();
    }

    public inline function get(k:K):Null<V>
    {
        return h.get(Type.getClassName(k));
    }

    public inline function set(k:K, v:V):Void
    {
        h.set(Type.getClassName(k), v);
    }

    public inline function exists(k:K):Bool
    {
        return h.exists(Type.getClassName(k));
    }

    public inline function remove(k:K):Bool
    {
        return h.remove(Type.getClassName(k));
    }

    public inline function keys():Iterator<K>
    {
        var i = h.keys();
        return {
            hasNext: i.hasNext,
            next: function():K { return cast Type.resolveClass(i.next()); }
        };
    }

    public inline function iterator():Iterator<V>
    {
        return h.iterator();
    }

    public inline function toString():String
    {
        return h.toString();
    }
}
