package net.richardlord.asteroids.systems;

import flash.geom.Point;
import net.richardlord.ash.core.Game;
import net.richardlord.ash.core.NodeList;
import net.richardlord.ash.core.System;
import net.richardlord.asteroids.EntityCreator;
import net.richardlord.asteroids.nodes.AsteroidCollisionNode;
import net.richardlord.asteroids.nodes.BulletCollisionNode;
import net.richardlord.asteroids.nodes.SpaceshipCollisionNode;


class CollisionSystem extends System
{
    private var creator : EntityCreator;

    private var spaceships : NodeList<SpaceshipCollisionNode>;
    private var asteroids : NodeList<AsteroidCollisionNode>;
    private var bullets : NodeList<BulletCollisionNode>;

    public function new( creator : EntityCreator )
    {
        this.creator = creator;
    }

    override public function addToGame( game : Game ) : Void
    {
        spaceships = game.getNodeList( SpaceshipCollisionNode );
        asteroids = game.getNodeList( AsteroidCollisionNode );
        bullets = game.getNodeList( BulletCollisionNode );
    }

    override public function update( time : Float ) : Void
    {
        var bullet : BulletCollisionNode;
        var asteroid : AsteroidCollisionNode;
        var spaceship : SpaceshipCollisionNode;

        bullet = bullets.head;
        while ( bullet != null )
        {
            asteroid = asteroids.head;
            while ( asteroid != null )
            {
                if ( Point.distance( asteroid.position.position, bullet.position.position ) <= asteroid.position.collisionRadius )
                {
                    creator.destroyEntity( bullet.entity );
                    if ( asteroid.position.collisionRadius > 10 )
                    {
                        creator.createAsteroid( asteroid.position.collisionRadius - 10, asteroid.position.position.x + Math.random() * 10 - 5, asteroid.position.position.y + Math.random() * 10 - 5 );
                        creator.createAsteroid( asteroid.position.collisionRadius - 10, asteroid.position.position.x + Math.random() * 10 - 5, asteroid.position.position.y + Math.random() * 10 - 5 );
                    }
                    creator.destroyEntity( asteroid.entity );
                    break;
                }
                asteroid = asteroid.next;
            }
            bullet = bullet.next;
        }

        spaceship = spaceships.head;
        while ( spaceship != null )
        {
            asteroid = asteroids.head;
            while( asteroid != null )
            {
                if ( Point.distance( asteroid.position.position, spaceship.position.position ) <= asteroid.position.collisionRadius + spaceship.position.collisionRadius )
                {
                    creator.destroyEntity( spaceship.entity );
                    break;
                }
                asteroid = asteroid.next;
            }
            spaceship = spaceship.next;
        }
    }

    override public function removeFromGame( game : Game ) : Void
    {
        spaceships = null;
        asteroids = null;
        bullets = null;
    }
}
