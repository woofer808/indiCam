comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										  indiCam_fnc_unitCooldown										";
comment "																										";
comment "	Call this script to add to/remove from, or check if a unit is on cooldown list.						";
comment "																										";
comment "	Returns true when unit already exists on cooldown list.												";
comment "	Returns false when unit had to be added to cooldown list.											";
comment "	Returns true if _checkUnit was passed while also finding the unit on the list.						";
comment "	Returns false if _checkUnit was passed while not finding the unit on the list.						";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

// Checking the list for a unit: 0.24ms
// Trying to add a unit to the list: 0.61ms


private _checkUnit = false; // Sets default value that can be overwritten by params
params ["_unit","_cooldownTime","_checkUnit"];


private "_return";


// Everytime the cooldown list is accessed, cull it for obsolete units
{
	if 	(
	(!alive (_x select 0)) 	// If the unit isn't alive
	or
	( time > (_x select 1))  // OR if the cooldown timer has run out (mission time is later than stored value)
	) then {				// Then remove the unit from the list
		
		indiCam_var_unitCooldown deleteAt _forEachIndex; // Confirmed working, probably because "forEach var" resolves "var" before continuing
		
	};
} forEach indiCam_var_unitCooldown;



// When one of the required params isn't passed to the function, the cooldown list is simply updated by skipping the rest of the code
if 	(
		(isNil "_unit")
		or
		(isNil "_cooldownTime")	
	)
then {
	
	if (indiCam_debug) then {systemChat "Nothing was passed to the function, so indiCam_var_unitCooldown was updated."};
		
} else {


	// Now with the remaining list
	// Split the cooldown array into two temporary arrays
	private _tempUnits = [];
	private _tempTimes = [];
	indiCam_var_unitCooldown apply {
		_tempUnits pushBack (_x select 0);
		_tempTimes pushBack (_x select 1);
	};
	
	// Check if the selected unit exists within the array and store its index
	private _findUnit = _tempUnits find _unit;
	
	
	
	
	// When the "check unit on list" bool was passed, return whether unit exists on the cooldown list
	if (_checkUnit && (_findUnit != -1) ) exitWith {
		if (indiCam_debug) then {systemChat "unit was found in cooldown array"};
		true;
	};
	if (_checkUnit && (_findUnit == -1) ) exitWith {
		if (indiCam_debug) then {systemChat "unit was not found in cooldown array"};
		false;
	};

	
	
	
	if ( _findUnit != -1 ) then { // If the unit was found on cooldown
		
		// If it does, grab its corresponding cooldown value
		_checkTime = _tempTimes select _findUnit;
		
		if (indiCam_debug) then {systemChat "unit was found in cooldown array"};
		_return = true;

	} else { // If the passed unit wasn't on the list, we can suppose it should be added along with its cooldown value
		
		_tempUnits pushBack _unit;
		_tempTimes pushBack (time + _cooldownTime);
		
		if (indiCam_debug) then {systemChat "unit was not found in cooldown array"};
		_return = false;
		
	};


	// Bake the new list in a global variable for later use
	indiCam_var_unitCooldown = [];
	{
		indiCam_var_unitCooldown pushBack [(_tempUnits select _forEachIndex),(_tempTimes select _forEachIndex)];
	} forEach _tempUnits;

	
	
	//_return;
};
