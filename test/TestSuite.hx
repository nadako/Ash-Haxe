import massive.munit.TestSuite;

import net.richardlord.ash.core.ComponentMatchingFamilyTest;
import net.richardlord.ash.core.EntityTest;
import net.richardlord.ash.core.GameAndFamilyIntegrationTest;
import net.richardlord.ash.core.GameTest;
import net.richardlord.ash.core.SystemTest;
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
		add(net.richardlord.ash.core.SystemTest);
		add(net.richardlord.ash.tools.ComponentPoolTest);
		add(net.richardlord.ash.tools.ListIteratingSystemTest);
		add(net.richardlord.signals.SignalTest);
	}
}
