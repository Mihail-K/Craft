
module craft.ast.bitshift;

import craft.ast;
import craft.lexer;

class BitshiftNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode left, LexerToken operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
