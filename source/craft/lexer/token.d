
module craft.lexer.token;

struct Token
{
private:
    size_t    _line;
    size_t    _offset;
    LexerRule _rule
    string    _token;

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
    LexerRule rule() const
    {
        return _rule;
    }

    @property
    string token() const
    {
        return _token;
    }
}
