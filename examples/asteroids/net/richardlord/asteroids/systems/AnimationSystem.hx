package net.richardlord.asteroids.systems;

import ash.tools.ListIteratingSystem;

import net.richardlord.asteroids.nodes.AnimationNode;

class AnimationSystem extends ListIteratingSystem<AnimationNode>
{
    public function new()
    {
        super(AnimationNode, updateNode);
    }

    private function updateNode(node:AnimationNode, time:Float):Void
    {
        node.animation.animation.animate(time);
    }
}
