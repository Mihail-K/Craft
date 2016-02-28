
module craft.ast.identifier;

import craft.ast;
import craft.lexer;

abstract class IdentifierNode : TerminalNode
{
public:
    static class Dollar : IdentifierNode
    {
        mixin Visitable;

        this(LexerToken token)
        {
            super(token);
        }
    }

    static class Lower : IdentifierNode
    {
        mixin Visitable;

        this(LexerToken token)
        {
            super(token);
        }
    }

    static class Upper : IdentifierNode
    {
        mixin Visitable;

        this(LexerToken token)
        {
            super(token);
        }
    }

private:
    LexerToken _token;

public:
    this(LexerToken token)
    {
        _token = token;
    }

    @property
    LexerToken token()
    {
        return _token;
    }
}
