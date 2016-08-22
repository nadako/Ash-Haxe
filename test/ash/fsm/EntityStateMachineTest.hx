package ash.fsm;

import org.hamcrest.MatchersBase;
import massive.munit.Assert;

import ash.core.Entity;
import ash.fsm.EntityStateMachine;
import ash.fsm.EntityState;
import ash.Mocks;

class EntityStateMachineTest extends MatchersBase
{
    private var fsm:EntityStateMachine;
    private var entity:Entity;

    @Before
    public function createState():Void
    {
        entity = new Entity();
        fsm = new EntityStateMachine( entity );
    }

    @After
    public function clearState():Void
    {
        entity = null;
        fsm = null;
    }

    @Test
    public function enterStateAddsStatesComponents():Void
    {
        var state:EntityState = new EntityState();
        var component:MockComponent = new MockComponent();
        state.add(MockComponent).withInstance(component);
        fsm.addState("test", state);
        fsm.changeState("test");
        assertThat(entity.get(MockComponent), theInstance(component));
    }

    @Test
    public function enterSecondStateAddsSecondStatesComponents():Void
    {
        var state1:EntityState = new EntityState();
        var component1:MockComponent = new MockComponent();
        state1.add(MockComponent).withInstance(component1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EntityState = new EntityState();
        var component2:MockComponent2 = new MockComponent2();
        state2.add(MockComponent2).withInstance(component2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(entity.get(MockComponent2), theInstance(component2));
    }

    @Test
    public function enterSecondStateRemovesFirstStatesComponents():Void
    {
        var state1:EntityState = new EntityState();
        var component1:MockComponent = new MockComponent();
        state1.add(MockComponent).withInstance(component1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EntityState = new EntityState();
        var component2:MockComponent2 = new MockComponent2();
        state2.add(MockComponent2).withInstance(component2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(entity.has(MockComponent), is(false));
    }

    @Test
    public function enterSecondStateDoesNotRemoveOverlappingComponents():Void
    {
        entity.componentRemoved.add(failIfCalled);

        var state1:EntityState = new EntityState();
        var component1:MockComponent = new MockComponent();
        state1.add(MockComponent).withInstance(component1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EntityState = new EntityState();
        var component2:MockComponent2 = new MockComponent2();
        state2.add(MockComponent).withInstance(component1);
        state2.add(MockComponent2).withInstance(component2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(entity.get(MockComponent), theInstance(component1));
    }

    @Test
    public function enterSecondStateRemovesDifferentComponentsOfSameType():Void
    {
        var state1:EntityState = new EntityState();
        var component1:MockComponent = new MockComponent();
        state1.add(MockComponent).withInstance(component1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EntityState = new EntityState();
        var component3:MockComponent = new MockComponent();
        var component2:MockComponent2 = new MockComponent2();
        state2.add(MockComponent).withInstance(component3);
        state2.add(MockComponent2).withInstance(component2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(entity.get(MockComponent), theInstance(component3));
    }

    private static function failIfCalled(entity:Entity, component:Dynamic):Void
    {
        Assert.fail("Component was removed when it shouldn't have been.");
    }
}
