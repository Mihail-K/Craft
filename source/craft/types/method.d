
module craft.types.method;

import craft.types;

enum Kind : uint
{
    NATIVE,
    CRAFT
}

struct Arguments
{
    CraftObject *[] arguments;

    this(CraftObject *[] arguments...)
    {
        this.arguments = arguments.dup;
    }

    size_t length() inout nothrow
    {
        return arguments.length;
    }

    alias opDollar = length;

    auto opIndex(size_t index)
    {
        return arguments[index];
    }

    auto opSlice(size_t start, size_t stop)
    {
        return arguments[start .. stop];
    }
}

struct CraftMethod
{
    uint  arity;
    Kind  kind;
    void *method;
    bool  varargs;

    this(uint arity, Kind kind, void *method, bool varargs = false)
    {
        this.arity   = arity;
        this.kind    = kind;
        this.method  = method;
        this.varargs = varargs;
    }

    CraftObject *invoke(CraftObject *instance, Arguments arguments)
    {
        assert(instance, "Invoking instance is null.");

        if(varargs)
        {
            assert(arguments.length >= arity, "Argument count mismatch.");
        }
        else
        {
            assert(arguments.length == arity, "Argument count mismatch.");
        }

        if(kind == Kind.NATIVE)
        {
            auto callable = cast(CraftObject *function(CraftObject *, Arguments)) method;
            assert(callable, "Native callable reference is null.");

            return callable(instance, arguments);
        }
        else
        {
            assert(0, "Craft Kind."); // TODO
        }
    }
}

CraftMethod native(uint arity, void *method, bool varargs = false)
{
    return CraftMethod(arity, Kind.NATIVE, method, varargs);
}
