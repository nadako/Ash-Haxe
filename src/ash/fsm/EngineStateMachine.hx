package ash.fsm;

import haxe.ds.ObjectMap;

import ash.core.Engine;
import ash.core.System;

/**
 * This is a state machine for the Engine. The state machine manages a set of states,
 * each of which has a set of System providers. When the state machine changes the state, it removes
 * Systems associated with the previous state and adds Systems associated with the new state.
 */
class EngineStateMachine
{
    public var engine:Engine;
    private var states:Map<String, EngineState>;
    private var currentState:EngineState;

    /**
     * Constructor. Creates an SystemStateMachine.
     */

    public function new(engine:Engine)
    {
        this.engine = engine;
        states = new Map();
    }
    
    /**
     * Check if a state exists.
     *
     * @param name The name of the state to query
     * @return A Bool that indicates whether or not a state exists.
     */
    
    public function hasState(name:String):Bool
    {
        return states.exists(name);
    }


    /**
     * Add a state to this state machine.
     *
     * @param name The name of this state - used to identify it later in the changeState method call.
     * @param state The state.
     * @return This state machine, so methods can be chained.
     */

    public function addState(name:String, state:EngineState):EngineStateMachine
    {
        states[ name ] = state;
        return this;
    }

    /**
     * Create a new state in this state machine.
     *
     * @param name The name of the new state - used to identify it later in the changeState method call.
     * @return The new EntityState object that is the state. This will need to be configured with
     * the appropriate component providers.
     */

    public function createState(name:String):EngineState
    {
        var state:EngineState = new EngineState();
        states[ name ] = state;
        return state;
    }

    /**
     * Change to a new state. The Systems from the old state will be removed and the Systems
     * for the new state will be added.
     *
     * @param name The name of the state to change to.
     */

    public function changeState(name:String):Void
    {
        var newState:EngineState = states[ name ];
        if (newState == null)
        {
            throw "Engine state " + name + " doesn't exist";
        }
        if (newState == currentState)
        {
            newState = null;
            return;
        }
        var toAdd:ObjectMap<Dynamic, Dynamic> = new ObjectMap();
        var id:Dynamic;
        for (provider in newState.providers)
        {
            id = provider.identifier;
            toAdd.set(id, provider);
        }
        if (currentState != null)
        {
            for (provider in currentState.providers)
            {
                id = provider.identifier;
                var other:ISystemProvider<System> = toAdd.get(id);

                if (other != null)
                {
                    toAdd.remove(id);
                }
                else
                {
                    engine.removeSystem(provider.getSystem());
                }
            }
        }
        for (provider in toAdd)
        {
            engine.addSystem(provider.getSystem(), provider.priority);
        }
        currentState = newState;
    }
}
