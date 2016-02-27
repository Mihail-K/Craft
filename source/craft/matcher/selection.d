
module craft.matcher.selection;

import craft.matcher.base;

class SelectionMatcher : Matcher
{
private:
    Matcher[] _matchers;

public:
    this(Matcher[] matchers)
    {
        _matchers = matchers;
    }

    override string match(string input)
    {
        foreach(matcher; _matchers)
        {
            string result = matcher.match(input);

            if(result)
            {
                return result;
            }
        }

        return null;
    }
}

SelectionMatcher selection(Matcher[] matchers...)
{
    return new SelectionMatcher(matchers);
}
