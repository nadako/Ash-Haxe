package ash.core;

import haxe.Constraints.Function;
import org.hamcrest.MatchersBase;

import ash.core.Engine;
import ash.core.System;
import ash.Mocks;

class SystemTest extends MatchersBase
{
    public var callBack:Dynamic;

    private var engine:Engine;

    private var system1:MockSystem;
    private var system2:MockSystem;

    @Before
    public function createEntity():Void
    {
        engine = new Engine();
    }

    @After
    public function clearEntity():Void
    {
        engine = null;
        callBack = null;
    }

    @Test
    public function systemsGetterReturnsAllTheSystems():Void
    {
        var system1:System = Type.createInstance(System, []);
        engine.addSystem(system1, 1);
        var system2:System = Type.createInstance(System, []);
        engine.addSystem(system2, 1);
        assertThat(engine.systems, hasItems([system1, system2]));
    }

    private function shouldCall<T:Function>(f:T)
    {
        return new ShouldCallHelper(f, this);
    }

    @Test
    public function addSystemCallsAddToEngine():Void
    {
        var h = shouldCall(addedCallbackMethod);
        var system:System = new MockSystem( this );
        callBack = h.func;
        engine.addSystem(system, 0);
        h.assertIsCalled();
    }

    @Test
    public function removeSystemCallsRemovedFromEngine():Void
    {
        var h = shouldCall(removedCallbackMethod);
        var system:System = new MockSystem( this );
        engine.addSystem(system, 0);
        callBack = h.func;
        engine.removeSystem(system);
        h.assertIsCalled();
    }

    @Test
    public function engineCallsUpdateOnSystems():Void
    {
        var h = shouldCall(updateCallbackMethod);
        var system:System = new MockSystem( this );
        engine.addSystem(system, 0);
        callBack = h.func;
        engine.update(0.1);
        h.assertIsCalled();
    }

    @Test
    public function defaultPriorityIsZero():Void
    {
        var system:System = new MockSystem( this );
        assertThat(system.priority, equalTo(0));
    }

    @Test
    public function canSetPriorityWhenAddingSystem():Void
    {
        var system:System = new MockSystem( this );
        engine.addSystem(system, 10);
        assertThat(system.priority, equalTo(10));
    }

    @Test
    public function systemsUpdatedInPriorityOrderIfSameAsAddOrder():Void
    {
        system1 = new MockSystem( this );
        engine.addSystem(system1, 10);
        system2 = new MockSystem( this );
        engine.addSystem(system2, 20);
        //        asyncCallback = async.createHandler(this, updateCallbackMethod1);
        callBack = updateCallbackMethod1;
        engine.update(0.1);
    }

    @Test
    public function systemsUpdatedInPriorityOrderIfReverseOfAddOrder():Void
    {
        system2 = new MockSystem( this );
        engine.addSystem(system2, 20);
        system1 = new MockSystem( this );
        engine.addSystem(system1, 10);
        //        asyncCallback = async.add(updateCallbackMethod1);
        callBack = updateCallbackMethod1;
        engine.update(0.1);
    }

    @Test
    public function systemsUpdatedInPriorityOrderIfPrioritiesAreNegative():Void
    {
        system2 = new MockSystem( this );
        engine.addSystem(system2, 10);
        system1 = new MockSystem( this );
        engine.addSystem(system1, -20);
        //        asyncCallback = async.add(updateCallbackMethod1, 10);
        callBack = updateCallbackMethod1;
        engine.update(0.1);
    }

    @Test
    public function updatingIsFalseBeforeUpdate():Void
    {
        assertThat(engine.updating, is(false));
    }

    @Test
    public function updatingIsTrueDuringUpdate():Void
    {
        var system:System = new MockSystem( this );
        engine.addSystem(system, 0);
        callBack = assertsUpdatingIsTrue;
        engine.update(0.1);
    }

    @Test
    public function updatingIsFalseAfterUpdate():Void
    {
        engine.update(0.1);
        assertThat(engine.updating, is(false));
    }

    @Test
    public function completeSignalIsDispatchedAfterUpdate():Void
    {
        var h = shouldCall(function() {});
        var system:System = new MockSystem( this );
        engine.addSystem(system, 0);
        callBack = function(s, a, t) { engine.updateComplete.add(h.func); };
        engine.update(0.1);
        h.assertIsCalled();
    }

    @Test
    public function getSystemReturnsTheSystem():Void
    {
        var system1:System = new MockSystem( this );
        engine.addSystem(system1, 0);
        engine.addSystem(new EmptySystem(), 0);
        assertThat(engine.getSystem(MockSystem), sameInstance(system1));
    }

    @Test
    public function getSystemReturnsNullIfNoSuchSystem():Void
    {
        engine.addSystem(new EmptySystem(), 0);
        assertThat(engine.getSystem(MockSystem), nullValue());
    }

    @Test
    public function removeAllSystemsDoesWhatItSays():Void
    {
        engine.addSystem(new EmptySystem(), 0);
        engine.addSystem(new MockSystem( this ), 0);
        engine.removeAllSystems();
        assertThat(engine.getSystem(MockSystem), nullValue());
        assertThat(engine.getSystem(EmptySystem), nullValue());
    }

    @Test
    public function removeAllSystemsSetsNextToNull():Void
    {
        var system1 : System = new System();
        engine.addSystem( system1, 1 );
        var system2 : System = new System();
        engine.addSystem( system2, 2 );
        assertThat( system1.next, sameInstance( system2 ) );
        engine.removeAllSystems();
        assertThat( system1.next, nullValue() );
    }

    @Test
    public function removeSystemAndAddItAgainDontCauseInvalidLinkedList():Void
    {
        var systemB:System = new EmptySystem();
        var systemC:System = new EmptySystem();
        engine.addSystem(systemB, 0);
        engine.addSystem(systemC, 0);
        engine.removeSystem(systemB);
        engine.addSystem(systemB, 0);
        // engine.update( 0.1 ); causes infinite loop in failing test
        assertThat(systemC.previous, nullValue());
        assertThat(systemB.next, nullValue());
    }

    private function addedCallbackMethod(system:System, action:String, systemEngine:Engine):Void
    {
        assertThat(action, equalTo("added"));
        assertThat(systemEngine, sameInstance(engine));
    }

    private function removedCallbackMethod(system:System, action:String, systemEngine:Engine):Void
    {
        assertThat(action, equalTo("removed"));
        assertThat(systemEngine, sameInstance(engine));
    }

    private function updateCallbackMethod(system:System, action:String, time:Float):Void
    {
        assertThat(action, equalTo("update"));
        assertThat(time, equalTo(0.1));
    }

    private function updateCallbackMethod1(system:System, action:String, time:Float):Void
    {
        assertThat(system, equalTo(system1));
        //        asyncCallback = async.createHandler(this, updateCallbackMethod2, 10);
        callBack = updateCallbackMethod2;
    }

    private function updateCallbackMethod2(system:System, action:String, time:Float):Void
    {
        assertThat(system, equalTo(system2));
    }

    private function assertsUpdatingIsTrue(system:System, action:String, time:Float):Void
    {
        assertThat(engine.updating, is(true));
    }
}
