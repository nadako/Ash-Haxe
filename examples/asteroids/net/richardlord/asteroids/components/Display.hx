package net.richardlord.asteroids.components;

import flash.display.DisplayObject;

class Display
{
    public var displayObject(default, null):DisplayObject;

    public function new(displayObject:DisplayObject)
    {
        this.displayObject = displayObject;
    }
}
