
module craft.ast.string;

import craft.ast;
import craft.lexer;

final class StringNode : LiteralNode
{
    mixin Visitable;

    this(LexerToken token)
    {
        super(token);
    }
}
