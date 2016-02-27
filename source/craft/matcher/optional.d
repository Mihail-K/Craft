
module craft.matcher.optional;

import craft.matcher.base;

class OptionalMatcher : Matcher
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
        string result = _matcher.match(input);
        return result ? result : "";
    }
}

OptionalMatcher optional(Matcher matcher)
{
    return new OptionalMatcher(matcher);
}
