
module craft.ast.visitor;

import craft.ast;

interface Visitor
{
    Object visit(AdditionNode node);

    Object visit(AssignmentNode node);

    Object visit(BitshiftNode node);

    Object visit(BitwiseNode node);

    Object visit(BooleanNode node);

    Object visit(EqualityNode node);

    Object visit(ExpressionListNode node);

    Object visit(IdentifierNode.Dollar node);

    Object visit(IdentifierNode.Lower node);

    Object visit(IdentifierNode.Upper node);

    Object visit(IfNode node);

    Object visit(IntegerNode node);

    Object visit(InvokeNode node);

    Object visit(LogicalNode node);

    Object visit(MultiplicationNode node);

    Object visit(PostfixNode node);

    Object visit(PrefixNode node);

    Object visit(RelationNode node);

    Object visit(StartNode node);

    Object visit(StringNode node);

    Object visit(SubscriptNode node);

    Object visit(TernaryNode node);
}

mixin template Visitable()
{
    override Object accept(Visitor visitor)
    {
        return visitor.visit(this);
    }
}
