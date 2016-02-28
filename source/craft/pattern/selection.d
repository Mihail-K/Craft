
module craft.pattern.selection;

import craft.pattern.base;

class Selection : Pattern
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
        foreach(pattern; _patterns)
        {
            string result = pattern.match(input);

            if(result)
            {
                return result;
            }
        }

        return null;
    }
}
