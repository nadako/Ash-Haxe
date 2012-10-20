import massive.munit.TestSuite;

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

		add(net.richardlord.ash.tools.ComponentPoolTest);
		add(net.richardlord.ash.tools.ListIteratingSystemTest);
		add(net.richardlord.signals.SignalTest);
	}
}
