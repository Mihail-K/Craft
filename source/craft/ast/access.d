
module craft.ast.access;

import craft.ast;
import craft.lexer;

final class AccessNode : UnaryNode
{
    mixin Visitable;

private:
    IdentifierNode _member; // TODO

public:
    this(ExpressionNode node, LexerToken operator, IdentifierNode member)
    {
        super(node, operator);

        _member = member;
    }

    @property
    inout(IdentifierNode) member() inout nothrow
    {
        return _member;
    }
}
