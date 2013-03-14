package ash.core;

import ash.ObjectMap;
import ash.signals.Signal2;

/**
 * An entity is composed from components. As such, it is essentially a collection object for components.
 * Sometimes, the entities in a game will mirror the actual characters and objects in the game, but this
 * is not necessary.
 *
 * <p>Components are simple value objects that contain data relevant to the entity. Entities
 * with similar functionality will have instances of the same components. So we might have
 * a position component</p>
 *
 * <p><code>class PositionComponent
 * {
 *   public var x:Float;
 *   public var y:Float;
 * }</code></p>
 *
 * <p>All entities that have a position in the game world, will have an instance of the
 * position component. Systems operate on entities based on the components they have.</p>
 */
class Entity
{
    /**
     * Optional, give the entity a name. This can help with debugging and with serialising the entity.
     */
    public var name:String;
    /**
     * This signal is dispatched when a component is added to the entity.
     */
    public var componentAdded(default, null):Signal2<Entity, Class<Dynamic>>;
    /**
     * This signal is dispatched when a component is removed from the entity.
     */
    public var componentRemoved(default, null):Signal2<Entity, Class<Dynamic>>;

    public var previous:Entity;
    public var next:Entity;
    public var components(default, null):ObjectMap<Class<Dynamic>, Dynamic>;

    public function new()
    {
        componentAdded = new Signal2<Entity, Class<Dynamic>>();
        componentRemoved = new Signal2<Entity, Class<Dynamic>>();
        components = new ObjectMap<Class<Dynamic>, Dynamic>();
    }

    /**
     * Add a component to the entity.
     *
     * @param component The component object to add.
     * @param componentClass The class of the component. This is only necessary if the component
     * extends another component class and you want the framework to treat the component as of
     * the base class type. If not set, the class type is determined directly from the component.
     *
     * @return A reference to the entity. This enables the chaining of calls to add, to make
     * creating and configuring entities cleaner. e.g.
     *
     * <code>var entity:Entity = new Entity()
     *     .add(new Position(100, 200)
     *     .add(new Display(new PlayerClip());</code>
     */

    public function add<T>(component:T, componentClass:Class<Dynamic> = null):Entity
    {
        if (componentClass == null)
            componentClass = Type.getClass(component);

        if (components.exists(componentClass))
            remove(componentClass);

        components.set(componentClass, component);
        componentAdded.dispatch(this, componentClass);
        return this;
    }

    /**
     * Remove a component from the entity.
     *
     * @param componentClass The class of the component to be removed.
     * @return the component, or null if the component doesn't exist in the entity
     */

    public function remove<T>(componentClass:Class<Dynamic>):T
    {
        var component:T = components.get(componentClass);
        if (component != null)
        {
            components.remove(componentClass);
            componentRemoved.dispatch(this, componentClass);
            return component;
        }
        return null;
    }

    /**
     * Get a component from the entity.
     *
     * @param componentClass The class of the component requested.
     * @return The component, or null if none was found.
     */

    public function get<T>(componentClass:Class<Dynamic>):T
    {
        return components.get(componentClass);
    }

    /**
     * Get all components from the entity.
     *
     * @return An array containing all the components that are on the entity.
     */

    public function getAll():Array<Dynamic>
    {
        var componentArray:Array<Dynamic> = new Array<Dynamic>();
        for (component in components)
            componentArray.push(component);
        return componentArray;
    }

    /**
     * Does the entity have a component of a particular type.
     *
     * @param componentClass The class of the component sought.
     * @return true if the entity has a component of the type, false if not.
     */

    public function has(componentClass:Class<Dynamic>):Bool
    {
        return components.exists(componentClass);
    }
}
