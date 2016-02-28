
module craft.pattern.optional;

import craft.pattern.base;

class Optional : Pattern
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
        string result = _pattern.match(input);
        return result ? result : "";
    }
}
