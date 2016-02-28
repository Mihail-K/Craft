
module craft.matcher.primitive;

import craft.matcher.base;

class Primitive : Matcher
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
