
module craft.ast.postfix;

import craft.ast;
import craft.lexer;

final class PostfixNode : UnaryNode
{
    mixin Visitable;

    this(ExpressionNode node, LexerToken operator)
    {
        super(node, operator);
    }
}
