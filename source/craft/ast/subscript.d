
module craft.ast.subscript;

import craft.ast;
import craft.lexer;

final class SubscriptNode : UnaryNode
{
    mixin Visitable;

private:
    ExpressionNode _index;

public:
    this(ExpressionNode node, LexerToken operator, ExpressionNode index)
    {
        super(node, operator);

        _index = index;
    }

    @property
    inout(ExpressionNode) index() inout nothrow
    {
        return _index;
    }
}
