comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										independent cinematic camera									";
comment "																										";
comment "																										";
comment "	The purpose of the init is to compile all functions and set all variables from start.				";
comment "																										";
comment "																										";
comment "	Definitions:																						";
comment "	- Scene: A predefined camera angle with camera movement along with take time, fov and so on.		";
comment "	- Variable names: indiCam_var_variableName															";
comment "	- Function and script names: indiCam_fnc_functionOrScriptName(.sqf)									";
comment "	- Object names: indiCam_objectName																	";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
// Versioning: Significant new functionality adds to the tenth of a version, scene additions and fixes adds to the hundreds


/* Changelog version 1.3 */	
comment " PRIORITIES / DONE ";
/*
Major redesign of camera movement system has been done. It now gets calculated on each frame to alleviate jitter as much as possible. The reason this wasn't the case before was because of the risk of a crash to desktop that can now happen. I decided that it was worth it to get higher quality camera movement. This now means that all the old scenes were wiped and I have started to create new ones. There is a basic set of scenes in and I will add more as I manage to get them stable and smooth enough.

The second large addition is the new system that detects special events and cuts to a scene to show that. The only one implemented just yet is the detection of launcher usage by a unit.
*/




// Recovery back into regular camera operation sometimes fail after special scene was played with devMode ON
// Likely due to some timing issue
// devMode OFF seems to work better.
// It seems that the camera goes back to whatever angle the scripted scene picked the next scene selected will be facked


//TEST- How do the new special scene actor stuff work alongside unconcious units with ace or reggs script
//TEST- Manual camera is affected by indiCam_fnc_followLogicFPS. Just properly suspend the camera
//TODO- Make actor deaths handeled by the cinematics system and more reliable.
//TODO- Actor death should now take actor auto switch setting into account.


//TEST- Make the main loop arrest for scripted scenes take into account all the keypresses
//TEST- Automatic night vision will now take terrain and current date into account and turn on half an hour after sunset and turn off half an hour before sunrise
//ADDED- Made the player list in gui display what side each player is on. Runs out of space real fast though.
//ADDED- Actor auto switching added to gui with controls for duration and nine different modes.
//ADDED- If a player is the current actor, that player will be selected in player list upon loading the gui
//ADDED- Manual mode added to gui.
//ADDED- Slider in GUI: Chance of capture cinematic scenes upon detection (0-100%). Zero means off.
//ADDED- The initial drop-down selection on map side will be whatever side the player is.
//ADDED- Pressing F9 during camera will now also store the scene name in a list. Going out of the camera immediately after pressing F9 will list the contents in a hint. Good for finding scenes that aren't working.
//FIXED- GUI now looks as intended in both the script and the mod version. Thanks Taro!
//ADDED- barrelWatch scene which will track barrel direction. Only for tanks for now.
//FIXED- Units of any side can now be selected on the gui map.
//FIXED- Scene override timer now works in scripted version without gui.
//FIXED- Eventhandlers weren't removed from non-actor units in a controlled fashion
//FIXED- Changed wording of gui elements and tooltips for some controls.
//FIXED- Updated diary with information on GUI.
//FIXED- Start button could be pressed repeatedly and launch several instances of the camera.
//FIXED- Settings changed in gui will now be applied even if the camera isn't already running.
//FIXED- Culled a whole lot of unused code.
//FIXED- When debug was on it spawned the indicator spheres on every machine.
//FIXED- indiCam settings window could be shown ontop of regular map which caused issues with cursor and markers
//KNOWN- If there is only one unit (the player) on a terrain, the camera will not find eligable actors and try to switch actor indefinitly
//KNOWN- An occational CTD when calculating too large or small movement values after switching actors. A crash detection and prevention is in place for now.

comment " SCRIPTED SCENES ";
//TODO- Turn dead actor handling over to scripted scenes and make a few different ones. make sure it isn't affected by the RNG 
//TODO- maybe put eventhandlers on units to handle death instead of the main loop thing?

comment " BACKLOG ";
//TODO- Add a variable that tracks all eventhandlers that have been started.
//TODO- Make a scene switch if the camera is stuck to the ground for too long
//TODO- Would be totally cool with a flashlight type function as with Zeus or the editor. Maybe spawn a local light above the actor?
//TODO- Preventing scene switching doesn't seem to prevent scene switching by obscured actor.
//TODO- Add proximity to enemies as a way to elevate the action value in situation check
//TODO- Moving value should maybe be used to stay on at least action value 1 in situation check
//TODO- Maybe should spawn several different action system checks that can work independently in situation check
//TODO- Scripted scene: Keep track of air assets when they have low velocity < 70 and are close to ground (< 10m) or when they are in the AO
//TODO- When using the randomize actor starting out from a civilian actor, the result might be an agent
//TODO- Add a good looking text that pops up on screen for a short time each time the actor was changed. gui: ["OFF", "TEMPORARY", "PERMANENT"]
//TODO- Add "persistent actor" function if that's not already in by default by selecting "none" in randomizer. It would then need something else to do while respawning and come back to the same player unit after respawn.
//TODO- Joey's play sessions produce rubberbanding when a stationary camera tracks a vic. At least vehicles need to use only logics
//TODO- Make sure the camera keeps following actors after death. Make sure the cameraman isn't selected. Use indiCam_var_actorAutoSwitch > 0
//TODO- Player selection list in dialogControl might need a refresh button. Now the user has to restart the dialog entirely.
//TODO- Make indiCam_fnc_distanceSort function test if proper params were passed.
//TODO- Add cleanup script that waits for the camera to close. Should make for a more stable cleanup if the main scripts gets interrupted
//TODO- Check to see if we can detect weapon switching. That would help with camera views on vehicles
//TODO- Rewrite game logics according to the new method used in randomLinear ro remove dependency on the logic objects.
//TODO- Make vehicles and aircraft detect shooting scenes with either a single fire category or by actionLevel
//TODO- Now that I have the environmentCheck I may want to add disqualification with something like (_urbanBool) then {find a new scene};
//TODO- Add indiCam_var_proximityValue functionality to situationCheck
//TODO- Add indiCam_var_movingValue functionality to situationCheck
//TODO- New scene: One that starts away from the actor and then uses cameraLogic to reduce distance in a non-linear manner
//TODO- New scene: groundCam - Human perspective of aircraft going by. Camera stationary at 1.8m
//TODO- New scene: randomWideFar - Randomized, long range, stationary shots with wide fov.
//TODO- New scene: weaponPerson - This would be the weaponCam, I guess. I'd love to get this to work
//TODO- New scene: linearPanCam - Camera that pans linearly while targeting the infrontLogic
//TODO- New scene: curvePanCam - Camera that pans non-linearly while targeting the infrontLogic
//TODO- New scene: groupCam - A camera that takes an entire squad into shot. Maybe maxDistance can be used to keep it in line if one member is half a world away. Check worldToScreen.
//TODO- New scene: Weapon cam tank/helo - attached right above or below the vic and rotating along with main barrel
//TODO- New scene: Infront logic combined with a camera attached above the rear of a tank


//OPINION- Tankbuster: fixed-wing, a camera 'bolted' to the top of the tailplane looking forward, or close to a weapon pylon. Perhaps it could switch near pylon/gun when player changes fire mode?
//OPINION- Land vehicles, when the player is in a Prowler, for example, a camera bolted to the roll cage would be funky.


//IDEA- "Roving mode" that doesn't make cuts, but simply moves the camera.
//IDEA- ADD CBA keybinds? Important that the script stays mod agnostic
//IDEA- ADD CBA mod settings? Important that the script stays mod agnostic, so maybe not
//IDEA- A more obvious indicator for when the camera is running. Perhaps a color indicator?
//IDEA- Make indiCam automatically look for other players on the server at startup and set one as actor. If no other players are there, set player as actor.
//IDEA- Add to GUI: indiCam_var_hiddenActorTime = 4; // Seconds to allow the actor to be hidden before switching scene unless indiCam_var_ignoreHiddenActor is true
//IDEA- Investigate "createSimpleObject/objects" if it's something that's better to use for logics
//IDEA- Maybe build a "transition" part between scenes, so that each scene can define how to go into it - sort of like with the different camera commits
//IDEA- A follow logic that tracks exactly where the actor stepped. That way it can follow through doors
//IDEA- Let advanced users override the onboard sceneSelect for a userconfig version.
//IDEA- Add ability to suspend the automatic switching of scenes at least through script. Would not top LOS switching.
//IDEA- Keep track of actor taking damage, up the action when that happens
//IDEA- Add camera control for other players. Maybe by broadcasting a variable containing connection ID or having a user grab the cameraman ID.
//IDEA- Add the possibility for the camera to follow objects around that has object name starting with indiCam_baton* in it's inventory
//IDEA- Maybe I should convert the main loop's interrupt to a function that I can call wherever?
//IDEA- Let any player walk up to the cameraman and action menu himself a set of addactions controls. that way we can send the vars to the correct connection id.
//IDEA- Is it possible to keep the follow logics away from buildings? Would help with LOS stuff
//IDEA- Maybe add a counter to sceneSelect so that the next scene test only tries a set number of times before waiting a little while before trying again.
//IDEA- How to stream the camera input to only an HUD element? Problem is camera commit. Maybe if the camera is created but not started it will work just fine? See KK's blog.
//IDEA- Can I get the camera to switch to first person view? Like when in a vic. Problem is recording will contain same perspective at times.
//IDEA- I need a way to know if an actor is on screen. some scenes are badly trimmed in. Maybe use worldToScreen?
//IDEA- A scene that checks for building windows around the actor and attempts to look through from the inside.
//IDEA- Maybe use something like {_justPlayers = allPlayers - entities "HeadlessClient_F";} to find players instead of what's used now


// This script should only run on player clients or on player host.
if (hasInterface) then {
	
	comment "-------------------------------------------------------------------------------------------------------";
	comment "													init												";
	comment "-------------------------------------------------------------------------------------------------------";
	// Loop to make sure player gets the mod initialized again after being dead for a time
	[] spawn {
	while {true} do {
	// Player is now either not spawned or has died
	waitUntil {alive player};
	// Player is now alive and kicking, let the script loose

	// initialize the graphical user interface
	[] execVM "INDICAM\indiCam_gui\indiCam_gui_init.sqf";



	comment "-------------------------------------------------------------------------------------------------------";
	comment "												settings												";
	comment "-------------------------------------------------------------------------------------------------------";
	// The following are useful values to change
	indiCam_devMode = false; // Makes scripts to either run as uncompiled with execVM or to recompile them continuously to speed up development
	indiCam_debug = false; // Switch this to true to enable debug messages (can be done in UI now)
	indiCam_var_hiddenActorTime = 4; // Seconds to allow the actor to be hidden before switching scene unless indiCam_var_ignoreHiddenActor is true
	indiCam_var_sceneHold = false; // True will suspend the timer that switches scene automatically



	indiCam = 0;



	comment "-------------------------------------------------------------------------------------------------------";
	comment "												variables												";
	comment "-------------------------------------------------------------------------------------------------------";
	indiCam_runIndiCam = false;
	indiCam_indiCamUpdate = false;


	// Logics - should probably be setup in a single array
	indiCam_followLogic = 0;
	indiCam_infrontLogic = 0;
	indiCam_weaponLogic = 0;
	indiCam_orbitLogic = 0;
	indiCam_centerLogic = 0;
	indiCam_linearLogic = 0;

	indiCam_indiCamLogicLoop = false;
	indiCam_var_visibilityCheckObscured = false;
	indiCam_var_visibilityCheckDistance = 0;
	indiCam_var_continuousCameraCommmit = false;
	indiCam_var_continuousCameraStopped = true;
	indiCam_var_interruptScene = false;


	// The following is for script control in conjunction with camera commit
	indiCam_var_holdScript = false;
	indiCam_var_runScript = false;
	indiCam_var_exitScript = false;


	// Actor management
	actor = player;
	indiCam_var_storedActor = player;			// For storing an actor unit so that another can be focused for a while
	indiCam_var_actorSide = side player;		// For keeping track of what side the current actor is part of
	indiCam_var_actorUID = 0; 					// For keeping track of players between deaths
	indiCam_var_mapselectAll = false;
	indiCam_var_mapOpened = false;
	indiCam_var_enterVehicleEH = 0;				// Eventhandler for actorManager
	indiCam_var_exitVehicleEH = 0;				// Eventhandler for actorManager
	indiCam_var_actorFiredEH = 0;				// Eventhandler for actorManager
	indiCam_var_actorAutoSwitch = false;		// Bool for when actor auto switch is enabled or not
	indiCam_var_actorAutoSwitchMode = 0;		// Default switch is between all players except cameraguy when there are more than him
	indiCam_var_actorAutoSwitchDuration = 300;	// Time for auto switch functions to attempt switch between units
	
	// Situation check
	indiCam_var_vicValue = 0;


	// These are for the selectScene and commitScene scripts
	indiCam_var_scene = "";
	indiCam_var_previousScene = "none";
	indiCam_var_takeTime = 5;
	indiCam_var_cameraMovementRate = 0;
	indiCam_var_cameraPos = (eyePos player);
	indiCam_var_cameraTarget = (eyePos actor);
	indiCam_var_cameraTargetScripted = (eyePos actor);
	indiCam_var_cameraFov = 0.7;
	indiCam_var_maxDistance = 1000;
	indiCam_var_cameraAttach = false;
	indiCam_var_cameraDetach = false;
	indiCam_var_ignoreHiddenActor = false;
	indiCam_var_attachCamera = false;
	indiCam_var_cameraChaseSpeed = 0.009;
	indiCam_var_targetTrackingSpeed = 0.1;
	indiCam_var_cameraType = "default";
	indiCam_var_disqualifyScene = false;
	indiCam_var_cameraSpeed = 1;
	indiCam_var_targetSpeed = 1;
	
	indiCam_var_actionValue = 0;

	indiCam_appliedVar_cameraType = indiCam_var_cameraType;
	indiCam_appliedVar_takeTime = indiCam_var_takeTime;
	indiCam_appliedVar_cameraMovementRate = indiCam_var_cameraMovementRate;
	indiCam_appliedVar_cameraPos = indiCam_var_cameraPos;
	indiCam_appliedVar_cameraTarget = indiCam_var_cameraTarget;
	indiCam_appliedVar_cameraTargetScripted = indiCam_var_cameraTarget;
	indiCam_appliedVar_cameraFov = indiCam_var_cameraFov;
	indiCam_appliedVar_maxDistance = indiCam_var_maxDistance;
	indiCam_appliedVar_cameraDetach = indiCam_var_cameraDetach;
	indiCam_appliedVar_ignoreHiddenActor = indiCam_var_ignoreHiddenActor;
	indiCam_appliedVar_cameraSpeed = indiCam_var_cameraSpeed;
	indiCam_appliedVar_targetSpeed = indiCam_var_targetSpeed;

	// Advanced scene scripts
	indiCam_scene_scriptedScene = {};
	indiCam_var_scriptedScene = false;
	indiCam_var_scriptedActor = player;
	indiCam_var_scriptedSceneType = "";
	indiCam_var_scriptedSceneChance = 100;

	// Camera control
	indiCam_var_visionIndex = 0;
	indiCam_var_manualMode = false;
	indiCam_var_sceneList = [];
	indiCam_var_activeEventHandlers = [];


	// GUI controls
	indiCam_var_checkBoxOverride = false;
	indiCam_var_durationOverride = 30;
	indiCam_var_actorAutoSwitchCheckboxState = false;
	
	indiCam_var_SceneOverrideState = false;
	indiCam_var_guiSceneOverrideDuration = 30;


	indiCam_var_unitCooldown = [];


	comment "-------------------------------------------------------------------------------------------------------";
	comment "												functions												";
	comment "-------------------------------------------------------------------------------------------------------";
	// Compile all scripts while also give a handy function to be able to recompile on the fly
	indiCam_fnc_compileAll = {

		//Logic scripts
		indiCam_cameraLogic_followLogic = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_followLogic.sqf";
		indiCam_cameraLogic_followLogicCamera = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_followLogicCamera.sqf";
		indiCam_cameraLogic_infrontLogic = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_infrontLogic.sqf";
		indiCam_cameraLogic_linear = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_linear.sqf";
		indiCam_cameraLogic_randomLinear = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_randomLinear.sqf";
		indiCam_cameraLogic_orbitActor = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_orbitActor.sqf";
		indiCam_cameraLogic_orbitPosition = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_orbitPosition.sqf";
		indiCam_cameraLogic_weaponLogic = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_weaponLogic.sqf";
		indiCam_cameraLogic_vehicleTurret = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_weaponLogic.sqf";

		// Scene scripts
		indiCam_fnc_sceneSelect = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_sceneSelect.sqf";
		indiCam_scene_mainFoot = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainFoot.sqf";
		indiCam_scene_mainCar = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainCar.sqf";
		indiCam_scene_mainHelicopter = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainHelicopter.sqf";
		indiCam_scene_mainPlane = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainPlane.sqf";
		indiCam_scene_mainTank = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainTank.sqf";
		indiCam_scene_mainBoat = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainBoat.sqf";
		indiCam_scene_mainScripted = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainScripted.sqf";
		
		// Engine scripts
		indiCam_fnc_actorManager = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_actorManager.sqf";
		indiCam_fnc_visibilityCheck = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_visibilityCheck.sqf";
		indiCam_fnc_cameraControl = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_cameraControl.sqf";
		indiCam_fnc_situationCheck = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_situationCheck.sqf";
		indiCam_fnc_environmentCheck = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_environmentCheck.sqf";
		indiCam_fnc_sceneTest = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_sceneTest.sqf";
		indiCam_fnc_sceneCommit = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_sceneCommit.sqf";
		
		// Functions
		indiCam_fnc_actorAutoSwitch = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_actorAutoSwitch.sqf";
		indiCam_fnc_launcherScan = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_launcherScan.sqf";
		indiCam_fnc_unitCooldown = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_unitCooldown.sqf";
		indiCam_fnc_followLogicFPS = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_followLogicFPS.sqf";
		indiCam_fnc_followLogicTurretAim = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_followLogicTurretAim.sqf";
		
		if (indiCam_debug) then {systemChat "-- scripts compiled --"};
		
	};
	[] call indiCam_fnc_compileAll;





	comment "-------------------------------------------------------------------------------------------------------";
	comment "												run scripts												";
	comment "-------------------------------------------------------------------------------------------------------";
	[] execVM "INDICAM\indiCam_diary.sqf";

	// Manages the actor, duh.
	if (indiCam_devMode) then {
		[] execVM "INDICAM\indiCam_fnc_actorManager.sqf";
		} else {
		[] spawn indiCam_fnc_actorManager;
	};


	// Give the player the option to start indiCam UI
	// Currently temporary. Make a script that makes sure that the player has these on him even after remoting with AIC
	player addAction ["indiCam", "_handle=createdialog 'indiCam_gui_dialogMain'"];



	// This is the end of the initialization to make sure the script will keep working after the cameraman has died
	waitUntil {!(alive player)};
	// Player is now dead
	removeAllActions player; // Makes sure that the dead player body won't have any addactions assigned by the script

	}; // This is where it all loops around when the player is back and alive

	}; // End of the infinite intitialization loop spawn

};