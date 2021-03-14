/*

This script initializes the network eventhandler system

*/



// All the eventhandler functions called locally on the client
indiCam_fnc_EHGetInMan = {};
indiCam_fnc_EHGetOutMan = {};
indiCam_fnc_EHFired = {systemChat format ["actor fired on remote with %1", _this select 0]};
indiCam_fnc_EHDeleted = {};
indiCam_fnc_EHKilled = {};

// The script that keeps track of eventhandlers
indiCam_fnc_eventHandlerService = {};
indiCam_fnc_eventHandlerCleanup = {};

// This function removes eventhandlers from the old actor when switching actors.
indiCam_fnc_actorRemoveEH = {

};