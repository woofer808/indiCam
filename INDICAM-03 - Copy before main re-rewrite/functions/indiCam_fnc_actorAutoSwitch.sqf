comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "									   indiCam_fnc_actorAutoSwitch										";
comment "																										";
comment "	Call this script to get a new unit picked as actor.													";
comment "																										";
comment "	Sets a new actor and sets conditions.																";
comment "	Returns nothing.																					";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
/* 
Let us check all the relevant cases of units and sides:
	- All sides
		- Only players
		- Closest unit
		- All units
		- Random unit within distance
	- Only actor side
		- Only players
		- Closest unit
		- All units
		- Random unit within distance
		- Random unit in current actors' group NOT IMPLEMENTED!!
*/


/* For testing:
actor = cursortarget;
indiCam_var_actorSide = side cursortarget;
systemchat str actor;
[8,6] execVM "INDICAM\functions\indiCam_fnc_actorAutoSwitch.sqf";
sleep 0.2;
hint str actor;

*/

private _case = indiCam_var_actorAutoSwitchMode;				// If nothing was passed, assume switching occurs between what is currently set
private _maxDistance = -1;										// Default distance assumes entire terrain
private _outputArray = [];										// Declaration and reset
private _unitArray = [];										// Declaration and reset
private _tempArray = [];										// Declaration and reset


params [
		"_case",												// If _case is passed, it will override currently global setting
		"_maxDistance"											// -1 means all of the terrain if the case allows for it
	   ];

   
// Executes the proper function for each mode and kills the current running one.
switch (_case) do {

	case 0: { // Only players of all sides anywhere
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between only players of all sides.", _case];};
				
				// Get all players on the field
				if ( (count allPlayers) > 1 ) then {_unitArray = (allPlayers - [player]);} else {_unitArray = allPlayers;};
				_outputArray = _unitArray;
		
				// select a random unit from the current output array
				_unit = selectRandom _outputArray;
				[_unit] call indiCam_fnc_actorChange;
			};
			
	case 1: { // Closest unit of any side 
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to closest unit from any side.", _case];};
				
				_unitArray = [
						false,	// West
						false,	// East
						false,	// Indy
						false,	// CIV
						true,	// All units
						false,	// All players
						false	// All units on current actor's side
				] call indiCam_fnc_actorList; // about 1ms. Don't run too often.

				_outputArray = [_unitArray,actor,-1] call indiCam_fnc_distanceSort;
				_unit = _outputArray select 0;


				[_unit] call indiCam_fnc_actorChange;
			};
			
	case 2: { // Any unit of any side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between all units in mission.", _case];};
				
				// select a random unit from the current output array
				_unit = selectRandom allUnits;
				[_unit] call indiCam_fnc_actorChange;
			};
			
	case 3: { // Random unit within distance of all sides
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to units on any side within given distance.", _case];};
				
				// If the cameraguy isn't alone on the terrain, don't include him
				if ( (count allUnits) > 1 ) then {_unitArray = (allUnits - [player]);} else {_unitArray = allUnits;};
				
				_outputArray = [_unitArray,actor,_maxDistance] call indiCam_fnc_distanceSort;
				_unit = selectRandom _outputArray;
				[_unit] call indiCam_fnc_actorChange;
			};
			
	case 4: { // Only players on actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between only players on current side.", _case];};
				
				// If the cameraguy isn't alone on the terrain, don't include him
				if ( (count allPlayers) > 1 ) then {_unitArray = (allPlayers - [player]);} else {_unitArray = allPlayers;};
					
				{
					if ( ((side _x) == indiCam_var_actorSide) ) then {
						_outputArray pushBack _x;
					};
				} forEach _unitArray;
				
				
				// select a random unit from the current output array
				_unit = selectRandom _outputArray;
				[_unit] call indiCam_fnc_actorChange;
			};
			
	case 5: { // Closest unit on actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to closest unit from current side.", _case];};
				
				if ( (count allUnits) > 1 ) then {_unitArray = (allUnits - [player]);} else {_unitArray = allUnits;};
					
				{
					if ( ((side _x) == indiCam_var_actorSide) ) then {
						_outputArray pushBack _x;
					};
				} forEach _unitArray;
				
				
				// select a random unit from the current output array
				_unit = selectRandom _outputArray;
				[_unit] call indiCam_fnc_actorChange;
				
			};
			
	case 6: { // All units on actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between all on current side.", _case];};
				
				// Pull units that are on the same side as the current actor
				_unitArray = [
					false,	// West
					false,	// East
					false,	// Indy
					false,	// CIV
					false,	// All units
					false,	// All players
					true	// All units on current actor's side
				] call indiCam_fnc_actorList; // about 1ms. Don't run too often.
				
				// select a random unit from the current output array
				_unit = selectRandom _unitArray;
				[_unit] call indiCam_fnc_actorChange;
				
			};
			
	case 7: { // Random unit search started within distance actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to units on current side within given distance.", _case];};
				
				if ( (count allUnits) > 1 ) then {_unitArray = (allUnits - [player]);} else {_unitArray = allUnits;};
				
				// Preform an initial culling of the list to see if there are any suitable units within direct reach
				{
					if ( ((side _x) == indiCam_var_actorSide) && ((_x distance2D actor) < _maxDistance) ) then {
						_outputArray pushBack _x;
					};
				} forEach _unitArray;
				
				// If we haven't found anyone, expand the search incrementally until we have someone
				while {(_maxDistance < 20000) && (count _outputArray <= 1)} do {
					{
						if ( ((side _x) == indiCam_var_actorSide) && ((_x distance2D actor) < _maxDistance) ) then {
							_outputArray pushBackUnique _x;
						};
					} forEach _unitArray;
					
					// Expand the search by a factor and start over until there are enough units in _outputArray
					_maxDistance = _maxDistance * 2;
					
				};	
				
				if (count _outputArray <= 1) then {
					// If we still don't have any takers, revert to the player
					actor = player;
				} else {
					_unit = selectRandom (_outputArray - [player]);
					[_unit] call indiCam_fnc_actorChange;
					
				};
			};
			
			
	case 8: { // Random unit within group of current unit
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between units in current group.", _case];};
				
				_unit = selectRandom (units group actor);
				[_unit] call indiCam_fnc_actorChange;
				
			};
			

}; // End of switch

if (indiCam_debug) then {systemChat format ["Switched to actor: %1.", actor];};

indiCam_var_interruptScene = true;