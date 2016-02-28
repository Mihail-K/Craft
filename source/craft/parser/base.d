
module craft.parser.base;

import craft.ast;
import craft.lexer;

struct Parser
{
private:
    LexerToken _last;
    Lexer      _lexer;

public:
    this(Lexer lexer)
    {
        _lexer = lexer;
    }

    ExpressionNode start()
    {
        return expression;
    }

private:
    void advance()
    {
        _last = _lexer.front;
        _lexer.popFront;
    }

    bool match(LexerRule rule)
    {
        return _lexer.front.rule == rule;
    }

    bool accept(LexerRule rule)
    {
        if(match(rule))
        {
            return advance, true;
        }

        return false;
    }

    bool expect(LexerRule rule)
    {
        assert(accept(rule));

        return true;
    }

    LexerToken last()
    {
        return _last;
    }

private:
    ExpressionNode expression()
    {
        return equality;
    }

    ExpressionNode equality()
    {
        auto node = relation;

        if(accept(LexerRules.OpEquals) ||
           accept(LexerRules.OpNotEquals))
        {
            node = new EqualityNode(node, last, equality);
        }

        return node;
    }

    ExpressionNode relation()
    {
        auto node = bitshift;

        if(accept(LexerRules.OpLess) ||
           accept(LexerRules.OpGreater) ||
           accept(LexerRules.OpLessEquals) ||
           accept(LexerRules.OpGreaterEquals))
        {
            node = new RelationNode(node, last, relation);
        }

        return node;
    }

    ExpressionNode bitshift()
    {
        auto node = addition;

        if(accept(LexerRules.OpShiftLeft) ||
           accept(LexerRules.OpShiftRight))
        {
            node = new BitshiftNode(node, last, bitshift);
        }

        return node;
    }

    ExpressionNode addition()
    {
        auto node = multiplication;

        if(accept(LexerRules.OpPlus) ||
           accept(LexerRules.OpMinus))
        {
            node = new AdditionNode(node, last, addition);
        }

        return node;
    }

    ExpressionNode multiplication()
    {
        auto node = terminal;

        if(accept(LexerRules.OpTimes) ||
           accept(LexerRules.OpDivide) ||
           accept(LexerRules.OpModulo))
        {
            node = new MultiplicationNode(node, last, multiplication);
        }

        return node;
    }

    ExpressionNode terminal()
    {
        if(accept(LexerRules.IdentifierLower))
        {
            return new IdentifierNode.Lower(last);
        }
        else if(accept(LexerRules.IdentifierUpper))
        {
            return new IdentifierNode.Upper(last);
        }
        else if(accept(LexerRules.IdentifierDollar))
        {
            return new IdentifierNode.Dollar(last);
        }
        else
        {
            assert(0);
        }
    }
}
