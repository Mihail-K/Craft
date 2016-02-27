
module craft.matcher.literal;

import craft.matcher.base;

class LiteralMatcher : Matcher
{
private:
    string[] _literals;

public:
    this(string[] literals)
    {
        _literals = literals;
    }

    override string match(string input)
    {
        foreach(literal; _literals)
        {
            if(input.length >= literal.length)
            {
                if(input[0 .. literal.length] == literal)
                {
                    return literal;
                }
            }
        }

        return null;
    }
}

LiteralMatcher literals(string[] literals...)
{
    return new LiteralMatcher(literals);
}
