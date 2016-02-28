
module craft.ast.boolean;

import craft.ast;
import craft.lexer;

final class BooleanNode : LiteralNode
{
    mixin Visitable;

    this(LexerToken token)
    {
        super(token);
    }
}
