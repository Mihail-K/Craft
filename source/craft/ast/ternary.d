
module craft.ast.ternary;

import craft.ast;
import craft.lexer;

class TernaryNode : ExpressionNode
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
    ExpressionNode query()
    {
        return _query;
    }

    @property
    ExpressionNode left()
    {
        return _left;
    }

    @property
    ExpressionNode right()
    {
        return _right;
    }
}
