
module craft.types.class_;

import craft.types;

import std.variant;

/+ - Class Class - +/

__gshared CraftObject CLASS_CLASS;

shared static this()
{
    with(CLASS_CLASS)
    {
        class_ = &CLASS_CLASS;  // Class.class => Class
        super_ = &OBJECT_CLASS; // Class.super => Object

        data["name"] = Variant("Class");

        methods["class"]  = native(0, &class_class);
        methods["name"]   = native(0, &class_name);
        methods["super"]  = native(0, &class_super);
        methods["string"] = native(0, &class_name);
    }
}

private
{
    CraftObject *class_class(CraftObject *instance, Arguments)
    {
        return instance.class_;
    }

    CraftObject *class_name(CraftObject *instance, Arguments)
    {
        return instance.data["name"].get!string.createString;
    }

    CraftObject *class_super(CraftObject *instance, Arguments)
    {
        return instance.super_;
    }
}
