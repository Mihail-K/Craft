
module craft.types.object;

import craft.types;

import std.string;
import std.variant;

/+ - Object Class - +/

__gshared CraftObject OBJECT_CLASS;

shared static this()
{
    OBJECT_CLASS.class_ = &CLASS_CLASS; // Object.class => Class
    OBJECT_CLASS.super_ = null;         // Object.super => null

    OBJECT_CLASS.data["name"] = "Object";
}

/+ - Object Instance - +/

CraftObject *createObject()
{
    auto obj = new CraftObject(&OBJECT_CLASS);

    obj.methods["$!"] = native(0, &object_not);
    obj.methods["&&"] = native(1, &object_and);
    obj.methods["&"]  = native(1, &object_and);
    obj.methods["||"] = native(1, &object_or);
    obj.methods["|"]  = native(1, &object_or);
    obj.methods["=="] = native(1, &object_equals);
    obj.methods["!="] = native(1, &object_notEquals);
    obj.methods["is"] = native(1, &object_equals);

    obj.methods["dispatch"] = native(1, &object_dispatch, true);
    obj.methods["hash_id"]  = native(0, &object_hashId);
    obj.methods["invoke"]   = native(1, &object_invoke, true);
    obj.methods["string"]   = native(0, &object_string);

    return obj;
}

private
{
    CraftObject *object_and(CraftObject *instance, Arguments arguments)
    {
        return arguments[0];
    }

    CraftObject *object_dispatch(CraftObject *instance, Arguments arguments)
    {
        assert(0, "Method not found."); // TODO
    }

    CraftObject *object_equals(CraftObject *instance, Arguments arguments)
    {
        return createBoolean(instance is arguments[0]);
    }

    CraftObject *object_hashId(CraftObject *instance, Arguments)
    {
        return createInteger(instance.hashOf);
    }

    CraftObject *object_invoke(CraftObject *instance, Arguments arguments)
    {
        auto name = arguments[0];
        auto args = arguments[1 .. $];

        return instance.invoke(name.as!string, Arguments(args));
    }

    CraftObject *object_not(CraftObject *instance, Arguments)
    {
        return &BOOLEAN_FALSE;
    }

    CraftObject *object_notEquals(CraftObject *instance, Arguments arguments)
    {
        return instance.invoke("==", arguments).opNegate;
    }

    CraftObject *object_or(CraftObject *instance, Arguments arguments)
    {
        return instance;
    }

    CraftObject *object_string(CraftObject *instance, Arguments)
    {
        return createString("Object(#0x%X)".format(instance.hashOf));
    }
}
