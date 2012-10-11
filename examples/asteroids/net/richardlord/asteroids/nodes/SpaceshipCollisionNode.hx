package net.richardlord.asteroids.nodes;

import net.richardlord.ash.core.Node;
import net.richardlord.asteroids.components.Position;
import net.richardlord.asteroids.components.Spaceship;

class SpaceshipCollisionNode extends Node<SpaceshipCollisionNode>
{
    public var spaceship:Spaceship;
    public var position:Position;
}
