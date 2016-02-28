
module craft.matcher.repetition;

import craft.matcher.base;

import std.array;

class Repetition : Matcher
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
                input = input[result.length .. $];

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
