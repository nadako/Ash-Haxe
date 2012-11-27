package net.richardlord.asteroids;

import flash.display.DisplayObjectContainer;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;

import net.richardlord.asteroids.systems.BulletAgeSystem;
import net.richardlord.asteroids.systems.CollisionSystem;
import net.richardlord.asteroids.systems.GameManager;
import net.richardlord.asteroids.systems.GunControlSystem;
import net.richardlord.asteroids.systems.MotionControlSystem;
import net.richardlord.asteroids.systems.MovementSystem;
import net.richardlord.asteroids.systems.RenderSystem;
import net.richardlord.asteroids.systems.SystemPriorities;
import net.richardlord.asteroids.systems.AnimationSystem;
import net.richardlord.asteroids.systems.DeathThroesSystem;
import net.richardlord.input.KeyPoll;

class Asteroids
{
    private var container:DisplayObjectContainer;
    private var engine:Engine;
    private var tickProvider:ITickProvider;
    private var creator:EntityCreator;
    private var keyPoll:KeyPoll;
    private var config:GameConfig;

    public function new(container:DisplayObjectContainer, width:Float, height:Float)
    {
        this.container = container;
        prepare(width, height);
    }

    private function prepare(width:Float, height:Float):Void
    {
        engine = new Engine();
        creator = new EntityCreator( engine );
        keyPoll = new KeyPoll( container.stage );
        config = new GameConfig();
        config.width = width;
        config.height = height;

        engine.addSystem(new GameManager( creator, config ), SystemPriorities.preUpdate);
        engine.addSystem(new MotionControlSystem( keyPoll ), SystemPriorities.update);
        engine.addSystem(new GunControlSystem( keyPoll, creator ), SystemPriorities.update);
        engine.addSystem(new BulletAgeSystem( creator ), SystemPriorities.update);
        engine.addSystem(new DeathThroesSystem( creator ), SystemPriorities.update);
        engine.addSystem(new MovementSystem( config ), SystemPriorities.move);
        engine.addSystem(new CollisionSystem( creator ), SystemPriorities.resolveCollisions);
        engine.addSystem(new AnimationSystem(), SystemPriorities.animate);
        engine.addSystem(new RenderSystem( container ), SystemPriorities.render);

        creator.createGame();
    }

    public function start():Void
    {
        tickProvider = new FrameTickProvider( container );
        tickProvider.add(engine.update);
        tickProvider.start();
    }
}
