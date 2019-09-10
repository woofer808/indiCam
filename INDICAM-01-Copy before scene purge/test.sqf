/*
[] execVM "INDICAM\test.sqf";
*/





/*

indiCam_fnc_followLogicFPS = {

params [
		"_object",
		"_target",
		"_speed"
		];
_pos = getPos _object;
_vector = _pos vectorDiff _target;
_distance = vectorMagnitude _vector;
_speedModifier = (-_speed * _distance^2);
_fps = diag_fps;
_frameDist = _speedModifier * (1 / _fps);
_velocityVector = (vectorNormalized _vector) vectorMultiply _frameDist;
_newPos = _pos vectorAdd _velocityVector;
_object setPos _newPos;

};


actor = patrol;

indiCam_var_fpsTarget = createVehicle ["ModuleEmpty_F", (actor modelToWorld [0,5,1]), [], 0, "CAN_COLLIDE"];

["indiCam_id_ballTarget", "onEachFrame", {[indiCam_var_fpsTarget,(actor modelToWorld [0,1,1]),1] call indiCam_fnc_followLogicFPS}] call BIS_fnc_addStackedEventHandler;
["indiCam_id_ballCamera", "onEachFrame", {[indiCam,(actor modelToWorld [0,-10,3]),0.01] call indiCam_fnc_followLogicFPS}] call BIS_fnc_addStackedEventHandler;

indiCam = "camera" camCreate (actor modelToWorld [0,-10,3]);
indiCam cameraEffect ["internal","back"];
camUseNVG false;
showCinemaBorder false;
indiCam camCommand "inertia on";
indiCam camSetTarget indiCam_var_fpsTarget;
indiCam camSetFov 0.4;
indiCam camCommit 0;


*/
















/*

["indiCam_id_ballTarget", "onEachFrame", {}] call BIS_fnc_addStackedEventHandler; 
["indiCam_id_ballCamera", "onEachFrame", {}] call BIS_fnc_addStackedEventHandler;
indiCam cameraEffect ["terminate","back"];
camDestroy indiCam;


[] spawn {
	while {true} do {
		actor = selectRandom allUnits;
		sleep 5;
	};
};


actor = selectRandom allUnits;
indiCam camSetTarget actor;
indiCam setPos (actor modelToWorld [0,-5,20]);
indiCam camCommit 0;

*/














/* for quick access:
[] execVM "INDICAM\test.sqf";
*/



