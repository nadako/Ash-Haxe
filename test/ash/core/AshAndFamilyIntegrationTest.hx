package ash.core;

import org.hamcrest.MatchersBase;

import flash.geom.Matrix;
import flash.geom.Point;

import ash.core.Entity;
import ash.core.Engine;
import ash.core.Node;
import ash.Mocks;

/**
 * Tests the family class through the engine class. Left over from a previous
 * architecture but retained because all tests should still pass.
 */
class AshAndFamilyIntegrationTest extends MatchersBase
{
    private var engine:Engine;

    @Before
    public function createEntity():Void
    {
        engine = new Engine();
    }

    @After
    public function clearEntity():Void
    {
        engine = null;
    }

    @Test
    public function testFamilyIsInitiallyEmpty():Void
    {
        var nodes = engine.getNodeList(MockNode2);
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

        var nodes = engine.getNodeList(MockNode2);
        engine.addEntity(entity);
        assertThat(nodes.head.point, sameInstance(point));
        assertThat(nodes.head.matrix, sameInstance(matrix));
    }

    @Test
    public function testCorrectEntityAddedToFamilyWhenAccessFamilyFirst():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        var nodes = engine.getNodeList(MockNode2);
        engine.addEntity(entity);
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testCorrectEntityAddedToFamilyWhenAccessFamilySecond():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        engine.addEntity(entity);
        var nodes = engine.getNodeList(MockNode2);
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testCorrectEntityAddedToFamilyWhenComponentsAdded():Void
    {
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        var nodes = engine.getNodeList(MockNode2);
        entity.add(new Point());
        entity.add(new Matrix());
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testIncorrectEntityNotAddedToFamilyWhenAccessFamilyFirst():Void
    {
        var entity:Entity = new Entity();
        var nodes = engine.getNodeList(MockNode2);
        engine.addEntity(entity);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testIncorrectEntityNotAddedToFamilyWhenAccessFamilySecond():Void
    {
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        var nodes = engine.getNodeList(MockNode2);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityRemovedFromFamilyWhenComponentRemovedAndFamilyAlreadyAccessed():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        engine.addEntity(entity);
        var nodes = engine.getNodeList(MockNode2);
        entity.remove(Point);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityRemovedFromFamilyWhenComponentRemovedAndFamilyNotAlreadyAccessed():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        engine.addEntity(entity);
        entity.remove(Point);
        var nodes = engine.getNodeList(MockNode2);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityRemovedFromFamilyWhenRemovedFromEngineAndFamilyAlreadyAccessed():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        engine.addEntity(entity);
        var nodes = engine.getNodeList(MockNode2);
        engine.removeEntity(entity);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityRemovedFromFamilyWhenRemovedFromEngineAndFamilyNotAlreadyAccessed():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        engine.addEntity(entity);
        engine.removeEntity(entity);
        var nodes = engine.getNodeList(MockNode2);
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
            engine.addEntity(entity);
        }

        var nodes = engine.getNodeList(MockNode2);
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
            engine.addEntity(entity);
        }

        var nodes = engine.getNodeList(MockNode2);
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
        engine.addEntity(entity);
        var nodes = engine.getNodeList(MockNode2);
        engine.releaseNodeList(MockNode2);
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
            engine.addEntity(entity);
        }

        var nodes = engine.getNodeList(MockNode2);
        var node:MockNode2 = nodes.head.next;
        engine.releaseNodeList(MockNode2);
        assertThat(node.next, nullValue());
    }

    @Test
    public function removeAllEntitiesDoesWhatItSays():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        engine.addEntity(entity);
        entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        engine.addEntity(entity);
        var nodes = engine.getNodeList(MockNode2);
        engine.removeAllEntities();
        assertThat(nodes.head, nullValue());
    }
}
