
module craft.ast.binary;

import craft.ast;
import craft.lexer;

abstract class BinaryNode : ExpressionNode
{
private:
    ExpressionNode _left;
    LexerToken     _operator;
    ExpressionNode _right;

public:
    this(ExpressionNode left, LexerToken operator, ExpressionNode right)
    {
        _left     = left;
        _operator = operator;
        _right    = right;
    }

    ExpressionNode left()
    {
        return _left;
    }

    LexerToken operator()
    {
        return _operator;
    }

    ExpressionNode right()
    {
        return _right;
    }
}
