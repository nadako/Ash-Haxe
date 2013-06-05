package ash.fsm;

import ash.core.System;

interface ISystemProvider<T:System>
{
    function getSystem():T;
    var identifier(get, never):Dynamic;
    var priority(get, set):Int;
}
