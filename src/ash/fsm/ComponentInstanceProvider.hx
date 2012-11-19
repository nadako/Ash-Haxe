package ash.fsm;

/**
 * This component provider always returns the same instance of the component. The instance
 * is passed to the provider at initialisation.
 */
class ComponentInstanceProvider<T> implements IComponentProvider<T>
{
    private var instance:T;

    /**
    * Constructor
    *
    * @param instance The instance to return whenever a component is requested.
    */

    public function new(instance:T)
    {
        this.instance = instance;
    }

    /**
    * Used to request a component from this provider
    *
    * @return The instance
    */

    public function getComponent():T
    {
        return instance;
    }

    /**
    * Used to compare this provider with others. Any provider that returns the same component
    * instance will be regarded as equivalent.
    *
    * @return The instance
    */
    public var identifier(get_identifier, never):Dynamic;

    private inline function get_identifier():Dynamic
    {
        return instance;
    }
}
