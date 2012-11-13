package net.richardlord.asteroids.components;

import net.richardlord.asteroids.graphics.IAnimatable;

class Animation
{
    public var animation:IAnimatable;

    public function new(animation:IAnimatable)
    {
        this.animation = animation;
    }
}
