import massive.munit.TestSuite;

import ash.core.AshAndFamilyIntegrationTest;
import ash.core.ComponentMatchingFamilyTest;
import ash.core.EngineTest;
import ash.core.EntityTest;
import ash.core.NodeListTest;
import ash.core.SystemTest;
import ash.fsm.ComponentInstanceProviderTest;
import ash.fsm.ComponentSingletonProviderTest;
import ash.fsm.ComponentTypeProviderTest;
import ash.fsm.DynamicComponentProviderTest;
import ash.fsm.EngineStateMachineTest;
import ash.fsm.EntityStateMachineTest;
import ash.fsm.EntityStateTest;
import ash.fsm.SystemInstanceProviderTest;
import ash.fsm.SystemMethodProviderTest;
import ash.fsm.SystemSingletonProviderTest;
import ash.fsm.SystemStateTest;
import ash.signals.SignalTest;
import ash.tools.ComponentPoolTest;
import ash.tools.ListIteratingSystemTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(ash.core.AshAndFamilyIntegrationTest);
		add(ash.core.ComponentMatchingFamilyTest);
		add(ash.core.EngineTest);
		add(ash.core.EntityTest);
		add(ash.core.NodeListTest);
		add(ash.core.SystemTest);
		add(ash.fsm.ComponentInstanceProviderTest);
		add(ash.fsm.ComponentSingletonProviderTest);
		add(ash.fsm.ComponentTypeProviderTest);
		add(ash.fsm.DynamicComponentProviderTest);
		add(ash.fsm.EngineStateMachineTest);
		add(ash.fsm.EntityStateMachineTest);
		add(ash.fsm.EntityStateTest);
		add(ash.fsm.SystemInstanceProviderTest);
		add(ash.fsm.SystemMethodProviderTest);
		add(ash.fsm.SystemSingletonProviderTest);
		add(ash.fsm.SystemStateTest);
		add(ash.signals.SignalTest);
		add(ash.tools.ComponentPoolTest);
		add(ash.tools.ListIteratingSystemTest);
	}
}
