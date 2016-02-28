
module craft.ast.equality;

import craft.ast;
import craft.lexer;

class EqualityNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode left, LexerToken operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
