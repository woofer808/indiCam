returnthis = compile preprocessFileLineNumbers "INDICAM\returnthis.sqf";
sleep 1;

_return = call returnthis;
_value3 = _return select 2;
hint str _value3;
