
module craft.ast.bitshift;

import craft.ast;
import craft.lexer;

class BitshiftNode : BinaryNode
{
    this(ExpressionNode left, LexerToken operator, ExpressionNode right)
    {
        super(left, operator, right);
    }

    override void accept(Visitor visitor)
    {
        visitor.visit(this);
    }
}
