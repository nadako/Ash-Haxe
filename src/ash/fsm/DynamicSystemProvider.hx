package ash.fsm;

import ash.core.System;

/**
 * This System provider returns results of a method call. The method
 * is passed to the provider at initialisation.
 */
class DynamicSystemProvider<T:System> implements ISystemProvider<T>
{
    private var method:DynamicSystemProviderClosure<T>;

    /**
     * Used to compare this provider with others. Any provider that returns the same component
     * instance will be regarded as equivalent.
     *
     * @return The method used to call the System instances
     */
    public var identifier(get, never):Dynamic;

    /**
     * The priority at which the System should be added to the Engine
     */
    @:isVar public var priority(get, set):Int;


    /**
     * Constructor
     *
     * @param method The method that returns the System instance;
     */
    public function new(method:DynamicSystemProviderClosure<T>)
    {
        this.method = method;
    }

    /**
     * Used to request a component from this provider
     *
     * @return The instance of the System
     */
    public inline function getSystem():T
    {
        return method();
    }

    public inline function get_identifier():Dynamic
    {
        return method;
    }

    public inline function get_priority():Int
    {
        return priority;
    }

    public inline function set_priority(value:Int):Int
    {
        return priority = value;
    }
}

typedef DynamicSystemProviderClosure<T:System> = Void -> T;
