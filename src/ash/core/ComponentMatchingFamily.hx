package ash.core;

import ash.ObjectMap;

/**
 * The default class for managing a NodeList. This class creates the NodeList and adds and removes
 * nodes to/from the list as the entities and the components in the engine change.
 *
 * It uses the basic entity matching pattern of an entity system - entities are added to the list if
 * they contain components matching all the public properties of the node class.
 */
class ComponentMatchingFamily<TNode:Node<TNode>> implements IFamily<TNode>
{
    /**
     * The nodelist managed by this family. This is a reference that remains valid always
     * since it is retained and reused by Systems that use the list. i.e. we never recreate the list,
     * we always modify it in place.
     */
    public var nodeList(default, null):NodeList<TNode>;

    private var entities:ObjectMap<Entity, TNode>;
    private var nodeClass:Class<TNode>;
    private var components:ObjectMap<Class<Dynamic>, String>;
    private var nodePool:NodePool<TNode>;
    private var engine:Engine;

    /**
     * The constructor. Creates a ComponentMatchingFamily to provide a NodeList for the
     * given node class.
     *
     * @param nodeClass The type of node to create and manage a NodeList for.
     * @param engine The engine that this family is managing teh NodeList for.
     */
    public function new(nodeClass:Class<TNode>, engine:Engine)
    {
        this.nodeClass = nodeClass;
        this.engine = engine;
        init();
    }

    /**
     * Initialises the class. Creates the nodelist and other tools. Analyses the node to determine
     * what component types the node requires.
     */
    private function init():Void
    {
        nodePool = new NodePool<TNode>( nodeClass );
        nodeList = new NodeList<TNode>();
        entities = new ObjectMap<Entity, TNode>();

        #if cpp
        components = Reflect.field(nodeClass, "_getComponents")();
        #else
        components = untyped nodeClass._getComponents();
        #end
    }

    /**
     * Called by the engine when an entity has been added to it. We check if the entity should be in
     * this family's NodeList and add it if appropriate.
     */
    public function newEntity(entity:Entity):Void
    {
        addIfMatch(entity);
    }

    /**
     * Called by the engine when a component has been added to an entity. We check if the entity is not in
     * this family's NodeList and should be, and add it if appropriate.
     */
    public function componentAddedToEntity(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        addIfMatch(entity);
    }

    /**
     * Called by the engine when a component has been removed from an entity. We check if the removed component
     * is required by this family's NodeList and if so, we check if the entity is in this this NodeList and
     * remove it if so.
     */
    public function componentRemovedFromEntity(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        if (components.exists(componentClass))
        {
            removeIfMatch(entity);
        }
    }

    /**
     * Called by the engine when an entity has been rmoved from it. We check if the entity is in
     * this family's NodeList and remove it if so.
     */
    public function removeEntity(entity:Entity):Void
    {
        removeIfMatch(entity);
    }

    /**
     * If the entity is not in this family's NodeList, tests the components of the entity to see
     * if it should be in this NodeList and adds it if so.
     */
    private function addIfMatch(entity:Entity):Void
    {
        if (!entities.exists(entity))
        {
            for (componentClass in components.keys())
            {
                if (!entity.has(componentClass))
                {
                    return;
                }
            }
            var node:TNode = nodePool.get();
            node.entity = entity;
            for (componentClass in components.keys())
            {
                Reflect.setField(node, components.get(componentClass), entity.get(componentClass));
            }
            entities.set(entity, node);
            nodeList.add(node);
        }
    }

    /**
     * Removes the entity if it is in this family's NodeList.
     */
    private function removeIfMatch(entity:Entity):Void
    {
        if (entities.exists(entity))
        {
            var node:TNode = entities.get(entity);
            entities.remove(entity);
            nodeList.remove(node);
            if (engine.updating)
            {
                nodePool.cache(node);
                engine.updateComplete.add(releaseNodePoolCache);
            }
            else
            {
                nodePool.dispose(node);
            }
        }
    }

    /**
     * Releases the nodes that were added to the node pool during this engine update, so they can
     * be reused.
     */
    private function releaseNodePoolCache():Void
    {
        engine.updateComplete.remove(releaseNodePoolCache);
        nodePool.releaseCache();
    }

    /**
     * Removes all nodes from the NodeList.
     */
    public function cleanUp():Void
    {
        for (node in nodeList)
            entities.remove(node.entity);
        nodeList.removeAll();
    }
}
