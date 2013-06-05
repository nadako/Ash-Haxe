package ash.fsm;

import ash.core.System;

/**
 * This System provider always returns the same instance of the component. The system
 * is passed to the provider at initialisation.
 */
class SystemInstanceProvider<T:System> implements ISystemProvider<T>
{
    private var instance:T;

    /**
     * Used to compare this provider with others. Any provider that returns the same component
     * instance will be regarded as equivalent.
     *
     * @return The instance
     */
    public var identifier(get, never):Dynamic;

    /**
     * The priority at which the System should be added to the Engine
     */
    @:isVar public var priority(get, set):Int;

    /**
     * Constructor
     *
     * @param instance The instance to return whenever a System is requested.
     */
    public function new(instance:T)
    {
        this.instance = instance;
    }

    /**
     * Used to request a component from this provider
     *
     * @return The instance of the System
     */
    public inline function getSystem():T
    {
        return instance;
    }

    public inline function get_identifier():Dynamic
    {
        return instance;
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
