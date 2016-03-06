
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

    CraftObject allocInstance(Arguments arguments = Arguments())
    {
        auto instance = CraftObject(&this);

        instance.methods = instanceMethods;
        auto ptr = "this" in instance.methods;

        if(ptr !is null)
        {
            // Call constructor if present.
            ptr.invoke(&instance, arguments);
        }

        // Check if a parent type is defined.
        if(superType && instance.super_ is null)
        {
            // Call the parent type's constructor.
            instance.super_ = superType.createInstance(arguments);
        }

        return instance;
    }

    CraftObject *createInstance(Arguments arguments = Arguments())
    {
        auto instance = new CraftObject;

        *instance = allocInstance(arguments);

        return instance;
    }

    @property
    CraftObject *getClass()
    {
        if(class_ is null)
        {
            class_ = createClass(&this);
            class_.data["name"] = name;
        }

        return class_;
    }
}

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

    @property
    CraftObject *class_()
    {
        return type.getClass;
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

bool isExactType(CraftObject *instance, CraftType *type)
{
    assert(instance, "Object instance is null.");

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
