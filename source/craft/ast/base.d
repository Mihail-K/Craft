
module craft.ast.base;

import craft.ast.visitor;

abstract class Node
{
    abstract void accept(Visitor visitor);
}
