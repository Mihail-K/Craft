
module craft.ast.assignment;

import craft.ast;
import craft.lexer;

final class AssignmentNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode[] nodes, LexerToken[] operators)
    {
        super(nodes, operators);
    }
}
