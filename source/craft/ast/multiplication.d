
module craft.ast.multiplication;

import craft.ast;
import craft.lexer;

class MultiplicationNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode left, LexerToken operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
