
module craft.ast.base;

import craft.ast.visitor;

abstract class Node
{
    abstract Object accept(Visitor visitor);

    final T accept(T : Object)(Visitor visitor)
    {
        return cast(T) accept(visitor);
    }
}
