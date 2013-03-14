package ash.tools;

import ash.ObjectMap;

/**
 * An object pool for re-using components. This is not integrated in to Ash but is used dierectly by
 * the developer. It expects components to not require any parameters in their constructor.
 *
 * <p>Fetch an object from the pool with</p>
 *
 * <p>ComponentPool.get(ComponentClass);</p>
 *
 * <p>If the pool contains an object of the required type, it will be returned. If it does not, a new object
 * will be created and returned.</p>
 *
 * <p>The object returned may have properties set on it from the time it was previously used, so all properties
 * should be reset in the object once it is received.</p>
 *
 * <p>Add an object to the pool with</p>
 *
 * <p>ComponentPool.dispose(component);</p>
 *
 * <p>You will usually want to do this when removing a component from an entity. The remove method on the entity
 * returns the component that was removed, so this can be done in one line of code like this</p>
 *
 * <p>ComponentPool.dispose(entity.remove(component));</p>
 */
class ComponentPool
{
    private static var pools:ObjectMap<Class<Dynamic>, Array<Dynamic>> = new ObjectMap<Class<Dynamic>, Array<Dynamic>>();

    private static function getPool<TComponent>(componentClass:Class<TComponent>):Array<TComponent>
    {
        var pool:Array<TComponent> = cast pools.get(componentClass);
        if (pool == null)
        {
            pool = new Array<TComponent>();
            pools.set(componentClass, pool);
        }
        return pool;
    }

    /**
     * Get an object from the pool.
     *
     * @param componentClass The type of component wanted.
     * @return The component.
     */

    public static function get<TComponent>(componentClass:Class<TComponent>):TComponent
    {
        var pool:Array<TComponent> = getPool(componentClass);
        if (pool.length > 0)
            return pool.pop();
        else
            return Type.createInstance(componentClass, []);
    }

    /**
     * Return an object to the pool for reuse.
     *
     * @param component The component to return to the pool.
     */

    public static function dispose<TComponent>(component:TComponent):Void
    {
        if (component != null)
        {
            var type:Class<TComponent> = Type.getClass(component);
            var pool:Array<TComponent> = getPool(type);
            pool.push(component);
        }
    }

    /**
     * Dispose of all pooled resources, freeing them for garbage collection.
     */

    public static function empty():Void
    {
        pools = new ObjectMap<Class<Dynamic>, Array<Dynamic>>();
    }
}
