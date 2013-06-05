package ash.fsm;

import ash.fsm.DynamicSystemProvider.DynamicSystemProviderClosure;
import ash.Mocks.EmptySystem;

import org.hamcrest.MatchersBase;


class SystemStateTest extends MatchersBase
{
    private var state:EngineState;

    @Before
    public function createState():Void
    {
        state = new EngineState();
    }

    @After
    public function clearState():Void
    {
        state = null;
    }

    @Test
    public function addInstanceCreatesInstanceProvider():Void
    {
        var component:EmptySystem = new EmptySystem();
        state.addInstance(component);
        var provider:ISystemProvider<EmptySystem> = cast state.providers[0];
        assertThat(provider, instanceOf(SystemInstanceProvider));
        assertThat(provider.getSystem(), equalTo(component));
    }

    @Test
    public function addSingletonCreatesSingletonProvider():Void
    {
        state.addSingleton(EmptySystem);
        var provider:ISystemProvider<EmptySystem> = cast state.providers[0];
        assertThat(provider, instanceOf(SystemSingletonProvider));
        assertThat(provider.getSystem(), instanceOf(EmptySystem));
    }

    @Test
    public function addMethodCreatesMethodProvider():Void
    {
        var instance:EmptySystem = new EmptySystem();

        var methodProvider:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        };

        state.addMethod(methodProvider);
        var provider:ISystemProvider<EmptySystem> = cast state.providers[0];
        assertThat(provider, instanceOf(DynamicSystemProvider));
        assertThat(provider.getSystem(), instanceOf(EmptySystem));
    }

    @Test
    public function withPrioritySetsPriorityOnProvider():Void
    {
        var priority:Int = 10;
        state.addSingleton(EmptySystem).withPriority(priority);
        var provider:ISystemProvider<EmptySystem> = cast state.providers[0];
        assertThat(provider.priority, equalTo(priority));

    }
}
