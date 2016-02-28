
module craft.matcher.callback;

import craft.matcher.base;

class Callback : Matcher
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
