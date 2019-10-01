/*
 * Author: woofer
 * Tests if there is line of sight between the camera and ther target object.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Reutrn Value:
 * Visible <BOOL>
 *
 * Example:
 * [player] call indicam_fnc_losTest
 *
 * Public: No
 */

//[_target] execVM "INDICAM\funcitons\indiCam_fnc_losTest.sqf";

indiCam_var_lineColor = [1,1,0,1];



private _ASLvisible = 0;	// Declaration
private _AGLvisible = 0;	// Declaration
private _return = false; 	// Declare and assume false


params ["_target"];



onEachFrame {drawLine3D [_weaponBasePos,_weaponLogicPos, indiCam_var_lineColor];};


// Assume ASL and do the line intersect checks accordingly
_nextActorVisibleASL = lineIntersectsSurfaces [_target, eyePos indiCam_actor, (vehicle player), (vehicle indiCam_actor), true, -1];
// Convert list to boolean, true if actor is visible
if ( (count _nextActorVisibleASL) == 0 ) then {_ASLvisible = true;} else {_ASLvisible = false;};



// Assume AGL and do the line intersect checks accordingly
_nextActorVisibleAGL = lineIntersectsSurfaces [(AGLToASL _target), eyePos indiCam_actor, (vehicle player), (vehicle indiCam_actor), true, -1];
// Convert list to boolean, true if actor is visible
if ( (count _nextActorVisibleAGL) == 0 ) then {_AGLvisible = true;} else {_AGLvisible = false;};





if (_ASLvisible || _AGLvisible) then {

	_return = true; // Return true if the actor is visible
	
	// Draw a green line between the camera pos and the target
	

} else {

	_return = false; // Return false if the actor is obscured
	
};

_return;



// hint format ["ASL:%1, AGL:%2, return:%3", _ASLvisible, _AGLvisible, _return];
