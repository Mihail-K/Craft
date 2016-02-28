
module craft.lexer.rule;

import craft.pattern;

import std.ascii;

enum LexerRules : LexerRule
{
    /+ - Whitespace - +/

    Whitespace = LexerRule("Whitespace")
    .discard(true)
    .pattern(
        new Repetition(
            new Callback(
                input => input[0].isWhite ? [ input[0] ] : null
            )
        )
    ),

    /+ - Comments - +/

    LineComment = LexerRule("LineComment")
    .discard(true)
    .pattern(
        new Sequence(
            new Primitive("//"),
            new Optional(
                new Repetition(
                    new Complement(
                        new Primitive("\n")
                    )
                )
            ),
            new Primitive("\n")
        )
    ),

    BlockComment = LexerRule("BlockComment")
    .discard(true)
    .pattern(
        new Sequence(
            new Primitive("/*"),
            new Optional(
                new Repetition(
                    new Complement(
                        new Primitive("*/")
                    )
                )
            ),
            new Primitive("*/")
        )
    ),

    /+ - Keywords - +/

    /+ - Operators - +/

    OpBang = LexerRule("OpBang")
    .pattern(
        new Primitive("!")
    ),

    OpBitAnd = LexerRule("OpBitAnd")
    .pattern(
        new Primitive("&")
    ),

    OpBitAndEquals = LexerRule("OpBitAndEquals")
    .pattern(
        new Primitive("&=")
    ),

    OpBitOr = LexerRule("OpBitOr")
    .pattern(
        new Primitive("|")
    ),

    OpBitOrEquals = LexerRule("OpBitOrEquals")
    .pattern(
        new Primitive("|=")
    ),

    OpColon = LexerRule("OpColon")
    .pattern(
        new Primitive(":")
    ),

    OpComma = LexerRule("OpComma")
    .pattern(
        new Primitive(",")
    ),

    OpDivide = LexerRule("OpDivide")
    .pattern(
        new Primitive("/")
    ),

    OpDivideEquals = LexerRule("OpDivideEquals")
    .pattern(
        new Primitive("/=")
    ),

    OpDot = LexerRule("OpDot")
    .pattern(
        new Primitive(".")
    ),

    OpEquals = LexerRule("OpEquals")
    .pattern(
        new Primitive("==")
    ),

    OpGreater = LexerRule("OpGreater")
    .pattern(
        new Primitive(">")
    ),

    OpGreaterEquals = LexerRule("OpGreaterEquals")
    .pattern(
        new Primitive(">=")
    ),

    OpLess = LexerRule("OpLess")
    .pattern(
        new Primitive("<")
    ),

    OpLessEquals = LexerRule("OpLessEquals")
    .pattern(
        new Primitive("<=")
    ),

    OpMinus = LexerRule("OpMinus")
    .pattern(
        new Primitive("-")
    ),

    OpMinusEquals = LexerRule("OpMinusEquals")
    .pattern(
        new Primitive("-=")
    ),

    OpModulo = LexerRule("OpModulo")
    .pattern(
        new Primitive("%")
    ),

    OpNotEquals = LexerRule("OpNotEquals")
    .pattern(
        new Primitive("!=")
    ),

    OpModuloEquals = LexerRule("OpModuloEquals")
    .pattern(
        new Primitive("%=")
    ),

    OpPlus = LexerRule("OpPlus")
    .pattern(
        new Primitive("+")
    ),

    OpPlusEquals = LexerRule("OpPlusEquals")
    .pattern(
        new Primitive("+=")
    ),

    OpShiftLeft = LexerRule("OpShiftLeft")
    .pattern(
        new Primitive("<<")
    ),

    OpShiftLeftEquals = LexerRule("OpShiftLeftEquals")
    .pattern(
        new Primitive("<<=")
    ),

    OpShiftRight = LexerRule("OpShiftRight")
    .pattern(
        new Primitive(">>")
    ),

    OpShiftRightEquals = LexerRule("OpShiftRightEquals")
    .pattern(
        new Primitive(">>=")
    ),

    OpTilde = LexerRule("OpTilde")
    .pattern(
        new Primitive("~")
    ),

    OpTildeEquals = LexerRule("OpTildeEquals")
    .pattern(
        new Primitive("~=")
    ),

    OpTimes = LexerRule("OpTimes")
    .pattern(
        new Primitive("*")
    ),

    OpTimesEquals = LexerRule("OpTimesEquals")
    .pattern(
        new Primitive("*=")
    ),

    OpXor = LexerRule("OpXor")
    .pattern(
        new Primitive("^")
    ),

    OpXorEquals = LexerRule("OpXorEquals")
    .pattern(
        new Primitive("^=")
    ),

    /+ - Identifiers - +/

    IdentifierDollar = LexerRule("IdentifierDollar")
    .pattern(
        new Sequence(
            new Primitive("$"),
            new Optional(
                new Repetition(
                    LexerRules.IdentifierFragment.pattern
                )
            )
        )
    ),

    IdentifierLower = LexerRule("IdentifierLower")
    .pattern(
        new Sequence(
            new Bracket('a', 'z'),
            new Optional(
                new Repetition(
                    LexerRules.IdentifierFragment.pattern
                )
            )
        )
    ),

    IdentifierUpper = LexerRule("IdentifierUpper")
    .pattern(
        new Sequence(
            new Bracket('A', 'Z'),
            new Optional(
                new Repetition(
                    LexerRules.IdentifierFragment.pattern
                )
            )
        )
    ),

    IdentifierFragment = LexerRule("IdentifierFragment")
    .partial(true)
    .pattern(
        new Selection(
            new Bracket('a', 'z'),
            new Bracket('A', 'Z'),
            new Bracket('0', '9'),
            new Primitive("_")
        )
    ),

    /+ - Internal Rules - +/

    Error     = LexerRule("<Error>"),
    EndOfFile = LexerRule("<EOF>")
}

struct LexerRule
{
private:
    bool    _discard;
    string  _name;
    bool    _partial;
    Pattern _pattern;

public:
    this(string name)
    {
        _name = name;
    }

    bool discard() const
    {
        return _discard;
    }

    LexerRule discard(bool discard)
    {
        _discard = discard;

        return this;
    }

    bool internal() const
    {
        return _pattern is null;
    }

    bool partial() const
    {
        return _partial;
    }

    LexerRule partial(bool partial)
    {
        _partial = partial;

        return this;
    }

    Pattern pattern()
    {
        return _pattern;
    }

    LexerRule pattern(Pattern pattern)
    {
        _pattern = pattern;

        return this;
    }
}
