package net.richardlord.asteroids.nodes;

import ash.core.Node;

import net.richardlord.asteroids.components.Position;
import net.richardlord.asteroids.components.Spaceship;

class SpaceshipNode extends Node<SpaceshipNode>
{
    public var spaceship:Spaceship;
    public var position:Position;
}
