
module craft.ast.logical;

import craft.ast;
import craft.lexer;

final class LogicalNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode left, LexerToken operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
