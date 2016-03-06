
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

    obj.methods["dispatch"] = native(1, &object_dispatch, true);
    obj.methods["hash_id"]  = native(0, &object_hashId);
    obj.methods["invoke"]   = native(1, &object_invoke, true);
    obj.methods["string"]   = native(0, &object_string);

    return obj;
}

private
{
    CraftObject *object_dispatch(CraftObject *instance, Arguments arguments)
    {
        assert(0, "Method not found."); // TODO
    }

    CraftObject *object_hashId(CraftObject *instance, Arguments)
    {
        return createInteger(instance.hashOf);
    }

    CraftObject *object_invoke(CraftObject *instance, Arguments arguments)
    {
        auto name = arguments[0];
        auto args = arguments[1 .. $];

        return instance.invoke(name.toNativeString, Arguments(args));
    }

    CraftObject *object_string(CraftObject *instance, Arguments)
    {
        return createString("Object(#0x%X)".format(instance.hashOf));
    }
}
