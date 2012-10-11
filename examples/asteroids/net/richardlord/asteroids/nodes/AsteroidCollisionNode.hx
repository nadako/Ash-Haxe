package net.richardlord.asteroids.nodes;

import net.richardlord.ash.core.Node;
import net.richardlord.asteroids.components.Asteroid;
import net.richardlord.asteroids.components.Position;

class AsteroidCollisionNode extends Node<AsteroidCollisionNode>
{
    public var asteroid:Asteroid;
    public var position:Position;
}
