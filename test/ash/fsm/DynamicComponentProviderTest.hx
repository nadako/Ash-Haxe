package ash.fsm;

import org.hamcrest.MatchersBase;

import ash.fsm.DynamicComponentProvider.DynamicComponentProviderClosure;
import ash.Mocks;

class DynamicComponentProviderTest extends MatchersBase
{
    @Test
    public function providerReturnsTheInstance():Void
    {
        var instance:MockComponent = new MockComponent();
        var providerMethod:DynamicComponentProviderClosure<MockComponent> = function():MockComponent
        {
            return instance;
        };
        var provider:DynamicComponentProvider<MockComponent> = new DynamicComponentProvider( providerMethod );
        assertThat(provider.getComponent(), sameInstance(instance));
    }

    @Test
    public function providersWithSameMethodHaveSameIdentifier():Void
    {
        var instance:MockComponent = new MockComponent();
        var providerMethod:DynamicComponentProviderClosure<MockComponent> = function():MockComponent
        {
            return instance;
        };

        var provider1:DynamicComponentProvider<MockComponent> = new DynamicComponentProvider( providerMethod );
        var provider2:DynamicComponentProvider<MockComponent> = new DynamicComponentProvider( providerMethod );
        assertThat(provider1.identifier, equalTo(provider2.identifier));
    }

    @Test
    public function providersWithDifferentMethodsHaveDifferentIdentifier():Void
    {
        var instance:MockComponent = new MockComponent();
        var providerMethod1:DynamicComponentProviderClosure<MockComponent> = function():MockComponent
        {
            return instance;
        };

        var providerMethod2:DynamicComponentProviderClosure<MockComponent> = function():MockComponent
        {
            return instance;
        };

        var provider1:DynamicComponentProvider<MockComponent> = new DynamicComponentProvider( providerMethod1 );
        var provider2:DynamicComponentProvider<MockComponent> = new DynamicComponentProvider( providerMethod2 );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
