






comment "-------------------------------------------------------------------------------------------";
comment "setup--------------------------------------------------------------------------------------";
woof_fnc_sceneRandomizer = compile preprocessFileLineNumbers "functions\woof_fnc_sceneRandomizer.sqf";
woof_fnc_situationCheck = compile preprocessFileLineNumbers "functions\woof_fnc_situationCheck.sqf";


comment "-------------------------------------------------------------------------------------------";
comment "spawn situation check script---------------------------------------------------------------";
comment "Spawn a script that keeps track of what type of situation is going on around the actor";
comment "The script should continuously output variables that other scripts can use out of sync";
[] spawn WOOF_fnc_situationCheck;


comment "----------setup variables-----------------------";
private [
		"_camera",
		"_actor",
		"_cameraTarget",
		"_commitTime",
		"_fov"
		];







comment "----------setup actor---------------------------";
_actor = actor;


comment "----------setup camera--------------------------";
_camera = "camera" camCreate (getPos _actor);




comment "-------------------------------------------------------------------------------------------";
comment "scene loop---------------------------------------------------------------------------------";
while (sceneSwitch = false) do {}



comment "Check if NVG's are necessary";
if ( (date select 3) < 4 || (date select 3) >= 20 ) then { camUseNVG true; } else { camUseNVG false; };



comment "----------pull scene values---------------------";
comment "Format should be something like [_posX,_posY,_posZ,_commitTime,_fov]";
[] call WOOF_fnc_sceneRandomizer;

comment "----------setup scene---------------------------";
_camera camSetFov _fov;
_camera camcommit _commitTime;

comment "----------commit scene--------------------------";



comment "----------output debug info---------------------";
systemChat str ["FOV" ,_fov];
systemChat str ["COMMIT" ,_commitTime];




comment "scene loop end-----------------------------------------------------------------------------";
comment "-------------------------------------------------------------------------------------------";



comment "-------------------------------------------------------------------------------------------";
comment "quit--------------------------------------------------------------------------------------";

_camera cameraEffect ["Terminate","back"];
camDestroy _camera;
camUseNVG false;


