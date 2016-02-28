
module craft.pattern.callback;

import craft.pattern.base;

class Callback : Pattern
{
private:
    string function(string) _callback;

public:
    this(string function(string) callback)
    {
        _callback = callback;
    }

    override string match(string input)
    {
        if(input.length)
        {
            return _callback(input);
        }
        else
        {
            return null;
        }
    }
}
