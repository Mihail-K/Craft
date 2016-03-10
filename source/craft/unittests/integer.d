
module craft.unittests.integer;

import craft;

unittest // operators
{
    assert(`1 + 2`.run.coerceString ==  "3");
    assert(`2 + 1`.run.coerceString ==  "3");
    assert(`2 - 1`.run.coerceString ==  "1");
    assert(`1 - 2`.run.coerceString == "-1");

    assert(`1 + 2 + 3`.run.coerceString == "6");
    assert(`3 + 1 - 2`.run.coerceString == "2");

    assert(`3 +  2 * 4 `.run.coerceString == "11");
    assert(`3 *  2 + 4 `.run.coerceString == "10");
    assert(`3 * (2 + 4)`.run.coerceString == "18");

    assert(`+3 + -3`.run.coerceString ==  "0");
    assert(`+3 - +3`.run.coerceString ==  "0");
    assert(`-3 + -3`.run.coerceString == "-6");
    assert(`-3 - -3`.run.coerceString ==  "0");

    assert(`1024 / 16`.run.coerceString ==    "64");
    assert(`1024 * 16`.run.coerceString == "16384");

    assert(`2730 | 324`.run.coerceString == "3054");
    assert(` 740 &  82`.run.coerceString ==   "64");
    assert(`4123 ^ 819`.run.coerceString == "4904");
}

unittest // functions
{
    assert(`(-123).abs`.run.coerceString == "123");
    assert(`(+123).abs`.run.coerceString == "123");

    assert(`123.max(456)`.run.coerceString == "456");
    assert(`123.min(456)`.run.coerceString == "123");
    assert(`456.max(123)`.run.coerceString == "456");
    assert(`456.min(123)`.run.coerceString == "123");
}
