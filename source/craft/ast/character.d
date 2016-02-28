
module craft.ast.character;

import craft.ast;
import craft.lexer;

final class CharacterNode : LiteralNode
{
    mixin Visitable;

    this(LexerToken token)
    {
        super(token);
    }
}
