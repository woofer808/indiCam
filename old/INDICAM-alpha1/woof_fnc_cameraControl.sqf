comment "-------------------------------------------------------------------------------------------";
comment "								woof_fnc_cameraControl										";
comment "																							";
comment "This purpose of this script is to keep the indiCam controls updated for the player			";
comment "It's epecially important for when remote control is used									";
comment "																							";
comment "Control is mainly for the non cameraman actor, but it might be a good idea to let the		";
comment "cameraman be able to do the same, which is easier.											";
comment "																							";
comment "-------------------------------------------------------------------------------------------";

if (indiCamDebug) then {systemChat str "camera control running"};


/*
_myaction = player addAction ["Hello", "hello.sqs"];
This stores the action's ID in the local variable "_myaction" and assists in keeping track of the action ID. To remove the above action, you would use the following line:
player removeAction _myaction;
*/
indiCam_addAction_start = player addAction ["<t color='#FFFFFF'>run indiCam</t>", {runIndiCam = true;}]; // this starts the script
indiCam_addAction_mapSelect = player addAction ["<t color='#FFFFFF'>set actor on map</t>",{[] call woof_fnc_mapSelect}];
indiCam_addAction_playerControl = player addAction ["<t color='#FFFFFF'>Take player control</t>",{[] call woof_fnc_playerControl}];


// This EH waits for button press that terminates the script
[] spawn {
	while {true} do {
		waituntil {runIndiCam};
		while {runIndiCam} do {
			waituntil {inputAction "SelectGroupUnit1" > 0}; // F1 to stop indiCam
			if (indiCamDebug) then {systemChat "F1-key pressed"};
			runIndiCam = false;
			sleep 1;
		};
	};
};



// This EH waits for button press that forces the next scene
interruptScene = false;
[] spawn {
	while {true} do {
		waituntil {runIndiCam};
		while {!interruptScene} do {
			waituntil {inputAction "SelectGroupUnit2" > 0}; // F2 to force next scene
			if (indiCamDebug) then {systemChat "F2-key pressed"};
			interruptScene = true;
			sleep 1;
		};
	};
};



// This EH waits for button press that toggles manual camera on/off
[] spawn {
	indiCamManual = false;
	while {true} do {
		waituntil {runIndiCam};
		while {runIndiCam} do {
			waituntil {inputAction "SelectGroupUnit3" > 0}; // F3 to toggle manual mode
			if (indiCamDebug) then {systemChat "F3-key pressed"};
			
			if (!indiCamManual) then {
				indiCam camCommand "manual on";indiCamManual = true;
				if (indiCamDebug) then {systemChat "manual on"};
			} else {
				indiCam camCommand "manual off";indiCamManual = false;
				if (indiCamDebug) then {systemChat "manual off"};
			};
			sleep 1;
		};
	};
};



// This function shows markes on the map so that units can be selected as actor
woof_fnc_mapSelect = {

	[] spawn {
	showMarkersAll = true;
	while {showMarkersAll} do {
		{
			private "_markername";
			if (alive _x) then {
				_markername = format ["indiCamMarker%1",_x];
				_markername = createMarkerLocal [_markername,(position _x)]; 
				_markername setMarkerShapeLocal "ICON"; 
				_markername setMarkerTypeLocal "hd_dot";
				
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
	if (indiCamDebug) then {systemChat "stopping markers..."};
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
	showMarkersAll = false; // Stops displaying any markers
	openMap [false, false];
	onMapSingleClick {};
};










visionModeRunning = true;
[] spawn {
	camUseNVG false;
	false setCamUseTI 0;
	visionIndex = -1;
	while {visionModeRunning} do {
		waitUntil {(inputAction "SelectGroupUnit5" > 0) or (inputAction "SelectGroupUnit6" > 0)};
		sleep 1;
		if (visionIndex == -1) then {false setCamUseTI 0;camUseNVG false;nightVisionOverride = false;if (indiCamDebug) then {systemChat "-1 - Automatic"};};
		if (visionIndex == 0) then {false setCamUseTI 0;camUseNVG false;nightVisionOverride = true;if (indiCamDebug) then {systemChat "0 - Daylight"};};
		if (visionIndex == 1) then {false setCamUseTI 0;camUseNVG true;nightVisionOverride = true;if (indiCamDebug) then {systemChat "1 - Night vision"};};
		if (visionIndex == 2) then {camUseNVG false;true setCamUseTI 0;if (indiCamDebug) then {systemChat "2 - White Hot"};};
		if (visionIndex == 3) then {camUseNVG false;true setCamUseTI 1;if (indiCamDebug) then {systemChat "3 - Black Hot"};};
		if (visionIndex == 4) then {camUseNVG false;true setCamUseTI 2;if (indiCamDebug) then {systemChat "4 - Light Green Hot / Darker Green cold"};};
		if (visionIndex == 5) then {camUseNVG false;true setCamUseTI 3;if (indiCamDebug) then {systemChat "5 - Black Hot / Darker Green cold"};};
		if (visionIndex == 6) then {camUseNVG false;true setCamUseTI 4;if (indiCamDebug) then {systemChat "6 - Light Red Hot /Darker Red Cold"};};
		if (visionIndex == 7) then {camUseNVG false;true setCamUseTI 5;if (indiCamDebug) then {systemChat "7 - Black Hot / Darker Red Cold"};};
		if (visionIndex == 8) then {camUseNVG false;true setCamUseTI 6;if (indiCamDebug) then {systemChat "8 - White Hot / Darker Red Cold"};};
		if (visionIndex == 9) then {camUseNVG false;true setCamUseTI 7;if (indiCamDebug) then {systemChat "9 - Thermal (Shade of Red and Green, Bodies are white)"};};
	};
};



// This EH waits for button press that switches to previous vision mode
[] spawn {
		visionIndex = -1;
	while {visionModeRunning} do {
		waituntil {inputAction "SelectGroupUnit5" > 0};
		if (indiCamDebug) then {systemChat "F5-key pressed"};
		visionIndex = visionIndex - 1;
		if (visionIndex < -1) then {visionIndex = 9};
		sleep 1;
	};
};



// This EH waits for button press that switches to next vision mode
[] spawn {
	visionIndex = -1;
	while {visionModeRunning} do {
		waituntil {inputAction "SelectGroupUnit6" > 0};
		if (indiCamDebug) then {systemChat "F6-key pressed"};
		visionIndex = visionIndex + 1;
		if (visionIndex > 9) then {visionIndex = -1};
		sleep 1;
	};
	
};
