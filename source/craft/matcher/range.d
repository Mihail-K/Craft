
module craft.matcher.range;

import craft.matcher.base;

class RangeMatcher : Matcher
{
private:
    char _min;
    char _max;

public:
    this(char min, char max)
    {
        _min = min;
        _max = max;
    }

    override string match(string input)
    {
        if(input.length && input[0] >= _min && input[0] <= _max)
        {
            return [ input[0] ];
        }
        else
        {
            return null;
        }
    }
}

RangeMatcher range(char min, char max)
{
    return new RangeMatcher(min, max);
}
