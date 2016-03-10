
module craft.parser.base;

import craft.ast;
import craft.lexer;
import craft.parser.exception;

import std.exception;

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
            nodes ~= expression;
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
        enforce(accept(rule), new ExpectFailedException(rule, last, front));
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
        LexerToken[] operators;
        ExpressionNode[] nodes = [ if_ ];

        while(accept(LexerRules.OpAssign) ||
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
            operators ~= last;
            nodes ~= if_;
        }

        if(operators.length)
        {
            return new AssignmentNode(nodes, operators);
        }
        else
        {
            return nodes[0];
        }
    }

    ExpressionNode if_()
    {
        if(accept(LexerRules.KeyIf))
        {
            return new IfNode(expression, ifBody, ifElse);
        }

        return ternary;
    }

    ExpressionNode ifBody()
    {
        if(front.line == last.line)
        {
            // Trailing colon separator.
            expect(LexerRules.OpColon);

            return expression;
        }
        else
        {
            ExpressionNode[] nodes;

            while(!match(LexerRules.KeyEnd) &&
                  !match(LexerRules.KeyElse))
            {
                nodes ~= expression;
            }

            return new ExpressionListNode(nodes);
        }
    }

    ExpressionNode ifElse()
    {
        if(accept(LexerRules.KeyElse))
        {
            if(front.line == last.line)
            {
                // Optional trailing colon.
                accept(LexerRules.OpColon);

                return expression;
            }
            else
            {
                ExpressionNode[] nodes;

                while(!accept(LexerRules.KeyEnd))
                {
                    nodes ~= expression;
                }

                return new ExpressionListNode(nodes);
            }
        }
        else
        {
            expect(LexerRules.KeyEnd);

            return null;
        }
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
        LexerToken[] operators;
        ExpressionNode[] nodes = [ bitwise ];

        while(accept(LexerRules.OpLogicalAnd) ||
              accept(LexerRules.OpLogicalOr))
        {
            operators ~= last;
            nodes ~= bitwise;
        }

        if(operators.length)
        {
            return new LogicalNode(nodes, operators);
        }
        else
        {
            return nodes[0];
        }
    }

    ExpressionNode bitwise()
    {
        LexerToken[] operators;
        ExpressionNode[] nodes = [ equality ];

        while(accept(LexerRules.OpBitAnd) ||
              accept(LexerRules.OpBitOr) ||
              accept(LexerRules.OpBitXor))
        {
            operators ~= last;
            nodes ~= equality;
        }

        if(operators.length)
        {
            return new BitwiseNode(nodes, operators);
        }
        else
        {
            return nodes[0];
        }
    }

    ExpressionNode equality()
    {
        LexerToken[] operators;
        ExpressionNode[] nodes = [ relation ];

        while(accept(LexerRules.OpEquals) ||
              accept(LexerRules.OpNotEquals))
        {
            operators ~= last;
            nodes ~= relation;
        }

        if(operators.length)
        {
            return new EqualityNode(nodes, operators);
        }
        else
        {
            return nodes[0];
        }
    }

    ExpressionNode relation()
    {
        LexerToken[] operators;
        ExpressionNode[] nodes = [ bitshift ];

        while(accept(LexerRules.OpLess) ||
              accept(LexerRules.OpGreater) ||
              accept(LexerRules.OpLessEquals) ||
              accept(LexerRules.OpGreaterEquals) ||
              accept(LexerRules.KeyIs))
        {
            // If matched `is` operator, check for not keyword.
            last.rule == "KeyIs" && accept(LexerRules.KeyNot);

            operators ~= last;
            nodes ~= bitshift;
        }

        if(operators.length)
        {
            return new RelationNode(nodes, operators);
        }
        else
        {
            return nodes[0];
        }
    }

    ExpressionNode bitshift()
    {
        LexerToken[] operators;
        ExpressionNode[] nodes = [ addition ];

        while(accept(LexerRules.OpShiftLeft) ||
              accept(LexerRules.OpShiftRight))
        {
            operators ~= last;
            nodes ~= addition;
        }

        if(operators.length)
        {
            return new BitshiftNode(nodes, operators);
        }
        else
        {
            return nodes[0];
        }
    }

    ExpressionNode addition()
    {
        LexerToken[] operators;
        ExpressionNode[] nodes = [ multiplication ];

        while(front.line == last.line && (
              accept(LexerRules.OpPlus) ||
              accept(LexerRules.OpMinus) ||
              accept(LexerRules.OpTilde)))
        {
            operators ~= last;
            nodes ~= multiplication;
        }

        if(operators.length)
        {
            return new AdditionNode(nodes, operators);
        }
        else
        {
            return nodes[0];
        }
    }

    ExpressionNode multiplication()
    {
        LexerToken[] operators;
        ExpressionNode[] nodes = [ exponent ];

        while(accept(LexerRules.OpTimes) ||
              accept(LexerRules.OpDivide) ||
              accept(LexerRules.OpModulo))
        {
            operators ~= last;
            nodes ~= exponent;
        }

        if(operators.length)
        {
            return new MultiplicationNode(nodes, operators);
        }
        else
        {
            return nodes[0];
        }
    }

    ExpressionNode exponent()
    {
        LexerToken[] operators;
        ExpressionNode[] nodes = [ prefix ];

        if(accept(LexerRules.OpExponent))
        {
            operators ~= last;
            nodes ~= prefix;
        }

        if(operators.length)
        {
            return new MultiplicationNode(nodes, operators);
        }
        else
        {
            return nodes[0];
        }
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

        while(accept(LexerRules.OpDot) ||
              accept(LexerRules.OpPlusPlus) ||
              accept(LexerRules.OpMinusMinus) ||
              accept(LexerRules.OpParenLeft) ||
              accept(LexerRules.OpBracketLeft))
        {
            if(last.rule == "OpDot")
            {
                node = new AccessNode(node, last, identifier);
            }
            else if(last.rule == "OpParenLeft")
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

    IdentifierNode identifier()
    {
        if(accept(LexerRules.IdentifierLower))
        {
            return new IdentifierNode.Lower(last);
        }
        else if(accept(LexerRules.IdentifierUpper))
        {
            return new IdentifierNode.Upper(last);
        }
        else
        {
            expect(LexerRules.IdentifierDollar); // TODO

            return new IdentifierNode.Dollar(last);
        }
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
        else if(accept(LexerRules.KeyNull))
        {
            return new NullNode;
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
            throw new UnexpectedTokenException(last, front);
        }
    }
}
