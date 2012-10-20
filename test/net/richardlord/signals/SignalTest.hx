package net.richardlord.signals;

import Reflect;

import org.hamcrest.MatchersBase;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class SignalTest extends MatchersBase
{
    private var signal:Signal0;

    @Before
    public function createSignal():Void
    {
        signal = new Signal0();
    }

    @After
    public function destroySignal():Void
    {
        signal = null;
    }

    private function dispatchSignal():Void
    {
        signal.dispatch();
    }

    private static function newEmptyHandler():Dynamic
    {
        return function():Void
        {
        };
    }

    private static function failIfCalled():Void
    {
        Assert.fail('This function should not have been called.');
    }

    @Test
    public function newSignalHasNoListeners():Void
    {
        assertThat(signal.head, nullValue());
    }

    @AsyncTest
    public function addListenerThenDispatchShouldCallIt(async:AsyncFactory):Void
    {
        signal.add(async.createHandler(this, newEmptyHandler(), 10));
        dispatchSignal();
    }

    @Test
    public function addListenerThenRemoveThenDispatchShouldNotCallListener():Void
    {
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        dispatchSignal();
    }

    @Test
    public function removeFunctionNotInListenersShouldNotThrowError():Void
    {
        signal.remove(newEmptyHandler());
        dispatchSignal();
    }

    @AsyncTest
    public function addListenerThenRemoveFunctionNotInListenersShouldStillCallListener(async:AsyncFactory):Void
    {
        signal.add(async.createHandler(this, newEmptyHandler(), 10));
        signal.remove(newEmptyHandler());
        dispatchSignal();
    }

    @AsyncTest
    public function add2ListenersThenDispatchShouldCallBoth(async:AsyncFactory):Void
    {
        signal.add(async.createHandler(this, newEmptyHandler(), 10));
        signal.add(async.createHandler(this, newEmptyHandler(), 10));
        dispatchSignal();
    }

    @AsyncTest
    public function add2ListenersRemove1stThenDispatchShouldCall2ndNot1stListener(async:AsyncFactory):Void
    {
        signal.add(failIfCalled);
        signal.add(async.createHandler(this, newEmptyHandler(), 10));
        signal.remove(failIfCalled);
        dispatchSignal();
    }

    @AsyncTest
    public function add2ListenersRemove2ndThenDispatchShouldCall1stNot2ndListener(async:AsyncFactory):Void
    {
        signal.add(async.createHandler(this, newEmptyHandler(), 10));
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        dispatchSignal();
    }

    @Test
    public function addSameListenerTwiceShouldOnlyAddItOnce():Void
    {
        var count:Int = 0;
        var func = function():Void
        {
            ++count;
        };
        signal.add(func);
        signal.add(func);
        dispatchSignal();
        assertThat(count, equalTo(1));
    }

    @Test
    public function addTheSameListenerTwiceShouldNotThrowError():Void
    {
        var listener = newEmptyHandler();
        signal.add(listener);
        signal.add(listener);
    }

    @AsyncTest
    public function dispatch2Listeners1stListenerRemovesItselfThen2ndListenerIsStillCalled(async:AsyncFactory):Void
    {
        signal.add(selfRemover);
        signal.add(async.createHandler(this, newEmptyHandler(), 10));
        dispatchSignal();
    }

    private function selfRemover():Void
    {
        signal.remove(selfRemover);
    }

    @AsyncTest
    public function dispatch2Listeners2ndListenerRemovesItselfThen1stListenerIsStillCalled(async:AsyncFactory):Void
    {
        signal.add(async.createHandler(this, newEmptyHandler(), 10));
        signal.add(selfRemover);
        dispatchSignal();
    }

    @AsyncTest
    public function addingAListenerDuringDispatchShouldNotCallIt(async:AsyncFactory):Void
    {
        signal.add(async.createHandler(this, addListenerDuringDispatch, 10));
        dispatchSignal();
    }

    private function addListenerDuringDispatch():Void
    {
        signal.add(failIfCalled);
    }

    @Test
    public function dispatch2Listeners2ndListenerRemoves1stThen1stListenerIsNotCalled():Void
    {
        signal.add(removeFailListener);
        signal.add(failIfCalled);
        dispatchSignal();
    }

    private function removeFailListener():Void
    {
        signal.remove(failIfCalled);
    }

    @Test
    public function add2ListenersThenRemoveAllShouldLeaveNoListeners():Void
    {
        signal.add(newEmptyHandler());
        signal.add(newEmptyHandler());
        signal.removeAll();
        assertThat(signal.head, nullValue());
    }

    @Test
    public function removeAllDuringDispatchShouldStopAll():Void
    {
        signal.add(removeAllListeners);
        signal.add(failIfCalled);
        signal.add(newEmptyHandler());
        dispatchSignal();
    }

    private function removeAllListeners():Void
    {
        signal.removeAll();
    }

    @AsyncTest
    public function addOnceListenerThenDispatchShouldCallIt(async:AsyncFactory):Void
    {
        signal.addOnce(async.createHandler(this, newEmptyHandler(), 10));
        dispatchSignal();
    }

    @Test
    public function addOnceListenerShouldBeRemovedAfterDispatch():Void
    {
        signal.addOnce(newEmptyHandler());
        dispatchSignal();
        assertThat(signal.head, nullValue());
    }
}
