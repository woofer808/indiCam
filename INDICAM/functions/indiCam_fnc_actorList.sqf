


// Outputs an array with eligible actors that the camera can use to switch to.
/* COPYPASTA
				_unitArray = [
					true,	// West
					false,	// East
					false,	// Indy
					false,	// CIV
					false,	// All units
					false,	// All players
					false	// All units from current actor side
				] call indiCam_fnc_actorList; // about 1ms
*/
//Result: 0.74 ms for 100 units

// Setup of function inputs
params ["_west",		// bool
		"_east",		// bool
		"_guer",		// bool
		"_civ",			// bool
		"_all",			// bool
		"_allPlayers",	// bool
		"_actorSide"	// bool
		];
	
private _actorList = []; // Declare function array

// Go through all the units and only add the eligible to the list
{

	if ( (_x != player) && (alive _x) ) then { // Adding this check is 33% faster than doing it in all the ones below on each _x

		if ( (_west or _all) and (side _x == WEST) ) then {_actorList pushBackUnique _x;};
		if ( (_east or _all) and (side _x == EAST) ) then {_actorList pushBackUnique _x;};
		if ( (_civ or _all) and (side _x == civilian) ) then {_actorList pushBackUnique _x;};
		if ( (_guer or _all) and (side _x == resistance) ) then {_actorList pushBackUnique _x;};
		
		if ( ((_allPlayers) and (isPlayer _x)) ) then {_actorList pushBackUnique _x;};

		if ( (_actorSide) and ((side _x) == indiCam_var_actorSide) ) then {_actorList pushBackUnique _x;};
	
	};
	
} forEach allUnits;



// If no actor could be found to populate the list, set the player as actor
if ((count _actorList) < 1) then {
	if (indiCam_debug) then {systemChat "No eligible actors found."};
	[player] call indiCam_fnc_actorSwitch;
};


// Return the array
_actorList;


