package ash.fsm;

import ash.ClassMap;
import ash.core.Entity;

/**
 * This is a state machine for an entity. The state machine manages a set of states,
 * each of which has a set of component providers. When the state machine changes the state, it removes
 * components associated with the previous state and adds components associated with the new state.
 */
class EntityStateMachine
{
    private var states:Map<String, EntityState>;
    /**
     * The current state of the state machine.
     */
    private var currentState:EntityState;
    /**
     * The entity whose state machine this is
     */
    public var entity:Entity;

    /**
     * Constructor. Creates an EntityStateMachine.
     */

    public function new(entity:Entity)
    {
        this.entity = entity;
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

    public function addState(name:String, state:EntityState):EntityStateMachine
    {
        states.set(name, state);
        return this;
    }

    /**
     * Create a new state in this state machine.
     *
     * @param name The name of the new state - used to identify it later in the changeState method call.
     * @return The new EntityState object that is the state. This will need to be configured with
     * the appropriate component providers.
     */

    public function createState(name:String):EntityState
    {
        var state:EntityState = new EntityState();
        states.set(name, state);
        return state;
    }

    /**
     * Change to a new state. The components from the old state will be removed and the components
     * for the new state will be added.
     *
     * @param name The name of the state to change to.
     */

    public function changeState(name:String):Void
    {
        var newState:EntityState = states.get(name);
        if (newState == null)
        {
            throw "Entity state " + name + " doesn't exist";
        }
        if (newState == currentState)
        {
            newState = null;
            return;
        }
        var toAdd:ClassMap<Class<Dynamic>, IComponentProvider<Dynamic>>;
        if (currentState != null)
        {
            toAdd = new ClassMap();
            for (t in newState.providers.keys())
            {
                toAdd.set(t, newState.providers.get(t));
            }
            for (t in currentState.providers.keys())
            {
                var other:IComponentProvider<Dynamic> = toAdd.get(t);

                if (other != null && other.identifier == currentState.providers.get(t).identifier)
                {
                    toAdd.remove(t);
                }
                else
                {
                    entity.remove(t);
                }
            }
        }
        else
        {
            toAdd = newState.providers;
        }
        for (t in toAdd.keys())
        {
            entity.add(toAdd.get(t).getComponent(), t);
        }
        currentState = newState;
    }
}
