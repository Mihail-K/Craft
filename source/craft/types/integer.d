
module craft.types.integer;

import craft.types;

import std.conv;
import std.meta;
import std.variant;

/+ - Integer Class - +/

static CraftObject INTEGER_CLASS;

shared static this()
{
    with(INTEGER_CLASS)
    {
        class_ = &CLASS_CLASS;  // Integer.class => Class
        super_ = &OBJECT_CLASS; // Integer.super => Object

        data["name"] = Variant("Integer");
    }
}

/+ - Integer Instance - +/

alias UnaryOps   = Alias!("+", "-", "!", "~");
alias BinaryOps  = Alias!("+", "-", "*", "/", "%", "<<", ">>", "&", "|", "^");
alias CompareOps = Alias!("==", "!=", "<", "<=", ">", ">=");

CraftObject *createInteger(long value)
{
    auto obj = new CraftObject(&INTEGER_CLASS, createObject);

    obj.data["raw"] = Variant(value);

    foreach(op; UnaryOps)
    {
        obj.methods["$" ~ op] = native(0, &integer_opUnary!(op));
    }

    foreach(op; BinaryOps)
    {
        obj.methods[op] = native(1, &integer_opBinary!(op));
    }

    foreach(op; CompareOps)
    {
        obj.methods[op] = native(1, &integer_opCompare!(op));
    }

    obj.methods["string"] = native(0, &integer_string);

    return obj;
}

@property
T as(T)(CraftObject *instance) if(is(T == long))
{
    assert(instance.isChildType(&INTEGER_CLASS));

    return instance.getData("raw").get!long;
}

@property
T coerce(T)(CraftObject *instance) if(is(T == long))
{
    return instance.as!long; // TODO
}

private
{
    CraftObject *integer_opUnary(string op : "+")(CraftObject *instance, Arguments)
    {
        return instance;
    }

    CraftObject *integer_opUnary(string op : "!")(CraftObject *instance, Arguments)
    {
        return createBoolean(cast(bool) instance.as!long == 0);
    }

    CraftObject *integer_opUnary(string op)(CraftObject *instance, Arguments)
    {
        long value = instance.as!long;

        return createInteger(mixin(op ~ "value"));
    }

    CraftObject *integer_opBinary(string op)(CraftObject *instance, Arguments arguments)
    {
        long left  = instance.as!long;
        long right = arguments[0].as!long;

        return createInteger(mixin("left " ~ op ~ " right"));
    }

    CraftObject *integer_opCompare(string op)(CraftObject *instance, Arguments arguments)
    {
        long left  = instance.as!long;
        long right = arguments[0].as!long;

        return createBoolean(mixin("left " ~ op ~ " right"));
    }

    CraftObject *integer_string(CraftObject *instance, Arguments)
    {
        return instance.as!long.to!string.createString;
    }
}
