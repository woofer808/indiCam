/*

This script initializes the network eventhandler system

*/



// All the eventhandler functions called remotely by the EH on the indiCam_actor client

indiCam_fnc_EHGetInMan = {
	indiCam_var_requestMode == "default";if (indiCam_debug && (indiCam_var_currentMode == "default") ) then {systemChat "actor mounted a vic"};
};

indiCam_fnc_EHGetOutMan = {
	indiCam_var_requestMode == "default";if (indiCam_debug && (indiCam_var_currentMode == "default") ) then {systemChat "actor dismounted a vic"};
};

indiCam_fnc_EHFired = {
	indiCam_var_actorFiredTimestamp = time;
	if (indiCam_debug && (indiCam_var_currentMode == "default") ) then {systemChat format ["actor has fired at time %1", time]};
};

indiCam_fnc_EHDeleted = {
	// This is where we stop all eventhandlers by switching unit
	if (indiCam_debug && indiCam_running) then {systemchat "actor was deleted";};
	[] call indiCam_fnc_actorSwitch;
	indiCam_var_requestMode = "default";
};

indiCam_fnc_EHKilled = {
	if ( indiCam_debug && indiCam_running ) then {systemChat "indiCam_actor was killed"};
	// Request the actor death scripted scene
	["actorDeath", indiCam_actor] spawn indiCam_scene_selectScripted;
};

// The script that keeps track of and cleans up eventhandlers handed out
indiCam_fnc_eventHandlerService = {};
indiCam_fnc_eventHandlerCleanup = {};
