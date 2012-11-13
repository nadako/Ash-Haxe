package net.richardlord.asteroids.systems;

import net.richardlord.ash.tools.ListIteratingSystem;
import net.richardlord.asteroids.EntityCreator;
import net.richardlord.asteroids.nodes.DeathThroesNode;

class DeathThroesSystem extends ListIteratingSystem<DeathThroesNode>
{
    private var creator:EntityCreator;

    public function new(creator:EntityCreator)
    {
        super(DeathThroesNode, updateNode);
        this.creator = creator;
    }

    private function updateNode(node:DeathThroesNode, time:Float):Void
    {
        node.death.countdown -= time;
        if (node.death.countdown <= 0)
        {
            creator.destroyEntity(node.entity);
        }
    }
}
