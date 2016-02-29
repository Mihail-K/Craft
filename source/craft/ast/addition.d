
module craft.ast.addition;

import craft.ast;
import craft.lexer;

final class AdditionNode : BinaryNode
{
    mixin Visitable;

    this(ExpressionNode[] nodes, LexerToken[] operators)
    {
        super(nodes, operators);
    }
}
