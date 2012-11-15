package net.richardlord.ash.fsm;

import org.hamcrest.MatchersBase;

import net.richardlord.ash.Mocks;

class ComponentSingletonProviderTest extends MatchersBase
{
    @Test
    public function providerReturnsAnInstanceOfType():Void
    {
        var provider:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        assertThat(provider.getComponent(), any(MockComponent));
    }

    @Test
    public function providerReturnsSameInstanceEachTime():Void
    {
        var provider:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        assertThat(provider.getComponent(), equalTo(provider.getComponent()));
    }

    @Test
    public function providersWithSameTypeHaveDifferentIdentifier():Void
    {
        var provider1:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        var provider2:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        assertThat(provider1.identifier, not(provider2.identifier));
    }

    @Test
    public function providersWithDifferentTypeHaveDifferentIdentifier():Void
    {
        var provider1:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        var provider2:ComponentSingletonProvider<MockComponent2> = new ComponentSingletonProvider( MockComponent2 );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
