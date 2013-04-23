package ash.core;

import org.hamcrest.MatchersBase;

import ash.core.IFamily;
import ash.core.Entity;
import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.Mocks;

class EngineTest extends MatchersBase
{
    private var engine:Engine;

    @Before
    public function createEngine():Void
    {
        engine = new Engine();
        engine.familyClass = MockFamily;
        MockFamily.reset();
    }

    @After
    public function clearEngine():Void
    {
        engine = null;
    }

    @Test
    public function entitiesGetterReturnsAllTheEntities():Void
    {
        var entity1:Entity = new Entity();
        engine.addEntity(entity1);
        var entity2:Entity = new Entity();
        engine.addEntity(entity2);
        assertThat(engine.entities, hasItems([entity1, entity2]));
    }

    @Test
    public function addEntityChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        assertThat(MockFamily.instances[0].newEntityCalls, equalTo(1));
        assertThat(MockFamily.instances[1].newEntityCalls, equalTo(1));
    }

    @Test
    public function removeEntityChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        engine.removeEntity(entity);
        assertThat(MockFamily.instances[0].removeEntityCalls, equalTo(1));
        assertThat(MockFamily.instances[1].removeEntityCalls, equalTo(1));
    }

    @Test
    public function removeAllEntitiesChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        var entity2:Entity = new Entity();
        engine.addEntity(entity);
        engine.addEntity(entity2);
        engine.removeAllEntities();
        assertThat(MockFamily.instances[0].removeEntityCalls, equalTo(2));
        assertThat(MockFamily.instances[1].removeEntityCalls, equalTo(2));
    }

    @Test
    public function componentAddedChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        entity.add(new Point());
        assertThat(MockFamily.instances[0].componentAddedCalls, equalTo(1));
        assertThat(MockFamily.instances[1].componentAddedCalls, equalTo(1));
    }

    @Test
    public function componentRemovedChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        entity.add(new Point());
        entity.remove(Point);
        assertThat(MockFamily.instances[0].componentRemovedCalls, equalTo(1));
        assertThat(MockFamily.instances[1].componentRemovedCalls, equalTo(1));
    }

    @Test
    public function getNodeListCreatesFamily():Void
    {
        engine.getNodeList(MockNode);
        assertThat(MockFamily.instances.length, equalTo(1));
    }

    @Test
    public function getNodeListChecksAllEntities():Void
    {
        engine.addEntity(new Entity());
        engine.addEntity(new Entity());
        engine.getNodeList(MockNode);
        assertThat(MockFamily.instances[0].newEntityCalls, equalTo(2));
    }

    @Test
    public function releaseNodeListCallsCleanUp():Void
    {
        engine.getNodeList(MockNode);
        engine.releaseNodeList(MockNode);
        assertThat(MockFamily.instances[0].cleanUpCalls, equalTo(1));
    }

    @Test
    public function entityCanBeObtainedByName():Void
    {
        var entity:Entity = new Entity( "anything" );
        engine.addEntity(entity);
        var other:Entity = engine.getEntityByName("anything");
        assertThat(other, sameInstance(entity));
    }

    @Test
    public function getEntityByInvalidNameReturnsNull():Void
    {
        var entity:Entity = engine.getEntityByName("anything");
        assertThat(entity, nullValue());
    }

    @Test
    public function entityCanBeObtainedByNameAfterRenaming():Void
    {
        var entity:Entity = new Entity( "anything" );
        engine.addEntity(entity);
        entity.name = "otherName";
        var other:Entity = engine.getEntityByName("otherName");
        assertThat(other, sameInstance(entity));
    }

    @Test
    public function entityCannotBeObtainedByOldNameAfterRenaming():Void
    {
        var entity:Entity = new Entity( "anything" );
        engine.addEntity(entity);
        entity.name = "otherName";
        var other:Entity = engine.getEntityByName("anything");
        assertThat(other, nullValue());
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

    public function new(nodeClass:Class<T>, engine:Engine)
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
