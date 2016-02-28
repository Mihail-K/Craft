
module craft.ast.visitor;

import craft.ast;

interface Visitor
{
    void visit(AdditionNode node);

    void visit(BitshiftNode node);

    void visit(EqualityNode node);

    void visit(IdentifierNode.Dollar node);

    void visit(IdentifierNode.Lower node);

    void visit(IdentifierNode.Upper node);

    void visit(MultiplicationNode node);

    void visit(RelationNode node);
}
