
module craft.types.string;

import craft.types;
import craft.types.object;

import std.variant;

/+ - String Class - +/

__gshared CraftType STRING_TYPE;

shared static this()
{
    // class String : Object
    CraftType *t = &STRING_TYPE;
    STRING_TYPE = CraftType("String", &OBJECT_TYPE);

    /+ - Instance Methods - +/

    t.instanceMethods["=="] = native(1, &string_instance_equal);

    t.instanceMethods["length"] = native(0, &string_instance_length);
    t.instanceMethods["string"] = native(0, &string_instance_string);
}

private
{
    CraftObject *string_instance_equal(CraftObject *instance, Arguments arguments)
    {
        string left  = instance.as!string;
        string right = arguments[0].as!string;

        return createBoolean(left == right);
    }

    CraftObject *string_instance_length(CraftObject *instance, Arguments)
    {
        return instance.as!string.length.createInteger;
    }

    CraftObject *string_instance_string(CraftObject *instance, Arguments)
    {
        return instance;
    }
}

/+ - String Instance - +/

CraftObject *createString(string value)
{
    auto instance = (&STRING_TYPE).createInstance;

    instance.data["raw"] = value;

    return instance;
}

@property
T as(T)(CraftObject *instance) if(is(T == string))
{
    assert(instance.isChildType(&STRING_TYPE));

    return instance.getData("raw").get!string;
}

@property
T coerce(T)(CraftObject *instance) if(is(T == string))
{
    return instance.as!string; // TODO
}
