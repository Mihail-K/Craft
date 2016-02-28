
module craft.ast.prefix;

import craft.ast;
import craft.lexer;

final class PrefixNode : UnaryNode
{
    mixin Visitable;

    this(LexerToken operator, ExpressionNode node)
    {
        super(node, operator);
    }
}
