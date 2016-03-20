
module craft.types.string;

import craft.types;
import craft.types.object;

import std.conv;
import std.regex;
import std.variant;

/+ - String Class - +/

__gshared CraftType STRING_TYPE;

shared static this()
{
    // class String : Object
    CraftType *t = &STRING_TYPE;
    STRING_TYPE = CraftType("String", &OBJECT_TYPE);

    /+ - Instance Methods - +/

    t.instanceMethods["~"]  = native(1, &string_instance_concat);
    t.instanceMethods["=="] = native(1, &string_instance_eq);

    t.instanceMethods["inject"] = native(0, &string_instance_inject, true);
    t.instanceMethods["length"] = native(0, &string_instance_length);
    t.instanceMethods["string"] = native(0, &string_instance_string);
}

private
{
    CraftObject *string_instance_concat(CraftObject *instance, Arguments arguments)
    {
        string left  = instance.asString;
        string right = arguments[0].asString;

        return createString(left ~ right);
    }

    CraftObject *string_instance_eq(CraftObject *instance, Arguments arguments)
    {
        string left  = instance.asString;
        string right = arguments[0].asString;

        return createBoolean(left == right);
    }

    CraftObject *string_instance_inject(CraftObject *instance, Arguments arguments)
    {
        string value = instance.asString;
        auto pattern = ctRegex!r"#(!|\d+|\(\d+\))";

        string replacer(Captures!string c)
        {
            if(c[1] == "!")
            {
                return "#";
            }
            else
            {
                // Trim parentheses if they're present.
                auto param  = c[1][0] == '(' ? c[1][1 .. $ - 1] : c[1];
                uint index  = param.to!uint;
                auto output = index < arguments.length ? arguments[index] : &NULL;

                return output.coerceString;
            }
        }

        return value.replaceAll!(replacer)(pattern).createString;
    }

    CraftObject *string_instance_length(CraftObject *instance, Arguments)
    {
        return instance.asString.length.createInteger;
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
string asString(CraftObject *instance)
{
    assert(instance.isExactType(&STRING_TYPE));

    return instance.getData("raw").get!string;
}

@property
string coerceString(CraftObject *instance)
{
    return instance.invoke("string").asString;
}
