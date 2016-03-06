
module craft.types.field;

import craft.types;

struct CraftField
{
    CraftObject *value;

    this(CraftObject *value)
    {
        this.value = value;
    }
}
