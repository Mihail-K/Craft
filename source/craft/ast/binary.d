
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

    @property
    inout(ExpressionNode) left() inout nothrow
    {
        return _left;
    }

    @property
    inout(LexerToken) operator() inout nothrow
    {
        return _operator;
    }

    @property
    inout(ExpressionNode) right() inout nothrow
    {
        return _right;
    }
}
