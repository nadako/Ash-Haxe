package net.richardlord.ash.tools;

import org.hamcrest.MatchersBase;

class ComponentPoolTest extends MatchersBase
{
    @Before
    public function createPool():Void
    {
    }

    @After
    public function destroyPool():Void
    {
        ComponentPool.empty();
    }

    @Test
    public function getRetrievesObjectOfAppropriateClass():Void
    {
        assertThat(ComponentPool.get(MockComponent), is(MockComponent));
    }

    @Test
    public function disposedComponentsAreRetrievedByGet():Void
    {
        var mockComponent:MockComponent = new MockComponent();
        ComponentPool.dispose(mockComponent);
        var retrievedComponent:MockComponent = ComponentPool.get(MockComponent);
        assertThat(retrievedComponent, sameInstance(mockComponent));
    }

    @Test
    public function emptyPreventsRetrievalOfPreviouslyDisposedComponents():Void
    {
        var mockComponent:MockComponent = new MockComponent();
        ComponentPool.dispose(mockComponent);
        ComponentPool.empty();
        var retrievedComponent:MockComponent = ComponentPool.get(MockComponent);
        assertThat(retrievedComponent, not(sameInstance(mockComponent)));
    }
}

class MockComponent
{
    public var value:Int;

    public function new()
    {
    }
}