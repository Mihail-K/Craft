
module craft.ast.if_;

import craft.ast;

final class IfNode : StatementNode
{
    mixin Visitable;

private:
    ExpressionNode _query;
    StatementNode  _body;
    StatementNode  _else;

public:
    this(ExpressionNode query, StatementNode body_, StatementNode else_)
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
    inout(StatementNode) body_() inout nothrow
    {
        return _body;
    }

    @property
    inout(StatementNode) else_() inout nothrow
    {
        return _else;
    }
}
