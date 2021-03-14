/*
 * Author: woofer
 * Assign a new actor according to actor autoswitch.
 * If nothing is passed to the function, it assumes values from actorAutoSwitch settings.
 * If a unit is passed to the function it will migrate all properties to this new actor.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * New Actor <OBJECT>
 *
 * Example:
 * [player] call indiCam_fnc_actorSwitch
 *
 * Public: No
 */

// Default setting, make better by figuring out how params really work
private _newActor = player;
private _unitArray = [];
private _sortedArray = [];

// Find out what side the current actor is before disconnecting him from the variable
private _actorSide = side indiCam_actor;
// Store the current position of the current actor
private _actorPos = getPosASL indiCam_actor;


// Get all the current autoswitch preferences
private _switchSide = indiCam_var_actorSwitchSettings select 0; // Actor switch SIDE [0=WEST,1=EAST,2=resistance,3=civilian,4=all,5=actorSide]
private _switchPlayersOnly = indiCam_var_actorSwitchSettings select 1; 		  // Restrict to players only
private _switchProximity = indiCam_var_actorSwitchSettings select 2; 		  // random unit within this proximity of actor (-1 means closest)
private _autoSwitchDurationSwitch = indiCam_var_actorSwitchSettings select 3; // Actor auto switch is off/on
private _autoSwitchDuration = indiCam_var_actorSwitchSettings select 4; 	  // Actor auto switch duration
	
/* ----------------------------------------------------------------------------------------------------
									In case where no unit was passed to the function
   ---------------------------------------------------------------------------------------------------- */

// Check if a unit was passed to the script. If not, use current autoswitch settings.
if (str _this == "[]") then { // There really should be a more elegant way to do this check, right?


private _case = (indiCam_var_actorSwitchSettings select 0);	// If nothing was passed, assume switching occurs between what is currently set

// Executes the proper function for each mode and kills the current running one.
switch (_case) do {

	case 0: { // Only players of all sides anywhere
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between only players of all sides.", _case];};
				_newActor = selectRandom allPlayers;
			};
			
	case 1: { // Closest unit of any side 
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to closest unit from any side.", _case];};
				_unitArray = (allUnits - [player,indiCam_actor]);
				_sortedArray = [_unitArray,indiCam_actor,-1] call indiCam_fnc_distanceSort;
				_newActor = _sortedArray select 0;
			};
			
	case 2: { // Any unit of any side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between all units in mission.", _case];};
				_unitArray = (allUnits - [player]);
				_newActor = selectRandom _unitArray;
			};
			
	case 3: { // Random unit within distance of all sides
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to units on any side within given distance.", _case];};
				_unitArray = (allUnits - [player]);
				private _distance = 500;

				while { ((count _sortedArray) < 1) && (_distance < 50000) } do { // Altis terrain is 47000m from corner to corner
					
					_sortedArray = [_unitArray,indiCam_actor,_distance] call indiCam_fnc_distanceSort;

					_distance = _distance * 1.25;
				};
				if (count _sortedArray > 1) then {_newActor = selectRandom _sortedArray} else {/*No other unit was to be found, do nothing*/ };
			};
			
	case 4: { // Only players on actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between only players on current side.", _case];};
				_unitArray = allPlayers - [player];
				{
					if (side _x == _actorSide) then {_sortedArray pushback _x};
				} forEach _unitArray;
				if (count _sortedArray > 1) then {_newActor = selectRandom _sortedArray} else {/*No other unit was to be found, do nothing*/ };
				
			};
			
	case 5: { // Closest unit on actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to closest unit from current side.", _case];};
				_unitArray = allUnits - [player,indiCam_actor];
				{
					if (side _x == _actorSide) then {_sortedArray pushback _x};
				} forEach _unitArray;
				if (count _sortedArray > 1) then {_newActor = _sortedArray select 0} else {/*No other unit was to be found, do nothing*/ };
			};
			
	case 6: { // All units on actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between all on current side.", _case];};
				_unitArray = allUnits - [player,indiCam_actor];
				{
					if (side _x == _actorSide) then {_sortedArray pushback _x};
				} forEach _unitArray;
				if (count _sortedArray > 1) then {_newActor = selectRandom _sortedArray} else {/*No other unit was to be found, do nothing*/ };
			};
			
	case 7: { // Random unit search started within distance actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to units on current side within given distance.", _case];};
				
				_unitArray = allUnits - [player,indiCam_actor];

				{
					if (side _x == _actorSide) then {_sortedArray pushback _x};
				} forEach _unitArray;
				
				_unitArray = _sortedArray;
				_sortedArray = [];
				
				private _distance = 500;
				while { ((count _unitArray) < 2) || (_distance < 50000) } do { // Altis terrain is 47000m from corner to corner
					
					_sortedArray = [_unitArray,indiCam_actor,_distance] call indiCam_fnc_distanceSort;
					_distance = _distance * 1.25;
				};
				if (count _sortedArray > 1) then {_newActor = selectRandom _sortedArray} else {/*No other unit was to be found, do nothing*/ };
			};
			
			
	case 8: { // Random unit within group of current unit
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between units in current group.", _case];};
				_unitArray = (units group indiCam_actor);
				_unitArray = _unitArray - [player];
				
				if ( (count _unitArray) > 0 ) then {_newActor = selectRandom _unitArray} else {/*No other unit was to be found, do nothing*/ };
				
			};
			

}; // End of switch

/* ----------------------------------------------------------------------------------------------------
									In case where a unit was passed													
   ---------------------------------------------------------------------------------------------------- */

// If there was something passed to this script, use that.
} else {
	_newActor = (_this select 0);
};

/* ----------------------------------------------------------------------------------------------------
											Eventhandlers												
   ---------------------------------------------------------------------------------------------------- */

[_newActor] call indiCam_fnc_indiCamEHToClient;


/* ----------------------------------------------------------------------------------------------------
											Return values												
   ---------------------------------------------------------------------------------------------------- */



// Set the actor variable to the newly setup unit
indiCam_actor = _newActor;

// Store current actorSide
indiCam_var_actorSwitchSettings set [5,(side indiCam_actor)];

// Reset the actor switch timer if it's active
if (indiCam_var_actorAutoSwitch) then {
	indiCam_var_actorTimer = time + (indiCam_var_actorSwitchSettings select 4);
};


// Return the new indiCam_actor as well
_newActor;