/*
 * Author: woofer
 * Makes indiCam_logicA move in a linear fashion in accordance to passed arguments;
 *
 * Arguments:
 * 0: Start Point <POSITION>
 * 1: End Point <POSITION>
 * 2: Speed Multiplier <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [posA, posB, 2] spawn indiCam_cameraLogic_fnc_linear
 *
 * Public: No
 */

/*
indiCam_logicA = createVehicle ["Sign_Sphere25cm_F", actor modelToWorld [0,5,1], [], 0, "NONE"];
[(player modelToWorld [-20,20,1.8]),(player modelToWorld [20,20,1.8]),2] execVM "INDICAM\logics\indiCam_cameraLogic_linear.sqf";

Make sure that controls for logics aren't pushed until the new scene commits
Also need to know how to test for the new camera angle I don't know where the next camera will be

*/

// Make sure to stop any active logic loops - this will cause problems
indiCam_indiCamLogicLoop = false;

// Pull the values passed to the function
private _startPoint = _this select 0;
private _endPoint = _this select 1;
private _speedMultiplier = _this select 2;

// These are constant, could be changed to global
private _updateFrequency = (1 / 90);

// Setup the loop that actually animates the game logic
indiCam_indiCamLogicLoop = true;

indiCam_logicA setPos _startPoint;
private _distance = _startPoint distance _endPoint;
indiCam_linearLogic setPos indiCam_appliedVar_cameraPos; // Move the logic close to it's starting point
while {indiCam_indiCamLogicLoop} do {
		
	_vectorDirection = (getPos indiCam_logicA) vectorFromTo _endpoint;
	_vectorSize = _vectorDirection vectorMultiply _speedMultiplier*_updateFrequency;
	_newPos = (getPos indiCam_logicA) vectorAdd _vectorSize;
	indiCam_logicA setpos _newPos;
	sleep (_updateFrequency);

};
	
indiCam_var_exitScript = false; // Used for killing waiting logic scripts
