package net.richardlord.asteroids.nodes;

import flash.display.DisplayObject;

import ash.core.Node;

import net.richardlord.asteroids.components.Display;
import net.richardlord.asteroids.components.Position;

/**
 * Node for rendering. Note that here it demonstrates how nodes work:
 *
 * component system treats all variables (both public and private) as links to required components
 * and sets their values on node initialization, while properties and functions are ignored completely
 * and can be used to make node API more useful
 **/
class RenderNode extends Node<RenderNode>
{
    public var position:Position;
    private var display:Display;

    public var displayObject(get_displayObject, never):DisplayObject;

    private inline function get_displayObject():DisplayObject
    {
        return display.displayObject;
    }
}
