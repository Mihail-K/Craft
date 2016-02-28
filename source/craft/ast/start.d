
module craft.ast.start;

import craft.ast;

final class StartNode : Node
{
    mixin Visitable;

private:
    Node[] _nodes;

public:
    this(Node[] nodes)
    {
        _nodes = nodes;
    }

    inout(Node[]) nodes() inout nothrow
    {
        return _nodes;
    }
}
