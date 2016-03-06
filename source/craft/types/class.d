
module craft.types.class_;

import craft.types;
import craft.types.object;

/+ - Class Type - +/

__gshared CraftType CLASS_TYPE;

shared static this()
{
    CraftType *t = &CLASS_TYPE;
    CLASS_TYPE = CraftType("Class", &OBJECT_TYPE);

    /+ - Instance Methods - +/

    t.instanceMethods["name"]   = native(0, &class_instance_name);
    t.instanceMethods["string"] = native(0, &class_instance_name);
}

private
{
    CraftObject *class_instance_name(CraftObject *instance, Arguments)
    {
        return instance.getData("type").get!(CraftType *).name.createString;
    }
}

/+ - Class Instance - +/

CraftObject *createClass(CraftType *type)
{
    auto instance = CLASS_TYPE.createInstance;

    instance.data["type"] = type;

    return instance;
}
