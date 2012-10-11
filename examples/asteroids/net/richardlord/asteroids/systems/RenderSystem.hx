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
        this.container = container;
    }

    override public function addToGame(game:Game):Void
    {
        nodes = game.getNodeList(RenderNode);
        var node:RenderNode = nodes.head;
        while (node != null)
        {
            addToDisplay(node);
            node = node.next;
        }
        nodes.nodeAdded.add(addToDisplay);
        nodes.nodeRemoved.add(removeFromDisplay);
    }

    private function addToDisplay(node:RenderNode):Void
    {
        container.addChild(node.display.displayObject);
    }

    private function removeFromDisplay(node:RenderNode):Void
    {
        container.removeChild(node.display.displayObject);
    }

    override public function update(time:Float):Void
    {
        var position:Position;
        var display:Display;
        var displayObject:DisplayObject;

        var node:RenderNode = nodes.head;
        while (node != null)
        {
            display = node.display;
            displayObject = display.displayObject;
            position = node.position;

            displayObject.x = position.position.x;
            displayObject.y = position.position.y;
            displayObject.rotation = position.rotation * 180 / Math.PI;

            node = node.next;
        }
    }

    override public function removeFromGame(game:Game):Void
    {
        nodes = null;
    }
}
