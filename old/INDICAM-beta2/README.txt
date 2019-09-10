--------------------------------------------------------------------------------------------------
											i n d i C a m - 2
--------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------
											C H A N G E L O G
--------------------------------------------------------------------------------------------------
- Markers are no longer broadcasted to other clients or servers
- More stable stable line of sight check for objects and terrain





--------------------------------------------------------------------------------------------------
									U S E F U L    C O M M A N D S
---------------------------------------------------------------------------------------------------
player onMapSingleClick "if (_alt) then {player setPosATL _pos}";

actor = player;publicvariable "actor";

actor = cursortarget;publicvariable "actor";


[] execVM "INDICAM\indiCam_main.sqf";


removeallactions player;
_pos = getpos player;
sleep 1;
player setpos [0,0,0];
sleep 1;
player setpos _pos;

indiCam camCommand "manual on";indiCamManual = true;


