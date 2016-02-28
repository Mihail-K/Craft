
module craft.matcher.sequence;

import craft.matcher.base;

import std.array;

class Sequence : Matcher
{
private:
    Matcher[] _matchers;

public:
    this(Matcher[] matchers...)
    {
        _matchers = matchers;
    }

    override string match(string input)
    {
        auto buffer = appender!string;

        foreach(matcher; _matchers)
        {
            string result = matcher.match(input);

            if(result)
            {
                buffer ~= result;
            }
            else
            {
                return null;
            }
        }

        return buffer.data;
    }
}
