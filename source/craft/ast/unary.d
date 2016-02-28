
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
    ExpressionNode node()
    {
        return _node;
    }

    @property
    LexerToken operator()
    {
        return _operator;
    }
}
