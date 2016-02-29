
module craft.ast.bitshift;

import craft.ast;
import craft.lexer;

final class BitshiftNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode[] nodes, LexerToken[] operators)
    {
        super(nodes, operators);
    }
}
