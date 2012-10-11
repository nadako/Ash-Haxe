package net.richardlord.asteroids.systems;

/**
 * @author richard
 */
class SystemPriorities
{
    public static inline var preUpdate:Int = 1;
    public static inline var update:Int = 2;
    public static inline var move:Int = 3;
    public static inline var resolveCollisions:Int = 4;
    public static inline var render:Int = 5;

}
