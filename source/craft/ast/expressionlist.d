
module craft.ast.expressionlist;

import craft.ast;

final class ExpressionListNode : ExpressionNode
{
    mixin Visitable;

private:
    ExpressionNode[] _nodes;

public:
    this(ExpressionNode[] nodes)
    {
        _nodes = nodes;
    }

    @property
    inout(ExpressionNode[]) nodes() inout nothrow
    {
        return _nodes;
    }
}
