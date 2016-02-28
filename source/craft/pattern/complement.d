
module craft.pattern.complement;

import craft.pattern.base;

class Complement : Pattern
{
private:
    Pattern _pattern;

public:
    this(Pattern pattern)
    {
        _pattern = pattern;
    }

    override string match(string input)
    {
        if(input.length && !_pattern.match(input))
        {
            return [ input[0] ];
        }
        else
        {
            return null;
        }
    }
}
