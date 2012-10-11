package net.richardlord.asteroids.components;

import flash.geom.Point;

class Position
{
    public var position:Point;
    public var rotation:Float;
    public var collisionRadius:Float;

    public function new(x:Float, y:Float, rotation:Float, collisionRadius:Float)
    {
        position = new Point( x, y );
        this.rotation = rotation;
        this.collisionRadius = collisionRadius;
    }
}
