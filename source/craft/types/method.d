
module craft.types.method;

import craft.types;

import std.algorithm;
import std.array;
import std.conv;
import std.meta;
import std.range;
import std.string;
import std.traits;

abstract class CraftMethod : CraftObject
{
private:
    uint _arity;
    bool _varargs;

public:
    this(uint arity, bool varargs = false)
    {
        super(null);

        _arity   = arity;
        _varargs = varargs;
    }

    @property
    uint arity()
    {
        return _arity;
    }

    abstract CraftObject call(CraftObject instance, Arguments args);

    @property
    bool varargs()
    {
        return _varargs;
    }
}

final class NativeMethod : CraftMethod
{
private:
    CraftObject function(CraftObject, Arguments) _method;

public:
    this(uint arity, CraftObject function(CraftObject, Arguments) method)
    {
        super(arity, false);

        _method = method;
    }

    this(uint arity, bool varargs, CraftObject function(CraftObject, Arguments) method)
    {
        super(arity, varargs);

        _method = method;
    }

    override CraftObject call(CraftObject instance, Arguments arguments)
    {
        arguments.ensure(arity, varargs);

        return _method(instance, arguments);
    }
}
