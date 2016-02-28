
module craft.ast.identifier;

import craft.ast;
import craft.lexer;

abstract class IdentifierNode : TerminalNode
{
public:
    static class Dollar : IdentifierNode
    {
        this(LexerToken token)
        {
            super(token);
        }

        override void accept(Visitor visitor)
        {
            visitor.visit(this);
        }
    }

    static class Lower : IdentifierNode
    {
        this(LexerToken token)
        {
            super(token);
        }

        override void accept(Visitor visitor)
        {
            visitor.visit(this);
        }
    }

    static class Upper : IdentifierNode
    {
        this(LexerToken token)
        {
            super(token);
        }

        override void accept(Visitor visitor)
        {
            visitor.visit(this);
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
