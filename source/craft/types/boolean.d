
module craft.types.boolean;

import craft.types;

import std.variant;

/+ - Boolean Class - +/

__gshared CraftObject TRUE_CLASS;
__gshared CraftObject FALSE_CLASS;

shared static this()
{
    with(TRUE_CLASS)
    {
        class_ = &CLASS_CLASS;  // True.class => Class
        super_ = &OBJECT_CLASS; // True.super => Object

        data["name"] = "True";
    }

    with(FALSE_CLASS)
    {
        class_ = &CLASS_CLASS;  // False.class => Class
        super_ = &OBJECT_CLASS; // False.super => Object

        data["name"] = "False";
    }
}

/+ - Boolean Instance - +/

__gshared CraftObject BOOLEAN_TRUE;
__gshared CraftObject BOOLEAN_FALSE;

shared static this()
{
    BOOLEAN_TRUE = CraftObject(&TRUE_CLASS, createObject);

    with(BOOLEAN_TRUE)
    {
        methods["$!"] = native(0, &true_not);
        methods["^"]  = native(1, &true_xor);

        methods["string"] = native(0, &true_string);
    }
}

shared static this()
{
    BOOLEAN_FALSE = CraftObject(&FALSE_CLASS, createObject);

    with(BOOLEAN_FALSE)
    {
        methods["$!"] = native(0, &false_not);
        methods["^"]  = native(1, &false_xor);

        methods["string"] = native(0, &false_string);
    }
}

CraftObject *createBoolean(bool value)
{
    return value ? &BOOLEAN_TRUE : &BOOLEAN_FALSE;
}

private
{
    CraftObject *true_not(CraftObject *instance, Arguments)
    {
        return &BOOLEAN_FALSE;
    }

    CraftObject *true_string(CraftObject *instance, Arguments)
    {
        return createString("true");
    }

    CraftObject *true_xor(CraftObject *instance, Arguments arguments)
    {
        return arguments[0].coerce!bool ? &BOOLEAN_FALSE : &BOOLEAN_TRUE;
    }
}

private
{
    CraftObject *false_not(CraftObject *instance, Arguments)
    {
        return &BOOLEAN_TRUE;
    }

    CraftObject *false_string(CraftObject *instance, Arguments)
    {
        return createString("false");
    }

    CraftObject *false_xor(CraftObject *instance, Arguments arguments)
    {
        return arguments[0].coerce!bool ? &BOOLEAN_TRUE : &BOOLEAN_FALSE;
    }
}

@property
T as(T)(CraftObject *instance) if(is(T == bool))
{
    if(instance.isExactType(&TRUE_CLASS))
    {
        return true;
    }
    else if(instance.isExactType(&FALSE_CLASS))
    {
        return false;
    }
    else
    {
        assert(0);
    }
}

@property
T coerce(T)(CraftObject *instance) if(is(T == bool))
{
    return !instance.isExactType(&FALSE_CLASS);
}
