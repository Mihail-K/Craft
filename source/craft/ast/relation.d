
module craft.ast.relation;

import craft.ast;
import craft.lexer;

final class RelationNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode left, LexerToken operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
