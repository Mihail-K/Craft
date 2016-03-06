
module craft.types.base;

import craft.types;

import std.variant;

struct CraftObject
{
    CraftObject *class_;
    CraftObject *super_;

    Variant[string]     data;
    CraftField[string]  fields;
    CraftMethod[string] methods;

    this(CraftObject *class_, CraftObject *super_ = null)
    {
        this.class_ = class_;
        this.super_ = super_;
    }

    string toString()
    {
        import std.conv : text;
        return "CraftObject(" ~ class_.text ~ ")";
    }
}

struct CraftField
{
    CraftObject *value;

    this(CraftObject *value)
    {
        this.value = value;
    }
}

Variant getData(CraftObject *instance, string name)
{
    Variant *data;
    CraftObject *current = instance;

    while(current !is null)
    {
        data = name in current.data;
        if(data !is null) return *data;

        current = current.super_;
    }

    assert(0); // TODO
}

CraftObject *invoke(CraftObject *instance, string name, Arguments arguments = Arguments())
{
    CraftMethod *method;
    CraftObject *current = instance;

    while(current !is null)
    {
        method = name in current.methods;

        if(method !is null)
        {
            return method.invoke(instance, arguments);
        }

        current = current.super_;
    }

    assert(0, "No such method " ~ name); // TODO
}

bool isExactType(CraftObject *instance, CraftObject *type)
{
    assert(instance, "Object instance is null.");

    return instance.class_ == type;
}

bool isChildType(CraftObject *instance, CraftObject *type)
{
    if(instance.isExactType(type))
    {
        return true;
    }
    else if(instance.super_)
    {
        return instance.super_.isChildType(type);
    }
    else
    {
        return false;
    }
}
