
module craft.ast.equality;

import craft.ast;
import craft.lexer;

final class EqualityNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode[] nodes, LexerToken[] operators)
    {
        super(nodes, operators);
    }
}
