/*
 * Author: woofer
 * WIP
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * spawn indiCam_fnc_trackDeadActor
 *
 * Public: No
 */

// Keep track of a player actor through death in case respawn takes too long
// Run this function in the main loop when the actor has been found dead
// It has to handle the case of the actor being a remote controlled unit, so the cameraman should be included.

private _functionTimeout = 30; // This is how long in seconds the system will wait for the actor to respawn


// Read the stored UID of the current actor
private _actorUID = (_this select 0);

if (isMultiplayer) then { // We only need to track players through respawn in MP

	private _timeStamp = time; // Check the time to prepare the function timeout

	// Start the loop that waits for the player to respawn
	private _trackLoop = true;
	while {_trackLoop} do {
		
		{
			if 	(
				((getPlayerUID _x) == _actorUID)
				&& (alive _x)
				)
			then {
				_x = indiCam_actor; // If the actor was found, put the camera on him again
				indiCam_var_requestMode ="default"; // Force a new scene in the main loop
				_trackLoop = false; // Stop the current loop
			};
		
		} forEach allPlayers;
	
		sleep 1; // The loop will only run once every second.
	
		// if too much time has passed since the function was started, give it up and let it down. Then run around and desert it.
		private _currentDuration = (time - _timeStamp);
	
		if (_timeStamp > _functionTimeout) then {
			if (indiCam_debug) then {systemChat "Actor didn't respawn in time"};
			_trackLoop = false; // Stop the current loop
			
		};

	};

};
