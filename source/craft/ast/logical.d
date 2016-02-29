
module craft.ast.logical;

import craft.ast;
import craft.lexer;

final class LogicalNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode[] nodes, LexerToken[] operators)
    {
        super(nodes, operators);
    }
}
