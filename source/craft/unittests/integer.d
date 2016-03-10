
module craft.unittests.integer;

import craft;

import std.algorithm;
import std.math;

unittest // operators
{
    assert(`1 + 2`.run.asLong ==  3);
    assert(`2 + 1`.run.asLong ==  3);
    assert(`2 - 1`.run.asLong ==  1);
    assert(`1 - 2`.run.asLong == -1);

    assert(`1 + 2 + 3`.run.asLong == 6);
    assert(`3 + 1 - 2`.run.asLong == 2);

    assert(`3 +  2 * 4 `.run.asLong == 11);
    assert(`3 *  2 + 4 `.run.asLong == 10);
    assert(`3 * (2 + 4)`.run.asLong == 18);

    assert(`+3 + -3`.run.asLong ==  0);
    assert(`+3 - +3`.run.asLong ==  0);
    assert(`-3 + -3`.run.asLong == -6);
    assert(`-3 - -3`.run.asLong ==  0);

    assert(`1024 / 16`.run.asLong ==    64);
    assert(`1024 * 16`.run.asLong == 16384);

    assert(`2730 | 324`.run.asLong == 3054);
    assert(` 740 &  82`.run.asLong ==   64);
    assert(`4123 ^ 819`.run.asLong == 4904);
}

unittest // functions
{
    assert(`(-123).abs`.run.asLong == abs(-123));
    assert(`(+123).abs`.run.asLong == abs(+123));

    assert(`123.max(456)`.run.asLong == 123.max(456));
    assert(`123.min(456)`.run.asLong == 123.min(456));
    assert(`456.max(123)`.run.asLong == 456.max(123));
    assert(`456.min(123)`.run.asLong == 123.min(123));
}
