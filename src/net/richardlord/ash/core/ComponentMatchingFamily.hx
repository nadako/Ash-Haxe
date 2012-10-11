package net.richardlord.ash.core;

import haxe.rtti.CType.Classdef;
import nme.ObjectHash;

/**
 * An default class for managing a NodeList. This class creates the NodeList and adds and removes
 * nodes to/from the list as the entities and the components in the game change.
 *
 * It uses the basic entity matching pattern of an entity system - entities are added to the list if
 * they contain components matching all the public properties of the node class.
 */
class ComponentMatchingFamily<TNode:Node<TNode>> implements Family<TNode>
{
    public var nodeList(default, null):NodeList<TNode>;
    private var entities:ObjectHash<Entity, TNode>;
    private var nodeClass:Class<TNode>;
    private var components:ObjectHash<Class<Dynamic>, String>;
    private var nodePool:NodePool<TNode>;
    private var game:Game;

    public function new(nodeClass:Class<TNode>, game:Game)
    {
        this.nodeClass = nodeClass;
        this.game = game;
        init();
    }

    private function init():Void
    {
        nodePool = new NodePool<TNode>( nodeClass );
        nodeList = new NodeList<TNode>();
        entities = new ObjectHash<Entity, TNode>();

        components = new ObjectHash<Class<Dynamic>, String>();
        nodePool.dispose(nodePool.get()); // create a dummy instance to ensure describeType works.

        var xml:Xml = Xml.parse(Reflect.field(nodeClass, "__rtti")).firstElement();
        var infos = new haxe.rtti.XmlParser().processElement(xml);
        var classDef:Classdef;
        switch(infos)
        {
            case TClassdecl(classDef):
                for (f in classDef.fields)
                {
                    if (f.name != "entity" && f.name != "previous" && f.name != "next")
                    {
                        var type:String = Std.string(f.type);
                        var arr:Array<String> = type.split("(");
                        arr.shift();
                        type = arr.pop();
                        arr = type.split(",");
                        arr.pop();
                        var classname:String = arr.pop();
                        if (classname == "{}" || classname == "Void")
                            continue;
                        var newClass:Class<Dynamic> = Type.resolveClass(classname);
                        components.set(newClass, f.name);
                    }
                }
            default:
        }


    }

    public function newEntity(entity:Entity):Void
    {
        addIfMatch(entity);
    }

    public function componentAddedToEntity(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        addIfMatch(entity);
    }

    public function componentRemovedFromEntity(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        if (components.exists(componentClass))
        {
            removeIfMatch(entity);
        }
    }

    public function removeEntity(entity:Entity):Void
    {
        removeIfMatch(entity);
    }

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

    private function removeIfMatch(entity:Entity):Void
    {
        if (entities.exists(entity))
        {
            var node:TNode = entities.get(entity);
            entities.remove(entity);
            nodeList.remove(node);
            if (game.updating)
            {
                nodePool.cache(node);
                game.updateComplete.add(releaseNodePoolCache);
            }
            else
            {
                nodePool.dispose(node);
            }
        }
    }

    private function releaseNodePoolCache():Void
    {
        game.updateComplete.remove(releaseNodePoolCache);
        nodePool.releaseCache();
    }

    public function cleanUp():Void
    {
        var node:TNode = nodeList.head;
        while (node != null)
        {
            entities.remove(node.entity);
            node = node.next;
        }
        nodeList.removeAll();
    }
}
