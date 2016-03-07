
module craft.types.base;

import craft.types;

import std.variant;

struct CraftType
{
    string name;

    CraftObject *class_;

    CraftMethod[string] instanceMethods;
    CraftMethod[string] staticMethods;

    CraftType *superType;

    this(string name, CraftType *superType = null)
    {
        this.name      = name;
        this.superType = superType;
    }
}

CraftObject allocInstance(CraftType *type, Arguments arguments = Arguments())
in
{
    assert(type, "Attempted to construct instance of null type.");
}
body
{
    auto instance = CraftObject(type);

    instance.methods = type.instanceMethods;
    auto ptr = "this" in instance.methods;

    if(ptr !is null)
    {
        // Call constructor if present.
        ptr.invoke(&instance, arguments);
    }

    // Check if a parent type is defined.
    if(type.superType && instance.super_ is null)
    {
        // Call the parent type's constructor.
        instance.super_ = type.superType.createInstance(arguments);
    }

    return instance;
}

CraftObject *createInstance(CraftType *type, Arguments arguments = Arguments())
in
{
    assert(type, "Attempted to construct instance of null type.");
}
body
{
    auto instance = new CraftObject;

    *instance = type.allocInstance(arguments);

    return instance;
}

@property
CraftObject *getClass(CraftType *type)
in
{
    assert(type, "Attempted to initialize class for null type.");
}
body
{
    if(type.class_ is null)
    {
        type.class_ = type.createClass;
    }

    return type.class_;
}

/+ - Craft Object - +/

struct CraftObject
{
    CraftType   *type;
    CraftObject *super_;

    Variant[string]     data;
    CraftMethod[string] methods;

    this(CraftType *type, CraftObject *super_ = null)
    {
        this.type   = type;
        this.super_ = super_;
    }
}

@property
CraftObject *class_(CraftObject *instance)
in
{
    assert(instance, "Attempted to access class on null object.");
}
body
{
    return instance.type.getClass;
}

Variant getData(CraftObject *instance, string name)
in
{
    assert(instance, "Attempted data-segment read on null object.");
}
body
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
in
{
    assert(instance, "Attempted methoed invocation on null object.");
}
body
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

bool isExactType(CraftObject *instance, CraftType *type)
in
{
    assert(instance, "Attempted type check on null object.");
}
body
{
    return instance.type == type;
}

bool isChildType(CraftObject *instance, CraftType *type)
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
