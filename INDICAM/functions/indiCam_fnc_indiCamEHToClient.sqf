/*

This script sets up and executes eventhandlers on a unit owned by a specific target machine 
It has a daughter script named indiCam_fnc_actorEH

*/



/*

Singleplayer:
-------------------------------------------
clientOwner 		// everything returns 0
owner			 	// everything returns 0

Hosted game:
-----------------------------------------------------
clientOwner		 	// returns 2 when run by the host
owner player		// returns 2 when run on the host
owner cursortarget	// returns 2 when run by the host on a non-grouped AI
owner cursortarget	// returns 2 when run by the host on an AI grouped to the player
owner cursortarget	// returns 0 when run by the host on terrain or terrain objects
owner cursortarget 	// returns 5 when run by the host on a connected client

clientOwner 	 	// returns 5 when run by the client
owner cursortarget 	// returns 0 when run by the client on the host  <-------------- this is the issue
owner indicam_actor // returns 0 when run by the client on the host  <-------------- this is the issue

Question now is: does it actually matter?
Answer is: Yes, because a client connected to a hosted game can't identify the ownerID of the host client (2), only the host server (0)
Will the host client always be 2? If so, then you'd just use 2 if {owner indiCam_actor} returns 0 and (isServer && hasInterface) returns true?

systemchat str owner indicam_actor; // Returns 0 if player host
if ((isplayer indiCam_actor) && (owner indiCam_actor == 0)) then {systemchat "player that returns owner ID 0 must be host dude or dedicated"}; // but dedicated shouldn't be in the selection pool

I could also check if indiCam_actor is local and combine with (owner indiCam_actor == 0). Those two tells me that the actor isn't on this machine and that the owner is a server
But I still can't send commands to id 0 because everybody and I need to combine with isPlayer check


okokokok, I think I see the problem now.
The issue is that I cannot use 0 as a target machine ID for remoteExec and setVariable since that means to do it on ALL machines in the network.
BUT.
I will identify objects belonging to the server that way.
SO.
I need to find a way to update data and set EH's on the server ONLY.
Bohemia says that "A server always has an ID of 2" which is what I'm looking for.
MEANING:
I should be able to say "if actor belongs to server use 2, otherwise use the respective ID"

*/



// -----------------------------------------------------------------------
//
//	Init 
//
//	-----------------------------------------------------------------------

// This is to prevent EH's to be assigned unnecessarily,
// but it's also to prevent EH's to get a machine target ID of 0 at spawn in the case of a hosted game.
if (_newActor == player) exitwith {
    ["Actor is the same as the cameraman, not applying eventhandlers.",true,false] call indiCam_fnc_debug;
}; // Actor is the cameraman, not applying eventhandlers


// -----------------------------------------------------------------------
//
//	Get params and set up data
//
//	-----------------------------------------------------------------------

private _newActor		= _this select 0;

private _clientOwnerID	= owner _newActor;
if ( (_clientOwnerID == 0 || _clientOwnerID == 2) && isMultiplayer) then {
	_clientOwnerID = 2; // Server is always ID 2
};
if (!isMultiplayer) then {_clientOwnerID == 0};

private _indiCamOwnerID = clientOwner;
private _indiCamUID 	= getPlayerUID player;



// Strip EH's from the previous actor
private _EHArray = (indicam_var_network select 4);	// _x = [_machineID,"EH name string",EHID]
{

	call compile format ["

		{
			(indiCam_var_network_%4_%5 select 0) removeEventHandler [%2,%3];
		} remoteExec ['call', %1]

	", _x select 0, str (_x select 1), _x select 2,_clientOwnerID,_indiCamOwnerID];

} forEach _EHArray;



// Define the new network data variable to match the newly chosen actor
indiCam_var_network set [0,_newActor]; 					// 0: The new actor unit
indiCam_var_network set [1,_clientOwnerID]; 			// 1: Target machine number in the network
indiCam_var_network set [2,_indiCamOwnerID]; 			// 2: Indicam machine number in the network
indiCam_var_network set [3,_indiCamUID]; 				// 3: No UID in singleplayer - renders as "_SP_PLAYER_"

// Update the variable on the target machine so that it can be read
missionNamespace setVariable ['indiCam_var_network',indiCam_var_network, _clientOwnerID];

// Then we put the network data on the client and give it a name that reflects this specific interaction
// Push the named network variable to the target machine
call compile format ["
	missionNamespace setVariable ['indiCam_var_network_%1_%2',indiCam_var_network, %1];
", _clientOwnerID, _indiCamOwnerID];
	// [{systemChat 'Just wrote indiCam_var_network_%1_%2 to this machine';}] remoteExec ['call', %1, false];

// Put the function that the target machine is to run locally on that machine
missionNamespace setVariable ['indiCam_fnc_actorEH',indiCam_fnc_actorEH, _clientOwnerID];

// Run the function on the target machine while supplying it with the proper data
[_newActor, _clientOwnerID, _indiCamOwnerID, _indiCamUID] remoteExec ['indiCam_fnc_actorEH', _clientOwnerID, false];
