
module craft.matcher.bracket;

import craft.matcher.base;

class Bracket : Matcher
{
private:
    char _lower;
    char _upper;

public:
    this(char lower, char upper)
    {
        _lower = lower;
        _upper = upper;
    }

    override string match(string input)
    {
        if(input.length && input[0] >= _lower && input[0] <= _upper)
        {
            return [ input[0] ];
        }
        else
        {
            return null;
        }
    }
}
