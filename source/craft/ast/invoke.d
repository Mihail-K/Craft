
module craft.ast.invoke;

import craft.ast;
import craft.lexer;

final class InvokeNode : UnaryNode
{
    mixin Visitable;

private:
    ExpressionListNode _args;

public:
    this(ExpressionNode node, LexerToken operator, ExpressionListNode args)
    {
        super(node, operator);

        _args = args;
    }

    @property
    inout(ExpressionListNode) args() inout nothrow
    {
        return _args;
    }
}
