import massive.munit.TestSuite;

import net.richardlord.ash.core.ComponentMatchingFamilyTest;
import net.richardlord.ash.core.EntityTest;
import net.richardlord.ash.core.GameAndFamilyIntegrationTest;
import net.richardlord.ash.core.GameTest;
import net.richardlord.ash.core.NodeListTest;
import net.richardlord.ash.core.SystemTest;
import net.richardlord.ash.fsm.ComponentInstanceProviderTest;
import net.richardlord.ash.fsm.ComponentSingletonProviderTest;
import net.richardlord.ash.fsm.ComponentTypeProviderTest;
import net.richardlord.ash.fsm.EntityStateMachineTest;
import net.richardlord.ash.fsm.EntityStateTest;
import net.richardlord.ash.tools.ComponentPoolTest;
import net.richardlord.ash.tools.ListIteratingSystemTest;
import net.richardlord.signals.SignalTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(net.richardlord.ash.core.ComponentMatchingFamilyTest);
		add(net.richardlord.ash.core.EntityTest);
		add(net.richardlord.ash.core.GameAndFamilyIntegrationTest);
		add(net.richardlord.ash.core.GameTest);
		add(net.richardlord.ash.core.NodeListTest);
		add(net.richardlord.ash.core.SystemTest);
		add(net.richardlord.ash.fsm.ComponentInstanceProviderTest);
		add(net.richardlord.ash.fsm.ComponentSingletonProviderTest);
		add(net.richardlord.ash.fsm.ComponentTypeProviderTest);
		add(net.richardlord.ash.fsm.EntityStateMachineTest);
		add(net.richardlord.ash.fsm.EntityStateTest);
		add(net.richardlord.ash.tools.ComponentPoolTest);
		add(net.richardlord.ash.tools.ListIteratingSystemTest);
		add(net.richardlord.signals.SignalTest);
	}
}
