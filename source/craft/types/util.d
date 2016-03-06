
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

CraftObject *opAdd(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("+", Arguments(other));
}

CraftObject *opSub(CraftObject *instance, CraftObject *other)
{
    return instance.invoke("-", Arguments(other));
}
