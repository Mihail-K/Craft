
module craft.types.arguments;

import craft.types;

struct Arguments
{
    CraftObject[] values;

    this(CraftObject[] values...)
    {
        this.values = values.dup;
    }

    void ensure(size_t count, bool varargs)
    {
        assert(varargs ? length >= count : length == count); // TODO
    }

    @property
    size_t length() inout nothrow
    {
        return values.length;
    }

    alias opDollar = length;

    CraftObject opIndex(size_t index)
    {
        return values[index];
    }

    CraftObject[] opSlice(size_t start, size_t stop)
    {
        return values[start .. stop];
    }
}
