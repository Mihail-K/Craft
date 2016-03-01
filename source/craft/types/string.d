
module craft.types.string;

import craft.types;

class CraftString : CraftObject
{
private:
    string _value;

public:
    this(string value)
    {
        super(null);

        _value = value;
    }

    @property
    string value()
    {
        return _value;
    }
}
