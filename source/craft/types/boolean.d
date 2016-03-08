
module craft.types.boolean;

import craft.types;
import craft.types.object;

/+ - Boolean Class - +/

__gshared CraftType TRUE_TYPE;
__gshared CraftType FALSE_TYPE;

shared static this()
{
    // class True : Object
    CraftType *t = &TRUE_TYPE;
    TRUE_TYPE = CraftType("True", &OBJECT_TYPE);

    /+ - Instance Methods - +/

    t.instanceMethods["$!"] = native(0, &true_instance_not);
    t.instanceMethods["&&"] = native(1, &true_instance_and);
    t.instanceMethods["&"]  = native(1, &true_instance_and);
    t.instanceMethods["||"] = native(1, &true_instance_or);
    t.instanceMethods["|"]  = native(1, &true_instance_or);
    t.instanceMethods["^"]  = native(1, &true_instance_xor);

    t.instanceMethods["string"] = native(0, &true_instance_string);
}

private
{
    CraftObject *true_instance_and(CraftObject *, Arguments arguments)
    {
        return arguments[0];
    }

    CraftObject *true_instance_not(CraftObject *, Arguments)
    {
        return &FALSE;
    }

    CraftObject *true_instance_or(CraftObject *instance, Arguments)
    {
        return instance;
    }

    CraftObject *true_instance_string(CraftObject *, Arguments)
    {
        return createString("true");
    }

    CraftObject *true_instance_xor(CraftObject *, Arguments arguments)
    {
        return arguments[0].coerceBool ? &FALSE : &TRUE;
    }
}

shared static this()
{
    // class False : Object
    CraftType *t = &FALSE_TYPE;
    FALSE_TYPE = CraftType("False", &OBJECT_TYPE);

    /+ - Instance Methods - +/

    t.instanceMethods["$!"] = native(0, &false_instance_not);
    t.instanceMethods["&&"] = native(1, &false_instance_and);
    t.instanceMethods["&"]  = native(1, &false_instance_and);
    t.instanceMethods["||"] = native(1, &false_instance_or);
    t.instanceMethods["|"]  = native(1, &false_instance_or);
    t.instanceMethods["^"]  = native(1, &false_instance_xor);

    t.instanceMethods["string"] = native(0, &false_instance_string);
}

private
{
    CraftObject *false_instance_and(CraftObject *instance, Arguments)
    {
        return instance;
    }

    CraftObject *false_instance_not(CraftObject *, Arguments)
    {
        return &TRUE;
    }

    CraftObject *false_instance_or(CraftObject *, Arguments arguments)
    {
        return arguments[0];
    }

    CraftObject *false_instance_string(CraftObject *, Arguments)
    {
        return createString("false");
    }

    CraftObject *false_instance_xor(CraftObject *, Arguments arguments)
    {
        return arguments[0].coerceBool ? &TRUE : &FALSE;
    }
}

/+ - Boolean Instance - +/

__gshared CraftObject TRUE;
__gshared CraftObject FALSE;

shared static this()
{
    TRUE  = (&TRUE_TYPE).allocInstance;
    FALSE = (&FALSE_TYPE).allocInstance;
}

CraftObject *createBoolean(bool value)
{
    return value ? &TRUE : &FALSE;
}

@property
bool asBool(CraftObject *instance)
{
    if(instance.isExactType(&TRUE_TYPE))
    {
        return true;
    }
    else if(instance.isExactType(&FALSE_TYPE))
    {
        return false;
    }
    else
    {
        assert(0);
    }
}

@property
bool coerceBool(CraftObject *instance)
{
    return !instance.isExactType(&FALSE_TYPE) &&
           !instance.isExactType(&NULL_TYPE);
}

@property
bool isFalse(CraftObject *instance)
{
    return instance is &FALSE;
}

@property
bool isTrue(CraftObject *instance)
{
    return instance is &TRUE;
}
