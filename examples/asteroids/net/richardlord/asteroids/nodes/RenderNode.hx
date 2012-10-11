package net.richardlord.asteroids.nodes;

import net.richardlord.ash.core.Node;
import net.richardlord.asteroids.components.Display;
import net.richardlord.asteroids.components.Position;

class RenderNode extends Node<RenderNode>
{
    public var position:Position;
    public var display:Display;
}
