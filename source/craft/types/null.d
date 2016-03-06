
module craft.types.null_;

import craft.types;

/+ - Null Class - +/

__gshared CraftObject NULL_CLASS;

shared static this()
{
    with(NULL_CLASS)
    {
        class_ = &CLASS_CLASS;  // Null.class => Class
        super_ = &OBJECT_CLASS; // Null.super => Object

        data["name"] = "Null";
    }
}

/+ - Null Instance - +/

__gshared CraftObject NULL;

shared static this()
{
    NULL = CraftObject(&NULL_CLASS, createObject);

    with(NULL)
    {
        methods["$!"] = native(0, &null_not);
        methods["&&"] = native(1, &null_and);
        methods["&"]  = native(1, &null_and);
        methods["||"] = native(1, &null_or);
        methods["|"]  = native(1, &null_or);
        methods["^"]  = native(1, &null_xor);

        methods["hash_id"] = native(0, &null_hashId);
        methods["string"]  = native(0, &null_string);
    }
}

private
{
    CraftObject *null_and(CraftObject *instance, Arguments)
    {
        return instance;
    }

    CraftObject *null_hashId(CraftObject *, Arguments)
    {
        return createInteger(0);
    }

    CraftObject *null_not(CraftObject *instance, Arguments)
    {
        return &BOOLEAN_TRUE;
    }

    CraftObject *null_or(CraftObject *instance, Arguments arguments)
    {
        return arguments[0];
    }

    CraftObject *null_string(CraftObject *, Arguments)
    {
        return createString("null");
    }

    CraftObject *null_xor(CraftObject *instance, Arguments arguments)
    {
        return arguments[0].coerce!bool ? &BOOLEAN_TRUE : &BOOLEAN_FALSE;
    }
}
