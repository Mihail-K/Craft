
module craft.ast.if_;

import craft.ast;

final class IfNode : ExpressionNode
{
    mixin Visitable;

private:
    ExpressionNode _query;
    ExpressionNode _body;
    ExpressionNode _else;

public:
    this(ExpressionNode query, ExpressionNode body_, ExpressionNode else_)
    {
        _query = query;
        _body  = body_;
        _else  = else_;
    }

    @property
    inout(ExpressionNode) query() inout nothrow
    {
        return _query;
    }

    @property
    inout(ExpressionNode) body_() inout nothrow
    {
        return _body;
    }

    @property
    inout(ExpressionNode) else_() inout nothrow
    {
        return _else;
    }
}
