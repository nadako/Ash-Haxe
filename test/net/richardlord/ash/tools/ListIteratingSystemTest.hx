package net.richardlord.ash.tools;

import org.hamcrest.MatchersBase;

import flash.geom.Point;

import net.richardlord.ash.core.Node;
import net.richardlord.ash.core.Entity;
import net.richardlord.ash.core.Game;
import net.richardlord.ash.Mocks;

class ListIteratingSystemTest extends MatchersBase
{
    private var entities:Array<Entity>;
    private var callCount:Int;

    @Test
    public function updateIteratesOverNodes():Void
    {
        var game:Game = new Game();
        var entity1:Entity = new Entity();
        var component1:Point = new Point();
        entity1.add(component1);
        game.addEntity(entity1);
        var entity2:Entity = new Entity();
        var component2:Point = new Point();
        entity2.add(component2);
        game.addEntity(entity2);
        var entity3:Entity = new Entity();
        var component3:Point = new Point();
        entity3.add(component3);
        game.addEntity(entity3);
        var system:ListIteratingSystem<MockNode> = new ListIteratingSystem( MockNode, updateNode );
        game.addSystem(system, 1);
        entities = [entity1, entity2, entity3];
        callCount = 0;
        game.update(0.1);
        assertThat(callCount, equalTo(3));
    }

    private function updateNode(node:MockNode, time:Float):Void
    {
        assertThat(node.entity, equalTo(entities[callCount]));
        assertThat(time, equalTo(0.1));
        callCount++;
    }
}
