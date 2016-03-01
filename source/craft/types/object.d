
module craft.types.object;

import craft.types;

T as(T : CraftObject)(CraftObject obj)
{
    T result = cast(T) obj;
    assert(result !is null); // TODO

    return result;
}

class CraftObject
{
protected:
    CraftClass _class;

public:
    this()
    {
        _class = ObjectClass.value;
    }

    this(CraftClass class_)
    {
        _class = class_;
    }

    final CraftClass class_()
    {
        return _class;
    }

    final CraftObject invoke(string name, Arguments arguments = Arguments())
    {
        auto method = class_.method(name);

        if(method !is null)
        {
            return method.as!CraftMethod.call(this, arguments);
        }
        else
        {
            assert(0); // TODO
        }
    }

    final CraftObject opPlus()
    {
        return invoke("opPlus");
    }

    final CraftObject opMinus()
    {
        return invoke("opMinus");
    }

    final CraftObject opNegate()
    {
        return invoke("opNegate");
    }

    final CraftObject opComplement()
    {
        return invoke("opComplement");
    }

    final CraftObject opAdd(CraftObject other)
    {
        return invoke("opAdd", Arguments(other));
    }

    final CraftObject opSubtract(CraftObject other)
    {
        return invoke("opSubtract", Arguments(other));
    }

    final CraftObject opMultiply(CraftObject other)
    {
        return invoke("opMultiply", Arguments(other));
    }

    final CraftObject opDivide(CraftObject other)
    {
        return invoke("opDivide", Arguments(other));
    }

    final CraftObject opModulo(CraftObject other)
    {
        return invoke("opModulo", Arguments(other));
    }

    final CraftObject opIs(CraftObject other)
    {
        return CraftBoolean.create(this is other);
    }

    final CraftObject prod(string name)
    {
        assert(0); // TODO
    }
}

final class ObjectClass : CraftClass
{
private:
    static CraftClass CLASS;

    static this()
    {
        CLASS = new ObjectClass;

        CLASS.method("invoke", new NativeMethod(1, true, &objectInvoke));
        CLASS.method("prod",   new NativeMethod(1, &objectProd));
    }

    this()
    {
        super(ClassClass.value);
    }

public:
    @property
    static CraftClass value()
    {
        return CLASS;
    }
}

private
{
    CraftObject objectInvoke(CraftObject instance, Arguments arguments)
    {
        auto name = arguments[0].as!CraftString;
        auto args = Arguments(arguments[1 .. $]);

        return instance.invoke(name.value, args);
    }

    CraftObject objectProd(CraftObject instance, Arguments arguments)
    {
        auto name = arguments[0].as!CraftString;

        return instance.prod(name.value);
    }
}
