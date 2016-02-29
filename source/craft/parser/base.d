
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

    StartNode start()
    {
        Node[] nodes;

        while(!accept(LexerRules.EndOfFile))
        {
            nodes ~= statement;
        }

        return new StartNode(nodes);
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

    void expect(LexerRule rule)
    {
        assert(accept(rule));
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
    StatementNode statement()
    {
        if(accept(LexerRules.KeyIf))
        {
            return ifStatement;
        }
        else
        {
            return expression;
        }
    }

    StatementNode ifStatement()
    {
        return new IfNode(ifQuery, ifBody, ifElse);
    }

    ExpressionNode ifQuery()
    {
        auto node = expression;

        if(front.line == last.line)
        {
            // Trailing colon separator.
            expect(LexerRules.OpColon);
        }

        return node;
    }

    StatementNode ifBody()
    {
        return statement;
    }

    StatementNode ifElse()
    {
        if(accept(LexerRules.KeyElse))
        {
            // Optional trailing colon.
            accept(LexerRules.OpColon);

            return statement;
        }
        else
        {
            return null;
        }
    }

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
           accept(LexerRules.OpTildeEquals) ||
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
           accept(LexerRules.OpQueryEquals) ||
           accept(LexerRules.OpExponentEquals))
        {
            return new AssignmentNode(node, last, assignment);
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

            return new TernaryNode(node, left, ternary);
        }

        return node;
    }

    ExpressionNode logical()
    {
        auto node = bitwise;

        if(accept(LexerRules.OpLogicalAnd) ||
           accept(LexerRules.OpLogicalOr))
        {
            return new LogicalNode(node, last, logical);
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
            return new BitwiseNode(node, last, bitwise);
        }

        return node;
    }

    ExpressionNode equality()
    {
        auto node = relation;

        if(accept(LexerRules.OpEquals) ||
           accept(LexerRules.OpNotEquals))
        {
            return new EqualityNode(node, last, equality);
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
            return new RelationNode(node, last, relation);
        }

        return node;
    }

    ExpressionNode bitshift()
    {
        auto node = addition;

        if(accept(LexerRules.OpShiftLeft) ||
           accept(LexerRules.OpShiftRight))
        {
            return new BitshiftNode(node, last, bitshift);
        }

        return node;
    }

    ExpressionNode addition()
    {
        auto node = multiplication;

        if(front.line == last.line)
        {
            if(accept(LexerRules.OpPlus) ||
               accept(LexerRules.OpMinus) ||
               accept(LexerRules.OpTilde))
            {
                return new AdditionNode(node, last, addition);
            }
        }

        return node;
    }

    ExpressionNode multiplication()
    {
        auto node = exponent;

        if(accept(LexerRules.OpTimes) ||
           accept(LexerRules.OpDivide) ||
           accept(LexerRules.OpModulo))
        {
            return new MultiplicationNode(node, last, multiplication);
        }

        return node;
    }

    ExpressionNode exponent()
    {
        auto node = prefix;

        if(accept(LexerRules.OpExponent))
        {
            return new MultiplicationNode(node, last, exponent);
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
              accept(LexerRules.OpParenLeft) ||
              accept(LexerRules.OpBracketLeft))
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
            else if(last.rule == "OpBracketLeft")
            {
                node = new SubscriptNode(node, last, expression);

                expect(LexerRules.OpBracketRight);
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
        else if(accept(LexerRules.KeyTrue) ||
                accept(LexerRules.KeyFalse))
        {
            return new BooleanNode(last);
        }
        else if(accept(LexerRules.DecLiteral) ||
                accept(LexerRules.HexLiteral))
        {
            return new IntegerNode(last);
        }
        else if(accept(LexerRules.StringLiteral))
        {
            return new StringNode(last);
        }
        else if(accept(LexerRules.OpParenLeft))
        {
            auto node = expression;

            expect(LexerRules.OpParenRight);

            return node;
        }
        else
        {
            import std.conv;
            assert(0, front.text);
        }
    }
}
