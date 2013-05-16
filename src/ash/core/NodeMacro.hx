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
        var nodeClass:ClassType = Context.getLocalClass().get();
        var fields:Array<Field> = Context.getBuildFields();

        var componentLinkFields:Array<Field> = [];
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
                            componentLinkFields.push(field);
                        default:
                            throw new Error("Invalid node class with field type other than class: " + field.name, field.pos);
                    }
                default:
                    // functions and properties are ignored and intended to be used only in custom Node APIs
                    // only variables are set by component system
            }
        }

        if (componentLinkFields.length == 0)
            throw new Error("Node subclass doesnt declare any component variables", nodeClass.pos);

        // Type path for ObjectMap<Class<Dynamic>, String>
        var componentsTypePath:TypePath =
        {
            pack: ["ash"],
            name: "ClassMap",
            params: [
                TPType(TPath({
                    pack: [],
                    name: "Class",
                    params: [
                        TPType(TPath({
                            pack: [],
                            name: "Dynamic",
                            params: []
                        }))
                    ]
                })),
                TPType(TPath({
                    pack: [],
                    name: "String",
                    params: []
                }))
            ]
        }
        var componentsType:ComplexType = TPath(componentsTypePath);

        fields.push({
            name: "_components",
            kind: FVar(componentsType),
            access: [APrivate, AStatic],
            pos: nodeClass.pos
        });

        var componentsRef:ExprDef = EConst(CIdent("_components"));

        var populateExprs:Array<Expr> = [
            {
                expr: EBinop(
                    OpAssign,
                    {expr: componentsRef, pos: nodeClass.pos},
                    {expr: ENew(componentsTypePath, []), pos: nodeClass.pos}
                ),
                pos: nodeClass.pos
            }
        ];

        for (field in componentLinkFields)
        {
            switch (field.kind)
            {
                case FVar(type, _):
                    switch (type)
                    {
                        case TPath(path):
                            var componentClassExpr = {
                                expr: EConst(CIdent(path.name)),
                                pos: field.pos
                            };
                            var componentFieldNameExpr = {
                                expr: EConst(CString(field.name)),
                                pos: field.pos
                            };
                            populateExprs.push({
                                expr: ECall(
                                    {
                                        expr: EField({expr: componentsRef, pos: field.pos}, "set"),
                                        pos: field.pos
                                    },
                                    [componentClassExpr, componentFieldNameExpr]
                                ),
                                pos: field.pos
                            });
                        default:
                    }
                default:
            }
        }


        var getComponentsExprs:Array<Expr> = [
            {
                expr: EIf(
                    {
                        expr: EBinop(
                            OpEq,
                            {expr: componentsRef, pos: nodeClass.pos},
                            {expr: EConst(CIdent("null")), pos: nodeClass.pos}
                        ),
                        pos: nodeClass.pos
                    },
                    {
                        expr: EBlock(populateExprs),
                        pos: nodeClass.pos
                    },
                    null
                ),
                pos: nodeClass.pos
            },
            {
                expr: EReturn({expr: componentsRef, pos: nodeClass.pos}),
                pos: nodeClass.pos
            }
        ];

        fields.push({
            name: "_getComponents",
            kind: FFun({
                args: [],
                params: [],
                ret: componentsType,
                expr: {expr: EBlock(getComponentsExprs), pos: nodeClass.pos}
            }),
            access: [APublic, AStatic, AInline],
            pos: nodeClass.pos
        });

        return fields;
    }
}
