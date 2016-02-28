
module craft.matcher.complement;

import craft.matcher.base;

class Complement : Matcher
{
private:
    Matcher _matcher;

public:
    this(Matcher matcher)
    {
        _matcher = matcher;
    }

    override string match(string input)
    {
        if(input.length && !_matcher.match(input))
        {
            return [ input[0] ];
        }
        else
        {
            return null;
        }
    }
}