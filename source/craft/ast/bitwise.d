
module craft.ast.bitwise;

import craft.ast;
import craft.lexer;

final class BitwiseNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode[] nodes, LexerToken[] operators)
    {
        super(nodes, operators);
    }
}
