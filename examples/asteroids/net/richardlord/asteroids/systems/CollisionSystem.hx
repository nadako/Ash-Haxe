package net.richardlord.asteroids.systems;

import flash.geom.Point;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import net.richardlord.asteroids.EntityCreator;
import net.richardlord.asteroids.nodes.AsteroidCollisionNode;
import net.richardlord.asteroids.nodes.BulletCollisionNode;
import net.richardlord.asteroids.nodes.SpaceshipCollisionNode;


class CollisionSystem extends System
{
    private var creator:EntityCreator;

    private var spaceships:NodeList<SpaceshipCollisionNode>;
    private var asteroids:NodeList<AsteroidCollisionNode>;
    private var bullets:NodeList<BulletCollisionNode>;

    public function new(creator:EntityCreator)
    {
        super();
        this.creator = creator;
    }

    override public function addToEngine(engine:Engine):Void
    {
        spaceships = engine.getNodeList(SpaceshipCollisionNode);
        asteroids = engine.getNodeList(AsteroidCollisionNode);
        bullets = engine.getNodeList(BulletCollisionNode);
    }

    override public function update(time:Float):Void
    {
        for (bullet in bullets)
        {
            for (asteroid in asteroids)
            {
                if (Point.distance(asteroid.position.position, bullet.position.position) <= asteroid.collision.radius)
                {
                    creator.destroyEntity(bullet.entity);
                    if (asteroid.collision.radius > 10)
                    {
                        creator.createAsteroid(asteroid.collision.radius - 10, asteroid.position.position.x + Math.random() * 10 - 5, asteroid.position.position.y + Math.random() * 10 - 5);
                        creator.createAsteroid(asteroid.collision.radius - 10, asteroid.position.position.x + Math.random() * 10 - 5, asteroid.position.position.y + Math.random() * 10 - 5);
                    }
                    creator.destroyEntity(asteroid.entity);
                    break;
                }
            }
        }

        for (spaceship in spaceships)
        {
            for (asteroid in asteroids)
            {
                if (Point.distance(asteroid.position.position, spaceship.position.position) <= asteroid.collision.radius + spaceship.collision.radius)
                {
                    spaceship.spaceship.fsm.changeState("destroyed");
                    break;
                }
            }
        }
    }

    override public function removeFromEngine(engine:Engine):Void
    {
        spaceships = null;
        asteroids = null;
        bullets = null;
    }
}
