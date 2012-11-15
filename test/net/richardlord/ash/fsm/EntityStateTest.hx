package net.richardlord.ash.fsm;

import org.hamcrest.MatchersBase;

import net.richardlord.ash.Mocks;

class EntityStateTest extends MatchersBase
{
    private var state:EntityState;

    @Before
    public function createState():Void
    {
        state = new EntityState();
    }

    @After
    public function clearState():Void
    {
        state = null;
    }

    @Test
    public function addWithNoQualifierCreatesTypeProvider():Void
    {
        state.add(MockComponent);
        var provider:IComponentProvider<MockComponent> = cast state.providers.get(MockComponent);
        assertThat(provider, any(ComponentTypeProvider));
        assertThat(provider.getComponent(), any(MockComponent));
    }

    @Test
    public function addWithTypeQualifierCreatesTypeProvider():Void
    {
        state.add(MockComponent).withType(MockComponentExtended);
        var provider:IComponentProvider<MockComponent> = cast state.providers.get(MockComponent);
        assertThat(provider, any(ComponentTypeProvider));
        assertThat(provider.getComponent(), any(MockComponentExtended));
    }

    @Test
    public function addWithInstanceQualifierCreatesInstanceProvider():Void
    {
        var component:MockComponent = new MockComponent();
        state.add(MockComponent).withInstance(component);
        var provider:IComponentProvider<MockComponent> = cast state.providers.get(MockComponent);
        assertThat(provider, any(ComponentInstanceProvider));
        assertThat(provider.getComponent(), equalTo(component));
    }

    @Test
    public function addWithSingletonQualifierCreatesSingletonProvider():Void
    {
        state.add(MockComponent).withSingleton(MockComponent);
        var provider:IComponentProvider<MockComponent> = cast state.providers.get(MockComponent);
        assertThat(provider, any(ComponentSingletonProvider));
        assertThat(provider.getComponent(), any(MockComponent));
    }
}
