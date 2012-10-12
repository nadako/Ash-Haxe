package net.richardlord.ash.core;

import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * This macro iterates over fields declared in Node subclasses and creates
 * a static function that returns a mapping from component classes to property names
 * for use in ComponentMatchingFamily class.
 **/
class NodeMacro
{
    static public function asTypePath(s:String, ?params):TypePath {
        var parts = s.split('.');
        var name = parts.pop(),
        sub = null;
        if (parts.length > 0 && parts[parts.length - 1].charCodeAt(0) < 0x5B) {
            sub = name;
            name = parts.pop();
        }
        return {
        name: name,
        pack: parts,
        params: params == null ? [] : params,
        sub: sub
        }
    }
    static public inline function asComplexType(s:String, ?params) {
        return TPath(asTypePath(s, params));
    }

    @:macro public static function build():Array<Field>
    {
        var fields:Array<Field> = Context.getBuildFields();
        var cls = Context.getLocalClass().get();

        var componentsTypePath = asTypePath("nme.ObjectHash", [
        TPType(asComplexType("Class", [TPType(asComplexType("Dynamic"))])),
        TPType(asComplexType("String"))
        ]);
        var componentsType = TPath(componentsTypePath);
        var mapRef:Expr = { pos: cls.pos, expr: EConst(CIdent("_components")) };

        var exprs:Array<Expr> = [];
        var populateExprs:Array<Expr> = [
            {
                expr: EBinop(
                    OpAssign,
                    mapRef,
                    {expr: ENew(componentsTypePath, []), pos: cls.pos}
                ),
                pos: cls.pos
            }
        ];

        var setter:Expr = { pos: cls.pos, expr: EField(mapRef, "set") };

        for (f in fields)
        {
            if (f.name != "entity" && f.name != "previous" && f.name != "next")
            {
                switch (f.kind)
                {
                    case FVar(type, expr):
                        switch (type)
                        {
                            case TPath(path):
                                // TODO: add support for type parameters
                                if (path.params.length > 0)
                                    throw new Error("Type parameters for node field types are not yet supported yet", f.pos);

                                var fieldTypeExpr = {
                                    expr: EConst(CIdent(path.name)),
                                    pos: f.pos
                                };
                                var fieldNameExpr = {expr: EConst(CString(f.name)), pos: f.pos};

                                populateExprs.push({ pos: f.pos, expr: ECall(setter, [fieldTypeExpr, fieldNameExpr]) });
                            default:
                                throw new Error("Invalid node class with field type other than class: " + f.name, f.pos);
                        }
                    default:
                        // TODO: add support for functions and properties
                        throw new Error("Node classes should only have public variables, no functions or properties. This will be fixed soon.", f.pos);
                }
            }
        }

        exprs.push({pos: cls.pos, expr: EIf(
            {expr: EBinop(OpEq, mapRef, {expr: EConst(CIdent("null")), pos: cls.pos}), pos: cls.pos},
            {expr: EBlock(populateExprs), pos: cls.pos},
            null
        )});

        exprs.push({pos: cls.pos, expr: EReturn(mapRef)});

        fields.push({
            name: "_components",
            kind: FVar(componentsType),
            access: [APrivate, AStatic],
            pos: cls.pos
        });

        fields.push({
            name: "_getComponents",
            kind: FFun({
                args: [],
                params: [],
                ret: componentsType,
                expr: {expr: EBlock(exprs), pos: cls.pos}
            }),
            access: [APublic, AStatic, AInline],
            pos: cls.pos
        });

        return fields;
    }
}
