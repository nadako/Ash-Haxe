package ash.fsm;

/**
 * Used by the EntityState class to create the mappings of components to providers via a fluent interface.
 */
class StateComponentMapping<T>
{
    private var componentType:Class<T>;
    private var creatingState:EntityState;
    private var provider:IComponentProvider<T>;

    /**
     * Used internally, the constructor creates a component mapping. The constructor
     * creates a ComponentTypeProvider as the default mapping, which will be replaced
     * by more specific mappings if other methods are called.
     *
     * @param creatingState The EntityState that the mapping will belong to
     * @param type The component type for the mapping
     */

    public function new(creatingState:EntityState, type:Class<T>)
    {
        this.creatingState = creatingState;
        componentType = type;
        withType(type);
    }

    /**
     * Creates a mapping for the component type to a specific component instance. A
     * ComponentInstanceProvider is used for the mapping.
     *
     * @param component The component instance to use for the mapping
     * @return This ComponentMapping, so more modifications can be applied
     */

    public function withInstance(component:T):StateComponentMapping<T>
    {
        setProvider(new ComponentInstanceProvider( component ));
        return this;
    }

    /**
     * Creates a mapping for the component type to new instances of the provided type.
     * The type should be the same as or extend the type for this mapping. A ComponentTypeProvider
     * is used for the mapping.
     *
     * @param type The type of components to be created by this mapping
     * @return This ComponentMapping, so more modifications can be applied
     */

    public function withType(type:Class<T>):StateComponentMapping<T>
    {
        setProvider(new ComponentTypeProvider( type ));
        return this;
    }

    /**
     * Creates a mapping for the component type to a single instance of the provided type.
     * The instance is not created until it is first requested. The type should be the same
     * as or extend the type for this mapping. A ComponentSingletonProvider is used for
     * the mapping.
     *
     * @param The type of the single instance to be created. If omitted, the type of the
     * mapping is used.
     * @return This ComponentMapping, so more modifications can be applied
     */

    public function withSingleton(type:Class<Dynamic> = null):StateComponentMapping<T>
    {
        if (type == null)
            type = componentType;
        setProvider(new ComponentSingletonProvider( type ));
        return this;
    }

    /**
     * Creates a mapping for the component type to any ComponentProvider.
     *
     * @param The component provider to use.
     * @return This ComponentMapping, so more modifications can be applied.
     */

    public function withProvider(provider:IComponentProvider<T>):StateComponentMapping<T>
    {
        setProvider(provider);
        return this;
    }

    private function setProvider(provider:IComponentProvider<T>):Void
    {
        this.provider = provider;
        creatingState.providers.set(componentType, provider);
    }

    /**
     * Maps through to the add method of the EntityState that this mapping belongs to
     * so that a fluent interface can be used when configuring entity states.
     *
     * @param type The type of component to add a mapping to the state for
     * @return The new ComponentMapping for that type
     */

    public function add<T>(type:Class<T>):StateComponentMapping<T>
    {
        return creatingState.add(type);
    }
}
