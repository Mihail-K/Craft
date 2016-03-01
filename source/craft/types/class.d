
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
        super(ClassClass.value);

        _superClass = superClass;
    }

    final CraftObject method(string name)
    {
        auto method = name in _methods;

        if(method !is null)
        {
            return *method;
        }
        else if(superClass && this !is superClass)
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

    final CraftClass superClass()
    {
        return _superClass;
    }
}

final class ClassClass : CraftClass
{
private:
    static CraftClass CLASS;

    static this()
    {
        CLASS = new ClassClass;
    }

    this()
    {
        super(this);
    }

public:
    @property
    static CraftClass value()
    {
        return CLASS;
    }
}
