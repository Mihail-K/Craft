
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

alias UnaryOps  = Alias!("+", "-", /*"!",*/ "~");
alias BinaryOps = Alias!("+", "-", "*", "/", "%", "<<", ">>");

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

    obj.methods["string"] = native(0, &integer_string);

    return obj;
}

@property
long toNativeInteger(CraftObject *obj)
{
    assert(obj, "Integer reference is null.");
    assert(obj.class_ == &INTEGER_CLASS, "Object is not an integer."); // TODO

    return obj.data["raw"].get!long;
}

private
{
    CraftObject *integer_opUnary(string op : "+")(CraftObject *instance, Arguments)
    {
        return instance;
    }

    CraftObject *integer_opUnary(string op)(CraftObject *instance, Arguments)
    {
        long value = instance.toNativeInteger;

        return createInteger(mixin(op ~ "value"));
    }

    CraftObject *integer_opBinary(string op)(CraftObject *instance, Arguments arguments)
    {
        long left  = instance.toNativeInteger;
        long right = arguments[0].toNativeInteger;

        return createInteger(mixin("left " ~ op ~ " right"));
    }

    CraftObject *integer_string(CraftObject *instance, Arguments)
    {
        return instance.toNativeInteger.to!string.createString;
    }
}
