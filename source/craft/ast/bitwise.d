
module craft.ast.bitwise;

import craft.ast;
import craft.lexer;

final class BitwiseNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode left, LexerToken operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
