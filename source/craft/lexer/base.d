
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

    bool empty() const
    {
        return _input.length == 0;
    }

    LexerToken front()
    {
        if(empty)
        {
            return _token = token(LexerRules.EndOfFile, "$");
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
                return _token = token(bestRule, bestMatch);
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
                        _offset = 0;
                        _line++;
                        break;

                    case '\t':
                        _offset += 4;
                        break;

                    default:
                        _offset++;
                        break;
                }
            }
        }

        _input = _input[_token.text.length .. $];
        _token = LexerToken.init;
    }

    private LexerToken token(LexerRule rule, string text)
    {
        return LexerToken(_line, _offset, rule, text);
    }
}
