package ash.core;

import ash.ObjectMap;
import ash.signals.Signal0;
import ash.signals.Signal1;

/**
 * The Engine class is the central point for creating and managing your game state. Add
 * entities and systems to the engine, and fetch families of nodes from the engine.
 */
class Engine
{
    public var entities(get_entities, never):Iterable<Entity>;
    public var systems(get_systems, never):Iterable<System>;

    private var entityList:EntityList;
    private var systemList:SystemList;
    private var families:ObjectMap<Class<Dynamic>, IFamily<Dynamic>>;

    /**
     * Indicates if the engine is currently in its update loop.
     */
    public var updating:Bool;

    public var entityAdded(default, null):Signal1<Entity>;
    public var entityRemoved(default, null):Signal1<Entity>;

    /**
     * Dispatched when the update loop ends. If you want to add and remove systems from the
     * engine it is usually best not to do so during the update loop. To avoid this you can
     * listen for this signal and make the change when the signal is dispatched.
     */
    public var updateComplete (default, null):Signal0;

    /**
     * The class used to manage node lists. In most cases the default class is sufficient
     * but it is exposed here so advanced developers can choose to create and use a
     * different implementation.
     *
     * The class must implement the IFamily interface.
     */
    public var familyClass:Class<IFamily<Dynamic>> = ComponentMatchingFamily;

    public function new()
    {
        entityList = new EntityList();
        systemList = new SystemList();
        families = new ObjectMap<Class<Node<Dynamic>>, IFamily<Dynamic>>();
        entityAdded = new Signal1<Entity>();
        entityRemoved = new Signal1<Entity>();
        updateComplete = new Signal0();
        updating = false;
    }

    /**
     * Add an entity to the engine.
     *
     * @param entity The entity to add.
     */

    public function addEntity(entity:Entity):Void
    {
        entityList.add(entity);
        entity.componentAdded.add(componentAdded);
        entity.componentRemoved.add(componentRemoved);
        for (family in families)
        {
            family.newEntity(entity);
        }
        entityAdded.dispatch(entity);
    }

    /**
     * Remove an entity from the engine.
     *
     * @param entity The entity to remove.
     */

    public function removeEntity(entity:Entity):Void
    {
        entity.componentAdded.remove(componentAdded);
        entity.componentRemoved.remove(componentRemoved);
        for (family in families)
        {
            family.removeEntity(entity);
        }
        entityList.remove(entity);
        entityRemoved.dispatch(entity);
    }

    /**
     * Remove all entities from the engine.
     */

    public function removeAllEntities():Void
    {
        while (entityList.head != null)
        {
            removeEntity(entityList.head);
        }
    }

    /**
     * Returns an iterator of all entities in the engine.
     */
    private inline function get_entities():Iterable<Entity>
    {
        return entityList;
    }

    /**
     * @private
     */

    private function componentAdded(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        for (family in families)
        {
            family.componentAddedToEntity(entity, componentClass);
        }
    }

    /**
     * @private
     */

    private function componentRemoved(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        for (family in families)
        {
            family.componentRemovedFromEntity(entity, componentClass);
        }
    }

    /**
     * Get a collection of nodes from the engine, based on the type of the node required.
     *
     * <p>The engine will create the appropriate NodeList if it doesn't already exist and
     * will keep its contents up to date as entities are added to and removed from the
     * engine.</p>
     *
     * <p>If a NodeList is no longer required, release it with the releaseNodeList method.</p>
     *
     * @param nodeClass The type of node required.
     * @return A linked list of all nodes of this type from all entities in the engine.
     */

    public function getNodeList<TNode:Node<TNode>>(nodeClass:Class<TNode>):NodeList<TNode>
    {
        if (families.exists(nodeClass))
            return cast(families.get(nodeClass)).nodeList;

        var family:IFamily<TNode> = cast(Type.createInstance(familyClass, [nodeClass, this ]));
        families.set(nodeClass, family);

        for (entity in entityList)
            family.newEntity(entity);

        return family.nodeList;
    }

    /**
     * If a NodeList is no longer required, this method will stop the engine updating
     * the list and will release all references to the list within the framework
     * classes, enabling it to be garbage collected.
     *
     * <p>It is not essential to release a list, but releasing it will free
     * up memory and processor resources.</p>
     *
     * @param nodeClass The type of the node class if the list to be released.
     */

    public function releaseNodeList<TNode:Node<TNode>>(nodeClass:Class<TNode>):Void
    {
        if (families.exists(nodeClass))
        {
            families.get(nodeClass).cleanUp();
            families.remove(nodeClass);
        }
    }

    /**
     * Add a system to the engine, and set its priority for the order in which the
     * systems are updated by the engine update loop.
     *
     * <p>The priority dictates the order in which the systems are updated by the engine update
     * loop. Lower numbers for priority are updated first. i.e. a priority of 1 is
     * updated before a priority of 2.</p>
     *
     * @param system The system to add to the engine.
     * @param priority The priority for updating the systems during the engine loop. A
     * lower number means the system is updated sooner.
     */

    public function addSystem(system:System, priority:Int):Void
    {
        system.priority = priority;
        system.addToEngine(this);
        systemList.add(system);
    }

    /**
     * Get the system instance of a particular type from within the engine.
     *
     * @param type The type of system
     * @return The instance of the system type that is in the engine, or
     * null if no systems of this type are in the engine.
     */

    public function getSystem<TSystem:System>(type:Class<TSystem>):TSystem
    {
        return systemList.get(type);
    }

    /**
     * Returns an iterator of all systems in the engine.
     */
    private inline function get_systems():Iterable<System>
    {
        return systemList;
    }

    /**
     * Remove a system from the engine.
     *
     * @param system The system to remove from the engine.
     */

    public function removeSystem(system:System):Void
    {
        systemList.remove(system);
        system.removeFromEngine(this);
    }

    /**
     * Remove all systems from the engine.
     */

    public function removeAllSystems():Void
    {
        while (systemList.head != null)
        {
            removeSystem(systemList.head);
        }
    }

    /**
     * Update the engine. This causes the engine update loop to run, calling update on all the
     * systems in the engine.
     *
     * <p>The package ash.tick contains classes that can be used to provide
     * a steady or variable tick that calls this update method.</p>
     *
     * @time The duration, in seconds, of this update step.
     */

    public function update(time:Float):Void
    {
        updating = true;
        for (system in systemList)
            system.update(time);
        updating = false;
        updateComplete.dispatch();
    }
}
