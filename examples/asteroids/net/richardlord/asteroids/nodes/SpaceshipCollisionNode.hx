package net.richardlord.asteroids.nodes;

import ash.core.Node;

import net.richardlord.asteroids.components.Position;
import net.richardlord.asteroids.components.Spaceship;
import net.richardlord.asteroids.components.Collision;

class SpaceshipCollisionNode extends Node<SpaceshipCollisionNode>
{
    public var spaceship:Spaceship;
    public var position:Position;
    public var collision:Collision;
}
