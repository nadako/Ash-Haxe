This is a HaXe port of the awesome Ash entity component framework by Richard Lord (http://www.ashframework.org/).
It leverages HaXe's great cross-platform portability and runs on Flash, JavaScript, C++, Android, iOS and so on.
Also it uses much static typing features of HaXe, allowing more mistakes to be detected at compile time instead
of runtime than in original ActionScript 3 version.

Check out original Ash website for great articles on entity frameworks and game development.

**TODO:**

 * Port serialization stuff. This is kind of tricky because original Ash uses reflection and we are trying to avoid it, so we gotta be smart about macros.
 * Refine access control for private classes and fields. Original Ash used internal class/field feature of AS3, in Haxe we need to use ACL metadata.

Author: Dan Korostelev <nadako@gmail.com>
