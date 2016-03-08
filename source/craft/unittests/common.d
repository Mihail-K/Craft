
module craft.unittests.common;

import craft;

@property
string asString(CraftObject *instance)
{
    return instance.invoke("string").as!string;
}
