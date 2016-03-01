
module craft.types.integer;

import craft.types;

import std.string;

class CraftInteger : CraftObject
{
private:
    static CraftInteger ZERO;

    static this()
    {
        ZERO = new CraftInteger(0);
    }

    long _value;

    this(long value)
    {
        super(IntegerClass.value);

        _value = value;
    }

public:
    static CraftInteger create(long value)
    {
        return value ? new CraftInteger(value) : ZERO;
    }

    @property
    long value() inout nothrow
    {
        return _value;
    }

    override string toString()
    {
        return "Integer(%s)".format(value);
    }
}

final class IntegerClass : CraftClass
{
private:
    static IntegerClass CLASS;

    this()
    {
        super(ClassClass.value);
    }

    static void initialize()
    {
        CLASS = new IntegerClass;

        CLASS.method("opPlus",       new NativeMethod(0, &integerPlus));
        CLASS.method("opMinus",      new NativeMethod(0, &integerMinus));
        CLASS.method("opNegate",     new NativeMethod(0, &integerNegate));
        CLASS.method("opComplement", new NativeMethod(0, &integerComplement));

        CLASS.method("opAdd",      new NativeMethod(1, &integerAdd));
        CLASS.method("opSubtract", new NativeMethod(1, &integerSubtract));
        CLASS.method("opMultiply", new NativeMethod(1, &integerMultiply));
        CLASS.method("opDivide",   new NativeMethod(1, &integerDivide));
        CLASS.method("opModulo",   new NativeMethod(1, &integerModulo));

        CLASS.method("opEqual",    new NativeMethod(1, &integerEqual));
        CLASS.method("opNotEqual", new NativeMethod(1, &integerNotEqual));
    }

public:
    @property
    static CraftClass value()
    {
        if(CLASS is null)
        {
            initialize;
        }

        return CLASS;
    }
}

private
{
    /+ - Unary Operations - +/

    CraftObject integerPlus(CraftObject instance, Arguments arguments)
    {
        return instance;
    }

    CraftObject integerMinus(CraftObject instance, Arguments arguments)
    {
        return CraftInteger.create(-instance.as!CraftInteger.value);
    }

    CraftObject integerNegate(CraftObject instance, Arguments arguments)
    {
        return CraftBoolean.create(!instance.as!CraftInteger.value);
    }

    CraftObject integerComplement(CraftObject instance, Arguments arguments)
    {
        return CraftInteger.create(~instance.as!CraftInteger.value);
    }

    /+ - Addition Operations - +/

    CraftObject integerAdd(CraftObject instance, Arguments arguments)
    {
        auto left  = instance.as!CraftInteger;
        auto right = arguments[0].as!CraftInteger;

        return CraftInteger.create(left.value + right.value);
    }

    CraftObject integerSubtract(CraftObject instance, Arguments arguments)
    {
        auto left  = instance.as!CraftInteger;
        auto right = arguments[0].as!CraftInteger;

        return CraftInteger.create(left.value - right.value);
    }

    /+ - Multiplication Operations - +/

    CraftObject integerMultiply(CraftObject instance, Arguments arguments)
    {
        auto left  = instance.as!CraftInteger;
        auto right = arguments[0].as!CraftInteger;

        return CraftInteger.create(left.value * right.value);
    }

    CraftObject integerDivide(CraftObject instance, Arguments arguments)
    {
        auto left  = instance.as!CraftInteger;
        auto right = arguments[0].as!CraftInteger;

        return CraftInteger.create(left.value / right.value);
    }

    CraftObject integerModulo(CraftObject instance, Arguments arguments)
    {
        auto left  = instance.as!CraftInteger;
        auto right = arguments[0].as!CraftInteger;

        return CraftInteger.create(left.value % right.value);
    }

    CraftObject integerEqual(CraftObject instance, Arguments arguments)
    {
        auto left  = instance.as!CraftInteger;
        auto right = cast(CraftInteger) arguments[0];

        return CraftBoolean.create(right && left.value == right.value);
    }

    CraftObject integerNotEqual(CraftObject instance, Arguments arguments)
    {
        return integerEqual(instance, arguments).opNegate;
    }
}
