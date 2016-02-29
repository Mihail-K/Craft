
module craft.ast.multiplication;

import craft.ast;
import craft.lexer;

final class MultiplicationNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode[] nodes, LexerToken[] operators)
    {
        super(nodes, operators);
    }
}
