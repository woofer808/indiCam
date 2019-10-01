/*
 * Author: woofer
 * Sets and manages vision modes.
 *
 * Arguments:
 * 0: Camera <OBJECT>
 *
 * Reutrn Value:
 * None
 *
 * Example:
 * [myCamera] call indicam_fnc_visionMode
 *
 * Public: No
 */

//TODO-Add the flashlight mode (invisible light source above actor)

// This script accepts 
	// Direct number inputs to set a specific vision mode
	// "next" to move to next vision mode
	// "previous" to move to previous vision mode
// Current vision mode index is stored in indiCam_var_visionIndex 


/* This will put a light above an actor - use to create the flashlight-effect
_light = "#lightpoint" createVehicleLocal (getPosATL actor); 
_light setLightBrightness 0.75; 
_light setLightAmbient [0.75, 0.75, 0.75]; 
_light setLightColor [0.75, 0.75, 0.75]; 
_light lightAttachObject [actor, [0,0,10]];
*/

private _param = (_this select 0);

// Do a check of param input type
if (
	((typeName _param) == "SCALAR") ||
	((typeName _param) == "STRING")
) then {
	// If a number was passed, use that directly
	if (typeName _param == "SCALAR") then {
		indiCam_var_visionIndex = (_this select 0);

	// If a string was passed, 
	} else {
		if (_param == "next") then {indiCam_var_visionIndex = indiCam_var_visionIndex + 1};
		if (_param == "previous") then {indiCam_var_visionIndex = indiCam_var_visionIndex - 1};
		if ( ( _param != "next") &&( _param != "previous") ) then {systemchat "indiCam_fnc_visionMode: String has to be either ""next"" or ""previous"""};
		
	};
// If the wrong type of param was passed to the function, tell the user and then do nothing about vision index.
} else {
	systemchat "indiCam_fnc_visionMode: No whole number or string was passed.";
};
	

// Adjust for when vision index is out of bounds.
if (indiCam_var_visionIndex > 10) then {indiCam_var_visionIndex = 0};
if (indiCam_var_visionIndex < 0) then {indiCam_var_visionIndex = 10};

// Update variable for GUI
indiCam_var_guiVisionModeDropdownState = indiCam_var_visionIndex;


// Finally we activate the proper vision mode, if there is an error somewhere
switch indiCam_var_visionIndex do {

	case 0:		{false setCamUseTI 0;camUseNVG false;if (indiCam_debug) then {systemChat "0 - Automatic"};};
	case 1:		{false setCamUseTI 0;camUseNVG true;if (indiCam_debug) then {systemChat "1 - Night vision"};};
	case 2:		{camUseNVG false;true setCamUseTI 0;if (indiCam_debug) then {systemChat "2 - White Hot"};};
	case 3:		{camUseNVG false;true setCamUseTI 1;if (indiCam_debug) then {systemChat "3 - Black Hot"};};
	case 4:		{camUseNVG false;true setCamUseTI 2;if (indiCam_debug) then {systemChat "4 - Light Green Hot / Darker Green cold"};};
	case 5:		{camUseNVG false;true setCamUseTI 3;if (indiCam_debug) then {systemChat "5 - Black Hot / Darker Green cold"};};
	case 6:		{camUseNVG false;true setCamUseTI 4;if (indiCam_debug) then {systemChat "6 - Light Red Hot /Darker Red Cold"};};
	case 7:		{camUseNVG false;true setCamUseTI 5;if (indiCam_debug) then {systemChat "7 - Black Hot / Darker Red Cold"};};
	case 8:		{camUseNVG false;true setCamUseTI 6;if (indiCam_debug) then {systemChat "8 - White Hot / Darker Red Cold"};};
	case 9:		{camUseNVG false;true setCamUseTI 7;if (indiCam_debug) then {systemChat "9 - Thermal (Shade of Red and Green, Bodies are white)"};};
	case 10:	{false setCamUseTI 0;camUseNVG false;if (indiCam_debug) then {systemChat "10 - Forced Daylight"};};

};
