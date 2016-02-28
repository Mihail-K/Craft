
module craft.lexer.rule;

import craft.matcher;

import std.ascii;

enum LexerRules : LexerRule
    /+ - Whitespace - +/

    Whitespace = LexerRule("Whitespace")
    .discard(true)
    .matcher(
        new Callback(
            input => input[0].isWhite ? [ input[0] ] : null
        )
    ),

    /+ - Comments - +/

    LineComment = LexerRule("LineComment")
    .discard(true)
    .matcher(
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
    .matcher(
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
    .matcher(
        new Primitive("!")
    ),

    OpBitAnd = LexerRule("OpBitAnd")
    .matcher(
        new Primitive("&")
    ),

    OpBitAndEquals = LexerRule("OpBitAndEquals")
    .matcher(
        new Primitive("&=")
    ),

    OpBitOr = LexerRule("OpBitOr")
    .matcher(
        new Primitive("|")
    ),

    OpBitOrEquals = LexerRule("OpBitOrEquals")
    .matcher(
        new Primitive("|=")
    ),

    OpColon = LexerRule("OpColon")
    .matcher(
        new Primitive(":")
    ),

    OpComma = LexerRule("OpComma")
    .matcher(
        new Primitive(",")
    ),

    OpDivide = LexerRule("OpDivide")
    .matcher(
        new Primitive("/")
    ),

    OpDivideEquals = LexerRule("OpDivideEquals")
    .matcher(
        new Primitive("/=")
    ),

    OpDot = LexerRule("OpDot")
    .matcher(
        new Primitive(".")
    ),

    OpEquals = LexerRule("OpEquals")
    .matcher(
        new Primitive("==")
    ),

    OpGreater = LexerRule("OpGreater")
    .matcher(
        new Primitive(">")
    ),

    OpGreaterEquals = LexerRule("OpGreaterEquals")
    .matcher(
        new Primitive(">=")
    ),

    OpLess = LexerRule("OpLess")
    .matcher(
        new Primitive("<")
    ),

    OpLessEquals = LexerRule("OpLessEquals")
    .matcher(
        new Primitive("<=")
    ),

    OpMinus = LexerRule("OpMinus")
    .matcher(
        new Primitive("-")
    ),

    OpMinusEquals = LexerRule("OpMinusEquals")
    .matcher(
        new Primitive("-=")
    ),

    OpModulo = LexerRule("OpModulo")
    .matcher(
        new Primitive("%")
    ),

    OpNotEquals = LexerRule("OpNotEquals")
    .matcher(
        new Primitive("!=")
    ),

    OpModuloEquals = LexerRule("OpModuloEquals")
    .matcher(
        new Primitive("%=")
    ),

    OpPlus = LexerRule("OpPlus")
    .matcher(
        new Primitive("+")
    ),

    OpPlusEquals = LexerRule("OpPlusEquals")
    .matcher(
        new Primitive("+=")
    ),

    OpShiftLeft = LexerRule("OpShiftLeft")
    .matcher(
        new Primitive("<<")
    ),

    OpShiftLeftEquals = LexerRule("OpShiftLeftEquals")
    .matcher(
        new Primitive("<<=")
    ),

    OpShiftRight = LexerRule("OpShiftRight")
    .matcher(
        new Primitive(">>")
    ),

    OpShiftRightEquals = LexerRule("OpShiftRightEquals")
    .matcher(
        new Primitive(">>=")
    ),

    OpTilde = LexerRule("OpTilde")
    .matcher(
        new Primitive("~")
    ),

    OpTildeEquals = LexerRule("OpTildeEquals")
    .matcher(
        new Primitive("~=")
    ),

    OpTimes = LexerRule("OpTimes")
    .matcher(
        new Primitive("*")
    ),

    OpTimesEquals = LexerRule("OpTimesEquals")
    .matcher(
        new Primitive("*=")
    ),

    OpXor = LexerRule("OpXor")
    .matcher(
        new Primitive("^")
    ),

    OpXorEquals = LexerRule("OpXorEquals")
    .matcher(
        new Primitive("^=")
    ),

    /+ - Identifiers - +/

    IdentifierLower = LexerRule("IdentifierDollar")
    .matcher(
        new Sequence(
            new Primitive("$"),
            new Optional(
                new Repetition(
                    LexerRules.IdentifierFragment.matcher
                )
            )
        )
    ),

    IdentifierLower = LexerRule("IdentifierLower")
    .matcher(
        new Sequence(
            new Bracket('a', 'z'),
            new Optional(
                new Repetition(
                    LexerRules.IdentifierFragment.matcher
                )
            )
        )
    ),

    IdentifierUpper = LexerRule("IdentifierUpper")
    .matcher(
        new Sequence(
            new Bracket('A', 'Z'),
            new Optional(
                new Repetition(
                    LexerRules.IdentifierFragment.matcher
                )
            )
        )
    ),

    IdentifierFragment = LexerRule("IdentifierFragment")
    .fragment(true)
    .matcher(
        new Selection(
            new Bracket('a', 'z'),
            new Bracket('A', 'Z'),
            new Bracket('0', '9'),
            new Primitive("_")
        )
    ),

    /+ - Internal Rules - +/

    Error     = LexerRule("<Error>"),
    EndOfFiel = LexerRule("<EOF>")
];

struct LexerRule
{
private:
    bool    _discard;
    Matcher _matcher;
    string  _name;
    bool    _partial;

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
        return _matcher is null;
    }

    Matcher matcher()
    {
        return _matcher;
    }

    LexerRule matcher(Matcher matcher)
    {
        _matcher = matcher;

        return this;
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
}
