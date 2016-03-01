
module craft.types.class_;

import craft.types;

class CraftClass : CraftObject
{
private:
    CraftObject[string] _methods;
    CraftClass          _superClass;

public:
    this(CraftClass superClass)
    {
        super(superClass);
    }

    final CraftObject method(string name)
    {
        auto method = name in _methods;

        if(method !is null)
        {
            return *method;
        }
        else if(superClass)
        {
            return superClass.method(name);
        }
        else
        {
            return null; // TODO
        }
    }

    final CraftObject method(string name, CraftMethod method)
    {
        return _methods[name] = method, this;
    }

    CraftObject methods()
    {
        return null; // TODO
    }

    CraftObject name()
    {
        return null; // TODO
    }

    CraftClass superClass()
    {
        return _superClass;
    }
}

final class ClassClass : CraftClass
{
private:
    static CraftClass CLASS;

    this()
    {
        super(null);
    }

public:
    @property
    static CraftClass value()
    {
        if(CLASS is null)
        {
            CLASS = new ClassClass;
        }

        return CLASS;
    }

    override CraftClass superClass()
    {
        return ObjectClass.value;
    }
}
