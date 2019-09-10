comment "-------------------------------------------------------------------------------------------";
comment "								droneCam script by woofer									";
comment "																							";
comment "This script creates a camera that observes a unit as if looking through a drone camera		";
comment "																							";
comment "F1 for previous view mode																	";
comment "F2 for next view mode																		";
comment "F3 for manual mode																			";
comment "F4 for stopping camera																		";
comment "-------------------------------------------------------------------------------------------";

// [] execVM "INDICAM\woof_fnc_droneCam.sqf";


actor = player;

// Create and initialize the camera on the actor to get it started
droneCamera = "camera" camCreate (actor modelToWorld [0,-50,200]);
droneCamera cameraEffect ["internal","back"];
droneCamera camCommand "inertia on";
showCinemaBorder false;

// Prepare camera before committing it
droneCamera camPrepareTarget actor;
droneCamera camPreparePos (actor modelToWorld [0,-50,100]);
droneCamera camPrepareFov 0.3;

// Do the actual commit
waitUntil {camPreloaded droneCamera};
droneCamera camCommitPrepared 0;

droneCameraRunning = true;
[] spawn {
	camUseNVG false;
	false setCamUseTI 0;
	indx = 0;
	while {droneCameraRunning} do {
	waitUntil {(inputAction "SelectGroupUnit1" > 0) or (inputAction "SelectGroupUnit2" > 0)}; // This is just a way to stop each view mode from being spammed
		if (indx == 0) then {false setCamUseTI 0;camUseNVG false;};	// 0 - Daylight
		if (indx == 1) then {false setCamUseTI 0;camUseNVG true;};	// 1 - Night vision
		if (indx == 2) then {camUseNVG false;true setCamUseTI 0;}; 	// 2 - White Hot
		if (indx == 3) then {camUseNVG false;true setCamUseTI 1;}; 	// 3 - Black Hot
		if (indx == 4) then {camUseNVG false;true setCamUseTI 2;}; 	// 4 - Light Green Hot / Darker Green cold
		if (indx == 5) then {camUseNVG false;true setCamUseTI 3;}; 	// 5 - Black Hot / Darker Green cold
		if (indx == 6) then {camUseNVG false;true setCamUseTI 4;}; 	// 6 - Light Red Hot /Darker Red Cold
		if (indx == 7) then {camUseNVG false;true setCamUseTI 5;}; 	// 7 - Black Hot / Darker Red Cold
		if (indx == 8) then {camUseNVG false;true setCamUseTI 6;}; 	// 8 - White Hot . Darker Red Cold
		if (indx == 9) then {camUseNVG false;true setCamUseTI 7;}; 	// 9 - Thermal (Shade of Red and Green, Bodies are white)
	};
};

[] spawn {
		indx = 0;
	while {droneCameraRunning} do {
		waituntil {inputAction "SelectGroupUnit1" > 0};
		systemChat "F1-key pressed";
		indx = indx - 1;
		if (indx < 0) then {indx = 9};
		systemChat str indx;
		sleep 1;
	};
};

[] spawn {
	indx = 0;
	while {droneCameraRunning} do {
		waituntil {inputAction "SelectGroupUnit2" > 0};
		systemChat "F2-key pressed";
		indx = indx + 1;
		if (indx > 9) then {indx = 0};
		systemChat str indx;
		sleep 1;
	};
	
};

[] spawn {
		indx = 0;
	while {droneCameraRunning} do {
		waituntil {inputAction "SelectGroupUnit3" > 0};
		systemChat "F3-key pressed";
		droneCamera camCommand "manual on";
		sleep 1;
	};
};


[] spawn {
		indx = 0;
	while {droneCameraRunning} do {
		waituntil {inputAction "SelectGroupUnit4" > 0};
		systemChat "F4-key pressed";
		droneCameraRunning = false;
		systemChat "stopping drone camera";
		indx == 0;
		false setCamUseTI 0;
		camUseNVG false;
		// Terminate the camera
		droneCamera cameraEffect ["terminate","back"];
		camDestroy droneCamera;
		sleep 1;
	};
};



