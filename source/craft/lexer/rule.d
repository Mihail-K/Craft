
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

    /+ - Literals - +/

    Underscore = LexerRule("Underscore")
    .partial(true)
    .pattern(
        new Primitive("_")
    ),

    Zero = LexerRule("Zero")
    .partial(true)
    .pattern(
        new Primitive("0")
    ),

    /+ - Dec Literals - +/

    DecDigit = LexerRule("DecDigit")
    .partial(true)
    .pattern(
        new Bracket('0', '9')
    ),

    DecDigits = LexerRule("DecDigits")
    .partial(true)
    .pattern(
        new Sequence(
            DecDigit.pattern,
            new Optional(
                new Repetition(
                    new Selection(
                        DecDigit.pattern,
                        Underscore.pattern
                    )
                )
            )
        )
    ),

    DecLiteral = LexerRule("DecLiteral")
    .pattern(
        DecDigits.pattern
    ),

    /+ - Hex Literals - +/

    HexDigit = LexerRule("HexDigit")
    .partial(true)
    .pattern(
        new Selection(
            DecDigit.pattern,
            new Bracket('a', 'f'),
            new Bracket('A', 'F')
        )
    ),

    HexDigits = LexerRule("HexDigits")
    .partial(true)
    .pattern(
        new Sequence(
            HexDigit.pattern,
            new Optional(
                new Repetition(
                    new Selection(
                        HexDigit.pattern,
                        Underscore.pattern
                    )
                )
            )
        )
    ),

    HexPrefix = LexerRule("HexPrefix")
    .partial(true)
    .pattern(
        new Sequence(
            Zero.pattern,
            new Primitive("x", "X")
        )
    ),

    HexLiteral = LexerRule("HexLiteral")
    .pattern(
        new Sequence(
            HexPrefix.pattern,
            HexDigits.pattern
        )
    ),

    /+ - Oct Literals - +/

    OctDigit = LexerRule("OctDigit")
    .partial(true)
    .pattern(
        new Selection(
            new Bracket('0', '7')
        )
    ),

    OctDigits = LexerRule("OctDigits")
    .partial(true)
    .pattern(
        new Sequence(
            OctDigit.pattern,
            new Optional(
                new Repetition(
                    new Selection(
                        OctDigit.pattern,
                        Underscore.pattern
                    )
                )
            )
        )
    ),

    OctPrefix = LexerRule("OctPrefix")
    .partial(true)
    .pattern(
        new Sequence(
            Zero.pattern,
            new Primitive("o", "O")
        )
    ),

    OctLiteral = LexerRule("OctLiteral")
    .pattern(
        new Sequence(
            OctPrefix.pattern,
            OctDigits.pattern
        )
    ),

    /+ - String Literals - +/

    BackSlash = LexerRule("BackSlash")
    .partial(true)
    .pattern(
        new Primitive("\\")
    ),

    SingleQuote = LexerRule("SingleQuote")
    .partial(true)
    .pattern(
        new Primitive("'")
    ),

    DoubleQuote = LexerRule("DoubleQuote")
    .partial(true)
    .pattern(
        new Primitive("\"")
    ),

    EscapeCharacter = LexerRule("EscapeCharacter")
    .partial(true)
    .pattern(
        new Selection(
            new Sequence(
                BackSlash.pattern,
                new Primitive(
                    "0", "b", "f", "n", "r",
                    "t", "v", "'", "\"", "\\"
                )
            ),
            OctalEscape.pattern,
            UnicodeEscape.pattern
        )
    ),

    OctalEscape = LexerRule("OctalEscape")
    .partial(true)
    .pattern(
        new Sequence(
            BackSlash.pattern,
            new Selection(
                OctDigit.pattern,
                new Sequence(
                    OctDigit.pattern,
                    OctDigit.pattern
                ),
                new Sequence(
                    new Bracket('0', '3'),
                    OctDigit.pattern,
                    OctDigit.pattern
                )
            )
        )
    ),

    UnicodeEscape = LexerRule("UnicodeEscape")
    .partial(true)
    .pattern(
        new Sequence(
            BackSlash.pattern,
            new Primitive("u"),
            HexDigit.pattern,
            HexDigit.pattern,
            HexDigit.pattern,
            HexDigit.pattern
        )
    ),

    StringLiteral = LexerRule("StringLiteral")
    .pattern(
        new Selection(
            new Sequence(
                SingleQuote.pattern,
                new Optional(
                    new Repetition(
                        new Selection(
                            new Complement(
                                new Selection(
                                    SingleQuote.pattern,
                                    BackSlash.pattern
                                )
                            ),
                            EscapeCharacter.pattern
                        )
                    )
                ),
                SingleQuote.pattern
            ),
            new Sequence(
                DoubleQuote.pattern,
                new Optional(
                    new Repetition(
                        new Selection(
                            new Complement(
                                new Selection(
                                    DoubleQuote.pattern,
                                    BackSlash.pattern
                                )
                            ),
                            EscapeCharacter.pattern
                        )
                    )
                ),
                DoubleQuote.pattern
            )
        )
    ),

    /+ - Keywords - +/

    KeyElse = LexerRule("KeyElse")
    .pattern(
        new Primitive("else")
    ),

    KeyFalse = LexerRule("KeyFalse")
    .pattern(
        new Primitive("false")
    ),

    KeyIf = LexerRule("KeyIf")
    .pattern(
        new Primitive("if")
    ),

    KeyThis = LexerRule("KeyThis")
    .pattern(
        new Primitive("this")
    ),

    KeyTrue = LexerRule("KeyTrue")
    .pattern(
        new Primitive("true")
    ),

    /+ - Operators - +/

    OpAssign = LexerRule("OpAssign")
    .pattern(
        new Primitive("=")
    ),

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

    OpBracketLeft = LexerRule("OpBracketLeft")
    .pattern(
        new Primitive("[")
    ),

    OpBracketRight = LexerRule("OpBracketRight")
    .pattern(
        new Primitive("]")
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

    OpLogicalAnd = LexerRule("OpLogicalAnd")
    .pattern(
        new Primitive("&&", "and")
    ),

    OpLogicalAndEquals = LexerRule("OpLogicalAndEquals")
    .pattern(
        new Primitive("&&=")
    ),

    OpLogicalOr = LexerRule("OpLogicalOr")
    .pattern(
        new Primitive("||", "or")
    ),

    OpLogicalOrEquals = LexerRule("OpLogicalOrEquals")
    .pattern(
        new Primitive("||=")
    ),

    OpMinus = LexerRule("OpMinus")
    .pattern(
        new Primitive("-")
    ),

    OpMinusEquals = LexerRule("OpMinusEquals")
    .pattern(
        new Primitive("-=")
    ),

    OpMinusMinus = LexerRule("OpMinusMinus")
    .pattern(
        new Primitive("--")
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

    OpParenLeft = LexerRule("OpParenLeft")
    .pattern(
        new Primitive("(")
    ),

    OpParenRight = LexerRule("OpParenRight")
    .pattern(
        new Primitive(")")
    ),

    OpPlus = LexerRule("OpPlus")
    .pattern(
        new Primitive("+")
    ),

    OpPlusEquals = LexerRule("OpPlusEquals")
    .pattern(
        new Primitive("+=")
    ),

    OpPlusPlus = LexerRule("OpPlusPlus")
    .pattern(
        new Primitive("++")
    ),

    OpQuery = LexerRule("OpQuery")
    .pattern(
        new Primitive("?")
    ),

    OpQueryEquals = LexerRule("OpQueryEquals")
    .pattern(
        new Primitive("?=")
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

    OpBitXor = LexerRule("OpBitXor")
    .pattern(
        new Primitive("^")
    ),

    OpBitXorEquals = LexerRule("OpBitXorEquals")
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
            new Selection(
                new Bracket('a', 'z'),
                new Primitive("_")
            ),
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

    bool discard() inout
    {
        return _discard;
    }

    LexerRule discard(bool discard)
    {
        _discard = discard;

        return this;
    }

    bool internal() inout
    {
        return _pattern is null;
    }

    string name() inout
    {
        return _name;
    }

    bool partial() inout
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
