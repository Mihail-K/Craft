
module craft.pattern.primitive;

import craft.pattern.base;

class Primitive : Pattern
{
private:
    string[] _primitives;

public:
    this(string[] primitives...)
    {
        _primitives = primitives;
    }

    override string match(string input)
    {
        foreach(primitive; _primitives)
        {
            if(input.length >= primitive.length)
            {
                if(input[0 .. primitive.length] == primitive)
                {
                    return primitive;
                }
            }
        }

        return null;
    }
}
