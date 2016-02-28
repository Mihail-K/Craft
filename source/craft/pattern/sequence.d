
module craft.pattern.sequence;

import craft.pattern.base;

import std.array;

class Sequence : Pattern
{
private:
    Pattern[] _patterns;

public:
    this(Pattern[] patterns...)
    {
        _patterns = patterns;
    }

    override string match(string input)
    {
        auto buffer = appender!string;

        foreach(pattern; _patterns)
        {
            string result = pattern.match(input);

            if(result)
            {
                input = input[result.length .. $];

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
