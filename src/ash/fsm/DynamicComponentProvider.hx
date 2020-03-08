package ash.fsm;

/**
 * This component provider calls a function to get the component instance. The function must
 * return a single component of the appropriate type.
 */
class DynamicComponentProvider<T> implements IComponentProvider<T>
{
    private var _closure:DynamicComponentProviderClosure<T>;

    /**
     * Constructor
     *
     * @param closure The function that will return the component instance when called.
     */
    public function new(closure:DynamicComponentProviderClosure<T>)
    {
        _closure = closure;
    }

    /**
     * Used to request a component from this provider
     *
     * @return The instance returned by calling the function
     */
    public function getComponent():T
    {
        return _closure();
    }


    /**
     * Used to compare this provider with others. Any provider that uses the function or method
     * closure to provide the instance is regarded as equivalent.
     *
     * @return The function
     */
    public var identifier(get, never):Dynamic;

    private inline function get_identifier():Dynamic
    {
        return _closure;
    }
}

typedef DynamicComponentProviderClosure<T> = Void -> T;
