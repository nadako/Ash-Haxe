package ash.signals;

import org.hamcrest.MatchersBase;

import massive.munit.Assert;

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

    private function shouldCall(f = null)
    {
        if (f == null)
            f = newEmptyHandler();
        return new ShouldCallHelper(f, this);
    }

    private static function newEmptyHandler():Dynamic
    {
        // due to strange bug/feature in neko,
        // function comparison will return true
        // for different anonymous function if they
        // dont hold any outer context
        var ctx = null;
        return function():Void
        {
            ctx;
        };
    }

    private static function failIfCalled():Void
    {
        Assert.fail('This function should not have been called.');
    }

    private function methodFailIfCalled():Void
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

    @Test
    public function addListenerThenDispatchShouldCallIt():Void
    {
        var h = shouldCall();
        signal.add(h.func);
        dispatchSignal();
        h.assertIsCalled();
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
    public function addMethodListenerThenRemoveThenDispatchShouldNotCallListener():Void
    {
        signal.add(methodFailIfCalled);
        signal.remove(methodFailIfCalled);
        dispatchSignal();
    }

    @Test
    public function addMethodListenerThenRemoveThenListenersCountIsZero():Void
    {
        signal.add(methodFailIfCalled);
        signal.remove(methodFailIfCalled);
        assertThat(signal.numListeners, equalTo(0));
    }

    @Test
    public function removeFunctionNotInListenersShouldNotThrowError():Void
    {
        signal.remove(newEmptyHandler());
        dispatchSignal();
    }

    @Test
    public function addListenerThenRemoveFunctionNotInListenersShouldStillCallListener():Void
    {
        var h = shouldCall();
        signal.add(h.func);
        signal.remove(function() {});
        dispatchSignal();
        h.assertIsCalled();
    }

    @Test
    public function add2ListenersThenDispatchShouldCallBoth():Void
    {
        var h1 = shouldCall();
        var h2 = shouldCall();
        signal.add(h1.func);
        signal.add(h2.func);
        dispatchSignal();
        h1.assertIsCalled();
        h2.assertIsCalled();
    }

    @Test
    public function add2ListenersThenListenersCountIsTwo():Void
    {
        signal.add(newEmptyHandler());
        signal.add(newEmptyHandler());
        assertThat(signal.numListeners, equalTo(2));
    }

    @Test
    public function add2ListenersRemove1stThenDispatchShouldCall2ndNot1stListener():Void
    {
        var h = shouldCall();
        signal.add(failIfCalled);
        signal.add(h.func);
        signal.remove(failIfCalled);
        dispatchSignal();
        h.assertIsCalled();
    }

    @Test
    public function add2ListenersRemove2ndThenDispatchShouldCall1stNot2ndListener():Void
    {
        var h = shouldCall();
        signal.add(h.func);
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        dispatchSignal();
        h.assertIsCalled();
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

    @Test
    public function dispatch2Listeners1stListenerRemovesItselfThen2ndListenerIsStillCalled():Void
    {
        var h = shouldCall();
        signal.add(selfRemover);
        signal.add(h.func);
        dispatchSignal();
        h.assertIsCalled();
    }

    private function selfRemover():Void
    {
        signal.remove(selfRemover);
    }

    @Test
    public function dispatch2Listeners2ndListenerRemovesItselfThen1stListenerIsStillCalled():Void
    {
        var h = shouldCall();
        signal.add(h.func);
        signal.add(selfRemover);
        dispatchSignal();
        h.assertIsCalled();
    }

    @Test
    public function addingAListenerDuringDispatchShouldNotCallIt():Void
    {
        var h = shouldCall(addListenerDuringDispatch);
        signal.add(h.func);
        dispatchSignal();
        h.assertIsCalled();
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
    public function addListenerThenRemoveAllThenAddAgainShouldAddListener():Void
    {
        var handler = newEmptyHandler();
        signal.add(handler);
        signal.removeAll();
        signal.add(handler);
        assertThat(signal.numListeners, equalTo(1));
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

    @Test
    public function addOnceListenerThenDispatchShouldCallIt():Void
    {
        var h = shouldCall();
        signal.addOnce(h.func);
        dispatchSignal();
        h.assertIsCalled();
    }

    @Test
    public function addOnceListenerShouldBeRemovedAfterDispatch():Void
    {
        signal.addOnce(newEmptyHandler());
        dispatchSignal();
        assertThat(signal.head, nullValue());
    }
}

