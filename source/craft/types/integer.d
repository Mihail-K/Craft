
module craft.types.integer;

import craft.types;
import craft.types.boolean;
import craft.types.object;

import std.conv;
import std.math;
import std.meta;

/+ - Integer Type - +/

static CraftType INTEGER_TYPE;

alias UnaryOps   = Alias!("+", "-", "!", "~");
alias BinaryOps  = Alias!("+", "-", "*", "/", "%", "<<", ">>", "&", "|", "^");
alias CompareOps = Alias!("==", "!=", "<", "<=", ">", ">=");

shared static this()
{
    // class Integer : Object
    CraftType *t = &INTEGER_TYPE;
    INTEGER_TYPE = CraftType("Integer", &OBJECT_TYPE);

    /+ - Instance Methods - +/

    foreach(op; UnaryOps)
    {
        t.instanceMethods["$" ~ op] = native(0, &integer_instance_opUnary!(op));
    }

    foreach(op; BinaryOps)
    {
        t.instanceMethods[op] = native(1, &integer_instance_opBinary!(op));
    }

    foreach(op; CompareOps)
    {
        t.instanceMethods[op] = native(1, &integer_instance_opCompare!(op));
    }

    t.instanceMethods["abs"]    = native(0, &integer_instance_abs);
    t.instanceMethods["max"]    = native(1, &integer_instance_max);
    t.instanceMethods["min"]    = native(1, &integer_instance_min);
    t.instanceMethods["sqrt"]   = native(0, &integer_instance_sqrt);
    t.instanceMethods["string"] = native(0, &integer_instance_string);
}

private
{
    CraftObject *integer_instance_abs(CraftObject *instance, Arguments)
    {
        long value = instance.as!long;
        long abs   = value.abs;

        return abs == value ? instance : abs.createInteger;
    }

    CraftObject *integer_instance_max(CraftObject *instance, Arguments arguments)
    {
        return instance.invoke(">", arguments).asBool ? instance : arguments[0];
    }

    CraftObject *integer_instance_min(CraftObject *instance, Arguments arguments)
    {
        return instance.invoke("<", arguments).asBool ? instance : arguments[0];
    }

    CraftObject *integer_instance_opUnary(string op : "+")(CraftObject *instance, Arguments)
    {
        return instance;
    }

    CraftObject *integer_instance_opUnary(string op : "!")(CraftObject *instance, Arguments)
    {
        return createBoolean(cast(bool) instance.as!long == 0);
    }

    CraftObject *integer_instance_opUnary(string op)(CraftObject *instance, Arguments)
    {
        long value = instance.as!long;

        return createInteger(mixin(op ~ "value"));
    }

    CraftObject *integer_instance_opBinary(string op)(CraftObject *instance, Arguments arguments)
    {
        long left  = instance.as!long;
        long right = arguments[0].as!long;

        return createInteger(mixin("left " ~ op ~ " right"));
    }

    CraftObject *integer_instance_opCompare(string op)(CraftObject *instance, Arguments arguments)
    {
        long left  = instance.as!long;
        long right = arguments[0].as!long;

        return createBoolean(mixin("left " ~ op ~ " right"));
    }

    CraftObject *integer_instance_sqrt(CraftObject *instance, Arguments)
    {
        // TODO : This should return a floating point value.
        return instance.as!long.to!double.sqrt.to!long.createInteger;
    }

    CraftObject *integer_instance_string(CraftObject *instance, Arguments)
    {
        return instance.as!long.to!string.createString;
    }
}

/+ - Integer Instance - +/

CraftObject *createInteger(long value)
{
    auto instance = (&INTEGER_TYPE).createInstance;

    instance.data["raw"] = value;

    return instance;
}

@property
T as(T)(CraftObject *instance) if(is(T == long))
{
    assert(instance.isChildType(&INTEGER_TYPE));

    return instance.getData("raw").get!long;
}

@property
T coerce(T)(CraftObject *instance) if(is(T == long))
{
    return instance.as!long; // TODO
}
