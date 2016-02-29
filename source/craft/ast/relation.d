
module craft.ast.relation;

import craft.ast;
import craft.lexer;

final class RelationNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode[] nodes, LexerToken[] operators)
    {
        super(nodes, operators);
    }
}
