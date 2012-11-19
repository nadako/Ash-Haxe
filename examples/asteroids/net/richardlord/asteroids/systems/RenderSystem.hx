package net.richardlord.asteroids.systems;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import net.richardlord.ash.core.Game;
import net.richardlord.ash.core.NodeList;
import net.richardlord.ash.core.System;
import net.richardlord.asteroids.components.Display;
import net.richardlord.asteroids.components.Position;
import net.richardlord.asteroids.nodes.RenderNode;

class RenderSystem extends System
{
    public var container:DisplayObjectContainer;

    private var nodes:NodeList<RenderNode>;

    public function new(container:DisplayObjectContainer)
    {
        super();
        this.container = container;
    }

    override public function addToGame(game:Game):Void
    {
        nodes = game.getNodeList(RenderNode);
        for (node in nodes)
            addToDisplay(node);
        nodes.nodeAdded.add(addToDisplay);
        nodes.nodeRemoved.add(removeFromDisplay);
    }

    private function addToDisplay(node:RenderNode):Void
    {
        container.addChild(node.displayObject);
    }

    private function removeFromDisplay(node:RenderNode):Void
    {
        container.removeChild(node.displayObject);
    }

    override public function update(time:Float):Void
    {
        for (node in nodes)
        {
            var displayObject:DisplayObject = node.displayObject;
            var position:Position = node.position;

            displayObject.x = position.position.x;
            displayObject.y = position.position.y;
            displayObject.rotation = position.rotation * 180 / Math.PI;
        }
    }

    override public function removeFromGame(game:Game):Void
    {
        nodes = null;
    }
}
