package net.richardlord.ash.core;

import massive.munit.async.AsyncFactory;

import org.hamcrest.MatchersBase;

import net.richardlord.ash.Mocks;
import net.richardlord.ash.core.Game;
import net.richardlord.ash.core.System;

class SystemTest extends MatchersBase
{
    public var async:AsyncFactory;
    public var asyncCallback:Dynamic;

    private var game:Game;

    private var system1:MockSystem;
    private var system2:MockSystem;

    @Before
    public function createEntity():Void
    {
        game = new Game();
    }

    @After
    public function clearEntity():Void
    {
        game = null;
        asyncCallback = null;
    }

    @Test
    public function systemsGetterReturnsAllTheSystems():Void
    {
        var system1:System = Type.createInstance(System, []);
        game.addSystem(system1, 1);
        var system2:System = Type.createInstance(System, []);
        game.addSystem(system2, 1);
        assertThat(game.systems, hasItems([system1, system2]));
    }

    @AsyncTest
    public function addSystemCallsAddToGame(async:AsyncFactory):Void
    {
        var system:System = new MockSystem( this );
        asyncCallback = async.createHandler(this, addedCallbackMethod, 10);
        game.addSystem(system, 0);
    }

    @AsyncTest
    public function removeSystemCallsRemovedFromGame(async:AsyncFactory):Void
    {
        var system:System = new MockSystem( this );
        game.addSystem(system, 0);
        asyncCallback = async.createHandler(this, removedCallbackMethod, 10);
        game.removeSystem(system);
    }

    @AsyncTest
    public function gameCallsUpdateOnSystems(async:AsyncFactory):Void
    {
        var system:System = new MockSystem( this );
        game.addSystem(system, 0);
        asyncCallback = async.createHandler(this, updateCallbackMethod, 10);
        game.update(0.1);
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
        game.addSystem(system, 10);
        assertThat(system.priority, equalTo(10));
    }

    @Test
    public function systemsUpdatedInPriorityOrderIfSameAsAddOrder():Void
    {
        system1 = new MockSystem( this );
        game.addSystem(system1, 10);
        system2 = new MockSystem( this );
        game.addSystem(system2, 20);
        //        this.async = async;
        //        asyncCallback = async.createHandler(this, updateCallbackMethod1, 10);
        asyncCallback = updateCallbackMethod1;
        game.update(0.1);
    }

    @Test
    public function systemsUpdatedInPriorityOrderIfReverseOfAddOrder():Void
    {
        system2 = new MockSystem( this );
        game.addSystem(system2, 20);
        system1 = new MockSystem( this );
        game.addSystem(system1, 10);
        //        asyncCallback = async.add(updateCallbackMethod1, 10);
        asyncCallback = updateCallbackMethod1;
        game.update(0.1);
    }

    @Test
    public function systemsUpdatedInPriorityOrderIfPrioritiesAreNegative():Void
    {
        system2 = new MockSystem( this );
        game.addSystem(system2, 10);
        system1 = new MockSystem( this );
        game.addSystem(system1, -20);
        //        asyncCallback = async.add(updateCallbackMethod1, 10);
        asyncCallback = updateCallbackMethod1;
        game.update(0.1);
    }

    @Test
    public function updatingIsFalseBeforeUpdate():Void
    {
        assertThat(game.updating, is(false));
    }

    @Test
    public function updatingIsTrueDuringUpdate():Void
    {
        var system:System = new MockSystem( this );
        game.addSystem(system, 0);
        asyncCallback = assertsUpdatingIsTrue;
        game.update(0.1);
    }

    @Test
    public function updatingIsFalseAfterUpdate():Void
    {
        game.update(0.1);
        assertThat(game.updating, is(false));
    }

    @AsyncTest
    public function completeSignalIsDispatchedAfterUpdate(async:AsyncFactory):Void
    {
        var system:System = new MockSystem( this );
        game.addSystem(system, 0);
        this.async = async;
        asyncCallback = listensForUpdateComplete;
        game.update(0.1);
    }

    @Test
    public function getSystemReturnsTheSystem():Void
    {
        var system1:System = new MockSystem( this );
        game.addSystem(system1, 0);
        game.addSystem(new EmptySystem(), 0);
        assertThat(game.getSystem(MockSystem), sameInstance(system1));
    }

    @Test
    public function getSystemReturnsNullIfNoSuchSystem():Void
    {
        game.addSystem(new EmptySystem(), 0);
        assertThat(game.getSystem(MockSystem), nullValue());
    }

    @Test
    public function removeAllSystemsDoesWhatItSays():Void
    {
        game.addSystem(new EmptySystem(), 0);
        game.addSystem(new MockSystem( this ), 0);
        game.removeAllSystems();
        assertThat(game.getSystem(MockSystem), nullValue());
        assertThat(game.getSystem(EmptySystem), nullValue());
    }

    @Test
    public function removeSystemAndAddItAgainDontCauseInvalidLinkedList():Void
    {
        var systemB:System = new EmptySystem();
        var systemC:System = new EmptySystem();
        game.addSystem(systemB, 0);
        game.addSystem(systemC, 0);
        game.removeSystem(systemB);
        game.addSystem(systemB, 0);
        // game.update( 0.1 ); causes infinite loop in failing test
        assertThat(systemC.previous, nullValue());
        assertThat(systemB.next, nullValue());
    }

    private function addedCallbackMethod(system:System, action:String, systemGame:Game):Void
    {
        assertThat(action, equalTo("added"));
        assertThat(systemGame, sameInstance(game));
    }

    private function removedCallbackMethod(system:System, action:String, systemGame:Game):Void
    {
        assertThat(action, equalTo("removed"));
        assertThat(systemGame, sameInstance(game));
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
        asyncCallback = updateCallbackMethod2;
    }

    private function updateCallbackMethod2(system:System, action:String, time:Float):Void
    {
        assertThat(system, equalTo(system2));
    }

    private function assertsUpdatingIsTrue(system:System, action:String, time:Float):Void
    {
        assertThat(game.updating, is(true));
    }

    private function listensForUpdateComplete(system:System, action:String, time:Float):Void
    {
        game.updateComplete.add(async.createHandler(this, function()
        {}));
    }
}
