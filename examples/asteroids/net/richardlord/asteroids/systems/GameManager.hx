package net.richardlord.asteroids.systems;

import net.richardlord.ash.core.Game;
import net.richardlord.ash.core.NodeList;
import net.richardlord.ash.core.System;
import net.richardlord.asteroids.EntityCreator;
import net.richardlord.asteroids.GameConfig;
import net.richardlord.asteroids.nodes.AsteroidCollisionNode;
import net.richardlord.asteroids.nodes.BulletCollisionNode;
import net.richardlord.asteroids.nodes.GameNode;
import net.richardlord.asteroids.nodes.SpaceshipCollisionNode;

import flash.geom.Point;

class GameManager extends System
{
    private var config:GameConfig;
    private var creator:EntityCreator;

    private var gameNodes:NodeList<GameNode>;
    private var spaceships:NodeList<SpaceshipCollisionNode>;
    private var asteroids:NodeList<AsteroidCollisionNode>;
    private var bullets:NodeList<BulletCollisionNode>;

    public function new(creator:EntityCreator, config:GameConfig)
    {
        this.creator = creator;
        this.config = config;
    }

    override public function addToGame(game:Game):Void
    {
        gameNodes = game.getNodeList(GameNode);
        spaceships = game.getNodeList(SpaceshipCollisionNode);
        asteroids = game.getNodeList(AsteroidCollisionNode);
        bullets = game.getNodeList(BulletCollisionNode);
    }

    override public function update(time:Float):Void
    {
        var node:GameNode = gameNodes.head;
        while (node != null)
        {
            if (spaceships.empty)
            {
                if (node.state.lives > 0)
                {
                    var newSpaceshipPosition:Point = new Point( config.width * 0.5, config.height * 0.5 );
                    var clearToAddSpaceship:Bool = true;

                    var asteroid:AsteroidCollisionNode = asteroids.head;
                    while (asteroid != null)
                    {
                        if (Point.distance(asteroid.position.position, newSpaceshipPosition) <= asteroid.position.collisionRadius + 50)
                        {
                            clearToAddSpaceship = false;
                            break;
                        }
                        asteroid = asteroid.next;
                    }
                    if (clearToAddSpaceship)
                    {
                        creator.createSpaceship();
                        node.state.lives--;
                    }
                }
                else
                {
                    // game over
                }
            }

            if (asteroids.empty && bullets.empty && !spaceships.empty)
            {
                // next level
                var spaceship:SpaceshipCollisionNode = spaceships.head;
                node.state.level++;
                var asteroidCount:Int = 2 + node.state.level;
                for (i in 0...asteroidCount)
                {
                    // check not on top of spaceship
                    var position:Point;
                    do
                    {
                        position = new Point( Math.random() * config.width, Math.random() * config.height );
                    }
                    while (Point.distance(position, spaceship.position.position) <= 80);
                    creator.createAsteroid(30, position.x, position.y);
                }
            }
            node = node.next;
        }
    }

    override public function removeFromGame(game:Game):Void
    {
        gameNodes = null;
        spaceships = null;
        asteroids = null;
        bullets = null;
    }
}
