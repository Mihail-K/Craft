
module craft.ast.identifier;

import craft.ast;
import craft.lexer;

abstract class IdentifierNode : TerminalNode
{
public:
    static final class Dollar : IdentifierNode
    {
        mixin Visitable;

        this(LexerToken token)
        {
            super(token);
        }
    }

    static final class Lower : IdentifierNode
    {
        mixin Visitable;

        this(LexerToken token)
        {
            super(token);
        }
    }

    static final class Upper : IdentifierNode
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
    inout(LexerToken) token() inout nothrow
    {
        return _token;
    }
}
