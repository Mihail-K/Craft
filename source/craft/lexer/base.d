
module craft.lexer.base;

import craft.lexer.rule;
import craft.lexer.token;

import std.traits;

struct Lexer
{
private:
    string     _input;
    LexerToken _token;

public:
    this(string input)
    {
        _input = input;
    }

    bool empty() const
    {
        return _input.length == 0;
    }

    LexerToken front()
    {
        if(empty)
        {
            return _token = LexerToken(0, 0, LexerRules.EndOfFile, "$");
        }
        else
        {
            string bestMatch;
            LexerRule bestRule;

            foreach(rule; EnumMembers!LexerRules)
            {
                if(!rule.internal && !rule.partial)
                {
                    string result = rule.matcher.match(_input);

                    if(result && result.length > bestMatch.length)
                    {
                        bestMatch = result;
                        bestRule  = rule;
                    }
                }
            }

            if(bestMatch.length > 0)
            {
                return _token = LexerToken(0, 0, bestRule, bestMatch);
            }
            else
            {
                return _token = LexerToken(0, 0, LexerRules.Error, _input);
            }
        }
    }

    void popFront()
    {
        _input = _input[_token.text.length .. $];
        _token = LexerToken.init;
    }
}
