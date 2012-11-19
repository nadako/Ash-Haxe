package ash;

import ash.core.Ash;
import ash.core.SystemTest;
import ash.core.System;
import ash.core.Node;

import flash.geom.Matrix;
import flash.geom.Point;


class MockNode extends Node<MockNode>
{
    public var point:Point;
}

class MockNode2 extends Node<MockNode2>
{
    public var point:Point;
    public var matrix:Matrix;
}

class MockNode3 extends Node<MockNode3>
{
    public var matrix:Matrix;
}

class MockComponent
{
    public var value:Int;

    public function new()
    {
    }
}

class MockComponent2
{
    public var value:String;

    public function new()
    {
    }
}

class MockComponentExtended extends MockComponent
{
    public var other:Int;

    public function new()
    {
        super();
    }
}

class MockSystem extends System
{
    private var tests:SystemTest;

    public function new(tests:SystemTest)
    {
        super();
        this.tests = tests;
    }

    override public function addToGame(game:Ash):Void
    {
        if (tests.asyncCallback != null)
            tests.asyncCallback(this, "added", game);
    }

    override public function removeFromGame(game:Ash):Void
    {
        if (tests.asyncCallback != null)
            tests.asyncCallback(this, "removed", game);
    }

    override public function update(time:Float):Void
    {
        if (tests.asyncCallback != null)
            tests.asyncCallback(this, "update", time);
    }
}

class EmptySystem extends System
{
    public function new()
    {
        super();
    }
}
