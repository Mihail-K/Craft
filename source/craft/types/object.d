
module craft.types.object;

import craft.types;

import std.string;
import std.variant;

/+ - Object Type - +/

__gshared CraftType OBJECT_TYPE;

shared static this()
{
    // class Object : <none>
    CraftType *t = &OBJECT_TYPE;
    OBJECT_TYPE = CraftType("Object");

    /+ - Instance Methods - +/

    t.instanceMethods["$!"] = native(0, &object_instance_not);
    t.instanceMethods["&&"] = native(1, &object_instance_and);
    t.instanceMethods["&"]  = native(1, &object_instance_and);
    t.instanceMethods["||"] = native(1, &object_instance_or);
    t.instanceMethods["|"]  = native(1, &object_instance_or);
    t.instanceMethods["=="] = native(1, &object_instance_eq);
    t.instanceMethods["!="] = native(1, &object_instance_ne);

    t.instanceMethods["class"]    = native(0, &object_instance_class);
    t.instanceMethods["dispatch"] = native(1, &object_instance_dispatch, true);
    t.instanceMethods["hash_id"]  = native(0, &object_instance_hashId);
    t.instanceMethods["invoke"]   = native(1, &object_instance_invoke, true);
    t.instanceMethods["string"]   = native(0, &object_instance_string);
}

private
{
    CraftObject *object_instance_and(CraftObject *instance, Arguments arguments)
    {
        return arguments[0];
    }

    CraftObject *object_instance_class(CraftObject *instance, Arguments)
    {
        return instance.class_;
    }

    CraftObject *object_instance_dispatch(CraftObject *instance, Arguments arguments)
    {
        assert(0, "Method not found."); // TODO
    }

    CraftObject *object_instance_eq(CraftObject *instance, Arguments arguments)
    {
        return createBoolean(instance is arguments[0]);
    }

    CraftObject *object_instance_hashId(CraftObject *instance, Arguments)
    {
        return createInteger(instance.hashOf);
    }

    CraftObject *object_instance_invoke(CraftObject *instance, Arguments arguments)
    {
        auto name = arguments[0];
        auto args = arguments[1 .. $];

        return instance.invoke(name.as!string, Arguments(args));
    }

    CraftObject *object_instance_not(CraftObject *instance, Arguments)
    {
        return &FALSE;
    }

    CraftObject *object_instance_ne(CraftObject *instance, Arguments arguments)
    {
        return instance.invoke("==", arguments).opNegate;
    }

    CraftObject *object_instance_or(CraftObject *instance, Arguments arguments)
    {
        return instance;
    }

    CraftObject *object_instance_string(CraftObject *instance, Arguments)
    {
        return createString("Object(#0x%X)".format(instance.hashOf));
    }
}

/+ - Object Instance - +/

CraftObject *createObject()
{
    return OBJECT_TYPE.createInstance;
}
