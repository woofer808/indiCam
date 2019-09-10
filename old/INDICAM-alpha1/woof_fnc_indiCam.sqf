comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										independent cinematic camera									";
comment "																										";
comment "																										";
comment "	It's function is to follow a designated actor around and position itself for decent camera shots	";
comment "	depending on circumstances such as visibility and situation around the actor.						";
comment "																										";
comment "	The original purpose of this script is to support a specific video recording workflow				";
comment "	with two separate perspectives of the same game session. It is meant to be executed					";
comment "	on a second gaming computer that is logged in as a regular player that only records gameplay.		";
comment "																										";
comment "	F1 Stop script																						";
comment "	F2 forces next scene																				";
comment "	F3 toggles manual camera on/off L-key disables focal square											";
comment "	F5 for previous vision mode																			";
comment "	F6 for next vision mode																				";
comment "-------------------------------------------------------------------------------------------------------";

/* Current feature list:

	- Randomly selects between pre-made scene types
	- Some scene types have randomized values such as placement and field of view
	- Camera starts each new scene on whichever unit that is currently named "actor".
	- Ability to switch actors from the map screen
	- Takes into account if the actor is on foot, in a car, in a boat or in an aircraft.
	- Takes level of action into account and picks scenes accordingly
	- Tests each upcoming camera angle so that it has a line of sight to the actor before applying it
	- Switches scene if the actor is hidden for too long
	- Switches scene if the actor is too far away for the current scene
	- Moving and stationary camera shots
	- Randomized or specific camera angles
	- It's harder to stay on a higher actionLevel
	- Homebrew deathcam for players (that might interfere with any mission deathcam systems)
	- Modular script so that adding new scenes are easier
	- If it's an AI actor that dies, the camera will switch to the closest friendly AI
	- Keypress to kill script
	- Keypress to switch to next scene
	- Keypress to cycle visible light/night vision/infrared light modes
	- Keypress to toggle manual camera
*/


// IDEA- If I can make a ball that smoothly follows an actor around, I should be able to make a good target to track. If the home position of that ball can then be moved to different hardpoints around the player then both first person and third person type views should be doable. Problem is still gun perspective and real close ones like that. (turns out it's not always so straightforward with oneachframe. probably need to continuously commit a camera)

// IDEA- Can I use _maxDistance to somehow have the camera keep up with shots far between
// IDEA- Maybe add _transitionTime which would make the camera move in one more step before applying _cameraSpeed
// IDEA- Add an {detachCamera = true;} to each scene and a {if (detachCamera) then {detach indiCam};} to the main loop

// TODO- publicVariable "actor" stops indiCam is incompatible with multiple cameramen. Look into letting a player send the actor variable and vision modes to a specific cameraman by doing a handshake _clientID = owner _someobject;
// TODO- Fix jittery scenes (build engine that chases the actor with continuous commits)
// TODO- Update the help with useful information
// TODO- Make it so that the cameraman can access the map actor selection, probably through button without stopping any ongoing scenes
// TODO- Adapt for mod building (build a proper init)
// TODO- Menu system for both actor and player, let's say that you set profile in the beginning "start indiCam as cameraman" and "start indiCam as player"
// TODO- Menu system should be able to handle AIC remoting and vanilla unit switch and be able to reset the liberation menu with something like {removeallactions player}
// TODO- Divide the different vicValue cases into separate files and compile functions to save on calculation time. makes it more modular too.

// WISH- Add _cameraStartPos and _cameraEndPos for each shot which will enable fly-bys
// WISH- Write a new camera operation engine that runs more smoothly
// WISH- Script cleanup and optimization
// WISH- Build a homebrew drone view, spawning a drone and looking through it is too much of a hassle
// WISH- Add safe mode and corresponding keypress. Maybe simply just turn to first person or something.
// WISH- See if effectName is useful in use with cameraEffect for stable camera: https://community.bistudio.com/wiki/cameraEffect
// WISH- Find a way to automatically remove the camera indicator from camCommand "manual on"
// WISH- Make the script switch to enemies that targets the actor (maybe knowsAbout, getHideFrom, targetKnowledge  )
// WISH- nearestBuilding, nearestLocation, nearestLocations for use with situationCheck



comment "-------------------------------------------------------------------------------------------";
comment "										 Init												";
comment "-------------------------------------------------------------------------------------------";


// This stops Niipaa's workshop from displaying a hint at startup
[] spawn {sleep 1;hint "";}; 

runIndiCam = false; // This is for interrupting the main loop
actor = player;
indiCamDebug = false; // This is the useful general debug info, see each script for a specific bool
// if (indiCamDebug) then {systemChat "general debug message"};

execVM "INDICAM\indiCam_diary.sqf"; // Set up the diary entries


// This need proper positioning in the script
[] execVM "INDICAM\woof_fnc_cameraControl.sqf"; // Keeps track of each units ability to control the camera

woof_fnc_playerControl = compile preprocessFileLineNumbers "INDICAM\woof_fnc_playerControl.sqf";

while {true} do { // This is a temporary way of making the script able to cycle on/off. Should be erased from memory when not running


	actorSide = side actor; // This is needed to preserve the side of a dead unit, since it will switch to CIV immediately upon death

	// Here's a method to make sure no text is displayed while the camera is on
	if (indiCamDebug) then {enableRadio true} else {enableRadio false};
	
	runIndiCam = false; // This is for interrupting the main loop
	waitUntil {runIndiCam};


	// Setup of variables
	private _cameraCommitDuration = 1;
	private _sceneSelector = [];
	private _newCameraPos = [0,0,0];
	private _newFov = 1;
	private _cameraTarget = actor;
	private _cameraTaketime = 10;
	private _cameraMovementRate = 1;
	private _currentCameraPos = [0,0,0];
	private _currentCameraDir = 0;
	private _maxDistance = 0;
	private _ignoreActorHidden = false;
	private _detachCamera = false;
	
	sceneSelector = [
						_newCameraPos,			// This select 0	//	(sceneSelector select 0)
						_newFov,				// This select 1	//	(sceneSelector select 1)
						_cameraTarget,			// This select 2	//	(sceneSelector select 2)
						_cameraTaketime,		// This select 3	//	(sceneSelector select 3)
						_cameraMovementRate,	// This select 4	//	(sceneSelector select 4)
						_maxDistance,			// This select 5	//	(sceneSelector select 5)
						_ignoreActorHidden,		// This select 6	//	(sceneSelector select 6)
						_detachCamera			// This select 7	//	(sceneSelector select 7)
	];
	
	actorObscuredPersistent = false;


	// Create and initialize the camera on the actor to get it started
	indiCam = "camera" camCreate (getPos actor);
	indiCam cameraEffect ["internal","back"];
	indiCam camSetTarget actor;
	camUseNVG false;
	showCinemaBorder false;
	indiCam camCommand "inertia on";
	// indiCam camCommand "manual on"; // https://community.bistudio.com/wiki/Camera.sqs

	visibilityCheckRunning = false;
	[] execVM "INDICAM\woof_fnc_visibilityCheck.sqf"; // This runs on a pretty short interval
	waitUntil {visibilityCheckRunning};


	situationCheckRunning = false;
	[] execVM "INDICAM\woof_fnc_situationCheck.sqf"; // This runs on a pretty long interval
	waitUntil {situationCheckRunning};


	// This will be called as needed I probably should do a preprocessFileLineNumbers on it
	woof_fnc_sceneSelector = compile preprocessFileLineNumbers "INDICAM\woof_fnc_sceneSelector.sqf";



	comment "-------------------------------------------------------------------------------------------";
	comment "									 Main loop												";
	comment "-------------------------------------------------------------------------------------------";

	while {runIndiCam} do { // Main loop pulls scenes based on situation and visibility and then commits and/or aborts the camera as needed
	interruptScene = false;

		// Find out current position of the camera
		_currentCameraPos = getPos indiCam;
		// Find out current directionof the camera
		_currentCameraDir = getDir indiCam;


		// Run the sceneSelector function to get the next set of scene values
		// I dunno why the call function broke. Will leave it with execVM for now
		// Also useful not to compile while I edit the sceneSelector file while indiCam is running
		sceneSelectorDone = false;
		[] execVM "INDICAM\woof_fnc_sceneSelector.sqf";
		// [] call woof_fnc_sceneSelector;
		waitUntil {sceneSelectorDone};

		private _futureCameraPosition = AGLToASL (sceneSelector select 0);

		// Try the new camera position before committing it. If the actor is obscured from that position, run the scene selector again until it finds something that works
		private _nextActorVisibility = [indiCam, "VIEW", vehicle actor] checkVisibility [_futureCameraPosition, eyePos actor];
		private _nextActorObscuredLine = lineIntersects [_futureCameraPosition, eyePos actor, indicam, vehicle actor];
		private _nextActorObscuredTerrain = terrainIntersectASL [_futureCameraPosition, eyePos actor];

		_ignoreActorHidden = (sceneSelector select 6); // check if the upcoming scene shall disregard the check for a hidden actor
		if (_ignoreActorHidden) then {_nextActorObscuredLine = false};
		
		if (!_nextActorObscuredLine) then { // If the actor isn't hidden from the next camera position, apply the next scene

			// Get all the new parameters from the last time sceneSelector ran
			_newCameraPos = (sceneSelector select 0);
			_newFov = (sceneSelector select 1);
			_cameraTarget = (sceneSelector select 2);
			_cameraTaketime = (sceneSelector select 3);
			_cameraMovementRate = (sceneSelector select 4);
			_maxDistance = (sceneSelector select 5);
			_ignoreActorHidden = (sceneSelector select 6);
			_detachCamera = (sceneSelector select 7);

			if (visionIndex == -1) then {
				// If it's nighttime, set view to nightvision (stolen from KP Liberation 0.96)
				if ( (date select 3) < 4 || (date select 3) >= 20 ) then {camUseNVG true;} else {camUseNVG false;};
			} else {};
			
			
			// Determine distance between current and the new camera position
			_cameraDistance = _currentCameraPos distance _newCameraPos;
			// Determine how long in seconds the camCommit needs to be
			if (_cameraMovementRate == 0) then {
				_cameraCommitDuration = 0;
			} else {
				_cameraCommitDuration = (_cameraDistance/_cameraMovementRate);
			};

			// Detach camera if needed
			if (_detachCamera) then {detach indiCam};

			// Prepare camera before committing it
			indiCam camPrepareTarget _cameraTarget;
			indiCam camPreparePos _newCameraPos;
			indiCam camPrepareFov _newFov;


			
			// Do the actual commit
			waitUntil {camPreloaded indiCam}; // Not sure if this is needed anymore
			indiCam camCommitPrepared _cameraCommitDuration;

			


			// While the camera is being committed for the duration of _cameraTakeTime, check for interrupts		
			_future = time + _cameraTaketime;
			while {time <= _future} do {
				if (!runIndiCam) exitWith {}; // If the close camera button was pressed
				if (actorObscuredPersistent) exitWith {if (indiCamDebug) then {systemChat "actor was obscured for too long"};}; // If the actor was obscured for too long
				if ((indiCam distance actor) > _maxDistance) exitWith {if (indiCamDebug) then {systemChat "actor too far away"};};
				if (!alive actor) exitWith {if (indiCamDebug) then {systemChat "actor died"};};
				if (interruptScene) exitWith {if (indiCamDebug) then {systemChat "next scene"};}; // F2 for next scene
				sleep 0.1;
			};




		} else {
			// If the next location for the camera doesn't have a clear line of sight to the actor, just run the main loop again

		};
		
		//if (_cameraTarget != actor) then {deleteVehicle _cameraTarget}; // This is to prevent a buildup of gamelogics - a wee bit dangerous since it deletes any vehicles the actor might be inside of.



	}; // End of main loop
	
	
	
	// Tell the user that the camera has been interrupted
	if (indiCamDebug) then {systemchat "stopping camera..."};

	// Terminate everything when outside of the loop
	indiCam cameraEffect ["terminate","back"];
	camDestroy indiCam;



};
