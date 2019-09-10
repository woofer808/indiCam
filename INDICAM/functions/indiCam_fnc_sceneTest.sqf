comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "											indiCam_fnc_sceneTest										";
comment "																										";
comment "	This function returns true if the actor is not visible enough from the next camera position.		";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
//[] execVM "indiCam\indiCam_fnc_sceneTest.sqf";


private _ASLvisible = 0;
private _AGLvisible = 0;
private _return = 0;

// Pull the value given to the function
private _nextCameraPos = _this select 0; // Could be either AGL or ASL



// Assume ASL and do the line intersect checks accordingly
_nextActorVisibleASL = lineIntersectsSurfaces [_nextCameraPos, eyePos indiCam_actor, (vehicle player), (vehicle indiCam_actor), true, -1];
// Convert list to boolean, true if indiCam_actor is visible
if ( (count _nextActorVisibleASL) == 0 ) then {_ASLvisible = true;} else {_ASLvisible = false;};



// Assume AGL and do the line intersect checks accordingly
_nextActorVisibleAGL = lineIntersectsSurfaces [(AGLToASL _nextCameraPos), eyePos indiCam_actor, (vehicle player), (vehicle indiCam_actor), true, -1];
// Convert list to boolean, true if indiCam_actor is visible
if ( (count _nextActorVisibleAGL) == 0 ) then {_AGLvisible = true;} else {_AGLvisible = false;};





if (_ASLvisible || _AGLvisible) then {

	_return = true; // Return true if the indiCam_actor is visible

} else {

	_return = false; // Return false if the indiCam_actor is obscured

};

_return;

// hint format ["ASL:%1, AGL:%2, return:%3", _ASLvisible, _AGLvisible, _return];
