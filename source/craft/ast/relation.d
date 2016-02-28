
module craft.ast.relation;

import craft.ast;
import craft.lexer;

class RelationNode : BinaryNode
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
