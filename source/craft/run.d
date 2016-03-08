
module craft.run;

import craft.lexer;
import craft.parser;
import craft.interpreter;
import craft.types;

@property
CraftObject *run(string input)
{
    auto lexer       = Lexer(input);
    auto parser      = Parser(lexer);
    auto interpreter = new Interpreter;

    return cast(CraftObject *) parser.start.accept(interpreter);
}
