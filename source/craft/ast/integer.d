
module craft.ast.integer;

import craft.ast;
import craft.lexer;

final class IntegerNode : LiteralNode
{
    mixin Visitable;

    this(LexerToken token)
    {
        super(token);
    }
}
