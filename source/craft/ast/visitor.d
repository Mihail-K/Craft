
module craft.ast.visitor;

import craft.ast;

import std.typecons;

interface Visitor
{
    void *visit(AdditionNode node);

    void *visit(AssignmentNode node);

    void *visit(BitshiftNode node);

    void *visit(BitwiseNode node);

    void *visit(BooleanNode node);

    void *visit(EqualityNode node);

    void *visit(ExpressionListNode node);

    void *visit(IdentifierNode.Dollar node);

    void *visit(IdentifierNode.Lower node);

    void *visit(IdentifierNode.Upper node);

    void *visit(IfNode node);

    void *visit(IntegerNode node);

    void *visit(InvokeNode node);

    void *visit(LogicalNode node);

    void *visit(MultiplicationNode node);

    void *visit(PostfixNode node);

    void *visit(PrefixNode node);

    void *visit(RelationNode node);

    void *visit(StartNode node);

    void *visit(StringNode node);

    void *visit(SubscriptNode node);

    void *visit(TernaryNode node);
}

alias NullVisitor = BlackHole!Visitor;

mixin template Visitable()
{
    override void *accept(Visitor visitor)
    {
        return visitor.visit(this);
    }
}
