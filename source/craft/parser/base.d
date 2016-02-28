
module craft.parser.base;

import craft.lexer;

struct Parser
{
private:
    Lexer _lexer;

public:
    this(Lexer lexer)
    {
        _lexer = lexer;
    }

    void start()
    {
        expression;
    }

private:
    void advance()
    {
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

private:
    void expression()
    {
        equality;
    }

    void equality()
    {
        relation;

        while(accept(LexerRules.OpEquals) ||
              accept(LexerRules.OpNotEquals))
        {
            relation;
        }
    }

    void relation()
    {
        bitshift;

        while(accept(LexerRules.OpLess) ||
              accept(LexerRules.OpGreater) ||
              accept(LexerRules.OpLessEquals) ||
              accept(LexerRules.OpGreaterEquals))
        {
            bitshift;
        }
    }

    void bitshift()
    {
        addition;

        while(accept(LexerRules.OpShiftLeft) ||
              accept(LexerRules.OpShiftRight))
        {
            addition;
        }
    }

    void addition()
    {
        multiplication;

        while(accept(LexerRules.OpPlus) ||
              accept(LexerRules.OpMinus))
        {
            multiplication;
        }
    }

    void multiplication()
    {
        terminal;

        while(accept(LexerRules.OpTimes) ||
              accept(LexerRules.OpDivide) ||
              accept(LexerRules.OpModulo))
        {
            terminal;
        }
    }

    void terminal()
    {
        if(accept(LexerRules.IdentifierLower))
        {
            // TODO
        }
        else if(accept(LexerRules.IdentifierUpper))
        {
            // TODO
        }
        else if(accept(LexerRules.IdentifierDollar))
        {
            // TODO
        }
        else
        {
            assert(0);
        }
    }


}
