package ash.signals;

import org.hamcrest.MatchersBase;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import ash.signals.Signal0;

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
    public function newSignalHasNullHead():Void
    {
        assertThat(signal.head, nullValue());
    }

    @Test
    public function newSignalHasListenersCountZero():Void
    {
        assertThat(signal.numListeners, equalTo(0));
    }

    @AsyncTest
    public function addListenerThenDispatchShouldCallIt(async:AsyncFactory):Void
    {
        signal.add(async.createHandler(this, newEmptyHandler(), 10));
        dispatchSignal();
    }

    @Test
    public function addListenerThenListenersCountIsOne():Void
    {
        signal.add(newEmptyHandler());
        assertThat(signal.numListeners, equalTo(1));
    }

    @Test
    public function addListenerThenRemoveThenDispatchShouldNotCallListener():Void
    {
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        dispatchSignal();
    }

    @Test
    public function addListenerThenRemoveThenListenersCountIsZero():Void
    {
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        assertThat(signal.numListeners, equalTo(0));
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

    @Test
    public function add2ListenersThenListenersCountIsTwo():Void
    {
        signal.add(newEmptyHandler());
        signal.add(newEmptyHandler());
        assertThat(signal.numListeners, equalTo(2));
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
    public function add2ListenersThenRemove1ThenListenersCountIsOne():Void
    {
        signal.add(newEmptyHandler());
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        assertThat(signal.numListeners, equalTo(1));
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

    @Test
    public function addSameListenerTwiceThenListenersCountIsOne():Void
    {
        signal.add(failIfCalled);
        signal.add(failIfCalled);
        assertThat(signal.numListeners, equalTo(1));
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
    public function addingAListenerDuringDispatchIncrementsListenersCount():Void
    {
        signal.add(addListenerDuringDispatchToTestCount);
        dispatchSignal();
        assertThat(signal.numListeners, equalTo(2));
    }

    private function addListenerDuringDispatchToTestCount():Void
    {
        assertThat(signal.numListeners, equalTo(1));
        signal.add(newEmptyHandler());
        assertThat(signal.numListeners, equalTo(2));
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
    public function add2ListenersThenRemoveAllThenListenerCountIsZero():Void
    {
        signal.add(newEmptyHandler());
        signal.add(newEmptyHandler());
        signal.removeAll();
        assertThat(signal.numListeners, equalTo(0));
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
