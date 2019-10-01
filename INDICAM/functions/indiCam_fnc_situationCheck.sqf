/*
 * Author: woofer
 * Keeps track of the situation around the actor.
 * Updates a value corresponding to a list of defined situation types.
 *
 * Arguments:
 * None
 *
 * Reutrn Value:
 * None
 *
 * Example:
 * spawn indiCam_fnc_situationCheck
 *
 * Public: No
 */

/*
vehicle values
"foot" - On foot
"car" - In a car or truck
"helicopter" - In a helicopter 
"plane" - In a plane
"tank" - In a tank
"boat" - In a boat
// not used: 6 - Scripted scenes

action levels
0 - no action
1 - low action level
2 - medium action level
3 - high action level
*/

/* ----------------------------------------------------------------------------------------------------
													init
   ---------------------------------------------------------------------------------------------------- */

private _situationCheckDebug = false;
private _actionLevel = 0;
private _vicType = 0;

private _timerFireDuration = 20;
private _timerFireFuture = 0;
private _timerFireStart = 0;
indiCam_var_actorFiredTimestamp = 0;

private _actorFired = false;

indiCam_var_actionValue = 0;
indiCam_var_movingValue = 0; // Unused for now
indiCam_var_proximityValue = 0; // Unused for now


/* ----------------------------------------------------------------------------------------------------
													main loop
   ---------------------------------------------------------------------------------------------------- */
while {indiCam_running} do {


/* ----------------------------------------------------------------------------------------------------
													turret / pylon check
   ---------------------------------------------------------------------------------------------------- */

/* UNDER CONSTRUCTION

It looks like I need to build a homebrew eventhandler that detects when the actor has switched from one turret to another
Mainly I want to know which pylon on an aircraft is currently in use.

Probably should think of it as which pylon of the actor vechicle is currently in use and create a weapon cam from that.

Commands to check:
currentWeaponTurret - Returns the name of the currently selected weapon on specified turret. Use turret path [-1] for driver's turret.
currentMagazineTurret - Returns the name of the type of the currently using magazine on specified turret. 
currentMagazineDetailTurret

weaponsTurret - Returns all weapons of given turret. Use turret path [-1] for driver's turret.


Also need to keep track of turretLocal:
A vehicle turret will change locality when player gunner gets in it, just like vehicle changes locality when player driver gets in it. Many commands for turrets work only where turret is local. When gunner leaves turret it is supposed to change locality to the locality of the vehicle.


This was interesting from Arma 3 1.69:
weaponState - Returns the currently selected weapon state for unit or vehicle. 
https://community.bistudio.com/wiki/weaponState
*/

/* ----------------------------------------------------------------------------------------------------
													vision check
   ---------------------------------------------------------------------------------------------------- */
// Checks general visibility and decides what vision mode should be active
// Only run if indiCam_var_visionIndex = 0
// Currently only switches between daylight and night vision.
// Could add check for when it's misty or under water

if (indiCam_var_visionIndex == 0) then {

	// Get the time
	_time = parseNumber (format ["%1.%2", (date select 3),(date select 4)]);
	
	// Get the times of sunrise and sunset for the current terrain
	_transition = date call BIS_fnc_sunriseSunsetTime; // Returns for example [4.159,19.456]
	
	// Turn off NVG vision some time before sunrise and turn on some time after sunset
	if ( ((_time + 0.5) > (_transition select 0)) && ((_time - 0.5) < (_transition select 1)) ) then {
		false setCamUseTI 0;camUseNVG false; // Daylight
	} else {
		false setCamUseTI 0;camUseNVG true; // Night vision
	};
	
};

/* ----------------------------------------------------------------------------------------------------
													vehicle check
   ---------------------------------------------------------------------------------------------------- */
	
if ((vehicle indiCam_actor) isKindOf "Man") then {indiCam_var_sceneType = "foot"};				// If actor is on foot
if ((vehicle indiCam_actor) isKindOf "Car") then {indiCam_var_sceneType = "car"}; 				// If actor is in a car, truck or equivalent
if ((vehicle indiCam_actor) isKindOf "Helicopter") then {indiCam_var_sceneType = "helicopter"};	// If actor is in a helicopter
if ((vehicle indiCam_actor) isKindOf "Plane") then {indiCam_var_sceneType = "plane"};			// If actor is a plane
// if ((vehicle indiCam_actor) isKindOf "Air") then {indiCam_var_sceneType = "air"};				// not used, kept for completion
if ((vehicle indiCam_actor) isKindOf "Tank") then {indiCam_var_sceneType = "tank"};				// If actor is in a tank or equivalent
if ((vehicle indiCam_actor) isKindOf "Ship") then {indiCam_var_sceneType = "ship"};				// If actor is on a boat




/* -------------------------------------------------------------------------------------------------------
 * 											action level check											
 * 																										
 * 	The action level is determined by a points system.													
 * 	Currently the action level varies between 0-3, each integer being a specific level.					
 * 																										
 * 	If the actor fires his weapon during a loop cyle, the action value goes up.							
 * 	If the actor hasn't fired his weapon during a time period, the value goes down one notch.			
 * 	The time period gets shorter the higher the action value is, thus making it harder to stay on		
 * 	higher values.																						
 * 																										
 * -------------------------------------------------------------------------------------------------------*/

	// This is a timer that resets every _timerFireDuration
	if (time > _timerFireFuture) then {

		// Check if the actor has fired his weapon during the last cycle of the timer if so, add one to fireValue
		if (indiCam_var_actorFiredTimestamp > _timerFireStart) then {
			_actionLevel = _actionLevel + 1;
			if (_actionLevel > 3) then {_actionLevel = 3}; // cap the action level at an appropriate value
			if (indiCam_debug) then {systemChat str format ["_actionLevel now at: %1", _actionLevel];};
		} else {
			_actionLevel = _actionLevel - 1;
			if (_actionLevel < 0) then {_actionLevel = 0}; // keep action level on the positive side
			if (indiCam_debug) then {systemChat str format ["_actionLevel goes down to: %1", _actionLevel];}; 
		};

		if (_actionLevel == 0) then {_timerFireDuration = 60}; // make it easier to reach higher actionLevel values
		if (_actionLevel == 1) then {_timerFireDuration = 20};
		if (_actionLevel == 2) then {_timerFireDuration = 10};
		if (_actionLevel == 3) then {_timerFireDuration = 5}; // make it harder to stay on higher actionLevel values
		_timerFireStart = time; // Reset the timer start time
		_timerFireFuture = time + _timerFireDuration; // Reset the timer, This is a count-up

	};


/* ----------------------------------------------------------------------------------------------------
								(NOT IN USE)		movement check			(NOT IN USE)
   ---------------------------------------------------------------------------------------------------- */

// This is a bit tricky as it probably should take into account what vehicle is used.


	// Store starting position for use with distance travelled calculation
	_startingPosition = position indiCam_actor;

	//Check distance travelled
	_endingPosition = position indiCam_actor;

	// If the current distance is sufficiently far enough from the starting location, make sure to use further away camera angles 
	_travelDistance = _startingPosition distance _endingposition;

	if (_travelDistance < 5) then {
		indiCam_var_movingValue = 0;
		// systemChat "Currently not moving";
		}
	else {
		if ((_travelDistance > 5) && (_traveldistance < 10)) then {
			indiCam_var_movingValue = 1;
			// systemChat "Far from starting position, currently traversing slowly";
			};
		if ((_travelDistance > 10) && (_traveldistance < 20)) then {
			indiCam_var_movingValue = 2;
			// systemChat "Far from starting position, currently traversing fast";
			};
		if (_travelDistance > 20) then {
			indiCam_var_movingValue = 3;
			// systemChat "Far from starting position, currently traversing very fast";
			};
	};


/* ----------------------------------------------------------------------------------------------------
							(NOT IN USE)		surrounding terrain check			(NOT IN USE)
   ---------------------------------------------------------------------------------------------------- */
	// Check what type of terrain there is around the actor. Test for buildings for example, I dunno really.
	indiCam_var_proximityValue = 0; // this has to be replaced with proper tests

/* ----------------------------------------------------------------------------------------------------
												end of main loop
   ---------------------------------------------------------------------------------------------------- */	
	
sleep indiCam_var_situationCheck; // Duration of situation check loop
}; // End of main loop
if (indiCam_debug) then {systemChat "stopping indiCam_fnc_situationCheck...";};
