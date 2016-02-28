
module craft.lexer.base;

import craft.lexer.rule;
import craft.lexer.token;

import std.traits;

struct Lexer
{
private:
    string     _input;
    size_t     _line;
    size_t     _offset;
    LexerToken _token;

public:
    this(string input)
    {
        _input = input;
    }

    bool empty() inout
    {
        return _input.length == 0;
    }

    LexerToken front()
    {
        if(empty)
        {
            return _token = token(LexerRules.EndOfFile, null);
        }
        else
        {
            string bestMatch;
            LexerRule bestRule;

            foreach(rule; EnumMembers!LexerRules)
            {
                if(!rule.internal && !rule.partial)
                {
                    string result = rule.pattern.match(_input);

                    if(result && result.length > bestMatch.length)
                    {
                        bestMatch = result;
                        bestRule  = rule;
                    }
                }
            }

            if(bestMatch.length > 0)
            {
                _token = token(bestRule, bestMatch);

                if(bestRule.discard)
                {
                    return popFront, front;
                }
                else
                {
                    return _token;
                }
            }
            else
            {
                return _token = token(LexerRules.Error, _input);
            }
        }
    }

    void popFront()
    {
        if(_token.text.length)
        {
            foreach(ch; _input[0 .. _token.text.length])
            {
                switch(ch)
                {
                    case '\n':
                        _line = _line + 1;
                        _offset = 0;
                        break;

                    case '\t':
                        _offset = _offset + 4;
                        break;

                    default:
                        _offset = _offset + 1;
                        break;
                }
            }
        }

        _input = _input[_token.text.length .. $];
        _token = LexerToken.init;
    }

    private LexerToken token(LexerRule rule, string text) inout
    {
        return LexerToken(_line, _offset, rule.name, text);
    }
}
