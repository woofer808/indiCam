/*

This script lives and runs on the indiCam machine to receive data on EH's set up on clients from indiCam_fnc_actorEH
It has a mother script named indiCam_fnc_indiCamEHToClient

It will be executed by the client script when the EH's are set up on the newly selected actor

This is the place to add cleanup scripts for remote EH's

*/

// Received by the script run on the client:
private _unit			= _this select 0;
private _clientOwnerID	= _this select 1;
private _indiCamOwnerID = _this select 2;
private _indiCamUID 	= _this select 3; // No UID in singleplayer - renders as "_SP_PLAYER_"
private _ehArray 		= _this select 4;

// The important bit is the _ehArray which will contain all the EH's set up on the target machine in format [["ehName", _EH_id_Number]]
indiCam_var_network set [4, _ehArray]; 	// Store the eventhandlers in the network variable

/*
private _accumulatedEH = (indiCam_var_network select 5);	// Get the current accumulation of EH's
_accumulatedEH pushBack (indiCam_var_network select 4);		// Add the new set into the array
indiCam_var_network set [5,_accumulatedEH]; 				// 5: Store the new array that inclues this latest actor
*/



