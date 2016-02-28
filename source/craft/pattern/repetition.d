
module craft.pattern.repetition;

import craft.pattern.base;

import std.array;

class Repetition : Pattern
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
        auto buffer = appender!string;

        while(true)
        {
            string result = _pattern.match(input);

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
