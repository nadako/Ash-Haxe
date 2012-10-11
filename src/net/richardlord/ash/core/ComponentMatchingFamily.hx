package net.richardlord.ash.core;

import haxe.rtti.CType.Classdef;

import flash.errors.Error;

import nme.ObjectHash;

/**
 * An default class for managing a NodeList. This class creates the NodeList and adds and removes
 * nodes to/from the list as the entities and the components in the game change.
 *
 * It uses the basic entity matching pattern of an entity system - entities are added to the list if
 * they contain components matching all the public properties of the node class.
 */
class ComponentMatchingFamily<TNode:Node<TNode>> implements IFamily<TNode>
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

        var xml:Xml = Xml.parse(Reflect.field(nodeClass, "__rtti")).firstElement();
        var infos = new haxe.rtti.XmlParser().processElement(xml);
        switch (infos)
        {
            case TClassdecl(classDef):
                for (f in classDef.fields)
                {
                    if (f.name != "entity" && f.name != "previous" && f.name != "next")
                    {
                        switch (f.type)
                        {
                            case CClass(name, params):
                                if (params.length > 0)
                                    throw new Error("Type parameters for node field types are not yet supported yet");
                                var newClass:Class<Dynamic> = Type.resolveClass(name);
                                components.set(newClass, f.name);
                            default:
                                throw new Error("Invalid node class with field type other than class: " + f.name);
                        }
                    }
                }
            default:
                // this can't happen, because nodeClass is always subclass of Node
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
        for (node in nodeList)
            entities.remove(node.entity);
        nodeList.removeAll();
    }
}
