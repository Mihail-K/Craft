
module craft.types.boolean;

import craft.types;

import std.variant;

/+ - Boolean Class - +/

__gshared static CraftObject BOOLEAN_CLASS;

shared static this()
{
    with(BOOLEAN_CLASS)
    {
        class_ = &CLASS_CLASS;  // Boolean.class => Class
        super_ = &OBJECT_CLASS; // Boolean.super => Object

        data["name"] = "Boolean";
    }
}

/+ - Boolean Instance - +/

__gshared static CraftObject BOOLEAN_TRUE;
__gshared static CraftObject BOOLEAN_FALSE;

CraftObject *createBoolean(bool value)
{
    return value ? &BOOLEAN_TRUE : &BOOLEAN_FALSE;
}

@property
bool toNativeBoolean(CraftObject *instance)
{
    assert(instance.isChildType(&BOOLEAN_CLASS));

    return instance.getData("raw").get!bool;
}

shared static this()
{
    BOOLEAN_TRUE  = initBoolean(true);
    BOOLEAN_FALSE = initBoolean(false);
}

private
{
    CraftObject initBoolean(bool value)
    {
        auto obj = CraftObject(&BOOLEAN_CLASS, createObject);

        obj.data["raw"] = Variant(value);

        obj.methods["$!"] = native(0, &boolean_not);

        obj.methods["string"] = native(0, &boolean_string);

        return obj;
    }

    CraftObject *boolean_not(CraftObject *instance, Arguments)
    {
        return instance == &BOOLEAN_TRUE ? &BOOLEAN_FALSE : &BOOLEAN_TRUE;
    }

    CraftObject *boolean_string(CraftObject *instance, Arguments)
    {
        if(instance == &BOOLEAN_TRUE)
        {
            return createString("true");
        }
        else if(instance == &BOOLEAN_FALSE)
        {
            return createString("false");
        }
        else
        {
            assert(0);
        }
    }
}
