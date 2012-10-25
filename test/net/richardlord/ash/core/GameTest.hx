package net.richardlord.ash.core;

import org.hamcrest.MatchersBase;

import net.richardlord.ash.core.IFamily;
import net.richardlord.ash.core.Entity;
import net.richardlord.ash.core.Game;
import net.richardlord.ash.core.Node;
import net.richardlord.ash.core.NodeList;
import net.richardlord.ash.Mocks;

import flash.geom.Matrix;
import flash.geom.Point;

class GameTest extends MatchersBase
{
    private var game:Game;

    @Before
    public function createGame():Void
    {
        game = new Game();
        game.familyClass = MockFamily;
        MockFamily.reset();
    }

    @After
    public function clearGame():Void
    {
        game = null;
    }

    @Test
    public function entitiesGetterReturnsAllTheEntities():Void
    {
        var entity1:Entity = new Entity();
        game.addEntity(entity1);
        var entity2:Entity = new Entity();
        game.addEntity(entity2);
        assertThat(game.entities, hasItems([entity1, entity2]));
    }

    @Test
    public function addEntityChecksWithAllFamilies():Void
    {
        game.getNodeList(MockNode);
        game.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        game.addEntity(entity);
        assertThat(MockFamily.instances[0].newEntityCalls, equalTo(1));
        assertThat(MockFamily.instances[1].newEntityCalls, equalTo(1));
    }

    @Test
    public function removeEntityChecksWithAllFamilies():Void
    {
        game.getNodeList(MockNode);
        game.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        game.addEntity(entity);
        game.removeEntity(entity);
        assertThat(MockFamily.instances[0].removeEntityCalls, equalTo(1));
        assertThat(MockFamily.instances[1].removeEntityCalls, equalTo(1));
    }

    @Test
    public function removeAllEntitiesChecksWithAllFamilies():Void
    {
        game.getNodeList(MockNode);
        game.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        var entity2:Entity = new Entity();
        game.addEntity(entity);
        game.addEntity(entity2);
        game.removeAllEntities();
        assertThat(MockFamily.instances[0].removeEntityCalls, equalTo(2));
        assertThat(MockFamily.instances[1].removeEntityCalls, equalTo(2));
    }

    @Test
    public function componentAddedChecksWithAllFamilies():Void
    {
        game.getNodeList(MockNode);
        game.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        game.addEntity(entity);
        entity.add(new Point());
        assertThat(MockFamily.instances[0].componentAddedCalls, equalTo(1));
        assertThat(MockFamily.instances[1].componentAddedCalls, equalTo(1));
    }

    @Test
    public function romponentRemovedChecksWithAllFamilies():Void
    {
        game.getNodeList(MockNode);
        game.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        game.addEntity(entity);
        entity.add(new Point());
        entity.remove(Point);
        assertThat(MockFamily.instances[0].componentAddedCalls, equalTo(1));
        assertThat(MockFamily.instances[1].componentAddedCalls, equalTo(1));
    }

    @Test
    public function getNodeListCreatesFamily():Void
    {
        game.getNodeList(MockNode);
        assertThat(MockFamily.instances.length, equalTo(1));
    }

    @Test
    public function getNodeListChecksAllEntities():Void
    {
        game.addEntity(new Entity());
        game.addEntity(new Entity());
        game.getNodeList(MockNode);
        assertThat(MockFamily.instances[0].newEntityCalls, equalTo(2));
    }

    @Test
    public function releaseNodeListCallsCleanUp():Void
    {
        game.getNodeList(MockNode);
        game.releaseNodeList(MockNode);
        assertThat(MockFamily.instances[0].cleanUpCalls, equalTo(1));
    }
}

class MockFamily<T:Node<T>> implements IFamily<T>
{
    public static function reset():Void
    {
        instances = new Array<MockFamily<Dynamic>>();
    }
    public static var instances:Array<MockFamily<Dynamic>>;

    public var newEntityCalls:Int = 0;
    public var removeEntityCalls:Int = 0;
    public var componentAddedCalls:Int = 0;
    public var componentRemovedCalls:Int = 0;
    public var cleanUpCalls:Int = 0;

    public function new(nodeClass:Class<T>, game:Game)
    {
        instances.push(this);
    }

    public var nodeList(default, never):NodeList<T>;

    public function newEntity(entity:Entity):Void
    {
        newEntityCalls++;
    }

    public function removeEntity(entity:Entity):Void
    {
        removeEntityCalls++;
    }

    public function componentAddedToEntity(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        componentAddedCalls++;
    }

    public function componentRemovedFromEntity(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        componentRemovedCalls++;
    }

    public function cleanUp():Void
    {
        cleanUpCalls++;
    }
}
