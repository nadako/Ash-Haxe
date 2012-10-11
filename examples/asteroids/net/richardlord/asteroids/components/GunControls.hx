package net.richardlord.asteroids.components;

class GunControls
{
    public var trigger(default, null):Int = 0;

    public function new(trigger:Int)
    {
        this.trigger = trigger;
    }
}
