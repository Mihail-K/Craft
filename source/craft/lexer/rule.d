
module craft.lexer.rule;

import craft.matcher;

enum LexerRules : LexerRule
{
    EndOfFile = LexerRule(null).internal(true)
}

struct LexerRule
{
private:
    bool    _discard;
    bool    _internal;
    Matcher _matcher;
    bool    _partial;

public:
    this(Matcher matcher)
    {
        _matcher = matcher;
    }

    bool discard() const
    {
        return _discard;
    }

    LexerRule discard(bool discard)
    {
        _discard = discard;

        return this;
    }

    bool internal() const
    {
        return _internal;
    }

    LexerRule internal(bool internal)
    {
        _internal = internal;

        return this;
    }

    Matcher matcher()
    {
        return _matcher;
    }

    bool partial() const
    {
        return _partial;
    }

    LexerRule partial(bool partial)
    {
        _partial = partial;

        return this;
    }
}
