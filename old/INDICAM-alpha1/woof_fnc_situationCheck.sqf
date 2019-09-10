comment "-------------------------------------------------------------------------------------------";
comment "This script keeps track of the situation around the actor									";
comment "Outputs a value corresponding to a list of defined situation types							";
comment "-------------------------------------------------------------------------------------------";


/*
vicValue
0 - On foot
1 - In a car, truck or tank
2 - In a helicopter or a plane
3 - In a boat

actionLevel = movingValue + terrainValue + fireValue
0 - no action
1 - low action level
2 - medium action level
3 - high action level

*/



private _loopDuration = 2; // This is the cycle time of this script's main loop

private _situationCheckDebug = false;
private _actionLevel = 0;
private _vicValue = 0;

private _timerFireDuration = 20;
private _timerFireFuture = 0;
private _timerFireStart = 0;
actorFiredTimestamp = 0;

private _actorFired = false;


situationCheck = [];
proximityValue = 0;
movingValue = 0;
vicValue = 0;
actionValue = 0;






comment "-------------------------------------------------------------------------------------------------------";
comment "				Start whatever eventhandlers that are to be used.										";
comment "Detect shots fired by actor (won't work from inside a vic which should be good. Use FiredMan for vics)	";
comment "					FiredNear, only works to a distance of 69m											";
comment "-------------------------------------------------------------------------------------------------------";


// I think I need a namespace for all eventhandlers


// Detect actor firing his weapon
actor addEventHandler ["Fired", {if (_situationCheckDebug) then {systemChat "actor fired a shot"}; actorFiredTimestamp = time;}];

// Detect actor taking hits
actor addEventHandler ["Dammaged", {if (_situationCheckDebug) then {systemChat "actor took damage"};_actorDamagedTimestamp = time;}];
// Detect actor mounting a vic
actor addEventHandler ["GetInMan", {if (_situationCheckDebug) then {systemChat "actor mounted a vic"};_actorMountedTimestamp = time;}];
// Detect actor dismounting a vic
actor addEventHandler ["GetOutMan", {if (_situationCheckDebug) then {systemChat "actor dismounted a vic"};_actorDismountedTimestamp = time;}];




situationCheckRunning = true;

while {runIndiCam} do {


// Check what type of terrain there is around the actor. Test for buildings for example
	proximityValue = 0; // this has to be replaced with proper tests




	// Check actor vehicle status
	if ((vehicle actor) iskindof "Man") then {_vicValue = 0};
	if ((vehicle actor) iskindof "Car") then {_vicValue = 1};
	if ((vehicle actor) iskindof "Tank") then {_vicValue = 1};
	if ((vehicle actor) iskindof "Helicopter") then {_vicValue = 2};
	if ((vehicle actor) iskindof "Plane") then {_vicValue = 2};
	// if ((vehicle actor) iskindof "Air") then {_vicValue = 2};
	if ((vehicle actor) iskindof "Ship") then {_vicValue = 1};

	// return the value to global
	situationCheck = [movingValue,_actionLevel,proximityValue,_vicValue];
	
	
	



	// Store starting position for use with distance travelled calculation
	_startingPosition = position actor;

	//Check distance travelled
	_endingPosition = position actor;

	// If the current distance is sufficiently far enough from the starting location, make sure to use further away camera angles 
	_travelDistance = _startingPosition distance _endingposition;

	if (_travelDistance < 5) then {
		movingValue = 0;
		// systemChat "Currently not moving";
		}
	else {
		if ((_travelDistance > 5) && (_traveldistance < 10)) then {
			movingValue = 1;
			// systemChat "Far from starting position, currently traversing slowly";
			};
		if ((_travelDistance > 10) && (_traveldistance < 20)) then {
			movingValue = 2;
			// systemChat "Far from starting position, currently traversing fast";
			};
		if (_travelDistance > 20) then {
			movingValue = 3;
			// systemChat "Far from starting position, currently traversing very fast";
			};
	};





comment "-------------------------------------------------------------------------------------------------------";
comment "										actionLevel														";
comment "																										";
comment "The action level is determined by a points system														";
comment "Currently the action level varies between 0-3, each integer being a specific level						";
comment "For each set amount of time, the action value goes up every time the actor shoots (more planned)		";
comment "For every time period that no action is happening, the value goes down one notch until it reaches zero	";
comment "-------------------------------------------------------------------------------------------------------";

	// This is a timer that resets every _timerFireDuration
	if (time > _timerFireFuture) then {

		// Check if the actor has fired his weapon during the last cycle of the timer if so, add one to fireValue
		if (actorFiredTimestamp > _timerFireStart) then {
			_actionLevel = _actionLevel + 1;
			if (_actionLevel > 3) then {_actionLevel = 3}; // cap the action level at an appropriate value
			if (indiCamDebug) then {systemChat str format ["_actionLevel goes up to: %1", _actionLevel];};
		} else {
			_actionLevel = _actionLevel - 1;
			if (_actionLevel < 0) then {_actionLevel = 0}; // keep action level on the positive side
			if (indiCamDebug) then {systemChat str format ["_actionLevel goes down to: %1", _actionLevel];}; 
		};

		if (_actionLevel == 0) then {_timerFireDuration = 60}; // make it easier to reach higher actionLevel values
		if (_actionLevel == 1) then {_timerFireDuration = 20};
		if (_actionLevel == 2) then {_timerFireDuration = 10};
		if (_actionLevel == 3) then {_timerFireDuration = 5}; // make it harder to stay on higher actionLevel values
		_timerFireStart = time; // Reset the timer start time
		_timerFireFuture = time + _timerFireDuration; // Reset the timer, This is a count-up

	};





comment "-------------------------------------------------------------------------------------------------------";
comment "									Return values														";
comment "-------------------------------------------------------------------------------------------------------";
	
	
	actionValue = _actionLevel;
	situationCheck = [_vicValue,_actionLevel];
	vicValue = _vicValue; // Clean this away used in other scripts
	

// Duration of status check
sleep _loopDuration;
}; // End of main loop


if (indiCamDebug) then {systemChat "stopping woof_fnc_situationCheck..."};

