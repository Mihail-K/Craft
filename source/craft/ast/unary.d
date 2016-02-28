
module craft.ast.unary;

import craft.ast.expression;
import craft.lexer;

abstract class UnaryNode : ExpressionNode
{
private:
    ExpressionNode _node;
    LexerToken     _operator;

public:
    this(ExpressionNode node, LexerToken operator)
    {
        _node     = node;
        _operator = operator;
    }

    @property
    inout(ExpressionNode) node() inout nothrow
    {
        return _node;
    }

    @property
    inout(LexerToken) operator() inout nothrow
    {
        return _operator;
    }
}
