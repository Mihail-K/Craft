
module craft.ast.binary;

import craft.ast;
import craft.lexer;

abstract class BinaryNode : ExpressionNode
{
private:
    ExpressionNode[] _nodes;
    LexerToken[]     _operators;

public:
    this(ExpressionNode[] nodes, LexerToken[] operators)
    {
        _nodes     = nodes;
        _operators = operators;
    }

    @property
    inout(ExpressionNode[]) nodes() inout nothrow
    {
        return _nodes;
    }

    @property
    inout(LexerToken[]) operators() inout nothrow
    {
        return _operators;
    }
}
