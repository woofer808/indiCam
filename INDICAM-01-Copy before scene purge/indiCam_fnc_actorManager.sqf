comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										   indiCam_fnc_actorManager										";
comment "																										";
comment "	This script manages who the actor is at a given time. 												";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";


// This function does what is needed when the actor is switched
// Use _restoreActor param (bool) to set actor to a previously saved value
// Use _storedActor param to temporarily save the current actor so that he can be reverted to later
indiCam_fnc_actorChange = {
// [_unit] call indiCam_fnc_actorChange;


/*	params [
		["_newActor",actor],
		["_restoreActor",false],
		["_storedActor",actor]
	];
	*/
	
	private _newActor = _this select 0;
	private _restoreActor = false;
	
	if (_restoreActor) then {
	
		indiCam_var_storedActor = _storedActor;
	
	} else {
	
		// This is where we strip the previous actor of any previous indicam eventhandlers
		// I should probably list all eventhandlers that I defined in here
		
		actor removeEventHandler ["GetInMan",indiCam_var_enterVehicleEH];
		actor removeEventHandler ["GetOutMan",indiCam_var_exitVehicleEH];
		actor removeEventHandler ["Fired",indiCam_var_actorFiredEH];
	
		// This is where we put any new indicam eventhandlers on the new actor
		indiCam_var_enterVehicleEH = _newActor addEventHandler ["GetInMan", {
			indiCam_var_interruptScene = true;if (indiCam_debug && indiCam_runIndiCam) then {systemChat "actor mounted a vic"};
		}];
		
		// Detect actor dismounting a vic
		indiCam_var_exitVehicleEH = _newActor addEventHandler ["GetOutMan", {
			indiCam_var_interruptScene = true;if (indiCam_debug && indiCam_runIndiCam) then {systemChat "actor dismounted a vic"};
		}];
		
		// Detect actor firing his weapon
		indiCam_var_actorFiredEH = _newActor addEventHandler ["Fired", {
			indiCam_var_actorFiredTimestamp = time;if (indiCam_debug && indiCam_runIndiCam) then {systemChat "actor fired a shot"};
		}];
		
		
		
	};
	
	// Here the temporary switch to scripted actor used to break. what the hell was that anyway?
	actor = _newActor;
	indiCam_var_actorSide = side actor;
	// Just return the new actor for simplicity
	_newActor;
	
};



// Converts a supplied list of objects into a sorted ascending list of objects with the object closest to the target first.
// Result: 0.45ms for 100 units
indiCam_fnc_distanceSort = {
	
	private _array = allunits;		// If no argument is passed, assume allunits
	private _target = actor;		// If no argument is passed, assume player
	private _maxDistance = -1;		// If no argument is passed, assume entire terrain
	
	private _distance = [];			// Making private
	private _sortedArray = [];		// Making private
	
	params ["_array","_target","_maxDistance"];

	{
		// Check 2D distance
		_distance = _x distance2D _target;
		
		// Only add the unit to the list if the distance is less than maximum distance allowed, or if _maxDistance is set to -1.
		if ( (_distance < _maxDistance) or (_maxDistance == -1) ) then {
			// Store unit and corresponding distance in an array that can be sorted
			_sortedArray pushBack [_distance, _x];
		};
		
	} forEach _array;
	
	// Sort the list with ascending distances
	_sortedArray sort true;
	
	_outputArray = _sortedArray apply {_x select 1};
	_outputArray;
};






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
indiCam_fnc_actorList = {

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
		[player] call indiCam_fnc_actorChange;
	};
	
	
	// Return the array
	_actorList;
	
};



comment "-------------------------------------------------------------------------------------------------------";
comment "											dead actor scene											";
comment "-------------------------------------------------------------------------------------------------------";
indiCam_fnc_actorDeath = {
	indiCam_var_actorDeathComplete = false;
	if (indiCam_debug) then {systemChat "Welcome to the death cam."};

	// Main loop is now suspended. Do whatever you need, man.
	
	// Save the actor in a variable so that we can track him through death and rebirth if needed
	private _actorUID = getPlayerUID actor;
	
	// Use another variable for the actor in case outside scripts reassigns actor during death scene
	private _deadActor = actor;

	//If the actor was a player, spawn a script with a timeout that looks for him again
	if (isPlayer actor) then {
		[_actorUID] spawn indiCam_fnc_trackDeadActor;
	};
	
	//show the recently deceased

	detach indiCam;
	indiCam camCommit 0;
	indiCam camSetPos [(getPos _deadActor select 0)+(selectRandom [1,-1]),(getPos _deadActor select 1)+(selectRandom [1,-1]),(getPos _deadActor select 2)+2];
	indiCam camSetTarget ( ASLToAGL (eyepos actor));
	indiCam camSetFov 1;
	indiCam camCommit 0;
	waitUntil {camCommitted indiCam};
	sleep 2;
	indiCam camSetTarget ( ASLToAGL (eyepos _deadActor));
	indiCam camSetFov 2;
	indiCam camCommit 3;
	waitUntil {camCommitted indiCam};
	
	sleep 5;
	
	
	
	// Switch to whatever unit the auto switch mode is currently set to
	[] call indiCam_fnc_actorAutoSwitch;
	
	


	indiCam_var_actorDeathComplete = true;

};





// Keep track of a player actor through death in case respawn takes too long
// Run this function in the main loop when the actor has been found dead
// It has to handle the case of the actor being a remote controlled unit, so the cameraman should be included.
indiCam_fnc_trackDeadActor = {

	private _functionTimeout = 30; // This is how long in seconds the system will wait for the actor to respawn

	
	// Read the stored UID of the current actor
	private _actorUID = (_this select 0);
	
	if (isMultiplayer) then { // We only need to track players through respawn in MP

		private _timeStamp = time; // Check the time to prepare the function timeout
	
		// Start the loop that waits for the player to respawn
		private _trackLoop = true;
		while {_trackLoop} do {
			
			{
				if 	(
					((getPlayerUID _x) == _actorUID)
					&& (alive _x)
					)
				then {
					_x = actor; // If the actor was found, put the camera on him again
					indiCam_var_interruptScene = true; // Force a new scene in the main loop
					_trackLoop = false; // Stop the current loop
				};
			
			} forEach allPlayers;
		
			sleep 1; // The loop will only run once every second.
		
			// if too much time has passed since the function was started, give it up and let it down. Then run around and desert it.
			private _currentDuration = (time - _timeStamp);
		
			if (_timeStamp > _functionTimeout) then {
				if (indiCam_debug) then {systemChat "Actor didn't respawn in time"};
				_trackLoop = false; // Stop the current loop
				
			};

		};

	};

};



comment "-------------------------------------------------------------------------------------------";
comment "								actor map selection											";
comment "-------------------------------------------------------------------------------------------";


// This function shows ALL units as markes on the map so that one can be selected as actor
// Format:
// [showAllUnitsBool] call indiCam_fnc_mapSelect;
indiCam_fnc_mapSelect = { // function contains sleep and should be spawned

	player linkItem "ItemMap"; // Just in case the cameraman is spawned without a map

	// The function needs to be able to set this variable with _this select 0;
	_mapSelectMode = _this select 0;

	// If no argument is given, assume all units to be accessible
	if (isNil "_mapSelectMode") then {indiCam_var_mapselectAll = true} else {indiCam_var_mapselectAll = _mapSelectMode;}; 

	comment "-------------------------------------------------------------------------------------------";
	comment "									markers on map											";
	comment "-------------------------------------------------------------------------------------------";

	[] spawn { // this contains sleep and thus needs to be spawned
		indiCam_var_showMarkers = true;
		
		while {indiCam_var_showMarkers} do {
			private "_markername";
			private _markerArray = [];
			private _unitArray = [];
		
			// Build the correct array of units depending on if it's only friendlies or if it's all units that are to be shown
			{	// forEach allUnits only pulls alive mans of the four main factions
				if (indiCam_var_mapselectAll) then {_unitArray pushBack _x};
				if (side _x == side player && (!indiCam_var_mapselectAll)) then {_unitArray pushBack _x};
			} foreach allUnits;
			
			
			{ // Use the newly created array of units to draw markers on their pos
				// Assign each unit a unique marker
				_markername = format ["indiCamMarker%1",_x];
				_markername = createMarkerLocal [_markername,(position _x)]; 
				_markername setMarkerShapeLocal "ICON"; 
				_markername setMarkerTypeLocal "hd_dot";
				_markername setMarkerSizeLocal [1,1];
				_markerArray pushBack _markername;
			
				// Depending on attributes give the marker shape, color and text
				if ((side _x) == WEST) then {_markername setMarkerColorLocal "ColorWEST"};
				if ((side _x) == EAST) then {_markername setMarkerColorLocal "ColorEAST"};
				if ((side _x) == resistance) then {_markername setMarkerColorLocal "ColorGUER"};
				if ((side _x) == civilian) then {_markername setMarkerColorLocal "ColorCIV"};
				if ((vehicle _x isKindOf "Car")) then {_markername setMarkerTextLocal "Car";};
				if ((vehicle _x isKindOf "Tank")) then {_markername setMarkerTextLocal "Tank";};
				if ((vehicle _x isKindOf "Helicopter")) then {_markername setMarkerTextLocal "Helicopter";};
				if ((vehicle _x isKindOf "Plane")) then {_markername setMarkerTextLocal "Plane";};
				if ((vehicle _x isKindOf "Ship")) then {_markername setMarkerTextLocal "Ship";};
				if (isPlayer _x) then {_markername setMarkerColorLocal "ColorYellow";_markername setMarkerTextLocal "a player";};
				if (_x == actor) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal "current actor";};
				if ((_x == actor) && (isPlayer _x)) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal  "current actor (a player)";};
				
			} foreach _unitArray;

			sleep 0.25; // This is the update frequency of the script. onEachFrame didn't pan out well.
		
			{ // Delete all markers before drawing them again
				deleteMarkerLocal _x;
			} foreach _markerArray;
			
		};
		
		if (indiCam_debug) then {systemChat "stopping markers..."};

	};



	comment "-------------------------------------------------------------------------------------------";
	comment "							actor selection	and assignment on map							";
	comment "-------------------------------------------------------------------------------------------";
	openMap [true, false]; // Force a soft map opening
	indiCam_var_mapOpened = addMissionEventHandler ["Map",{mapClosed = true;indiCam_var_showMarkers = false;}];

	mapClosed = false;
	onMapSingleClick { // Using the old version of this EH, is that bad?
		private _friendlyUnitsData = [];
		private _allUnitsData = [];

		{ // forEach that splits all the units into separate arrays depending on if we want all or just friendlies
		
			if (!indiCam_var_mapselectAll) then {// This is for when the actor can only be on the same side as the cameraman

				if (side _x == side player) then {_friendlyUnitsData pushBack [_x,(getPos _x distance2D _pos)]};
				_friendlyUnitsData sort true;
				_unit = ((_friendlyUnitsData select 0) select 0); // Set the unit closest to the clicked position as the actor
				[_unit] call indiCam_fnc_actorChange;

			} else {// This is for when the actor can be selected from any unit
			
				_allUnitsData pushBack [_x,(getPos _x distance2D _pos)];
				_allUnitsData sort true;
				_unit = ((_allUnitsData select 0) select 0); // Set the unit closest to the clicked position as the actor
				[_unit] call indiCam_fnc_actorChange;

			};

		} forEach allUnits;
		
		hint format ["Actor set to: %1",actor];
		
	};

	waitUntil {mapClosed};
	removeMissionEventHandler ["Map", indiCam_var_mapOpened];
	onMapSingleClick {}; // empty brackets stops the eventhandler?

};














comment "-------------------------------------------------------------------------------------------------------";
comment "										main loop block													";
comment "-------------------------------------------------------------------------------------------------------";	

// Spawn the auto switching, but only run if the camera is running and auto switching is enabled
[] spawn {
	while {indiCam_runIndiCam} do {
		if (indiCam_var_actorAutoSwitch) then {
			if (indiCam_devMode) then {
				_actorAutoSwitch = [] execVM "INDICAM\functions\indiCam_fnc_actorAutoSwitch.sqf";
				waitUntil {scriptDone _actorAutoSwitch};
			} else {
				[] call indiCam_fnc_actorAutoSwitch;
				indiCam_var_interruptScene = true;
			};

			private _future = time + indiCam_var_actorAutoSwitchDuration;
			while {time <= _future} do {
				if (!indiCam_runIndiCam) exitWith {indiCam_var_actorAutoSwitch = false;}; // Stops the loop
				if (!indiCam_var_actorAutoSwitch) exitWith {}; // Stops the loop
			};
		
		};
	};
};


