/*

This script sets up and executes eventhandlers on a unit owned by a specific target machine 
It has a daughter script named indiCam_fnc_actorEH

*/


// waitUntil {dialog};


private _newActor		= _this select 0;

private _clientOwnerID	= owner _newActor;
if ( (_clientOwnerID == 0 || _clientOwnerID == 2) && isMultiplayer) then {
	_clientOwnerID = 2; // Server is always ID 2
};
if (!isMultiplayer) then {_clientOwnerID == 0};

private _indiCamOwnerID = clientOwner;
private _indiCamUID 	= getPlayerUID player;





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





private _indiCamOwnerID = clientOwner;
private _clientOwnerID = owner indicam_actor;
systemchat format ["target is on: %1", _clientOwnerID];
if ( (_clientOwnerID == 0 || _clientOwnerID == 2) && isMultiplayer) then { 
 systemchat "unit is owned by the server."; 
 _clientOwnerID = 2;
};
systemchat format ["decided on: %1", _clientOwnerID];
systemchat str isMultiplayer;




if (isServer && hasInterface) then {systemchat "this is a player hosted game"}; // Confirmed working on player host

{
	systemchat format ["I am machine ID: %1",clientOwner]

} remoteExec ["call", 0, false];


*/







// !!!!!!!!!!!!!!!!! This is where we strip the previous actor of his eventhandler
// But first we gotta make sure that the first set of EH's are in the array.










// Define the new network data variable to match the newly chosen actor
indiCam_var_network set [0,_newActor]; 					// 0: The new actor unit
indiCam_var_network set [1,_clientOwnerID]; 			// 1: Target machine number in the network
indiCam_var_network set [2,_indiCamOwnerID]; 			// 2: Indicam machine number in the network
indiCam_var_network set [3,_indiCamUID]; 				// 3: No UID in singleplayer - renders as "_SP_PLAYER_"

// Update the variable on the target machine so that it can be read
missionNamespace setVariable ['indiCam_var_network',indiCam_var_network, _clientOwnerID];

systemchat format ["the new actor attempted: %1", _newActor];

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
