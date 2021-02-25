/*
[] call indicam_fnc_compileall;
systemchat "recompiled";
[indicam_actor] call indiCam_fnc_actorEH;



indiCam_actor forceWeaponFire [(currentWeapon indiCam_actor), "single"];

*/




// Currently doing
// ---------------
//TODO- I need to somehow make the eventhandler happen on the target unit from the indicam machine
//TODO- how to pass _newActor to a remote machine with remoteExec





/* ----------------------------------------------------------------------------------------------------
											Setup											
---------------------------------------------------------------------------------------------------- */
private _newActor = _this;				// Get the new actor that is being set
private _oldActor = indiCam_actor;		// Make sure to store the current actor in case we fub it up in the future







/* ----------------------------------------------------------------------------------------------------
											Strip eventhandlers												
---------------------------------------------------------------------------------------------------- */

// This is where we strip the previous actor of any previous indicam eventhandlers
indiCam_fnc_removeEventhandlers = {
	private _oldActor = _this;
	
	systemchat "removing eventhandlers locally";
	systemchat format ["old actor: %1",_oldActor];

	indiCam_actor removeEventHandler ["GetInMan",(indiCam_var_network select 2)];
	indiCam_actor removeEventHandler ["GetOutMan",(indiCam_var_network select 3)];
	indiCam_actor removeEventHandler ["Fired",(indiCam_var_network select 4)];
	indiCam_actor removeEventHandler ["Deleted",(indiCam_var_network select 5)];
	indiCam_actor removeEventHandler ["Killed",(indiCam_var_network select 6)];


	systemchat format ["fired old EHID was locally: %1", (indiCam_var_network select 4)];

};




/* ----------------------------------------------------------------------------------------------------
										Eventhandler definitions												
---------------------------------------------------------------------------------------------------- */

// Define the function which will execute on the remote machine, setting up the eventhandler on the object
indiCam_fnc_setEventhandlers = {
	private _newActor = _this;
	systemchat format ["new actor: %1",_newActor];

	// This is where we put any new indicam eventhandlers on the new actor
	_indiCam_var_enterVehicleEH = _newActor addEventHandler ["GetInMan", {
		missionNamespace setVariable ["indiCam_var_requestMode", "default", (indiCam_var_network select 0)];
	}];

	// Detect actor dismounting a vic
	_indiCam_var_exitVehicleEH = _newActor addEventHandler ["GetOutMan", {
		missionNamespace setVariable ["indiCam_var_requestMode", "default", (indiCam_var_network select 0)];
	}];

	// Detect actor firing his weapon
	_indiCam_var_actorFiredEH = _newActor addEventHandler ["Fired", {
		_indiCam_var_actorFiredTimestamp = time;
		missionNamespace setVariable ["indiCam_var_actorFiredTimestamp", _indiCam_var_actorFiredTimestamp, (indiCam_var_network select 0)];
		["actor has fired on remote"] remoteExec ["systemChat",(indiCam_var_network select 0),false];
		systemChat "actor just fired locally";
	}];

	// Detect actor getting deleted
	_indiCam_var_actorDeletedEH = _newActor addEventHandler ["Deleted", {
		// Run actorswitch on indicam machine
		[] remoteExec ["indiCam_fnc_actorSwitch",(indiCam_var_network select 1),false];
		missionNamespace setVariable ["indiCam_var_requestMode", "default", (indiCam_var_network select 0)];
	}];

	// Detect actor dying
	_indiCam_var_actorKilledEH = _newActor addEventHandler ["Killed", {
		// Request the actor death scripted scene
		["actorDeath", indiCam_actor] remoteExec ["indiCam_scene_selectScripted",(indiCam_var_network select 1),false];
	}];

	// Update the network variable with eventhandler ID's locally
	indiCam_var_network set [2,_indiCam_var_enterVehicleEH]; 	// select 2: Eventhandler enter vehicle
	indiCam_var_network set [3,_indiCam_var_exitVehicleEH];		// select 3: Eventhandler exit vehicle
	indiCam_var_network set [4,_indiCam_var_actorFiredEH];		// select 4: Eventhandler actor Fired
	indiCam_var_network set [5,_indiCam_var_actorDeletedEH];	// select 5: Eventhandler actor deleted
	indiCam_var_network set [6,_indiCam_var_actorKilledEH];		// select 6: Eventhandler actor killed

	systemchat format ["fired EHID set to locally: %1", (indiCam_var_network select 4)];
	
	// Set the eventhandler ID's on the network variable and update on indiCam machine
	missionNamespace setVariable ["indiCam_var_network", indiCam_var_network, (indiCam_var_network select 0)];
};





/* ----------------------------------------------------------------------------------------------------
										Networking process												
---------------------------------------------------------------------------------------------------- */

// Define the current network info locally on indiCam machine
	indiCam_var_network set [0,(owner player)]; 		// select 0: Indicam machine client ID
	indiCam_var_network set [1,(owner indiCam_actor)]; 	// select 1: Target machine client ID


// Update the actors target machine with the current network info
missionNamespace setVariable ["indiCam_var_network", indiCam_var_network, (indiCam_var_network select 1)];

// make sure the function to remove eventhandlers is local on the target machine
missionNamespace setVariable ["indiCam_fnc_removeEventhandlers", indiCam_fnc_removeEventhandlers, (indiCam_var_network select 1)];

// Execute the remove eventhandler function locally on the target machine
_oldActor remoteExec ["indiCam_fnc_removeEventhandlers",(indiCam_var_network select 1),false];


// make sure the function to set eventhandlers is local on the target machine
missionNamespace setVariable ["indiCam_fnc_setEventhandlers", indiCam_fnc_setEventhandlers, (indiCam_var_network select 1)];

// Execute the set eventhandler function locally on the target machine
_newActor remoteExec ["indiCam_fnc_setEventhandlers",(indiCam_var_network select 1),false];

systemchat format ["actorEH function ran with %1 as actor", _newActor];
