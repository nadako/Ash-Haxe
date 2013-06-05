package ash.fsm;

import ash.core.System;

/**
 * This System provider always returns the same instance of the System. The instance
 * is created when first required and is of the type passed in to the constructor.
 */
class SystemSingletonProvider<T:System> implements ISystemProvider<T>
{
    private var componentType:Class<T>;
    private var instance:T;

    /**
     * Used to compare this provider with others. Any provider that returns the same single
     * instance will be regarded as equivalent.
     *
     * @return The single instance
     */
    public var identifier(get, never):Dynamic;

    /**
     * The priority at which the System should be added to the Engine
     */
    @:isVar public var priority(get, set):Int;

    /**
     * Constructor
     *
     * @param type The type of the single System instance
     */
    public function new(type:Class<T>)
    {
        this.componentType = type;
    }

    /**
     * Used to request a System from this provider
     *
     * @return The single instance
     */
    public function getSystem():T
    {
        if (instance == null)
            instance = Type.createInstance(componentType, []);
        return instance;
    }

    public inline function get_identifier():Dynamic
    {
        return getSystem();
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
