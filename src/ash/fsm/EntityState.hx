package ash.fsm;

import ash.ObjectMap;

/**
 * Represents a state for an EntityStateMachine. The state contains any number of ComponentProviders which
 * are used to add components to the entity when this state is entered.
 */
class EntityState
{
    /**
     * @private
     */
    public var providers(default, null):ObjectMap<Class<Dynamic>, IComponentProvider<Dynamic>>;

    public function new()
    {
        providers = new ObjectMap();
    }

    /**
     * Add a new ComponentMapping to this state. The mapping is a utility class that is used to
     * map a component type to the provider that provides the component.
     *
     * @param type The type of component to be mapped
     * @return The component mapping to use when setting the provider for the component
     */

    public function add<T>(type:Class<T>):StateComponentMapping<T>
    {
        return new StateComponentMapping<T>( this, type );
    }

    /**
     * Get the ComponentProvider for a particular component type.
     *
     * @param type The type of component to get the provider for
     * @return The ComponentProvider
     */

    public function get<T>(type:Class<T>):IComponentProvider<T>
    {
        return cast providers.get(type);
    }

    /**
     * To determine whether this state has a provider for a specific component type.
     *
     * @param type The type of component to look for a provider for
     * @return true if there is a provider for the given type, false otherwise
     */

    public function has(type:Class<Dynamic>):Bool
    {
        return providers.exists(type);
    }
}
