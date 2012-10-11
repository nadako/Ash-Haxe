package net.richardlord.asteroids.graphics;

import flash.display.Shape;

class AsteroidView extends Shape
{
    public function new(radius:Float)
    {
        super();

        var angle:Float = 0;
        graphics.beginFill(0xFFFFFF);
        graphics.moveTo(radius, 0);
        while (angle < Math.PI * 2)
        {
            var length:Float = ( 0.75 + Math.random() * 0.25 ) * radius;
            var posX:Float = Math.cos(angle) * length;
            var posY:Float = Math.sin(angle) * length;
            graphics.lineTo(posX, posY);
            angle += Math.random() * 0.5;
        }
        graphics.lineTo(radius, 0);
        graphics.endFill();
    }
}
