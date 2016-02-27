
module craft.matcher.repeat;

import craft.matcher.base;

import std.array;

class RepeatMatcher : Matcher
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
        auto buffer = appender!string;

        while(true)
        {
            string result = _matcher.match(input);

            if(result)
            {
                buffer ~= result;
            }
            else
            {
                break;
            }
        }

        string result = buffer.data;
        return result ? result : null;
    }
}

RepeatMatcher repeat(Matcher matcher)
{
    return new RepeatMatcher(matcher);
}
