/*

This script will let the indicam client listen in on direct speech and radio traffic

For now it'll just put the cameraman where the actor is




put this in *_core_main:
-----------------------------
// This is the radio listening
if (indiCam_devMode) then {
	[] execVM "INDICAM\functions\indiCam_fnc_radio.sqf";
} else {
	[] spawn indiCam_fnc_radio;
};



put this in core_init
---------------------
indiCam_fnc_radio = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_radio.sqf";

//TODO- Update version in GUI
//TODO- Update indiCam manual document https://docs.google.com/document/d/1lOaXuHszVZCs0aKUJvlOgFpmqqYSNWr8XzokD9oyUCI/edit#heading=h.86uyez4snnz



*/




// Apparently all sorts of weirdness will happen if the cameraman is in a vehicle, so we gotta account for that.
// Get the cameraman out of his vic



// First we get the cameraman position.
private _cameramanStartPos = getPos player;

// Make the cameraman invisible and set him to captured (Mark a unit as captive. If unit is a vehicle, commander is marked.)
// hideObjectGlobal (This command is designed for MP. Hides object on all connected clients as well as JIP. Call on the server only. Can be used on static objects. In SP this command behaves just like hideObject.)
[player, {

	_this hideObjectGlobal true;
	_this setCaptive true;

}] remoteExec ["call", 2];




// When the camera is not running, go back to normal
waitUntil {!indiCam_running};



[player, {

	_this hideObjectGlobal false;
	_this setCaptive false;

}] remoteExec ["call", 2];




// Put the player back to where he was
player setPos _cameramanStartPos;