comment "-------------------------------------------------------------------------------------------";
comment "							UAV Observer script by woofer									";
comment "																							";
comment "This script spawns a uav on the fly and gives the gunners perspective of it.				";
comment "It's purpose is to be used as an observation point for woof_fnc_indiCam.					";
comment "-------------------------------------------------------------------------------------------";



// UAV script mostly gotten from KK's blog: http://killzonekid.com/arma-scripting-tutorials-uav-r2t-and-pip/




// Create the uav
uav = createVehicle ["B_UAV_01_F", actor modelToWorld [0,100,100], [], 0, "FLY"];

// Create the crew that is to occupy it
createVehicleCrew uav;
gunner = (gunner uav); // I might have to name the gunner or at least pull the gunner name


// Setup the uav
uav flyInHeight 100;
uav allowDamage false;
uav setCaptive true;


// Lock uav camera onto the actor or maybe even town/location of the actor
// I changed the order of some of these from what KK had
// Usage:   vehicle lockCameraTo [target, turretPath]
// Example: uav lockCameraTo [vehicle, [0,0]];
// target: Object or PositionASL - use objNull for unlocking
uav lockCameraTo [actor, [0]];



// Adds a loiter waypoint, seems to need it even though it's stationary
// Probably good to keep for when we want to use a greyhawk
wp = group uav addWaypoint [(getPos actor), 0];
wp setWaypointType "LOITER";
wp setWaypointLoiterType "CIRCLE_L";
wp setWaypointLoiterRadius 100;



// Look through the view of the gunner
_gunner switchCamera "Gunner";
showHUD [
		true,	 // hud: Boolean - show scripted HUD (same as normal showHUD true/false)
		false,	 // info: Boolean - show vehicle + soldier info (hides weapon info from the HUD as well)
		false,	 // radar: Boolean - show vehicle radar
		false,	 // compass: Boolean - show vehicle compass
		true,	 // direction: Boolean - show tank direction indicator (not present in vanilla Arma 3)
		true,	 // menu: Boolean - show commanding menu (hides HC related menus)
		true,	 // group: Boolean - show group info bar (hides squad leader info bar)
		true,	 // cursors: Boolean - show HUD weapon cursors (connected with scripted HUD)
		true	 // panels: Boolean - show vehicle panels
		];



















/* I think I need to get out of the camera and switch to the actual unit camera
switchCamera
Switch camera to given vehicle / camera. Mode is one of:
"INTERNAL": 1st person
"GUNNER": optics / sights
"EXTERNAL": 3rd person
"GROUP": group
"CARGO": same as "INTERNAL"

also:

player remoteControl driver UAV;
driver UAV switchCamera "Internal"; //switchCamera required
//sometimes switchCamera is not needed
player remoteControl driver UAV;

Return control to player:
objNull remoteControl driver UAV;


*/

/* Probably not a way to do it
_cam = "camera" camCreate [0,0,0];
_cam cameraEffect ["Internal", "Back", "uavrtt"];
*/


// When the uav isn't needed anymore
deleteVehicleCrew // won't be needed if I do deleteVehicle
deleteVehicle
