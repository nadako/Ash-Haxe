package ash.fsm;

import ash.core.System;
import ash.core.Engine;
import ash.Mocks.EmptySystem2;

import org.hamcrest.MatchersBase;

class EngineStateMachineTest extends MatchersBase
{
    private var fsm:EngineStateMachine;
    private var engine:Engine;

    @Before
    public function createState():Void
    {
        engine = new Engine();
        fsm = new EngineStateMachine( engine );
    }

    @After
    public function clearState():Void
    {
        engine = null;
        fsm = null;
    }

    @Test
    public function enterStateAddsStatesSystems():Void
    {
        var state:EngineState = new EngineState();
        var system:RemovingSystem = new RemovingSystem();
        state.addInstance(system);
        fsm.addState("test", state);
        fsm.changeState("test");
        assertThat(engine.getSystem(RemovingSystem), theInstance(system));
    }

    @Test
    public function enterSecondStateAddsSecondStatesSystems():Void
    {
        var state1:EngineState = new EngineState();
        var system1:RemovingSystem = new RemovingSystem();
        state1.addInstance(system1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EngineState = new EngineState();
        var system2:EmptySystem2 = new EmptySystem2();
        state2.addInstance(system2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(engine.getSystem(EmptySystem2), theInstance(system2));
    }

    @Test
    public function enterSecondStateRemovesFirstStatesSystems():Void
    {
        var state1:EngineState = new EngineState();
        var system1:RemovingSystem = new RemovingSystem();
        state1.addInstance(system1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EngineState = new EngineState();
        var system2:EmptySystem2 = new EmptySystem2();
        state2.addInstance(system2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(engine.getSystem(RemovingSystem), nullValue());
    }

    @Test
    public function enterSecondStateDoesNotRemoveOverlappingSystems():Void
    {
        var state1:EngineState = new EngineState();
        var system1:RemovingSystem = new RemovingSystem();
        state1.addInstance(system1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EngineState = new EngineState();
        var system2:EmptySystem2 = new EmptySystem2();
        state2.addInstance(system1);
        state2.addInstance(system2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(system1.wasRemoved, is(false));
        assertThat(engine.getSystem(RemovingSystem), theInstance(system1));
    }

    @Test
    public function enterSecondStateRemovesDifferentSystemsOfSameType():Void
    {
        var state1:EngineState = new EngineState();
        var system1:RemovingSystem = new RemovingSystem();
        state1.addInstance(system1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EngineState = new EngineState();
        var system3:RemovingSystem = new RemovingSystem();
        var system2:EmptySystem2 = new EmptySystem2();
        state2.addInstance(system3);
        state2.addInstance(system2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(engine.getSystem(RemovingSystem), theInstance(system3));
    }
}


class RemovingSystem extends System
{
    public var wasRemoved:Bool = false;

    override public function removeFromEngine(engine:Engine):Void
    {
        wasRemoved = true;
    }
}
