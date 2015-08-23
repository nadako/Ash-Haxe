This is a [Haxe](http://haxe.org/) port of the awesome [Ash entity component framework](http://www.ashframework.org/) by Richard Lord.
It leverages Haxe's great cross-platform portability and runs on Flash, JavaScript, C++, Android, iOS and so on.
Also it uses much static typing features of Haxe, allowing more mistakes to be detected at compile time instead
of runtime than in original ActionScript 3 version.

Check out original Ash website for great articles on entity frameworks and game development.

**TODO:**

 * Port serialization stuff. This is kind of tricky because original Ash uses reflection and we are trying to avoid it, so we gotta be smart about macros.
 * Refine access control for private classes and fields. Original Ash used internal class/field feature of AS3, in Haxe we need to use ACL metadata.
 * Review generacted code on performance, add inlines (especially important to inline iterators)

Author: Dan Korostelev <nadako@gmail.com>
