comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										   indiCam_fnc_actorManager										";
comment "																										";
comment "	This script manages who the actor is at a given time. 												";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

//TODO- Rewrite to shorten since there is a lot of duplicate code in here






// Make the following into something useful
indiCam_fnc_actorControl = {

	// First pull the clientID of the cameraman
	_clientID = owner cursorObject;

	
	// Do something to set the actor, maybe by running the map selection processDiaryLink
	indiCam_addAction_mapSelectFriendly = player addAction ["<t color='#FFFFFF'>set friendly actor</t>",{[] call woof_fnc_mapSelectFriendly}];
	indiCam_addAction_mapSelectAll = player addAction ["<t color='#FFFFFF'>set ANY actor</t>",{[] call woof_fnc_mapSelectAll}];

	
	
	// Send the variable to the cameraman through clientID
	_clientID publicVariableClient actor;
	
};









// This function switches to the closest unit of the current actor and assings the status of actor to that new unit
indiCam_fnc_actorSwitchToClosest = {

	// https://forums.bohemia.net/forums/topic/94695-how-to-find-nearest-unit-of-a-given-side/
	_nearestObjects = nearestObjects [actor,["Man"],750];
	_nearestFriendlies = [];
	if ((indiCam_var_actorSide) countSide _nearestObjects > 0) then {
		{
			private _unit = _x;
			if (((side _unit) == (indiCam_var_actorSide)) && (!isPlayer _unit) && (alive _unit) && (_unit isKindOf "Man")) then {
				_nearestFriendlies = _nearestFriendlies + [_unit]
			};
		} foreach _nearestObjects;
		
		actor = _nearestFriendlies select 0;
		indiCam_var_actorSide = side actor;

	};

	if (count _nearestFriendlies == 0) then {
		/* DEBUG */ if (indiCam_debug) then {systemChat "no AI could be found around the actor, switching to player..."};
		actor = player;
	};

};








comment "-------------------------------------------------------------------------------------------";
comment "								actor map selection											";
comment "-------------------------------------------------------------------------------------------";


// This function shows ALL units as markes on the map so that one can be selected as actor
indiCam_fnc_mapSelectAll = {

	[] spawn { // this contains sleep and thus needs to be spawned
		indiCam_var_showMarkersAll = true;
		
		while {indiCam_var_showMarkersAll} do {
		
			{ // forEach allUnits start
				private "_markername";
				if (alive _x) then { // Pull every unit that is alive
				
					// Assign each unit a unique marker
					_markername = format ["indiCamMarker%1",_x];
					_markername = createMarkerLocal [_markername,(position _x)]; 
					_markername setMarkerShapeLocal "ICON"; 
					_markername setMarkerTypeLocal "hd_dot";
				
					// Depending on attributes give the marker shape, color and text
					if ((side _x) == WEST) then {_markername setMarkerColorLocal "ColorWEST"};
					if ((side _x) == EAST) then {_markername setMarkerColorLocal "ColorEAST"};
					if ((side _x) == resistance) then {_markername setMarkerColorLocal "ColorGUER"};
					if ((side _x) == civilian) then {_markername setMarkerColorLocal "ColorCIV"};
					if ((vehicle _x isKindOf "Car")) then {_markername setMarkerTextLocal  "Car";};
					if ((vehicle _x isKindOf "Tank")) then {_markername setMarkerTextLocal  "Tank";};
					if ((vehicle _x isKindOf "Helicopter")) then {_markername setMarkerTextLocal  "Helicopter";};
					if ((vehicle _x isKindOf "Plane")) then {_markername setMarkerTextLocal  "Plane";};
					if ((vehicle _x isKindOf "Ship")) then {_markername setMarkerTextLocal  "Ship";};
					if (isPlayer _x) then {_markername setMarkerColorLocal "ColorYellow";_markername setMarkerTextLocal  "a player";};
					if (_x == actor) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal  "current actor";};
					if ((_x == actor) && (isPlayer _x)) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal  "current actor (a player)";};
				};
			} foreach allUnits;

			sleep 1;

			{
				_markername = format ["indiCamMarker%1",_x];
				deleteMarkerLocal _markername;
			} foreach allUnits;

			sleep 0.2;

			};
		if (indiCam_debug) then {systemChat "stopping markers..."};
	};
	
	
	
	if (visibleMap) then {openMap [false, false];};
	private _mapClickPos = [0,0,0];
	mapClicked = false;
	openMap [true, true];
	onMapSingleClick {
		_mapClickPos = _pos;
		private _objectArray = nearestObjects [_mapClickPos,["Man","Car","Tank","Helicopter","Plane","Ship"],100,true];
		private _unitArray = [];

		if (count _objectArray > 0) then {
			{
				private _unit = _x;
				if (
					((side _unit == (WEST)) || (side _unit == (EAST)) || (side _unit == (resistance)) || (side _unit == (civilian)))
					&& (alive _unit)
					&& ((_unit isKindOf "Man") || (_unit isKindOf "Car") || (_unit isKindOf "Tank") || (_unit isKindOf "Helicopter") || (_unit isKindOf "Plane") || (_unit isKindOf "Ship"))
					) then {
					_unitArray pushback _unit;
				};
			} foreach _objectArray;
			
			actor = _unitArray select 0;
			actorSide = side actor;
			hint format ["Actor set to %1", actor];
			mapClicked = true;
		};
		
		if (count _unitArray == 0) then {
			hint "no valid actor could be found close to that point";
			mapClicked = true;
		};

	};
	waitUntil {mapClicked};
	indiCam_var_showMarkersAll = false; // Stops displaying any markers
	openMap [false, false];
	onMapSingleClick {};
};




// This function shows FRIENDLY units as markers on the map so that one can be selected as actor
indiCam_fnc_mapSelectFriendly = {

	[] spawn { // this contains sleep and thus needs to be spawned
		indiCam_var_showMarkersAll = true;
		
		while {indiCam_var_showMarkersAll} do {
		
			{ // forEach allUnits start
				private "_markername";
				if ((alive _x) && ((side _x) == (side player))) then { // Pull every unit that is alive on the same side as the cameraman
				
					// Assign each unit a unique marker
					_markername = format ["indiCamMarker%1",_x];
					_markername = createMarkerLocal [_markername,(position _x)]; 
					_markername setMarkerShapeLocal "ICON"; 
					_markername setMarkerTypeLocal "hd_dot";
				
					// Depending on attributes give the marker shape, color and text
					if ((side _x) == WEST) then {_markername setMarkerColorLocal "ColorWEST"};
					if ((side _x) == EAST) then {_markername setMarkerColorLocal "ColorEAST"};
					if ((side _x) == resistance) then {_markername setMarkerColorLocal "ColorGUER"};
					if ((side _x) == civilian) then {_markername setMarkerColorLocal "ColorCIV"};
					if ((vehicle _x isKindOf "Car")) then {_markername setMarkerTextLocal  "Car";};
					if ((vehicle _x isKindOf "Tank")) then {_markername setMarkerTextLocal  "Tank";};
					if ((vehicle _x isKindOf "Helicopter")) then {_markername setMarkerTextLocal  "Helicopter";};
					if ((vehicle _x isKindOf "Plane")) then {_markername setMarkerTextLocal  "Plane";};
					if ((vehicle _x isKindOf "Ship")) then {_markername setMarkerTextLocal  "Ship";};
					if (isPlayer _x) then {_markername setMarkerColorLocal "ColorYellow";_markername setMarkerTextLocal  "a player";};
					if (_x == actor) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal  "current actor";};
					if ((_x == actor) && (isPlayer _x)) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal  "current actor (a player)";};
				};
			} foreach allUnits;

			sleep 1;

			{
				_markername = format ["indiCamMarker%1",_x];
				deleteMarkerLocal _markername;
			} foreach allUnits;

			sleep 0.2;

			};
		if (indiCam_debug) then {systemChat "stopping markers..."};
	};
	
	
	
	if (visibleMap) then {openMap [false, false];};
	private _mapClickPos = [0,0,0];
	mapClicked = false;
	openMap [true, true];
	onMapSingleClick {
		_mapClickPos = _pos;
		private _objectArray = nearestObjects [_mapClickPos,["Man","Car","Tank","Helicopter","Plane","Ship"],100,true];
		private _unitArray = [];

		if (count _objectArray > 0) then {
			{
				private _unit = _x;
				if (
					((side _unit == (WEST)) || (side _unit == (EAST)) || (side _unit == (resistance)) || (side _unit == (civilian)))
					&& (alive _unit)
					&& ((_unit isKindOf "Man") || (_unit isKindOf "Car") || (_unit isKindOf "Tank") || (_unit isKindOf "Helicopter") || (_unit isKindOf "Plane") || (_unit isKindOf "Ship"))
					) then {
					_unitArray pushback _unit;
				};
			} foreach _objectArray;
			
			actor = _unitArray select 0;
			actorSide = side actor;
			hint format ["Actor set to %1", actor];
			mapClicked = true;
		};
		
		if (count _unitArray == 0) then {
			hint "no valid actor could be found close to that point";
			mapClicked = true;
		};

	};
	waitUntil {mapClicked};
	indiCam_var_showMarkersAll = false; // Stops displaying any markers
	openMap [false, false];
	onMapSingleClick {};
};




comment "-------------------------------------------------------------------------------------------------------";
comment "											dead actor scene											";
comment "-------------------------------------------------------------------------------------------------------";
indiCam_fnc_actorDeath = {
// Run this deathcam scene all the way through. The new actor will be selected in the main loop after this is run through

	/* DEBUG */ if (indiCam_debug) then {systemChat "so welcome to the death cam"};

	detach indiCam;
	indiCam camSetPos (getPos indiCam);
	indiCam camSetTarget actor;
	indiCam camSetFov 0.3;
	indiCam camCommit 5;
	waitUntil {camCommitted indiCam};


	indiCam_var_actorDeathComplete = true;



};


