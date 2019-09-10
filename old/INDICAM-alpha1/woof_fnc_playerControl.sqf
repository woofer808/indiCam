comment "-------------------------------------------------------------------------------------------";
comment "							woof_fnc_playerControl											";
comment "																							";
comment "	This script lets the player send variables to a specific player (cameraman).			";
comment "	The idea is to do a handshake with the cameraman of choice so that can happen.			";
comment "																							";
comment "-------------------------------------------------------------------------------------------";


/* Basic idea:

On server machine, returns the ID of the client where the object is local. Otherwise returns 0. For use on clients clientOwner command is available. To find out the owner of a Group, use groupOwner.
_clientID = owner _someobject;


Send the variable value to the client computer - same limitations regarding variable type as publicVariable. The Client ID is the temporary ID given to a connected client for that session. You can find out this ID with the owner command (using it on a player's character, for example, will give you that players client ID).
3 publicVariableClient "CTFscoreOne";

*/

playerControlID = owner cursortarget; // look at something while this script is running to store it's owner IDs

if (clientOwner == playerControlID) then {hint "Not another cameraman."} else {hint format ["Commands will go to playerID %1.",playerControlID]};
