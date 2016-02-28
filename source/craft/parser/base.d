
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
        auto node = expression;

        expect(LexerRules.EndOfFile);

        return node;
    }

private:
    void advance()
    {
        _last = front;
        _lexer.popFront;
    }

    bool match(LexerRule rule)
    {
        return front.rule == rule.name;
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

    LexerToken front()
    {
        return _lexer.front;
    }

    LexerToken last()
    {
        return _last;
    }

private:
    ExpressionListNode expressionlist()
    {
        ExpressionNode[] nodes;

        do
        {
            nodes ~= expression;
        }
        while(accept(LexerRules.OpComma));

        return new ExpressionListNode(nodes);
    }

    ExpressionNode expression()
    {
        return assignment;
    }

    ExpressionNode assignment()
    {
        auto node = ternary;

        if(accept(LexerRules.OpAssign) ||
           accept(LexerRules.OpPlusEquals) ||
           accept(LexerRules.OpMinusEquals) ||
           accept(LexerRules.OpTimesEquals) ||
           accept(LexerRules.OpDivideEquals) ||
           accept(LexerRules.OpModuloEquals) ||
           accept(LexerRules.OpShiftLeftEquals) ||
           accept(LexerRules.OpShiftRightEquals) ||
           accept(LexerRules.OpBitAndEquals) ||
           accept(LexerRules.OpBitOrEquals) ||
           accept(LexerRules.OpBitXorEquals) ||
           accept(LexerRules.OpLogicalAndEquals) ||
           accept(LexerRules.OpLogicalOrEquals) ||
           accept(LexerRules.OpQueryEquals))
        {
            node = new AssignmentNode(node, last, assignment);
        }

        return node;
    }

    ExpressionNode ternary()
    {
        auto node = logical;

        if(accept(LexerRules.OpQuery))
        {
            auto left = expression;

            expect(LexerRules.OpColon);

            node = new TernaryNode(node, left, ternary);
        }

        return node;
    }

    ExpressionNode logical()
    {
        auto node = bitwise;

        if(accept(LexerRules.OpLogicalAnd) ||
           accept(LexerRules.OpLogicalOr))
        {
            node = new LogicalNode(node, last, logical);
        }

        return node;
    }

    ExpressionNode bitwise()
    {
        auto node = equality;

        if(accept(LexerRules.OpBitAnd) ||
           accept(LexerRules.OpBitOr) ||
           accept(LexerRules.OpBitXor))
        {
            node = new BitwiseNode(node, last, bitwise);
        }

        return node;
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
        auto node = prefix;

        if(accept(LexerRules.OpTimes) ||
           accept(LexerRules.OpDivide) ||
           accept(LexerRules.OpModulo))
        {
            node = new MultiplicationNode(node, last, multiplication);
        }

        return node;
    }

    ExpressionNode prefix()
    {
        if(accept(LexerRules.OpPlusPlus) ||
           accept(LexerRules.OpMinusMinus) ||
           accept(LexerRules.OpPlus) ||
           accept(LexerRules.OpMinus) ||
           accept(LexerRules.OpBang) ||
           accept(LexerRules.OpTilde))
        {
            return new PrefixNode(last, prefix);
        }

        return postfix;
    }

    ExpressionNode postfix()
    {
        auto node = terminal;

        while(accept(LexerRules.OpPlusPlus) ||
              accept(LexerRules.OpMinusMinus) ||
              accept(LexerRules.OpParenLeft))
        {
            if(last.rule == "OpParenLeft")
            {
                auto paren = last;
                ExpressionListNode args;

                if(accept(LexerRules.OpParenRight))
                {
                    args = new ExpressionListNode([ ]);
                }
                else
                {
                    args = expressionlist;

                    expect(LexerRules.OpParenRight);
                }

                node = new InvokeNode(node, paren, args);
            }
            else
            {
                node = new PostfixNode(node, last);
            }
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
