
module craft.parser.exception;

import craft.exception;
import craft.lexer;

import std.string;

final class ExpectFailedException : CraftException
{
    this(LexerRule expected, LexerToken last, LexerToken front)
    {
        super("Error on line %d:%d : Expected `%s` after `%s`, got `%s`.".format(
            front.line, front.offset, expected.name, last.text, front.text
        ));
    }
}

final class UnexpectedTokenException : CraftException
{
    this(LexerToken last, LexerToken front)
    {
        super("Error on line %d:%d : Unexpected `%s` after `%s`.".format(
            front.line, front.offset, front.text, last.text
        ));
    }
}
