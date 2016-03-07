
module craft.types.null_;

import craft.types;
import craft.types.object;

/+ - Null Type - +/

__gshared CraftType NULL_TYPE;

shared static this()
{
    // class Null : Object
    CraftType *t = &NULL_TYPE;
    NULL_TYPE = CraftType("Null", &OBJECT_TYPE);

    /+ - Instance Methods - +/

    t.instanceMethods["$!"] = native(0, &null_instance_not);
    t.instanceMethods["&&"] = native(1, &null_instance_and);
    t.instanceMethods["&"]  = native(1, &null_instance_and);
    t.instanceMethods["||"] = native(1, &null_instance_or);
    t.instanceMethods["|"]  = native(1, &null_instance_or);
    t.instanceMethods["^"]  = native(1, &null_instance_xor);

    t.instanceMethods["hash_id"] = native(0, &null_instance_hashId);
    t.instanceMethods["string"]  = native(0, &null_instance_string);
}

private
{
    CraftObject *null_instance_and(CraftObject *instance, Arguments)
    {
        return instance;
    }

    CraftObject *null_instance_hashId(CraftObject *, Arguments)
    {
        return createInteger(0);
    }

    CraftObject *null_instance_not(CraftObject *instance, Arguments)
    {
        return &TRUE;
    }

    CraftObject *null_instance_or(CraftObject *instance, Arguments arguments)
    {
        return arguments[0];
    }

    CraftObject *null_instance_string(CraftObject *, Arguments)
    {
        return createString("null");
    }

    CraftObject *null_instance_xor(CraftObject *instance, Arguments arguments)
    {
        return arguments[0].coerce!bool ? &TRUE : &FALSE;
    }
}

/+ - Null Instance - +/

__gshared CraftObject NULL;

shared static this()
{
    NULL = (&NULL_TYPE).allocInstance;
}

@property
bool isNull(CraftObject *instance)
{
    return instance is &NULL;
}
