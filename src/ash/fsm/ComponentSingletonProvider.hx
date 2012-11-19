package ash.fsm;

/**
 * This component provider always returns the same instance of the component. The instance
 * is created when first required and is of the type passed in to the constructor.
 */
class ComponentSingletonProvider<T> implements IComponentProvider<T>
{
    private var componentType:Class<T>;
    private var instance:T;

    /**
     * Constructor
     *
     * @param type The type of the single instance
     */

    public function new(type:Class<T>)
    {
        this.componentType = type;
    }

    /**
     * Used to request a component from this provider
     *
     * @return The single instance
     */

    public function getComponent():T
    {
        if (instance == null)
        {
            instance = Type.createInstance(componentType, []);
        }
        return instance;
    }

    /**
     * Used to compare this provider with others. Any provider that returns the same single
     * instance will be regarded as equivalent.
     *
     * @return The single instance
     */
    public var identifier(get_identifier, never):Dynamic;

    private inline function get_identifier():Dynamic
    {
        return getComponent();
    }
}
