
module craft.types.integer;

import craft.types;

import std.string;

final class CraftInteger : CraftObject
{
private:
    long _value;

public:
    this(long value)
    {
        _value = value;
    }

    override CraftInteger opPlus()
    {
        return this;
    }

    override CraftInteger opMinus()
    {
        // No need to create a negative Zero object.
        return value ? new CraftInteger(-value) : this;
    }

    override CraftInteger opComplement()
    {
        return new CraftInteger(~value);
    }

    override CraftInteger opNegate()
    {
        return new CraftInteger(!value);
    }

    override CraftInteger opPlus(CraftObject right)
    {
        auto other = cast(CraftInteger) right;
        assert(other);

        return new CraftInteger(value + other.value);
    }

    override CraftInteger opMinus(CraftObject right)
    {
        auto other = cast(CraftInteger) right;
        assert(other);

        return new CraftInteger(value - other.value);
    }

    override CraftObject opTimes(CraftObject right)
    {
        auto other = cast(CraftInteger) right;
        assert(other);

        return new CraftInteger(value * other.value);
    }

    override CraftObject opDivide(CraftObject right)
    {
        auto other = cast(CraftInteger) right;
        assert(other);

        return new CraftInteger(value / other.value);
    }

    override CraftObject opModulo(CraftObject right)
    {
        auto other = cast(CraftInteger) right;
        assert(other);

        return new CraftInteger(value % other.value);
    }

    @property
    long value() inout
    {
        return _value;
    }

    override string toString()
    {
        return "Integer(%s)".format(value);
    }
}
