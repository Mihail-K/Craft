
module craft.types.util;

import craft.types;

CraftObject *opPlus(CraftObject *instance)
{
    return instance.invoke("$+");
}

CraftObject *opMinus(CraftObject *instance)
{
    return instance.invoke("$-");
}

CraftObject *opNegate(CraftObject *instance)
{
    return instance.invoke("$!");
}

CraftObject *opComplement(CraftObject *instance)
{
    return instance.invoke("$~");
}

CraftObject *opAdd(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("+", Arguments(other));
}

CraftObject *opSub(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("-", Arguments(other));
}

CraftObject *opTimes(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("*", Arguments(other));
}

CraftObject *opDivide(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("/", Arguments(other));
}

CraftObject *opModulo(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("%", Arguments(other));
}

CraftObject *opLess(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("<", Arguments(other));
}

CraftObject *opGreater(CraftObject *instance, CraftObject *other)
{
    return instance.invoke(">", Arguments(other));
}

CraftObject *opLessOrEqual(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("<=", Arguments(other));
}

CraftObject *opGreaterOrEqual(CraftObject *instance, CraftObject *other)
{
    return instance.invoke(">=", Arguments(other));
}

CraftObject *opEqual(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("==", Arguments(other));
}

CraftObject *opNotEqual(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("!=", Arguments(other));
}
