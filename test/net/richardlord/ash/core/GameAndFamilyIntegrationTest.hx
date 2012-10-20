package net.richardlord.ash.core;

import org.hamcrest.MatchersBase;
import net.richardlord.ash.core.Node;
import net.richardlord.ash.Mocks;

import flash.geom.Matrix;
import flash.geom.Point;

/**
 * Tests the family class through the game class. Left over from a previous
 * architecture but retained because all tests should still pass.
 */
class GameAndFamilyIntegrationTest extends MatchersBase
{
    private var game:Game;

    @Before
    public function createEntity():Void
    {
        game = new Game();
    }

    @After
    public function clearEntity():Void
    {
        game = null;
    }

    @Test
    public function testFamilyIsInitiallyEmpty():Void
    {
        var nodes = game.getNodeList(MockNode2);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testNodeContainsEntityProperties():Void
    {
        var entity:Entity = new Entity();
        var point:Point = new Point();
        var matrix:Matrix = new Matrix();
        entity.add(point);
        entity.add(matrix);

        var nodes = game.getNodeList(MockNode2);
        game.addEntity(entity);
        assertThat(nodes.head.point, sameInstance(point));
        assertThat(nodes.head.matrix, sameInstance(matrix));
    }

    @Test
    public function testCorrectEntityAddedToFamilyWhenAccessFamilyFirst():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        var nodes = game.getNodeList(MockNode2);
        game.addEntity(entity);
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testCorrectEntityAddedToFamilyWhenAccessFamilySecond():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        game.addEntity(entity);
        var nodes = game.getNodeList(MockNode2);
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testCorrectEntityAddedToFamilyWhenComponentsAdded():Void
    {
        var entity:Entity = new Entity();
        game.addEntity(entity);
        var nodes = game.getNodeList(MockNode2);
        entity.add(new Point());
        entity.add(new Matrix());
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testIncorrectEntityNotAddedToFamilyWhenAccessFamilyFirst():Void
    {
        var entity:Entity = new Entity();
        var nodes = game.getNodeList(MockNode2);
        game.addEntity(entity);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testIncorrectEntityNotAddedToFamilyWhenAccessFamilySecond():Void
    {
        var entity:Entity = new Entity();
        game.addEntity(entity);
        var nodes = game.getNodeList(MockNode2);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityRemovedFromFamilyWhenComponentRemovedAndFamilyAlreadyAccessed():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        game.addEntity(entity);
        var nodes = game.getNodeList(MockNode2);
        entity.remove(Point);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityRemovedFromFamilyWhenComponentRemovedAndFamilyNotAlreadyAccessed():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        game.addEntity(entity);
        entity.remove(Point);
        var nodes = game.getNodeList(MockNode2);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityRemovedFromFamilyWhenRemovedFromGameAndFamilyAlreadyAccessed():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        game.addEntity(entity);
        var nodes = game.getNodeList(MockNode2);
        game.removeEntity(entity);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityRemovedFromFamilyWhenRemovedFromGameAndFamilyNotAlreadyAccessed():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        game.addEntity(entity);
        game.removeEntity(entity);
        var nodes = game.getNodeList(MockNode2);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function familyContainsOnlyMatchingEntities():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entity.add(new Matrix());
            entities.push(entity);
            game.addEntity(entity);
        }

        var nodes = game.getNodeList(MockNode2);
        for (node in nodes)
        {
            assertThat(entities, hasItem(node.entity));
        }
    }

    @Test
    public function familyContainsAllMatchingEntities():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entity.add(new Matrix());
            entities.push(entity);
            game.addEntity(entity);
        }

        var nodes = game.getNodeList(MockNode2);
        for (node in nodes)
        {
            var index:Int = Lambda.indexOf(entities, node.entity);
            entities.splice(index, 1);
        }
        assertThat(entities, emptyArray());
    }

    @Test
    public function releaseFamilyEmptiesNodeList():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        game.addEntity(entity);
        var nodes = game.getNodeList(MockNode2);
        game.releaseNodeList(MockNode2);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function releaseFamilySetsNextNodeToNull():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entity.add(new Matrix());
            entities.push(entity);
            game.addEntity(entity);
        }

        var nodes = game.getNodeList(MockNode2);
        var node:MockNode2 = nodes.head.next;
        game.releaseNodeList(MockNode2);
        assertThat(node.next, nullValue());
    }

    @Test
    public function removeAllEntitiesDoesWhatItSays():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        game.addEntity(entity);
        entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        game.addEntity(entity);
        var nodes = game.getNodeList(MockNode2);
        game.removeAllEntities();
        assertThat(nodes.head, nullValue());
    }
}
