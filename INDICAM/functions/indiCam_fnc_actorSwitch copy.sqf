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
private _newActor = _this select 0;
private _unitArray = [];
private _sortedArray = [];


// Find out what side the current actor is before disconnecting him from the variable, but only if he's alive
private _actorSide = side indiCam_actor;
if (!alive indiCam_actor) then {
	_actorSide = (indiCam_var_actorSwitchSettings select 5); // Use the globally stored side instead
};

// Store the current position of the current actor
private _actorPos = getPosASL indiCam_actor;

// Make an updated list that contains only human players without current actor and cameraman
private _humanPlayerArray = allPlayers - (entities "HeadlessClient_F") - [player, indiCam_actor];
if (count _humanPlayerArray < 1) then {_humanPlayerArray = [player]}; // use the player if there is noone else
// Make an updated list that contains only units which are alive
private _allUnitsArray = allUnits - (entities "HeadlessClient_F") - [player, indiCam_actor];
if (count _allUnitsArray < 1) then {_allUnitsArray = [player]}; // use player if there is noone else


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
				// Sort out cameraman from selection, but only if he's not alone
				_newActor = selectRandom _humanPlayerArray;
				
			};
			
	case 1: { // Closest unit of any side 
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to closest unit from any side.", _case];};
				_sortedArray = [_allUnitsArray,indiCam_actor,-1] call indiCam_fnc_distanceSort; // Sort with no distance limit out from curent actor
				_newActor = _sortedArray select 0; // select the first unit in the sorted list which should be the closest
			};
			
	case 2: { // Any unit of any side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between all units in mission.", _case];};
				_newActor = selectRandom _allUnitsArray; // Select from any eligable unit that is alive
			};
			
	case 3: { // Random unit within distance (hardcoded for now) of all sides
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to units on any side within given distance.", _case];};
				private _distance = 500;

				while { ((count _sortedArray) < 1) && (_distance < 50000) } do { // Altis terrain is 47000m from corner to corner
					
					_sortedArray = [_allUnitsArray,indiCam_actor,_distance] call indiCam_fnc_distanceSort;
					_distance = _distance * 1.25; // Next iteration will happen 25% further out
				};
				if (count _sortedArray > 1) then {_newActor = selectRandom _sortedArray} else {/*No other unit was to be found, do nothing*/ };
			};
			
	case 4: { // Only players on actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between only players on current side.", _case];};
				{
					if (side _x == _actorSide) then {_sortedArray pushback _x};
				} forEach _humanPlayerArray;
				if (count _sortedArray > 1) then {_newActor = selectRandom _sortedArray} else {/*No other unit was to be found, do nothing*/ };
				
			};
			
	case 5: { // Closest unit on actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to closest unit from current side.", _case];};
				{
					if (side _x == _actorSide) then {_sortedArray pushback _x};
				} forEach _allUnitsArray;
				if (count _sortedArray > 1) then {_newActor = _sortedArray select 0} else {/*No other unit was to be found, do nothing*/ };
			};
			
	case 6: { // All units on actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between all on current side.", _case];};
				{
					if (side _x == _actorSide) then {_sortedArray pushback _x};
				} forEach _allUnitsArray;
				if (count _sortedArray > 1) then {_newActor = selectRandom _sortedArray} else {/*No other unit was to be found, do nothing*/ };
			};
			
	case 7: { // Random unit search started within distance actor side
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching to units on current side within given distance.", _case];};
				
				_unitArray = _allUnitsArray; // Rest from rewrite, couldn't be bothered to rewrite the rest

				{
					if (side _x == _actorSide) then {_sortedArray pushback _x};
				} forEach _unitArray;
				
				_unitArray = _sortedArray;
				_sortedArray = [];
				
				private _distance = 500; // Needs a gui distance, but probably on a second settings screen.
				while { ((count _unitArray) < 2) || (_distance < 50000) } do { // Altis terrain is 47000m from corner to corner
					
					_sortedArray = [_unitArray,indiCam_actor,_distance] call indiCam_fnc_distanceSort;
					_distance = _distance * 1.25;
				};
				if (count _sortedArray > 1) then {_newActor = selectRandom _sortedArray} else {/*No other unit was to be found, do nothing*/ };
			};
			
			
	case 8: { // Random unit within group of current unit
				if (indiCam_debug) then {systemChat format ["Case: %1 - Auto switching between units in current group.", _case];};

				// This is where we need to take dead units out of the pool, since they are considered part of the group until reported as dead
				// Looks like the best option is to rebuild the _unitArray from scratch
				_unitArray = [];
				{
				if (alive _x) then {_unitArray pushBackUnique _x};
				} forEach (units group indiCam_actor);

				// Take out cameraman from array in case he's in the same group but keep current actor in
				_unitArray = _unitArray - [player];
				
				// Select a random unit from the current group as long as the trimmed group size is larger than 0
				_unitsAlive = { alive _x; } count _unitArray;
				if ( _unitsAlive > 0 ) then {
					_newActor = selectRandom _unitArray;
				} else {
					// If no other unit was found, it means the actor is the lone member, or the group is dead
					// so let's find a new group to follow as close as possible

					_sortedArray = [];
					{
						if (side _x == _actorSide) then {_sortedArray pushback _x};
					} forEach _allUnitsArray;

					if (count _sortedArray > 0) then {_newActor = _sortedArray select 0} else {
						_newActor = selectRandom _allUnitsArray; // If nothing could be found, just get any unit on the terrain
					};

				};
				
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

// This is where indiCam_fnc_indiCamEHToClient should be executed


/* ----------------------------------------------------------------------------------------------------
											Store info												
   ---------------------------------------------------------------------------------------------------- */

// Store current actorSide
indiCam_var_actorSwitchSettings set [5,(side indiCam_actor)];

// Reset the actor switch timer if it's active
if (indiCam_var_actorAutoSwitch) then {
	indiCam_var_actorTimer = time + (indiCam_var_actorSwitchSettings select 4);
};


/* ----------------------------------------------------------------------------------------------------
											Return values												
   ---------------------------------------------------------------------------------------------------- */

// Return the new indiCam_actor as well
_newActor;