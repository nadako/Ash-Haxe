package net.richardlord.asteroids.nodes;

import ash.core.Node;

import net.richardlord.asteroids.components.Bullet;
import net.richardlord.asteroids.components.Position;
import net.richardlord.asteroids.components.Collision;

class BulletCollisionNode extends Node<BulletCollisionNode>
{
    public var bullet:Bullet;
    public var position:Position;
    public var collision:Collision;
}
