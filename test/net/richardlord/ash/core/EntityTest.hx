package net.richardlord.ash.core;

import massive.munit.async.AsyncFactory;

import org.hamcrest.MatchersBase;

class EntityTest extends MatchersBase
{
    private var entity:Entity;

    @Before
    public function createEntity():Void
    {
        entity = new Entity();
    }

    @After
    public function clearEntity():Void
    {
        entity = null;
    }

    @Test
    public function addReturnsReferenceToEntity():Void
    {
        var component:MockComponent = new MockComponent();
        var e:Entity = entity.add(component);
        assertThat(e, sameInstance(entity));
    }

    @Test
    public function canStoreAndRetrieveComponent():Void
    {
        var component:MockComponent = new MockComponent();
        entity.add(component);
        assertThat(entity.get(MockComponent), sameInstance(component));
    }

    @Test
    public function canStoreAndRetrieveMultipleComponents():Void
    {
        var component1:MockComponent = new MockComponent();
        entity.add(component1);
        var component2:MockComponent2 = new MockComponent2();
        entity.add(component2);
        assertThat(entity.get(MockComponent), sameInstance(component1));
        assertThat(entity.get(MockComponent2), sameInstance(component2));
    }

    @Test
    public function canReplaceComponent():Void
    {
        var component1:MockComponent = new MockComponent();
        entity.add(component1);
        var component2:MockComponent = new MockComponent();
        entity.add(component2);
        assertThat(entity.get(MockComponent), sameInstance(component2));
    }

    @Test
    public function canStoreBaseAndExtendedComponents():Void
    {
        var component1:MockComponent = new MockComponent();
        entity.add(component1);
        var component2:MockComponentExtended = new MockComponentExtended();
        entity.add(component2);
        assertThat(entity.get(MockComponent), sameInstance(component1));
        assertThat(entity.get(MockComponentExtended), sameInstance(component2));
    }

    @Test
    public function canStoreExtendedComponentAsBaseType():Void
    {
        var component:MockComponentExtended = new MockComponentExtended();
        entity.add(component, MockComponent);
        assertThat(entity.get(MockComponent), sameInstance(component));
    }

    @Test
    public function getReturnNullIfNoComponent():Void
    {
        assertThat(entity.get(MockComponent), nullValue());
    }

    @Test
    public function willRetrieveAllComponents():Void
    {
        var component1:MockComponent = new MockComponent();
        entity.add(component1);
        var component2:MockComponent2 = new MockComponent2();
        entity.add(component2);
        var all:Array<Dynamic> = entity.getAll();
        assertThat(all.length, equalTo(2));
        assertThat(all, hasItems([component1, component2]));
    }

    @Test
    public function hasComponentIsFalseIfComponentTypeNotPresent():Void
    {
        entity.add(new MockComponent2());
        assertThat(entity.has(MockComponent), is(false));
    }

    @Test
    public function hasComponentIsTrueIfComponentTypeIsPresent():Void
    {
        entity.add(new MockComponent());
        assertThat(entity.has(MockComponent), is(true));
    }

    @Test
    public function canRemoveComponent():Void
    {
        var component:MockComponent = new MockComponent();
        entity.add(component);
        entity.remove(MockComponent);
        assertThat(entity.has(MockComponent), is(false));
    }

    @AsyncTest
    public function storingComponentTriggersAddedSignal(async:AsyncFactory):Void
    {
        var component:MockComponent = new MockComponent();
        entity.componentAdded.add(async.createHandler(this, function():Void
        {}));
        entity.add(component);
    }

    @AsyncTest
    public function removingComponentTriggersRemovedSignal(async:AsyncFactory):Void
    {
        var component:MockComponent = new MockComponent();
        entity.add(component);
        entity.componentRemoved.add(async.createHandler(this, function():Void
        {}));
        entity.remove(MockComponent);
    }

    @AsyncTest
    public function componentAddedSignalContainsCorrectParameters(async:AsyncFactory):Void
    {
        var component:MockComponent = new MockComponent();
        entity.componentAdded.add(async.createHandler(this, testSignalContent, 10));
        entity.add(component);
    }

    @AsyncTest
    public function componentRemovedSignalContainsCorrectParameters(async:AsyncFactory):Void
    {
        var component:MockComponent = new MockComponent();
        entity.add(component);
        entity.componentRemoved.add(async.createHandler(this, testSignalContent, 10));
        entity.remove(MockComponent);
    }

    @Test
    public function cloneIsNewReference():Void
    {
        entity.add(new MockComponent());
        var clone:Entity = entity.clone();
        assertThat(clone, not(sameInstance(entity)));
    }

    @Test
    public function cloneHasChildComponent():Void
    {
        entity.add(new MockComponent());
        var clone:Entity = entity.clone();
        assertThat(clone.has(MockComponent), is(true));
    }

    @Test
    public function cloneChildComponentIsNewReference():Void
    {
        entity.add(new MockComponent());
        var clone:Entity = entity.clone();
        assertThat(clone.get(MockComponent), not(sameInstance(entity.get(MockComponent))));
    }

    @Test
    public function cloneChildComponentHasSameProperties():Void
    {
        var component:MockComponent = new MockComponent();
        component.value = 5;
        entity.add(component);
        var clone:Entity = entity.clone();
        assertThat(clone.get(MockComponent).value, equalTo(5));
    }

    private function testSignalContent(signalEntity:Entity, componentClass:Class<Dynamic>):Void
    {
        assertThat(signalEntity, sameInstance(entity));
        assertThat(componentClass, sameInstance(MockComponent));
    }
}

class MockComponent
{
    public var value:Int;

    public function new()
    {
    }
}

class MockComponent2
{
    public var value:String;

    public function new()
    {
    }
}

class MockComponentExtended extends MockComponent
{
    public var other:Int;

    public function new()
    {
        super();
    }
}
