
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

CraftObject *opConcat(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("~", Arguments(other));
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

CraftObject *opIs(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("is", Arguments(other));
}

CraftObject *opIsNot(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("isnt", Arguments(other));
}

CraftObject *opEqual(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("==", Arguments(other));
}

CraftObject *opNotEqual(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("!=", Arguments(other));
}

CraftObject *opBitAnd(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("&", Arguments(other));
}

CraftObject *opBitOr(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("|", Arguments(other));
}

CraftObject *opBitXor(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("^", Arguments(other));
}

CraftObject *opLogicalAnd(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("&&", Arguments(other));
}

CraftObject *opLogicalOr(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("||", Arguments(other));
}
