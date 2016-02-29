
module craft.exception;

abstract class CraftException : Exception
{
    @nogc @safe
    this(string msg, string file = __FILE__, uint line = cast(int) __LINE__, Throwable next = null) pure nothrow
    {
        super(msg, file, line, next);
    }
}
