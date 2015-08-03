package ash.core;

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * This macro iterates over fields declared in Node subclasses and creates
 * a static function that returns a mapping from component classes to property names
 * for use in ComponentMatchingFamily class.
 **/
class NodeMacro
{
    macro public static function build():Array<Field>
    {
        var fields = Context.getBuildFields();
        var pos = Context.currentPos();

        Context.getLocalClass().get().meta.add(":keep", [], pos);

        var populateExprs = [];
        for (field in fields)
        {
            switch (field.kind)
            {
                case FVar(type, _):
                    switch (type)
                    {
                        case TPath(path):
                            // TODO: add support for type parameters
                            if (path.params.length > 0)
                                throw new Error("Type parameters for node field types are not yet supported yet", field.pos);
                            populateExprs.push(macro _components.set($i{path.name}, $v{field.name}));
                        default:
                            throw new Error("Invalid node class with field type other than class: " + field.name, field.pos);
                    }
                default:
                    // functions and properties are ignored and intended to be used only in custom Node APIs
                    // only variables are set by component system
            }
        }

        if (populateExprs.length == 0)
            throw new Error("Node subclass doesnt declare any component variables", pos);


        var componentsType = macro : ash.ClassMap<Class<Dynamic>, String>;

        fields.push({
            name: "_components",
            kind: FVar(componentsType),
            access: [APrivate, AStatic],
            pos: pos
        });

        fields.push({
            name: "_getComponents",
            kind: FFun({
                args: [],
                params: [],
                ret: componentsType,
                expr: macro
                {
                    if (_components == null)
                    {
                        _components = new ash.ClassMap<Class<Dynamic>, String>();
                        $b{populateExprs};
                    }
                    return _components;
                }
            }),
            access: [APublic, AStatic],
            pos: pos
        });

        return fields;
    }
}
