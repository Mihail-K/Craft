
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

    CraftObject *invoke(string name, Arguments arguments = Arguments())
    {
        auto ptr = name in methods;

        if(ptr)
        {
            return ptr.invoke(&this, arguments);
        }

        if(super_)
        {
            return super_.invoke(name, arguments);
        }

        assert(0, "No such method " ~ name); // TODO
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
