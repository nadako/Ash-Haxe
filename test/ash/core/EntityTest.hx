package ash.core;

import haxe.Constraints.Function;
import org.hamcrest.MatchersBase;

import ash.core.Entity;
import ash.Mocks;

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

    private function shouldCall<T:Function>(f:T):ShouldCallHelper<T>
    {
        return new ShouldCallHelper(f, this);
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

        var components:Array<Dynamic> = [component1, component2];
        assertThat(all, hasItems(components));
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

    @Test
    public function storingComponentTriggersAddedSignal():Void
    {
        var h = shouldCall(function(e, c) {});
        var component:MockComponent = new MockComponent();
        entity.componentAdded.add(h.func);
        entity.add(component);
        h.assertIsCalled();
    }

    @Test
    public function removingComponentTriggersRemovedSignal():Void
    {
        var h = shouldCall(function(e, c) {});
        var component:MockComponent = new MockComponent();
        entity.add(component);
        entity.componentRemoved.add(h.func);
        entity.remove(MockComponent);
        h.assertIsCalled();
    }

    @Test
    public function componentAddedSignalContainsCorrectParameters():Void
    {
        var component:MockComponent = new MockComponent();
        entity.componentAdded.add(testSignalContent);
        entity.add(component);
    }

    @Test
    public function componentRemovedSignalContainsCorrectParameters():Void
    {
        var component:MockComponent = new MockComponent();
        entity.add(component);
        entity.componentRemoved.add(testSignalContent);
        entity.remove(MockComponent);
    }

    private function testSignalContent(signalEntity:Entity, componentClass:Class<Dynamic>):Void
    {
        assertThat(signalEntity, sameInstance(entity));
        assertThat(componentClass, sameInstance(MockComponent));
    }

    @Test
    public function testEntityHasNameByDefault():Void
    {
        entity = new Entity();
        assertThat(entity.name.length, greaterThan(0));
    }

    @Test
    public function testEntityNameStoredAndReturned():Void
    {
        var name:String = "anything";
        entity = new Entity( name );
        assertThat(entity.name, equalTo(name));
    }

    @Test
    public function testEntityNameCanBeChanged():Void
    {
        entity = new Entity( "anything" );
        entity.name = "otherThing";
        assertThat(entity.name, equalTo("otherThing"));
    }

    @Test
    public function testChangingEntityNameDispatchesSignal():Void
    {
        var h = shouldCall(testNameChangedSignal);
        entity = new Entity( "anything" );
        entity.nameChanged.add(h.func);
        entity.name = "otherThing";
        h.assertIsCalled();
    }

    private function testNameChangedSignal(signalEntity:Entity, oldName:String):Void
    {
        assertThat(signalEntity, sameInstance(entity));
        assertThat(entity.name, equalTo("otherThing"));
        assertThat(oldName, equalTo("anything"));
    }
}
