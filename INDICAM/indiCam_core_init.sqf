//-------------------------------------------------------------------------------------------------------
//											indiCam, by woofer.
//
//										independent cinematic camera									"
//																										
//																										
//	The purpose of the init is to compile all functions and set all variables from start.				
//																										
//																										
//	Definitions:																						
//	- Scene: A predefined camera angle with camera movement along with take time, fov and so on.		
//	- Variable names: indiCam_var_variableName															
//	- Function and script names: indiCam_fnc_functionOrScriptName(.sqf)									
//	- Object names: indiCam_objectName																	
//																										
//-------------------------------------------------------------------------------------------------------
// Versioning: Significant new functionality adds to the tenth of a version, scene additions and fixes adds to the hundreds




// Currently doing:
// - Can't seem to compile with 	#include "\a3\editor_f\Data\Scripts\dikCodes.h"  in config.cpp
// - Listening to TFAR and ACRE radios
		/*
		A-a-ron Today at 6:45 PM
		I know it was brought up/hinted at before but have you looked into the ACRE Spectator Display's for listening to radio/local comms.
		https://acre2.idi-systems.com/wiki/frameworks/spectator-displays
		*/


/* Changelog version 1.32*/	
///		PRIORITIES / DONE
//TODO- waitUntil {alive player}; not enough at start of indicam_core_init
//TODO- Make clients that have a running indicam camera post put a note on the server so that they can be excluded from other indicam clients actor autoswitching
//TODO- Make the actor switching work with several indicam running in the same mp session by individualizing indicam_var_network on each machine
//TODO- Situation checks do not work in multiplayer since local eventhandlers can't work on objects owned by remote machines.
//TODO- Actor death do not work on players in MP because the death cam eventhandler isn't local to their machine
//TODO- Put a setting in indiCam_core_Settings to define auto switching minimum distance (case 3)
//TODO- Dead units are considered SIDE CIV, meaning we need a last confirmed actorSide that wasn't polluted by death
//TODO- indiCam_fnc_actorSwitch uses allUnits, make sure to remove headless clients from that
//TEST- Actor switching modes in MP for not including actor, headless clients, dedis, player
//FIXED- Headless clients and dedicated servers are now more excluded from actor randomizations (Thanks Gold John King)
//FIXED- Cameradude wasn't excluded from "only players" actor randomization (Thanks Gold John King)
//FIXED- Current actor wasn't excluded from selection pool in some actor auto switching modes
//FIXED- Unit autoswitching mode within group now switches to another group if all units within the group dies.
//FIXED- Unit autoswitching mode within group no longer makes dead units the actor.
//FIXED- Chat is now hidden by default during camera operation.
//ADDED- Checkbox in gui for showing chat during camera operation.
//FIXED- Purged the last bunch of usages of comment command in scripts
//TWEAKED- Foot scenes spend less time high above and more time at low and medium distance
//TWEAKED- Foot scenes at higher action values have shorter scene duration by about a third
//ADDED- New foot scene "stationaryFrontRandom"
//TWEAKED- Helicopter scenes switch earlier when actor moves away from stationary camera
//TWEAKED- Helicopter front facing scenes are shorter by about two thirds
//TWEAKED- Actor was set multiple times when using the mapclick selection method.


//TODO- When a player actor enters a vehicle, the camera autoswitches actor according to current settings instead of staying with the unit.
//TODO- Put in disqualification features on scenes and make one "not for MP use" to get rid of helicopter choppy scenes
//TODO- Make sure actor deletion is handled the same way as actor getting killed.
//TODO- Make a gui setting for autoswitching distance sort (case 3) instead of the currently hard coded 500m on a second settings screen.
//TODO- Move keybinds from init to control script. Only F1 should work when camera is not running.
//TODO- Make it so that the script can be started without the GUI stuff. vision index currently craps it up. check TETET's post. --> Thanks for this not so informative comment, past me.
//TODO- Possibility to state conditions in a scene to disqualify it. For example if a scene should only be used for a specific vehicle.
//TODO- Make sure the camera keeps following actors after death.
//TODO- Add "persistent actor" function if that's not already in by default by selecting "none" in randomizer. It would then need something else to do while respawning and come back to the same player unit after respawn.
//TODO- Would be totally cool with a flashlight type function as with Zeus or the editor. Maybe spawn a local light above the actor?
//TODO- Preventing scene switching doesn't seem to prevent scene switching by obscured actor. Are we fine with that?

///		SCRIPTED SCENES 
//TODO- How do the new special scene actor stuff work alongside unconcious units with ace or reggs script?
//TODO- Add "killer" as scripted scene as a death scene. Could be made to be shown on every occation in GUI.
//TODO- Detect incoming mortar fire and switch to show an overview of the location at impact
//TODO- Soemthing weird with launcherScan sometimes. It's like it's being looped endlessly on having an AT actor on cooldown
//TODO- When the AT script is activated, it should keep a lookout if the unit puts the AT back.
//TODO- Scripted scene: DropOff - Keep track of helicopters when they have low velocity < 70 and are close to ground (< 10m) and in camera vincinity

///		BACKLOG
//TODO- Fog of war functionality. A checkbox in the GUI that only shows enemies that current camera side knowsAbout.
//TODO- Might need to spawn a background function that keeps track of indiCam_running variable
//TODO- Scripted scenes that makes jumps to close-by animals
//TODO- Make a scene switch if the camera is stuck to the ground for too long
//TODO- Add proximity to enemies as a way to elevate the action value in situation check
//TODO- Moving value should maybe be used to stay on at least action value 1 in situation check
//TODO- Maybe should spawn several different action system checks that can work independently in situation check
//TODO- When using the randomize actor starting out from a civilian actor, the result might be an agent
//TODO- Add a good looking text that pops up on screen for a short time each time the actor was changed. gui: ["OFF", "TEMPORARY", "PERMANENT"]
//TODO- Player selection list in dialogControl might need a refresh button. Now the user has to restart the dialog entirely.
//TODO- Make indiCam_fnc_distanceSort function test if proper params were passed.
//TODO- Add cleanup script that waits for the camera to close. Should make for a more stable cleanup if the main scripts gets interrupted
//TODO- Check to see if we can detect weapon switching. That would help with camera views on vehicles (compare current ammo to weapon type?)
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


// ------------------------------------------------------------------------------------------------------
//													init												
//-------------------------------------------------------------------------------------------------------
// indiCam script should only init on player clients or on player hosts.
if (!hasInterface) exitWith {};

// Start of init function
indiCam_fnc_init = {	// Here to suspend initialization if there is a mission control box.



	// Player is now either not spawned or has died --> NO! Not enough when autospawning into editor placed units as in indicam dev mission
	// Needs something more robust
	waitUntil {alive player};



	indiCam_actor = player;

	// Read up on all the hottest settings
	// Execute this during camera operation to reset to normal
	_settings = [] execVM "INDICAM\indiCam_core_settings.sqf";
	waitUntil {scriptDone _settings};


	// initialize the graphical user interface
	[] execVM "INDICAM\indiCam_gui\indiCam_gui_init.sqf";


	// Initialize running modes - possible modes are [default, interrupt, scripted, manual, off]
	indiCam_var_requestMode = "off";
	indiCam_var_currentMode = "off";
	indiCam_running = false;

	// Initialize the diary entry
	[] execVM "INDICAM\indiCam_core_diary.sqf";


	//-------------------------------------------------------------------------------------------------------
	//												variables												
	//-------------------------------------------------------------------------------------------------------
	// Actor management
	indiCam_var_actorAutoSwitch = false;
	indiCam_var_actorSide		= side player;		// Keeps track of actor's side through death
	
	indiCam_var_network = [	// The network data for eventhandlers
		player,			// 0: The new actor unit
		2,		// 1: Target machine number in the network
		2,	// 2: Indicam machine number in the network
		123456789,		// 3: No UID in singleplayer - renders as "_SP_PLAYER_"
		[],					// 4: the array containing EH name and id numbers
		[]					// 5: accumulated eh's from select 4 for mopping up
	];


	// Initialize switching timers
	indiCam_var_sceneTimer = time + 9999999;
	indiCam_var_actorTimer = time + 9999999;
	indiCam_var_sceneSelectRunning = false;

	// Camera variables
	indiCam_var_activeEventHandlers = [];

	// More variables
	indiCam_var_mapselectAll = false;
	indiCam_var_mapOpened = false;
	indiCam_var_sceneList = [];
	indiCam_var_actionValue = 0;

	// Scene selection
	indiCam_var_scene = "";
	indiCam_var_sceneType = "";
	indiCam_var_previousScene = "none";

	indiCam_var_takeTime = 30;
	indiCam_var_cameraMovementRate = 0.5;
	indiCam_var_cameraPos = (getPos player);
	indiCam_var_targetPos = (getPos player);
	indiCam_var_cameraSpeed = 1;
	indiCam_var_targetSpeed = 1;
	indiCam_var_cameraTarget = player;
	indiCam_var_cameraTargetScripted = player;
	indiCam_var_cameraFov = 0.74;
	indiCam_var_maxDistance = 5000;
	indiCam_var_ignoreHiddenActor = false;
	indiCam_var_cameraType = "";
	indiCam_var_sceneHold = false;

	indiCam_appliedVar_takeTime = indiCam_var_takeTime;
	indiCam_appliedVar_cameraMovementRate = indiCam_var_cameraMovementRate;
	indiCam_appliedVar_cameraPos = indiCam_var_cameraPos;
	indiCam_appliedVar_targetPos = indiCam_var_targetPos;
	indiCam_appliedVar_cameraSpeed = indiCam_var_cameraSpeed;
	indiCam_appliedVar_targetSpeed = indiCam_var_targetSpeed;
	indiCam_appliedVar_cameraTarget = indiCam_var_cameraTarget;
	indiCam_appliedVar_cameraTargetScripted = indiCam_var_cameraTargetScripted;
	indiCam_appliedVar_cameraFov = indiCam_var_cameraFov;
	indiCam_appliedVar_maxDistance = indiCam_var_maxDistance;
	indiCam_appliedVar_ignoreHiddenActor = indiCam_var_ignoreHiddenActor;
	indiCam_appliedVar_cameraType = indiCam_var_cameraType;

	// Advanced scene scripts
	indiCam_scene_scriptedScene = {};
	indiCam_var_scriptedSceneRunning = false;
	indiCam_var_scriptedSceneType = "";
	indiCam_var_unitCooldown = [];
	indiCam_var_tempPos = [0,0,0];
	indiCam_var_launcherScanArray = [];

	// GUI controls
	indiCam_var_checkBoxOverride = false;
	indiCam_var_durationOverride = 30;
	indiCam_var_actorAutoSwitchCheckboxState = false;

	indiCam_var_SceneOverrideState = false;
	indiCam_var_guiSceneOverrideDuration = 30;
	indiCam_var_sceneSwitch = true;

	// Variables to fix bugs
	indiCam_var_visionIndex = 0;

	//-------------------------------------------------------------------------------------------------------
	//												functions												
	//-------------------------------------------------------------------------------------------------------
	// Compile functions as a function. Makes it possible to compile on the fly
	indiCam_fnc_compileAll = {
		indiCam_core_main = compile preprocessFileLineNumbers "INDICAM\indiCam_core_main.sqf";
		indiCam_core_mainLoop = compile preprocessFileLineNumbers "INDICAM\indiCam_core_mainLoop.sqf";
		indiCam_core_inputControls = compile preprocessFileLineNumbers "INDICAM\indiCam_core_inputControls.sqf";
		
		indiCam_fnc_debug = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_debug.sqf";
		indiCam_fnc_sceneTest = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_sceneTest.sqf";
		indiCam_fnc_actorSwitch = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_actorSwitch.sqf";
		indiCam_fnc_EHsetup = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_EHsetup.sqf";
		indiCam_fnc_actorEH = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_actorEH.sqf";
		indiCam_fnc_clientEHToIndiCam = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_clientEHToIndiCam.sqf";
		indiCam_fnc_indiCamEHToClient = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_indiCamEHToClient.sqf";
		indiCam_fnc_actorList = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_actorList.sqf";
		indiCam_fnc_distanceSort = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_distanceSort.sqf";
		indiCam_fnc_situationCheck = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_situationCheck.sqf";
		indiCam_fnc_visibilityCheck = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_visibilityCheck.sqf";
		indiCam_fnc_environmentCheck = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_environmentCheck.sqf";
		indiCam_fnc_visionMode = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_visionMode.sqf";
		indiCam_fnc_manualMode = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_manualMode.sqf";
		indiCam_fnc_launcherScan = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_launcherScan.sqf";
		indiCam_fnc_unitCooldown = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_unitCooldown.sqf";
		indiCam_fnc_followLogicFPS = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_followLogicFPS.sqf";
		indiCam_fnc_followLogicTurretAim = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_followLogicTurretAim.sqf";
		indiCam_fnc_twopointLOS = compile preprocessFileLineNumbers "INDICAM\functions\indiCam_fnc_twopointLOS.sqf";
		
		indiCam_scene_selectMain = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_selectMain.sqf";
		indiCam_scene_selectScripted = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_selectScripted.sqf";
		indiCam_scene_mainBoat = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainBoat.sqf";
		indiCam_scene_mainCar = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainCar.sqf";
		indiCam_scene_mainFoot = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainFoot.sqf";
		indiCam_scene_mainHelicopter = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainHelicopter.sqf";
		indiCam_scene_mainPlane = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainPlane.sqf";
		indiCam_scene_mainTank = compile preprocessFileLineNumbers "INDICAM\scenes\indiCam_scene_mainTank.sqf";
		
		if (indiCam_debug) then {systemChat "-- scripts compiled --"};
	};
	[] call indiCam_fnc_compileAll;

	// Set the player as the initial actor by calling the actor switch script thereby setting the proper eventhandlers
	// Initialize the network eventhandler system before though
	call indiCam_fnc_EHsetup;
	// Always use this script to set a new actor. Don't use the regular actor for scripted scenes.
	[player] call indiCam_fnc_actorSwitch;



	// This function removes eventhandlers of certain types stored in the global variable
	indiCam_fnc_clearEventhandlers = {
		while { !(indiCam_var_activeEventHandlers isEqualTo []) } do {	// This extra while loop ensures array is empty
			{
				[_x, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				indiCam_var_activeEventHandlers = indiCam_var_activeEventHandlers - [_x];
			} forEach indiCam_var_activeEventHandlers;
		};

	};

	/*
	// Define the function that is to run when the CBA bound key is pressed.
	indiCam_fnc_keyGUI = {
		// Only open the dialog if it's not already open
		if (isNull (findDisplay indiCam_id_guiDialogMain)) then {createDialog "indiCam_gui_dialogMain";} else {closeDialog 0};
	};
	*/

	

	// Only init the GUI key if it's not already initialized
	if (isNil {missionNamespace getVariable "indiCam_var_inizialized"}) then {
		missionNamespace setVariable ["indiCam_var_inizialized", true];


		//-------------------------------------------------------------------------------------------------------
		//	Stop camera / Open GUI - F1-key																		
		//-------------------------------------------------------------------------------------------------------

		// Define the function that is to run when the CBA bound key is pressed.
		indiCam_fnc_keyGUI = {
			// Only open the dialog if it's not already open
			if (isNull (findDisplay indiCam_id_guiDialogMain)) then {createDialog "indiCam_gui_dialogMain";} else {closeDialog 0};
		};	


		// Assign the key depending on CBA being loaded or not
		if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {

			// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
			["indiCam","guiKey", ["indiCam control windows", "Show or hide indiCam controls."], {_this spawn indiCam_fnc_keyGUI}, {}, [59, [false, false, false]]] call CBA_fnc_addKeybind;

		} else {
			
			// This key needs to be persistent
			[] spawn {
				while {true} do {
					waituntil {(inputAction "SelectGroupUnit1" > 0)};
					["F1-key pressed.",true,true] call indiCam_fnc_debug;
					[] spawn indiCam_fnc_keyGUI;
					waituntil {inputAction "SelectGroupUnit1" <= 0};
				};
			};
		};

	};



}; // end of init function


// If there is an object in the mission called indiCam_missionControl that will get the action menu option to initialize at will
// Perfect for when only a specific user should have access to the indiCam script version
// This part makes sure indiCam only initializes if there is no mission control box
if (isNil {missionNamespace getVariable "indiCam_missionControl"}) then {

	[] spawn indiCam_fnc_init; 												// Initialize indiCam if no box was found
	
} else {
	["Mission control box found.",true,true] call indiCam_fnc_debug;		// make debug debug
	
	indiCam_missionControl addAction ["start indiCam", {					// Put the addaction to the object
		
		[] spawn {
			[] spawn indiCam_fnc_init;										// initialize indiCam scripts
			hintSilent "indiCam starting...";
			sleep 1;
			createDialog "indiCam_gui_dialogMain";
			hintSilent "indiCam initialized";
		};
		
	}];





};


