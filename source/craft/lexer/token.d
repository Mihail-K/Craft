
module craft.lexer.token;

import craft.lexer.rule;

struct LexerToken
{
private:
    size_t    _line;
    size_t    _offset;
    LexerRule _rule;
    string    _text;

public:
    @property
    size_t line() const
    {
        return _line;
    }

    @property
    size_t offset() const
    {
        return _offset;
    }

    @property
    LexerRule rule()
    {
        return _rule;
    }

    @property
    string text() const
    {
        return _text;
    }
}
