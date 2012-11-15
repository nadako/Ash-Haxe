package net.richardlord.ash.fsm;

import org.hamcrest.MatchersBase;

import net.richardlord.ash.Mocks;

class ComponentTypeProviderTest extends MatchersBase
{
    @Test
    public function providerReturnsAnInstanceOfType():Void
    {
        var provider:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        assertThat(provider.getComponent(), any(MockComponent));
    }

    @Test
    public function providerReturnsNewInstanceEachTime():Void
    {
        var provider:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        assertThat(provider.getComponent(), not(provider.getComponent()));
    }

    @Test
    public function providersWithSameTypeHaveSameIdentifier():Void
    {
        var provider1:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        var provider2:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        assertThat(provider1.identifier, equalTo(provider2.identifier));
    }

    @Test
    public function providersWithDifferentTypeHaveDifferentIdentifier():Void
    {
        var provider1:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        var provider2:ComponentTypeProvider<MockComponent2> = new ComponentTypeProvider( MockComponent2 );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
