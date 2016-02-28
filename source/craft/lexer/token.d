
module craft.lexer.token;

import craft.lexer.rule;

struct LexerToken
{
private:
    size_t _line;
    size_t _offset;
    string _rule;
    string _text;

public:
    @property
    size_t line() inout nothrow
    {
        return _line;
    }

    @property
    size_t offset() inout nothrow
    {
        return _offset;
    }

    @property
    string rule() inout nothrow
    {
        return _rule;
    }

    @property
    string text() inout nothrow
    {
        return _text;
    }
}
