package ash.fsm;

import ash.core.System;
import ash.Mocks.EmptySystem;
import ash.Mocks.EmptySystem2;

import org.hamcrest.MatchersBase;

class SystemSingletonProviderTest extends MatchersBase
{
    @Test
    public function providerReturnsAnInstanceOfSystem():Void
    {
        var provider:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        assertThat(provider.getSystem(), instanceOf(EmptySystem));
    }

    @Test
    public function providerReturnsSameInstanceEachTime():Void
    {
        var provider:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        assertThat(provider.getSystem(), equalTo(provider.getSystem()));
    }

    @Test
    public function providersWithSameSystemHaveDifferentIdentifier():Void
    {
        var provider1:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        var provider2:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        assertThat(provider1.identifier, not(provider2.identifier));
    }

    @Test
    public function providersWithDifferentSystemsHaveDifferentIdentifier():Void
    {
        var provider1:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        var provider2:SystemSingletonProvider<EmptySystem2> = new SystemSingletonProvider( EmptySystem2 );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
