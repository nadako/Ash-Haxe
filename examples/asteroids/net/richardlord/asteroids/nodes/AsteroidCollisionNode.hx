package net.richardlord.asteroids.nodes;

import ash.core.Node;

import net.richardlord.asteroids.components.Asteroid;
import net.richardlord.asteroids.components.Position;
import net.richardlord.asteroids.components.Collision;

class AsteroidCollisionNode extends Node<AsteroidCollisionNode>
{
    public var asteroid:Asteroid;
    public var position:Position;
    public var collision:Collision;
}
