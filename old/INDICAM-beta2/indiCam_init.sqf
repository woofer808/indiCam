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
// [] execVM "INDICAM\indiCam_init.sqf";





//RELEASELEVEL- fix button controls
//RELEASELEVEL- signed serverkey
//RELEASELEVEL- make mod folder and script folder into a release package



//TODO- Turns out I can select vehicles as actors. Gotta fix that.
//TODO- Forcing next scene with F2 seems to stop working at times, seems to be when I don't wait long enough between presses
//TODO- Manual mode key won't work properly if the camera is stuck. It also needs to suspend the scene countdown timer while it's active
//TODO- Handle the situation of the actor being deleted
//TODO- Now that I have the environmentCheck I may want to add a variable to disqualify a scene like if (_urbanBool) then {find a new scene};
//TODO- Make cameraControl keep track of camera control between remoting
//TODO- Add camera control for other players. Maybe by broadcasting a variable containing connection ID or having a user grab the cameraman ID.
//TODO- Add indiCam_var_proximityValue functionality to situationCheck
//TODO- Add indiCam_var_movingValue functionality to situationCheck
//TODO- Linear random cam is now causing the scene switching to fail and sometimes crashes computer pretty badly (!)
//TODO- Finish the scriptedScene functionality

//TODO- New scene: One that starts away from the actor and then uses cameraLogic to reduce distance in a non-linear manner
//TODO- New scene: groundCam - Human perspective of aircraft going by. Camera stationary at 1.8m
//TODO- New scene: thirdPerson - Port the old third version view, use as high action scene
//TODO- New scene: randomWideFar - Randomized, long range, stationary shots with wide fov.
//TODO- New scene: weaponPerson - This would be the weaponCam, I guess. I'd love to get this to work
//TODO- New scene: linearPanCam - Camera that pans linearly while targeting the infrontLogic
//TODO- New scene: curvePanCam - Camera that pans non-linearly while targeting the infrontLogic
//TODO- New scene: roadieCam - Shaky follow camera from behind the actor (aka like gears of war). Both infrontLogic and followLogic needs to randomize linearly.
//TODO- New scene: shakyCamZoom - a zoomed in camera that is targeting a fast and short randomLinearLogic
//TODO- New scene: nonStabilizedCam - a zoomed in camera targeting a slow and long moving randomLinearLogic
//TODO- New scene: groupCam - A camera that takes an entire squad into shot. Maybe maxDistance can be used to keep it in line if one member is half a world away. Check worldToScreen.
//TODO- New scene: Weapon cam tank/helo - attached right above or below the vic and rotating along with main barrel
//TODO- New scene: Infront logic combined with a camera attached above the rear of a tank
//TODO- Keep track of actor taking damage
//TODO- Make aircraft detect shooting scenes with either a single fire category or by actionLevel

//IDEA- Add the possibility for the camera to follow objects around that has object name starting with indiCam_baton*
//IDEA- Maybe I should convert the main loop's interrupt to a function that I can call wherever?
//IDEA- Let any player walk up to the cameraman and action menu himself a set of addactions controls. that way we can send the vars to the correct connection id.
//IDEA- Maybe build a "transition" part between scenes, so that each scene can define how to go into it - sort of like with the different camera commits
//IDEA- Is it possible to keep the follow logics away from buildings? Would help with LOS stuff
//IDEA- Maybe add a counter to sceneSelect so that the next scene test only tries a set number of times before waiting a little while before trying again.
//IDEA- How to stream the camera input to only an HUD element? Problem is camera commit. Maybe if the camera is created but not started it will work just fine? See KK's blog.
//IDEA- Can I get the camera to switch to first person view? Like when in a vic. Problem is recording will contain same perspective at times.
//IDEA- I need a way to know if an actor is on screen. some scenes are badly trimmed in. Maybe use worldToScreen?
//IDEA- A scene that checks for building windows around the actor and attempts to look through from the inside.





comment "-------------------------------------------------------------------------------------------------------";
comment "												variables												";
comment "-------------------------------------------------------------------------------------------------------";
// The following are useful values to change
indiCam_debug = false; // Switch this for debug messages
indiCam_var_hiddenActorTime = 4; // Seconds to allow the actor to be hidden before switching scene unless ignoreHiddenActor is true


// The following are just setting up of variables
indiCam_runIndiCam = false;
indiCam_indiCamUpdate = false;

indiCam = 0;


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
indiCam_var_actorSide = side player;


// These are for the selectScene and commitScene scripts
indiCam_var_previousScene = "none";
indiCam_var_takeTime = 5;
indiCam_var_cameraMovementRate = 0;
indiCam_var_cameraPos = (eyePos player);
indiCam_var_cameraTarget = (eyePos actor);
indiCam_var_cameraFov = 0.7;
indiCam_var_maxDistance = 1000;
indiCam_var_cameraAttach = false;
indiCam_var_cameraDetach = false;
indiCam_var_ignoreHiddenActor = false;
indiCam_var_useRelativePos = false;
indiCam_var_relativePos = [0,-1,1.8];
indiCam_var_attachCamera = false;
indiCam_var_cameraChaseSpeed = 0.009;
indiCam_var_targetTrackingSpeed = 0.1;
indiCam_var_cameraType = "default";
indiCam_var_disqualifyScene = false;

indiCam_appliedVar_cameraType = indiCam_var_cameraType;
indiCam_appliedVar_takeTime = indiCam_var_takeTime;
indiCam_appliedVar_cameraMovementRate = indiCam_var_cameraMovementRate;
indiCam_appliedVar_cameraPos = indiCam_var_cameraPos;
indiCam_appliedVar_cameraTarget = indiCam_var_cameraTarget;
indiCam_appliedVar_cameraFov = indiCam_var_cameraFov;
indiCam_appliedVar_maxDistance = indiCam_var_maxDistance;
indiCam_appliedVar_cameraDetach = indiCam_var_cameraDetach;
indiCam_appliedVar_ignoreHiddenActor = indiCam_var_ignoreHiddenActor;
indiCam_appliedVar_cameraAttach = indiCam_var_cameraAttach;

// Advanced scene scripts
indiCam_fnc_scriptedScene = {};
indiCam_var_scriptedSceneDone = false;


comment "-------------------------------------------------------------------------------------------------------";
comment "												functions												";
comment "-------------------------------------------------------------------------------------------------------";
// Compile all scripts while also give a handy function to be able to recompile on the fly
indiCam_fnc_compileAll = {
	indiCam_cameraLogic_followLogic = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_followLogic.sqf";
	indiCam_cameraLogic_followLogicCamera = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_followLogicCamera.sqf";
	indiCam_cameraLogic_infrontLogic = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_infrontLogic.sqf";
	indiCam_cameraLogic_linear = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_linear.sqf";
	indiCam_cameraLogic_randomLinear = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_randomLinear.sqf";
	indiCam_cameraLogic_orbitActor = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_orbitActor.sqf";
	indiCam_cameraLogic_orbitPosition = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_orbitPosition.sqf";
	indiCam_cameraLogic_weaponLogic = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_weaponLogic.sqf";
	indiCam_cameraLogic_vehicleTurret = compile preprocessFileLineNumbers "INDICAM\logics\indiCam_cameraLogic_weaponLogic.sqf";

	indiCam_fnc_sceneSelect = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_sceneSelect.sqf";
	indiCam_fnc_visibilityCheck = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_visibilityCheck.sqf";
	indiCam_fnc_situationCheck = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_situationCheck.sqf";
	indiCam_fnc_environmentCheck = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_environmentCheck.sqf";
	indiCam_fnc_sceneTest = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_sceneTest.sqf";
	indiCam_fnc_sceneCommit = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_sceneCommit.sqf";
	indiCam_fnc_actorManager = compile preprocessFileLineNumbers "INDICAM\indiCam_fnc_actorManager.sqf";
	
};
[] call indiCam_fnc_compileAll;





comment "-------------------------------------------------------------------------------------------------------";
comment "												run scripts												";
comment "-------------------------------------------------------------------------------------------------------";
[] execVM "INDICAM\indiCam_diary.sqf";
[] execVM "INDICAM\indiCam_fnc_actorManager.sqf";



// Currently temporary. Make a script that makes sure that the player has these on him even after remoting with AIC
indiCam_addAction_startCamera = player addAction ["<t color='#FFFFFF'>start camera</t>",{[] execVM "INDICAM\indiCam_main.sqf";}];
indiCam_addAction_mapSelectFriendly = player addAction ["<t color='#FFFFFF'>set friendly actor</t>",{[] call indiCam_fnc_mapSelectFriendly}];
indiCam_addAction_mapSelectAll = player addAction ["<t color='#FFFFFF'>set ANY actor</t>",{[] call indiCam_fnc_mapSelectAll}];

indiCam_addAction_debug = player addAction ["<t color='#FFFFFF'>toggle debug</t>",{indiCam_debug = !indiCam_debug;hint str indiCam_debug;}];





// NOT VERIFIED
// Here's a method to make sure no text is displayed while the camera is on
if (indiCam_debug) then {enableRadio true} else {enableRadio false};
// NOT VERIFIED



