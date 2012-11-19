package ash.matchers;

import org.hamcrest.core.IsEqual;
import org.hamcrest.Matcher;
import org.hamcrest.Description;
import org.hamcrest.TypeSafeMatcher;

import ash.core.Node;
import ash.core.NodeList;

class NodeListMatcher<TNode:Node<TNode>> extends TypeSafeMatcher<NodeList<TNode>>
{
    private var elementMatchers:Array<Matcher<TNode>>;

    public static function nodeList<TNode:Node<TNode>>(nodes:Array<TNode>):NodeListMatcher<TNode>
    {
        return new NodeListMatcher(Lambda.array(Lambda.map(nodes, IsEqual.equalTo)));
    }

    public function new(elementMatchers:Array<Matcher<TNode>>)
    {
        super();
        this.elementMatchers = elementMatchers;
    }

    override public function matchesSafely(nodes:NodeList<TNode>):Bool
    {
        var index:Int = 0;
        for (node in nodes)
        {
            if (index >= elementMatchers.length)
            {
                return false;
            }
            if (!elementMatchers[index].matches(node))
            {
                return false;
            }
            ++index;
        }

        return true;
    }

    override public function isExpectedType(value:Dynamic):Bool
    {
        return Std.is(value, NodeList);
    }

    override public function describeTo(description:Description):Void
    {
        description.appendList(descriptionStart(), descriptionSeparator(), descriptionEnd(), elementMatchers);
    }

    private function descriptionStart():String
    {
        return "[";
    }

    private function descriptionSeparator():String
    {
        return ", ";
    }

    private function descriptionEnd():String
    {
        return "]";
    }
}
