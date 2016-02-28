
module craft.ast.literal;

import craft.ast;
import craft.lexer;

abstract class LiteralNode : TerminalNode
{
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
