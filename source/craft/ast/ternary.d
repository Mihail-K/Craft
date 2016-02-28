
module craft.ast.ternary;

import craft.ast;
import craft.lexer;

final class TernaryNode : ExpressionNode
{
    mixin Visitable;

private:
    ExpressionNode _query;
    ExpressionNode _left;
    ExpressionNode _right;

public:
    this(ExpressionNode query, ExpressionNode left, ExpressionNode right)
    {
        _query = query;
        _left  = left;
        _right = right;
    }

    @property
    inout(ExpressionNode) query() inout nothrow
    {
        return _query;
    }

    @property
    inout(ExpressionNode) left() inout nothrow
    {
        return _left;
    }

    @property
    inout(ExpressionNode) right() inout nothrow
    {
        return _right;
    }
}
