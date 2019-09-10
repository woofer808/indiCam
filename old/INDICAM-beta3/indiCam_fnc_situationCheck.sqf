comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										  indiCam_fnc_situationCheck										";
comment "																										";
comment "	This script keeps track of the situation around the actor 											";
comment "	Updates a value corresponding to a list of defined situation types									";
comment "-------------------------------------------------------------------------------------------------------";

/*
vehicle values
0 - On foot
1 - In a car, truck or tank
2 - In a helicopter or a plane
3 - In a boat

action levels
0 - no action
1 - low action level
2 - medium action level
3 - high action level
*/

//TODO- Add proximity to enemies as a way to elevate the action value
//TODO- Moving value should be used to stay on at least action value 1
//TODO- Maybe should spawn several different action system checks that can work independently


comment "-------------------------------------------------------------------------------------------------------";
comment "												init													";
comment "-------------------------------------------------------------------------------------------------------";

private _loopDuration = 2; // This is the cycle time of this script's main loop
private _situationCheckDebug = false;
private _actionLevel = 0;
private _vicValue = 0;

private _timerFireDuration = 20;
private _timerFireFuture = 0;
private _timerFireStart = 0;
indiCam_var_actorFiredTimestamp = 0;

private _actorFired = false;



indiCam_var_vicValue = 0;
indiCam_var_actionValue = 0;
indiCam_var_movingValue = 0; // Unused
indiCam_var_proximityValue = 0; // Unused




comment "-------------------------------------------------------------------------------------------------------";
comment "											event handlers												";
comment "-------------------------------------------------------------------------------------------------------";

// Detect actor firing his weapon
actor addEventHandler ["Fired", {if (_situationCheckDebug) then {systemChat "actor fired a shot"}; indiCam_var_actorFiredTimestamp = time;}];

// Detect actor taking hits
actor addEventHandler ["Dammaged", {if (_situationCheckDebug) then {systemChat "actor took damage"};_actorDamagedTimestamp = time;}];

// Detect actor mounting a vic
actor addEventHandler ["GetInMan", {if (_situationCheckDebug) then {systemChat "actor mounted a vic"};_actorMountedTimestamp = time;}];

// Detect actor dismounting a vic
actor addEventHandler ["GetOutMan", {if (_situationCheckDebug) then {systemChat "actor dismounted a vic"};_actorDismountedTimestamp = time;}];




comment "-------------------------------------------------------------------------------------------------------";
comment "												main loop												";
while {indiCam_runIndiCam} do {
comment "-------------------------------------------------------------------------------------------------------";





	
comment "-------------------------------------------------------------------------------------------------------";
comment "												vehicle check											";
comment "-------------------------------------------------------------------------------------------------------";
	
	if ((vehicle actor) iskindof "Man") then {_vicValue = 0}; // If actor is on foot
	if ((vehicle actor) iskindof "Car") then {_vicValue = 1}; // If actor is in a car, truck or equivalent
	if ((vehicle actor) iskindof "Helicopter") then {_vicValue = 2}; // If actor is in a helicopter
	if ((vehicle actor) iskindof "Plane") then {_vicValue = 2}; // If actor is a plane
	// if ((vehicle actor) iskindof "Air") then {_vicValue = 2}; // If actor is in either a plane or a helicopter
	if ((vehicle actor) iskindof "Tank") then {_vicValue = 3}; // If actor is in a tank or equivalent
	if ((vehicle actor) iskindof "Ship") then {_vicValue = 4}; // If actor is on a boat

	


comment "-------------------------------------------------------------------------------------------------------";
comment "											action level check											";
comment "																										";
comment "	The action level is determined by a points system.													";
comment "	Currently the action level varies between 0-3, each integer being a specific level.					";
comment "																										";
comment "	If the actor fires his weapon during a period of time, the action value goes up.					";
comment "	If the actor hasn't fired his weapon during a time period, the value goes down one notch.			";
comment "	The time period gets shorter the higher the action value is, thus making it harder to stay on		";
comment "	higher values.																						";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

	// This is a timer that resets every _timerFireDuration
	if (time > _timerFireFuture) then {

		// Check if the actor has fired his weapon during the last cycle of the timer if so, add one to fireValue
		if (indiCam_var_actorFiredTimestamp > _timerFireStart) then {
			_actionLevel = _actionLevel + 1;
			if (_actionLevel > 3) then {_actionLevel = 3}; // cap the action level at an appropriate value
			if (indiCam_debug) then {systemChat str format ["_actionLevel goes up to: %1", _actionLevel];};
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




comment "-------------------------------------------------------------------------------------------------------";
comment "						(NOT IN USE)		movement check			(NOT IN USE)						";
comment "-------------------------------------------------------------------------------------------------------";
// This is a bit tricky as it probably should take into account what vehicle is used.



	// Store starting position for use with distance travelled calculation
	_startingPosition = position actor;

	//Check distance travelled
	_endingPosition = position actor;

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


comment "-------------------------------------------------------------------------------------------------------";
comment "					(NOT IN USE)		surrounding terrain check			(NOT IN USE)				";
comment "-------------------------------------------------------------------------------------------------------";
	// Check what type of terrain there is around the actor. Test for buildings for example, I dunno really.
	indiCam_var_proximityValue = 0; // this has to be replaced with proper tests


	
	

comment "-------------------------------------------------------------------------------------------------------";
comment "											return values												";
	
	indiCam_var_actionValue = _actionLevel;
	indiCam_var_vicValue = _vicValue;
	
comment "-------------------------------------------------------------------------------------------------------";

	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "											end of main loop												";
sleep _loopDuration; // Duration of status check
}; // End of main loop
if (indiCam_debug) then {systemChat "stopping indiCam_fnc_situationCheck..."};
comment "-------------------------------------------------------------------------------------------------------";	
	



