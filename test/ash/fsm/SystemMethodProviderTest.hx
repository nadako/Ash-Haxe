package ash.fsm;

import ash.core.System;
import ash.fsm.DynamicSystemProvider.DynamicSystemProviderClosure;
import ash.Mocks.EmptySystem;

import org.hamcrest.MatchersBase;

class SystemMethodProviderTest extends MatchersBase
{
    @Test
    public function providerReturnsTheInstance():Void
    {
        var instance:EmptySystem = new EmptySystem();
        var providerMethod:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        }

        var provider:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod );
        assertThat(provider.getSystem(), theInstance(instance));
    }

    @Test
    public function providersWithSameMethodHaveSameIdentifier():Void
    {
        var instance:EmptySystem = new EmptySystem();
        var providerMethod:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        }
        var provider1:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod );
        var provider2:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod );
        assertThat(provider1.identifier, theInstance(provider2.identifier));
    }

    @Test
    public function providersWithDifferentMethodHaveDifferentIdentifier():Void
    {
        var instance:EmptySystem = new EmptySystem();
        var providerMethod1:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        }

        var providerMethod2:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        }

        var provider1:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod1 );
        var provider2:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod2 );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
