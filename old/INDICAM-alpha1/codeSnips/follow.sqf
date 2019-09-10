
-------------------------------------------------------------------
Flowing camera without sharp cuts (should be used most of the time)
-------------------------------------------------------------------
I want a function that takes the data _newCameraPos and smoothly moves the camera into this new location.
There is presedence in cinematic_camera.sqf in KP liberation on line 76.


private [
			"_camera",
			"_currentCameraPos",
			"_currentCameraDir",
			"_newCameraPos",
			"_newCameraDir",
			"_commitDuration",
			"_cameraDistance",
			"_cameraMovementRate"
		];



comment "Sets up the actor and pushes the cameraman to world origin 0,0,0";
actor = cursortarget;
player setPos [0,0,0];

comment "Setup of variables";
_currentCameraPos = [0,0,0];
_currentCameraDir = 0;
_newCameraPos = [0,0,0];
_newCameraDir = 0;
_cameraMovementRate = 10;


comment "Create the camera on the actor";
_camera = "camera" camCreate (getPos actor);
_camera cameraEffect ["internal","back"];
_camera camSetTarget actor;



comment "------------- loop for testing purposes -------------";
for "_i" from 0 to 10 do {


comment "Find out where the camera currently is and where it's pointing";
_currentCameraPos = getPos _camera;
_currentCameraDir = getDir _camera;



comment "Decide on next position for camera";
comment "Ideally this should just pull a random pre-made camera angle (scene)";
comment "_newCameraPos = [] call WOO_FNC_randomCameraAngle";
_posX = random [0,0,0];
_posY = random [-10,-5,-1];
_posZ = random [1,5,10];
_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
hint str _newCameraPos;



comment "Determine distance between new and old camera position";
_cameraDistance = _currentCameraPos distance _newCameraPos;
comment "Determine how long in seconds the camCommit needs to be";
_commitDuration = (_cameraDistance/_cameraMovementRate);



comment "------------- update the camera -------------";
_camera camSetPos _newCameraPos;
comment "_camera camSetDir direction <-- if needed";
comment "------------- commit the camera -------------";
_camera camcommit _cameraMovementRate;
waitUntil {camCommitted _camera};



comment "sleep for a random duration (8-20seconds) before cycling to a new camera angle";
sleep (random [8,10,20]);



};

comment "get rid of the camera";
_camera cameraEffect ["Terminate","back"];
camDestroy _camera;

