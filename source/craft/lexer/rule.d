
module craft.lexer.rule;

import pattern;

import std.ascii;

enum LexerRules : LexerRule
{
    /+ - Whitespace - +/

    Whitespace = LexerRule("Whitespace")
    .discard(true)
    .pattern(
        repeat!isWhite
    ),

    /+ - Comments - +/

    LineComment = LexerRule("LineComment")
    .discard(true)
    .pattern(
        sequence!(
            primitive!("//"),
            optional!(
                repeat!(
                    complement!(
                        primitive!("\n")
                    )
                )
            ),
            primitive!("\n")
        )
    ),

    BlockComment = LexerRule("BlockComment")
    .discard(true)
    .pattern(
        sequence!(
            primitive!("/*"),
            optional!(
                repeat!(
                    complement!(
                        primitive!("*/")
                    )
                )
            ),
            primitive!("*/")
        )
    ),

    /+ - Literals - +/

    Underscore = LexerRule("Underscore")
    .partial(true)
    .pattern(
        primitive!("_")
    ),

    Zero = LexerRule("Zero")
    .partial(true)
    .pattern(
        primitive!("0")
    ),

    /+ - Dec Literals - +/

    DecDigit = LexerRule("DecDigit")
    .partial(true)
    .pattern(
        bracket!('0', '9')
    ),

    DecDigits = LexerRule("DecDigits")
    .partial(true)
    .pattern(
        sequence!(
            DecDigit.pattern(),
            optional!(
                repeat!(
                    selection!(
                        DecDigit.pattern(),
                        Underscore.pattern()
                    )
                )
            )
        )
    ),

    DecLiteral = LexerRule("DecLiteral")
    .pattern(
        DecDigits.pattern()
    ),

    /+ - Hex Literals - +/

    HexDigit = LexerRule("HexDigit")
    .partial(true)
    .pattern(
        selection!(
            DecDigit.pattern(),
            bracket!('a', 'f'),
            bracket!('A', 'F')
        )
    ),

    HexDigits = LexerRule("HexDigits")
    .partial(true)
    .pattern(
        sequence!(
            HexDigit.pattern(),
            optional!(
                repeat!(
                    selection!(
                        HexDigit.pattern(),
                        Underscore.pattern()
                    )
                )
            )
        )
    ),

    HexPrefix = LexerRule("HexPrefix")
    .partial(true)
    .pattern(
        sequence!(
            Zero.pattern(),
            primitive!("x", "X")
        )
    ),

    HexLiteral = LexerRule("HexLiteral")
    .pattern(
        sequence!(
            HexPrefix.pattern(),
            HexDigits.pattern()
        )
    ),

    /+ - Oct Literals - +/

    OctDigit = LexerRule("OctDigit")
    .partial(true)
    .pattern(
        selection!(
            bracket!('0', '7')
        )
    ),

    OctDigits = LexerRule("OctDigits")
    .partial(true)
    .pattern(
        sequence!(
            OctDigit.pattern(),
            optional!(
                repeat!(
                    selection!(
                        OctDigit.pattern(),
                        Underscore.pattern()
                    )
                )
            )
        )
    ),

    OctPrefix = LexerRule("OctPrefix")
    .partial(true)
    .pattern(
        sequence!(
            Zero.pattern(),
            primitive!("o", "O")
        )
    ),

    OctLiteral = LexerRule("OctLiteral")
    .pattern(
        sequence!(
            OctPrefix.pattern(),
            OctDigits.pattern()
        )
    ),

    /+ - String Literals - +/

    BackSlash = LexerRule("BackSlash")
    .partial(true)
    .pattern(
        primitive!("\\")
    ),

    SingleQuote = LexerRule("SingleQuote")
    .partial(true)
    .pattern(
        primitive!("'")
    ),

    DoubleQuote = LexerRule("DoubleQuote")
    .partial(true)
    .pattern(
        primitive!("\"")
    ),

    EscapeCharacter = LexerRule("EscapeCharacter")
    .partial(true)
    .pattern(
        selection!(
            sequence!(
                BackSlash.pattern(),
                primitive!(
                    "0", "b", "f", "n", "r",
                    "t", "v", "'", "\"", "\\"
                )
            ),
            OctalEscape.pattern(),
            UnicodeEscape.pattern()
        )
    ),

    OctalEscape = LexerRule("OctalEscape")
    .partial(true)
    .pattern(
        sequence!(
            BackSlash.pattern(),
            selection!(
                OctDigit.pattern(),
                sequence!(
                    OctDigit.pattern(),
                    OctDigit.pattern()
                ),
                sequence!(
                    bracket!('0', '3'),
                    OctDigit.pattern(),
                    OctDigit.pattern()
                )
            )
        )
    ),

    UnicodeEscape = LexerRule("UnicodeEscape")
    .partial(true)
    .pattern(
        sequence!(
            BackSlash.pattern(),
            primitive!("u"),
            HexDigit.pattern(),
            HexDigit.pattern(),
            HexDigit.pattern(),
            HexDigit.pattern()
        )
    ),

    StringLiteral = LexerRule("StringLiteral")
    .pattern(
        selection!(
            sequence!(
                SingleQuote.pattern(),
                optional!(
                    repeat!(
                        selection!(
                            complement!(
                                selection!(
                                    SingleQuote.pattern(),
                                    BackSlash.pattern()
                                )
                            ),
                            EscapeCharacter.pattern()
                        )
                    )
                ),
                SingleQuote.pattern()
            ),
            sequence!(
                DoubleQuote.pattern(),
                optional!(
                    repeat!(
                        selection!(
                            complement!(
                                selection!(
                                    DoubleQuote.pattern(),
                                    BackSlash.pattern()
                                )
                            ),
                            EscapeCharacter.pattern()
                        )
                    )
                ),
                DoubleQuote.pattern()
            )
        )
    ),

    /+ - Keywords - +/

    KeyElse = LexerRule("KeyElse")
    .pattern(
        primitive!("else")
    ),

    KeyEnd = LexerRule("KeyEnd")
    .pattern(
        primitive!("end")
    ),

    KeyFalse = LexerRule("KeyFalse")
    .pattern(
        primitive!("false")
    ),

    KeyIf = LexerRule("KeyIf")
    .pattern(
        primitive!("if")
    ),

    KeyIs = LexerRule("KeyIs")
    .pattern(
        primitive!("is")
    ),

    KeyNot = LexerRule("KeyNot")
    .pattern(
        primitive!("not")
    ),

    KeyNull = LexerRule("KeyNull")
    .pattern(
        primitive!("null")
    ),

    KeyThis = LexerRule("KeyThis")
    .pattern(
        primitive!("this")
    ),

    KeyTrue = LexerRule("KeyTrue")
    .pattern(
        primitive!("true")
    ),

    /+ - Operators - +/

    OpAssign = LexerRule("OpAssign")
    .pattern(
        primitive!("=")
    ),

    OpBang = LexerRule("OpBang")
    .pattern(
        primitive!("!")
    ),

    OpBitAnd = LexerRule("OpBitAnd")
    .pattern(
        primitive!("&")
    ),

    OpBitAndEquals = LexerRule("OpBitAndEquals")
    .pattern(
        primitive!("&=")
    ),

    OpBitOr = LexerRule("OpBitOr")
    .pattern(
        primitive!("|")
    ),

    OpBitOrEquals = LexerRule("OpBitOrEquals")
    .pattern(
        primitive!("|=")
    ),

    OpBracketLeft = LexerRule("OpBracketLeft")
    .pattern(
        primitive!("[")
    ),

    OpBracketRight = LexerRule("OpBracketRight")
    .pattern(
        primitive!("]")
    ),

    OpColon = LexerRule("OpColon")
    .pattern(
        primitive!(":")
    ),

    OpComma = LexerRule("OpComma")
    .pattern(
        primitive!(",")
    ),

    OpDivide = LexerRule("OpDivide")
    .pattern(
        primitive!("/")
    ),

    OpDivideEquals = LexerRule("OpDivideEquals")
    .pattern(
        primitive!("/=")
    ),

    OpDot = LexerRule("OpDot")
    .pattern(
        primitive!(".")
    ),

    OpEquals = LexerRule("OpEquals")
    .pattern(
        primitive!("==")
    ),

    OpExponent = LexerRule("OpExponent")
    .pattern(
        primitive!("^^")
    ),

    OpExponentEquals = LexerRule("OpExponentEquals")
    .pattern(
        primitive!("^^=")
    ),

    OpGreater = LexerRule("OpGreater")
    .pattern(
        primitive!(">")
    ),

    OpGreaterEquals = LexerRule("OpGreaterEquals")
    .pattern(
        primitive!(">=")
    ),

    OpLess = LexerRule("OpLess")
    .pattern(
        primitive!("<")
    ),

    OpLessEquals = LexerRule("OpLessEquals")
    .pattern(
        primitive!("<=")
    ),

    OpLogicalAnd = LexerRule("OpLogicalAnd")
    .pattern(
        primitive!("&&", "and")
    ),

    OpLogicalAndEquals = LexerRule("OpLogicalAndEquals")
    .pattern(
        primitive!("&&=")
    ),

    OpLogicalOr = LexerRule("OpLogicalOr")
    .pattern(
        primitive!("||", "or")
    ),

    OpLogicalOrEquals = LexerRule("OpLogicalOrEquals")
    .pattern(
        primitive!("||=")
    ),

    OpMinus = LexerRule("OpMinus")
    .pattern(
        primitive!("-")
    ),

    OpMinusEquals = LexerRule("OpMinusEquals")
    .pattern(
        primitive!("-=")
    ),

    OpMinusMinus = LexerRule("OpMinusMinus")
    .pattern(
        primitive!("--")
    ),

    OpModulo = LexerRule("OpModulo")
    .pattern(
        primitive!("%")
    ),

    OpNotEquals = LexerRule("OpNotEquals")
    .pattern(
        primitive!("!=")
    ),

    OpModuloEquals = LexerRule("OpModuloEquals")
    .pattern(
        primitive!("%=")
    ),

    OpParenLeft = LexerRule("OpParenLeft")
    .pattern(
        primitive!("(")
    ),

    OpParenRight = LexerRule("OpParenRight")
    .pattern(
        primitive!(")")
    ),

    OpPlus = LexerRule("OpPlus")
    .pattern(
        primitive!("+")
    ),

    OpPlusEquals = LexerRule("OpPlusEquals")
    .pattern(
        primitive!("+=")
    ),

    OpPlusPlus = LexerRule("OpPlusPlus")
    .pattern(
        primitive!("++")
    ),

    OpQuery = LexerRule("OpQuery")
    .pattern(
        primitive!("?")
    ),

    OpQueryEquals = LexerRule("OpQueryEquals")
    .pattern(
        primitive!("?=")
    ),

    OpShiftLeft = LexerRule("OpShiftLeft")
    .pattern(
        primitive!("<<")
    ),

    OpShiftLeftEquals = LexerRule("OpShiftLeftEquals")
    .pattern(
        primitive!("<<=")
    ),

    OpShiftRight = LexerRule("OpShiftRight")
    .pattern(
        primitive!(">>")
    ),

    OpShiftRightEquals = LexerRule("OpShiftRightEquals")
    .pattern(
        primitive!(">>=")
    ),

    OpTilde = LexerRule("OpTilde")
    .pattern(
        primitive!("~")
    ),

    OpTildeEquals = LexerRule("OpTildeEquals")
    .pattern(
        primitive!("~=")
    ),

    OpTimes = LexerRule("OpTimes")
    .pattern(
        primitive!("*")
    ),

    OpTimesEquals = LexerRule("OpTimesEquals")
    .pattern(
        primitive!("*=")
    ),

    OpBitXor = LexerRule("OpBitXor")
    .pattern(
        primitive!("^")
    ),

    OpBitXorEquals = LexerRule("OpBitXorEquals")
    .pattern(
        primitive!("^=")
    ),

    /+ - Identifiers - +/

    IdentifierDollar = LexerRule("IdentifierDollar")
    .pattern(
        sequence!(
            primitive!("$"),
            optional!(
                repeat!(
                    IdentifierFragment.pattern()
                )
            )
        )
    ),

    IdentifierLower = LexerRule("IdentifierLower")
    .pattern(
        sequence!(
            selection!(
                bracket!('a', 'z'),
                primitive!("_")
            ),
            optional!(
                repeat!(
                    IdentifierFragment.pattern()
                )
            )
        )
    ),

    IdentifierUpper = LexerRule("IdentifierUpper")
    .pattern(
        sequence!(
            bracket!('A', 'Z'),
            optional!(
                repeat!(
                    IdentifierFragment.pattern()
                )
            )
        )
    ),

    IdentifierFragment = LexerRule("IdentifierFragment")
    .partial(true)
    .pattern(
        selection!(
            bracket!('a', 'z'),
            bracket!('A', 'Z'),
            bracket!('0', '9'),
            primitive!("_")
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

    Pattern pattern() inout
    {
        return _pattern;
    }

    LexerRule pattern(Pattern pattern)
    {
        _pattern = pattern;

        return this;
    }
}
