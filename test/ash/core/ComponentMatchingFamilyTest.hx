package ash.core;

import org.hamcrest.MatchersBase;

import flash.geom.Matrix;
import flash.geom.Point;

import ash.core.Entity;
import ash.core.ComponentMatchingFamily;
import ash.core.Ash;
import ash.core.Node;
import ash.Mocks;

class ComponentMatchingFamilyTest extends MatchersBase
{
    private var game:Ash;
    private var family:ComponentMatchingFamily<MockNode>;

    @Before
    public function createFamily():Void
    {
        game = new Ash();
        family = new ComponentMatchingFamily( MockNode, game );
    }

    @After
    public function clearFamily():Void
    {
        family = null;
        game = null;
    }

    @Test
    public function testNodeListIsInitiallyEmpty():Void
    {
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testMatchingEntityIsAddedWhenAccessNodeListFirst():Void
    {
        var nodes = family.nodeList;
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testMatchingEntityIsAddedWhenAccessNodeListSecond():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testNodeContainsEntityProperties():Void
    {
        var entity:Entity = new Entity();
        var point:Point = new Point();
        entity.add(point);
        family.newEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head.point, sameInstance(point));
    }

    @Test
    public function testMatchingEntityIsAddedWhenComponentAdded():Void
    {
        var nodes = family.nodeList;
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.componentAddedToEntity(entity, Point);
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testNonMatchingEntityIsNotAdded():Void
    {
        var entity:Entity = new Entity();
        family.newEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testNonMatchingEntityIsNotAddedWhenComponentAdded():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Matrix());
        family.componentAddedToEntity(entity, Matrix);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityIsRemovedWhenAccessNodeListFirst():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        var nodes = family.nodeList;
        family.removeEntity(entity);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityIsRemovedWhenAccessNodeListSecond():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        family.removeEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityIsRemovedWhenComponentRemoved():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        entity.remove(Point);
        family.componentRemovedFromEntity(entity, Point);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function nodeListContainsOnlyMatchingEntities():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entities.push(entity);
            family.newEntity(entity);
            family.newEntity(new Entity());
        }

        var nodes = family.nodeList;
        for (node in nodes)
        {
            assertThat(entities, hasItem(node.entity));
        }
    }

    @Test
    public function nodeListContainsAllMatchingEntities():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entities.push(entity);
            family.newEntity(entity);
            family.newEntity(new Entity());
        }

        var nodes = family.nodeList;
        for (node in nodes)
        {
            var index:Int = Lambda.indexOf(entities, node.entity);
            entities.splice(index, 1);
        }
        assertThat(entities, emptyArray());
    }

    @Test
    public function cleanUpEmptiesNodeList():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        var nodes = family.nodeList;
        family.cleanUp();
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function cleanUpSetsNextNodeToNull():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entities.push(entity);
            family.newEntity(entity);
        }

        var nodes = family.nodeList;
        var node:MockNode = nodes.head.next;
        family.cleanUp();
        assertThat(node.next, nullValue());
    }
}
