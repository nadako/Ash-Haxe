package ash;

import haxe.Constraints.Function;
import haxe.PosInfos;

import massive.munit.Assert;

class ShouldCallHelper<T:Function>
{
    private var called:Bool;
    private var callback:T;
    private var context:Dynamic;

    public var func(default, null):T;

    public function new(callback:T, context:Dynamic = null)
    {
        this.callback = callback;
        this.context = context;
        this.called = false;
        func = Reflect.makeVarArgs(_func);
    }

    public function assertIsCalled(?info:PosInfos)
    {
        Assert.isTrue(called, info);
    }

    private function _func(args:Array<Dynamic>):Dynamic
    {
        var result = Reflect.callMethod(context, callback, args);
        called = true;
        return result;
    }
}
