
module craft.types.string;

import craft.types;

import std.variant;

/+ - String Class - +/

__gshared CraftObject STRING_CLASS;

shared static this()
{
    with(STRING_CLASS)
    {
        class_ = &CLASS_CLASS;  // String.class => Class
        super_ = &OBJECT_CLASS; // String.super => Object

        data["name"] = "String";
    }
}

/+ - String Instance - +/

CraftObject *createString(string value)
{
    auto obj = new CraftObject(&STRING_CLASS, createObject);

    obj.data["raw"] = Variant(value);

    obj.methods["=="] = native(1, &string_equal);

    obj.methods["length"] = native(0, &string_length);
    obj.methods["string"] = native(0, &string_string);

    return obj;
}

@property
T as(T)(CraftObject *instance) if(is(T == string))
{
    assert(instance.isChildType(&STRING_CLASS));

    return instance.getData("raw").get!string;
}

@property
T coerce(T)(CraftObject *instance) if(is(T == string))
{
    return instance.as!string; // TODO
}

private
{
    CraftObject *string_equal(CraftObject *instance, Arguments arguments)
    {
        string left  = instance.as!string;
        string right = arguments[0].as!string;

        return createBoolean(left == right);
    }

    CraftObject *string_length(CraftObject *instance, Arguments)
    {
        return instance.as!string.length.createInteger;
    }

    CraftObject *string_string(CraftObject *instance, Arguments)
    {
        return instance;
    }
}
