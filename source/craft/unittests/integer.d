
module craft.unittests.integer;

import craft;
import craft.unittests.common;

unittest // operators
{
    assert(`1 + 2`.run.asString ==  "3");
    assert(`2 + 1`.run.asString ==  "3");
    assert(`2 - 1`.run.asString ==  "1");
    assert(`1 - 2`.run.asString == "-1");

    assert(`1 + 2 + 3`.run.asString == "6");
    assert(`3 + 1 - 2`.run.asString == "2");

    assert(`3 +  2 * 4 `.run.asString == "11");
    assert(`3 *  2 + 4 `.run.asString == "10");
    assert(`3 * (2 + 4)`.run.asString == "18");

    assert(`+3 + -3`.run.asString ==  "0");
    assert(`+3 - +3`.run.asString ==  "0");
    assert(`-3 + -3`.run.asString == "-6");
    assert(`-3 - -3`.run.asString ==  "0");

    assert(`1024 / 16`.run.asString ==    "64");
    assert(`1024 * 16`.run.asString == "16384");

    assert(`2730 | 324`.run.asString == "3054");
    assert(` 740 &  82`.run.asString ==   "64");
    assert(`4123 ^ 819`.run.asString == "4904");
}

unittest // functions
{
    assert(`(-123).abs`.run.asString == "123");
    assert(`(+123).abs`.run.asString == "123");

    assert(`123.max(456)`.run.asString == "456");
    assert(`123.min(456)`.run.asString == "123");
    assert(`456.max(123)`.run.asString == "456");
    assert(`456.min(123)`.run.asString == "123");
}
