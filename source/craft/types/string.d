
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

    obj.methods["length"] = native(0, &string_length);
    obj.methods["string"] = native(0, &string_string);

    return obj;
}

@property
string toNativeString(CraftObject *obj)
{
    assert(obj, "String reference is null.");
    assert(obj.class_ == &STRING_CLASS, "Object is not a string."); // TODO

    string result = obj.data["raw"].get!string;

    return result;
}

private
{
    CraftObject *string_length(CraftObject *instance, Arguments)
    {
        return instance.data["raw"].get!string.length.createInteger;
    }

    CraftObject *string_string(CraftObject *instance, Arguments)
    {
        return instance;
    }
}
