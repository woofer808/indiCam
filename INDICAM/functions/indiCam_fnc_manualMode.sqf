



// I need to start the camera before this goes online so that indiCam_camera can be created.
// First, check if the camera exists.
if (isNil {missionNamespace getVariable "indiCam_camera"}) then {

	// Do the thing that starts the camera
	_mainStart = [] execVM "INDICAM\indiCam_core_main.sqf";
	waitUntil {scriptDone _mainStart};

};



if (indiCam_var_currentMode != "manual") then { // This is a basic toggle
	if (indiCam_debug) then {systemChat "manual camera controls on"};
	indiCam_camera camSetTarget indiCam_actor;
	indiCam_camera camCommand "manual on";
	indiCam_var_requestMode = "manual";
} else {
	indiCam_camera camCommand "manual off";
	indiCam_var_requestMode = "default";
	if (indiCam_debug) then {systemChat "manual camera controls off"};
};

