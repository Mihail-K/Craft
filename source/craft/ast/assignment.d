
module craft.ast.assignment;

import craft.ast;
import craft.lexer;

class AssignmentNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode left, LexerToken operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
