comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "											indiCam_fnc_sceneSelect										";
comment "																										";
comment "	This script contains and selects from the available scenes.											";
comment "																										";
comment "	Each scene is a separate case and so can be duplicated and slightly altered to give more variation.	";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";



comment "-------------------------------------------------------------------------------------------------------";
comment "												init													";
comment "-------------------------------------------------------------------------------------------------------";
private "_scene";
indiCam_var_sceneSelectDone = false;

// Check the environment 
private _environmentCheck = [] call indicam_fnc_environmentCheck;



comment "-------------------------------------------------------------------------------------------------------";
comment "											main loop start												";
comment "-------------------------------------------------------------------------------------------------------";
// This loop will run until a scene is found that will have enough visibility of the actor.
private _runSceneSelect = true;
while {_runSceneSelect} do {

	// Terminate any paused logic scripts before preparing the next scene
	if (indiCam_var_holdScript) then {indiCam_var_exitScript = true;};



comment "-------------------------------------------------------------------------------------------------------";
comment "										actor on foot scenes											";
comment "-------------------------------------------------------------------------------------------------------";
	if (indiCam_var_vicValue == 0) then { // Actor on foot scenes
		
		if (indiCam_var_actionValue == 0) then { // Low action value scenes
		
			_scene = selectRandom [ // Choose a random scene from the list
										"standardScene",		// Basic example scene (randomWideMedium)
										"randomWideFar",		// Randomized stationary wide shots
										"cheeseCam",			// Advanced chase cam with logic target
										"actorChase",			// Basic chase cam with actor as target
										"relativeCam",			// Preforms a contiuous commit alongside camSetRelPos
										"droneCamActor", 		// Angled top-down view that rotates around a follow logic
										"droneCamPosition",//jittery 	// Angled top-down view that rotates around a fixed position
										"birdPerson",			// Fixed top-down bird view that targets actor
										"satellitePersonStill",	// Fixed top-down view that targets point in front of the actor
										"faceCamFront",			// Fixed wide fovfront view that targets the follow logic
										"randomNarrowFar",		// Randomized stationary narrow shots
										"randomWideClose",		// Randomized stationary narrow shots
										"thirdPersonHigh",		// High third person followcam with logic target
										"droneCamPerson",		// Basic chase cam with a top-down view
										"randomWideSmooth",		// Smooth randomized stationary wide shots
										"randomWideCloseSmooth",// Smooth randomized stationary wide shots for run-bys
										"randomNarrowSmooth"	// Smooth randomized stationary wide shots for run-bys
									];


			switch (_scene) do {
				
				case "standardScene": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-40,0,40]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-40,0,40]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [1,3,10]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
					}; // end of case
				
				
				case "randomWideFar": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-100,0,100];
					_posY = random [-100,0,100];
					_posZ = random [1,8,20];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.4,0.6,0.9]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				
				case "cheeseCam": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = (actor modelToWorld [0.3,-2,1.8]);
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[5,0.1] spawn indiCam_cameraLogic_infrontLogic;
					[indiCam_var_cameraPos,110,0.2] spawn indiCam_cameraLogic_followLogicCamera;
				}; // end of case
				
			
				case "actorChase": {
				// Basic chase cam with actor as target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-1,1.8];
					indiCam_var_cameraTarget = actor;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-1,1.8]];
					// Start up any necessary logic entities
					[[0.3,-1,1.8],110,1] spawn indiCam_cameraLogic_followLogicCamera;
				}; // end of case
				
			
				case "relativeCam": {
				// Preforms a contiuous commit alongside camSetRelPos
					indiCam_var_cameraType = "relative";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 5;
					indiCam_var_cameraTarget = actor;
					indiCam_var_relativePos = [0.75,-2,2];
					indiCam_var_cameraPos = indiCam_var_cameraTarget modelToWorld indiCam_var_relativePos;
					indiCam_var_cameraFov = 0.8;
					indiCam_var_maxDistance = 1000;
					indiCam_var_cameraAttach = false;
					indiCam_var_ignoreHiddenActor = false;
					// unused for now
					indiCam_var_cameraMovementRate = 0;
				}; // end of case
				
				case "droneCamActor": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.03;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[100,300,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "droneCamPosition": { // Currently jittery
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = (getPos actor);
					indiCam_var_cameraFov = 0.25;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[125,200,100,0.075] spawn indiCam_cameraLogic_orbitActor;
				}; // end of case
				
				case "birdPerson": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-50,0,50];
					_posY = random [-50,0,50];
					_posZ = random [175,200,175];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.3,0.5,0.6]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "satellitePersonStill": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-50,0,50];
					_posY = 50;
					_posZ = random [100,150,100];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = [(getPos actor) select 0,((getPos actor) select 1) + 50,(getPos actor) select 2]; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.3,0.5,0.6]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "faceCamFront": {
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,2,1];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 1.2;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_infrontLogic, [0.3,0,1]];
					// Start up any necessary logic entities
					[3,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
					[[0.3,2,1],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "randomNarrowFar": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = selectRandom [random [-225,-125,-225],random [125,225,125]];
					_posY = selectRandom [random [-225,-125,-225],random [125,225,125]];
					_posZ = random [1.8,40,1.8];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.01,0.05,0.01]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 500; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "randomWideClose": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 7; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-8,0,8];
					_posY = random [-8,0,8];
					_posZ = random [0.3,2,0.3];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [1,1.5,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 30; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "thirdPersonHigh": {
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 40;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-1,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 0.5;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-1,3]];
					// Start up any necessary logic entities
					[1,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
					[[0.3,-1,3],100,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "droneCamPerson": {
				// Basic chase cam with a top-down view
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0,-1,100];
					indiCam_var_cameraTarget = actor;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-1,1.8]];
					// Start up any necessary logic entities
					[[0,-1,100],110,1] spawn indiCam_cameraLogic_followLogicCamera;
				}; // end of case
				
				case "randomWideSmooth": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					_posX = random [-40,0,40]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-40,0,40]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [0.7,4,10]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = false;
					// Start up any necessary logic entities
					[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
				}; // end of case
				
				case "randomWideCloseSmooth": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8;
					indiCam_var_cameraMovementRate = 0;
					_posX = random [-7,0,7]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-7,0,7]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [0.3,1,2]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 1.2;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = false;
					// Start up any necessary logic entities
					[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
				}; // end of case
				
				case "randomNarrowSmooth": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8;
					indiCam_var_cameraMovementRate = 0;
					_posX = selectRandom [random [-100,-40,-100],random [100,40,100]];
					_posY = selectRandom [random [-100,-40,-100],random [100,40,100]];
					_posZ = random [0.8,2,3]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.5;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = false;
					// Start up any necessary logic entities
					[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
				}; // end of case
				
			}; // end of switch
			
		}; // End of low action value scenes
		
		if (indiCam_var_actionValue == 1) then { // Medium action value scenes
		
		
					_scene = selectRandom [ // Choose a random scene from the list
										"standardScene",		// Basic example scene (randomWideMedium)
										"randomWideFar",		// Randomized stationary wide shots
										"cheeseCam",			// Advanced chase cam with logic target
										"actorChase",			// Basic chase cam with actor as target
										"relativeCam",			// Preforms a contiuous commit alongside camSetRelPos
										"droneCamActor", 		// Angled top-down view that rotates around a follow logic
										"birdPerson",			// Fixed top-down bird view that targets actor
										"satellitePersonStill",	// Fixed top-down view that targets point in front of the actor
										"randomNarrowFar",		// Randomized stationary narrow shots
										"randomWideClose",		// Randomized stationary narrow shots
										"shoulderCam",			// Intense action shoulder cam to run for short periods of time.
										"droneCamPerson",		// Basic chase cam with a top-down view
										"randomWideSmooth",		// Smooth randomized stationary wide shots
										"randomWideCloseSmooth",// Smooth randomized stationary wide shots for run-bys
										"randomNarrowSmooth"	// Smooth randomized stationary wide shots for run-bys
									];


			switch (_scene) do {
				
				case "standardScene": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-40,0,40]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-40,0,40]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [1,3,10]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
					}; // end of case
				
				
				case "randomWideFar": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-100,0,100];
					_posY = random [-100,0,100];
					_posZ = random [1,8,20];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.4,0.6,0.9]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				
				case "cheeseCam": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = (actor modelToWorld [0.3,-2,1.8]);
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[5,0.1] spawn indiCam_cameraLogic_infrontLogic;
					[indiCam_var_cameraPos,110,0.2] spawn indiCam_cameraLogic_followLogicCamera;
				}; // end of case
			
				case "actorChase": {
				// Basic chase cam with actor as target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-1,1.8];
					indiCam_var_cameraTarget = actor;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-1,1.8]];
					// Start up any necessary logic entities
					[[0.3,-1,1.8],110,1] spawn indiCam_cameraLogic_followLogicCamera;
				}; // end of case
				
			
				case "relativeCam": {
				// Preforms a contiuous commit alongside camSetRelPos
					indiCam_var_cameraType = "relative";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 5;
					indiCam_var_cameraTarget = actor;
					indiCam_var_relativePos = [0.75,-2,2];
					indiCam_var_cameraPos = indiCam_var_cameraTarget modelToWorld indiCam_var_relativePos;
					indiCam_var_cameraFov = 0.8;
					indiCam_var_maxDistance = 1000;
					indiCam_var_cameraAttach = false;
					indiCam_var_ignoreHiddenActor = false;
					// unused for now
					indiCam_var_cameraMovementRate = 0;
				}; // end of case
				
				case "droneCamActor": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.03;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[100,300,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "birdPerson": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-50,0,50];
					_posY = random [-50,0,50];
					_posZ = random [175,200,175];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.3,0.5,0.6]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "satellitePersonStill": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-50,0,50];
					_posY = 50;
					_posZ = random [100,150,100];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = [(getPos actor) select 0,((getPos actor) select 1) + 50,(getPos actor) select 2]; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.3,0.5,0.6]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "randomNarrowFar": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = selectRandom [random [-225,-125,-225],random [125,225,125]];
					_posY = selectRandom [random [-225,-125,-225],random [125,225,125]];
					_posZ = random [1.8,40,1.8];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.01,0.05,0.01]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 500; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "randomWideClose": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 7; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-8,0,8];
					_posY = random [-8,0,8];
					_posZ = random [0.3,2,0.3];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [1,1.5,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 30; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "shoulderCam": {
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 10;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_weaponLogic;
					indiCam_var_cameraFov = 0.7;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [actor, [0.1,0.1,0.1], "RightHand"];
					// Start up any necessary logic entities
					[3] spawn indiCam_cameraLogic_weaponLogic; // [distance]
				}; // end of case
				
				case "droneCamPerson": {
				// Basic chase cam with a top-down view
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0,-1,100];
					indiCam_var_cameraTarget = actor;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-1,1.8]];
					// Start up any necessary logic entities
					[[0,-1,100],110,1] spawn indiCam_cameraLogic_followLogicCamera;
				}; // end of case
				
				case "randomWideSmooth": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					_posX = random [-40,0,40]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-40,0,40]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [0.7,4,10]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = false;
					// Start up any necessary logic entities
					[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
				}; // end of case
				
				case "randomWideCloseSmooth": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8;
					indiCam_var_cameraMovementRate = 0;
					_posX = random [-7,0,7]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-7,0,7]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [0.3,1,2]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 1.2;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = false;
					// Start up any necessary logic entities
					[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
				}; // end of case
				
				case "randomNarrowSmooth": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8;
					indiCam_var_cameraMovementRate = 0;
					_posX = selectRandom [random [-100,-40,-100],random [100,40,100]];
					_posY = selectRandom [random [-100,-40,-100],random [100,40,100]];
					_posZ = random [0.8,2,3]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.5;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = false;
					// Start up any necessary logic entities
					[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
				}; // end of case
				
			}; // end of switch
		
		
		}; // End of medium action value scenes
		
		if (indiCam_var_actionValue == 2) then { // High action value scenes
		
		
					_scene = selectRandom [ // Choose a random scene from the list
										"standardScene",		// Basic example scene (randomWideMedium)
										"cheeseCam",			// Advanced chase cam with logic target
										"actorChase",			// Basic chase cam with actor as target
										"relativeCam",			// Preforms a contiuous commit alongside camSetRelPos
										"droneCamActor", 		// Angled top-down view that rotates around a follow logic
										"birdPerson",			// Fixed top-down bird view that targets actor
										"faceCamFront",			// Fixed wide fovfront view that targets the follow logic
										"randomNarrowFar",		// Randomized stationary narrow shots
										"randomWideClose",		// Randomized stationary narrow shots
										"thirdPersonHigh",		// High third person followcam with logic target
										"randomWideSmooth",		// Smooth randomized stationary wide shots
										"randomWideCloseSmooth",// Smooth randomized stationary wide shots for run-bys
										"randomNarrowSmooth"	// Smooth randomized stationary wide shots for run-bys
									];


			switch (_scene) do {
				
				case "standardScene": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-40,0,40]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-40,0,40]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [1,3,10]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
					}; // end of case
				
				case "cheeseCam": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = (actor modelToWorld [0.3,-2,1.8]);
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[5,0.1] spawn indiCam_cameraLogic_infrontLogic;
					[indiCam_var_cameraPos,110,0.2] spawn indiCam_cameraLogic_followLogicCamera;
				}; // end of case
				
			
				case "actorChase": {
				// Basic chase cam with actor as target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-1,1.8];
					indiCam_var_cameraTarget = actor;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-1,1.8]];
					// Start up any necessary logic entities
					[[0.3,-1,1.8],110,1] spawn indiCam_cameraLogic_followLogicCamera;
				}; // end of case
				
			
				case "relativeCam": {
				// Preforms a contiuous commit alongside camSetRelPos
					indiCam_var_cameraType = "relative";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 5;
					indiCam_var_cameraTarget = actor;
					indiCam_var_relativePos = [0.75,-2,2];
					indiCam_var_cameraPos = indiCam_var_cameraTarget modelToWorld indiCam_var_relativePos;
					indiCam_var_cameraFov = 0.8;
					indiCam_var_maxDistance = 1000;
					indiCam_var_cameraAttach = false;
					indiCam_var_ignoreHiddenActor = false;
					// unused for now
					indiCam_var_cameraMovementRate = 0;
				}; // end of case
				
				case "droneCamActor": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.03;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[100,300,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "birdPerson": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-50,0,50];
					_posY = random [-50,0,50];
					_posZ = random [175,200,175];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.3,0.5,0.6]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case

				case "faceCamFront": {
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,2,1];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 1.2;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_infrontLogic, [0.3,0,1]];
					// Start up any necessary logic entities
					[3,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
					[[0.3,2,1],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "randomNarrowFar": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = selectRandom [random [-225,-125,-225],random [125,225,125]];
					_posY = selectRandom [random [-225,-125,-225],random [125,225,125]];
					_posZ = random [1.8,40,1.8];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.01,0.05,0.01]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 500; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "randomWideClose": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 7; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-8,0,8];
					_posY = random [-8,0,8];
					_posZ = random [0.3,2,0.3];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [1,1.5,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 30; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "thirdPersonHigh": {
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 40;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-1,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 0.5;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-1,3]];
					// Start up any necessary logic entities
					[1,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
					[[0.3,-1,3],100,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "randomWideSmooth": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					_posX = random [-40,0,40]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-40,0,40]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [0.7,4,10]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = false;
					// Start up any necessary logic entities
					[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
				}; // end of case
				
				case "randomWideCloseSmooth": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8;
					indiCam_var_cameraMovementRate = 0;
					_posX = random [-7,0,7]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-7,0,7]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [0.3,1,2]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 1.2;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = false;
					// Start up any necessary logic entities
					[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
				}; // end of case
				
				case "randomNarrowSmooth": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8;
					indiCam_var_cameraMovementRate = 0;
					_posX = selectRandom [random [-100,-40,-100],random [100,40,100]];
					_posY = selectRandom [random [-100,-40,-100],random [100,40,100]];
					_posZ = random [0.8,2,3]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.5;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = false;
					// Start up any necessary logic entities
					[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
				}; // end of case
				
			}; // end of switch
		
		
		}; // End of high action value scenes
		
		if (indiCam_var_actionValue == 3) then { // Very high action value scenes
		
		
					_scene = selectRandom [ // Choose a random scene from the list
										"standardScene",		// Basic example scene (randomWideMedium)
										"actorChase",			// Basic chase cam with actor as target
										"relativeCam",			// Preforms a contiuous commit alongside camSetRelPos
										"birdPerson",			// Fixed top-down bird view that targets actor
										"faceCamFront",			// Fixed wide fovfront view that targets the follow logic
										"randomWideClose",		// Randomized stationary narrow shots
										"thirdPersonHigh",		// High third person followcam with logic target
										"shoulderCam"			// Intense action shoulder cam to run for short periods of time.
									];


			switch (_scene) do {
				
				case "standardScene": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-1,0,1]; // Specifies the range for the camera position sideways to the actor
					_posY = random [-1,-10,-1]; // Specifies the range for the camera position to the front and back of the actor
					_posZ = random [1,3,10]; // Specifies the range for the camera position vertically from the actor
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
					}; // end of case
				
				case "actorChase": {
				// Basic chase cam with actor as target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-1,1.8];
					indiCam_var_cameraTarget = actor;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-1,1.8]];
					// Start up any necessary logic entities
					[[0.3,-1,1.8],110,1] spawn indiCam_cameraLogic_followLogicCamera;
				}; // end of case
				
			
				case "relativeCam": {
				// Preforms a contiuous commit alongside camSetRelPos
					indiCam_var_cameraType = "relative";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15;
					indiCam_var_cameraTarget = actor;
					indiCam_var_relativePos = [0.75,-2,2];
					indiCam_var_cameraPos = indiCam_var_cameraTarget modelToWorld indiCam_var_relativePos;
					indiCam_var_cameraFov = 0.8;
					indiCam_var_maxDistance = 1000;
					indiCam_var_cameraAttach = false;
					indiCam_var_ignoreHiddenActor = false;
					// unused for now
					indiCam_var_cameraMovementRate = 0;
				}; // end of case
				
				case "birdPerson": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 10; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-50,0,50];
					_posY = random [-50,0,50];
					_posZ = random [175,200,175];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.3,0.5,0.6]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case

				case "faceCamFront": {
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,2,1];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 1.2;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_infrontLogic, [0.3,0,1]];
					// Start up any necessary logic entities
					[3,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
					[[0.3,2,1],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "randomWideClose": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 10; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-8,0,8];
					_posY = random [-8,0,8];
					_posZ = random [0.3,2,0.3];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [1,1.5,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 30; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "thirdPersonHigh": {
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-1,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 0.5;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-1,3]];
					// Start up any necessary logic entities
					[1,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
					[[0.3,-1,3],100,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "shoulderCam": {
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 10;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_weaponLogic;
					indiCam_var_cameraFov = 0.7;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [actor, [0.1,0.1,0.1], "RightHand"];
					// Start up any necessary logic entities
					[3] spawn indiCam_cameraLogic_weaponLogic; // [distance]
				}; // end of case

			}; // end of switch
		
		}; // End of very high action value scenes
		
	}; // End of actor on foot scenes

	
comment "-------------------------------------------------------------------------------------------------------";
comment "										actor in vehicle scenes											";
comment "-------------------------------------------------------------------------------------------------------";
	if (indiCam_var_vicValue == 1) then { // Car, quad, truck or similar type scenes
		
		if ((speed vehicle actor) < 3 ) then { // Low speed or stationary vehicle
		
			_scene = selectRandom [ // Choose a random scene from the list
										"standardSceneCar",	// Basic example scene
										"randomDriveBy",	// Randomized low, close and wide fov angle
										//"wheelCam",			// Wheel cam view - the racing equivalent to the Wilhelm scream. Gotta have it.
										//"hoodCamForward",	// Hood cam forward.
										"hoodCamBackward",	// Hood cam backward.
										"droneCamCar"		// Orbiting drone view that follows target.
									];

			switch (_scene) do {
				
				case "standardSceneCar": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-150,0,150]; // Specifies
					_posY = random [-150,0,150];
					_posZ = random [1,3,10];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "randomDriveBy": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = selectRandom [random [-10,-3,-10],random [3,10,3]];
					_posY = random [-10,20,30];
					_posZ = random [0.8,1,1.3];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.8,1,1.2]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 100; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "wheelCam": {
					indiCam_var_cameraType = "default";
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [(vehicle actor), [selectRandom [-2,2],-1,-0.5]];
					indiCam_logicInfront attachTo [(vehicle actor), [0,10,1]];
				}; // end of case
				
				case "hoodCamForward": {
					indiCam_var_cameraType = "default";
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1.4;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [(vehicle actor), [selectRandom [-0.3,0.3],0,0.5]];
					indiCam_logicInfront attachTo [(vehicle actor), [0,10,1]];
				}; // end of case
				
				case "hoodCamBackward": {
					indiCam_var_cameraType = "default";
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = actor;
					indiCam_var_cameraFov = 1.4;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [(vehicle actor), [selectRandom [-0.3,0.3],0.5,0.5]];
				}; // end of case
				
				case "droneCamCar": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.07;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[100,300,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],30,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
			}; // End of switch
		
		}; // End of no speed scenes
		
		if ( ((speed vehicle actor) > 3) && ((speed vehicle actor) < 50) ) then { // Medium speed
		
			_scene = selectRandom [ // Choose a random scene from the list
										"standardSceneCar",	// Basic example scene
										"randomDriveBy",	// Randomized low, close and wide fov angle
										//"wheelCam",			// Wheel cam view - the racing equivalent to the Wilhelm scream. Gotta have it.
										//"hoodCamForward",	// Hood cam forward.
										"hoodCamBackward",	// Hood cam backward.
										"droneCamCar"		// Orbiting drone view that follows target.
									];

			switch (_scene) do {
				
				case "standardSceneCar": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-150,0,150]; // Specifies
					_posY = random [-150,0,150];
					_posZ = random [1,3,10];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "randomDriveBy": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = selectRandom [random [-10,-3,-10],random [3,10,3]];
					_posY = random [-10,20,30];
					_posZ = random [0.8,1,1.3];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.8,1,1.2]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 100; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "wheelCam": {
					indiCam_var_cameraType = "default";
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [(vehicle actor), [selectRandom [-2,2],-1,-0.5]];
					indiCam_logicInfront attachTo [(vehicle actor), [0,10,1]];
				}; // end of case
				
				case "hoodCamForward": {
					indiCam_var_cameraType = "default";
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1.4;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [(vehicle actor), [selectRandom [-0.3,0.3],0,0.5]];
					indiCam_logicInfront attachTo [(vehicle actor), [0,10,1]];
				}; // end of case
				
				case "hoodCamBackward": {
					indiCam_var_cameraType = "default";
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = actor;
					indiCam_var_cameraFov = 1.4;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [(vehicle actor), [selectRandom [-0.3,0.3],0.5,0.5]];
				}; // end of case
				
				case "droneCamCar": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.07;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[100,300,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],30,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
			}; // End of switch
		
		}; // End of medium speed scenes
		
		if ( ((speed vehicle actor) > 50) ) then { // Speed of Speed
		
			_scene = selectRandom [ // Choose a random scene from the list
										"standardSceneCar",	// Basic example scene
										"randomDriveBy",	// Randomized low, close and wide fov angle
										//"wheelCam",			// Wheel cam view - the racing equivalent to the Wilhelm scream. Gotta have it.
										//"hoodCamForward",	// Hood cam forward.
										"hoodCamBackward",	// Hood cam backward.
										"droneCamCar"		// Orbiting drone view that follows target.
									];

			switch (_scene) do {
				
				case "standardSceneCar": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-150,0,150]; // Specifies
					_posY = random [-150,0,150];
					_posZ = random [1,3,10];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "randomDriveBy": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = selectRandom [random [-10,-3,-10],random [3,10,3]];
					_posY = random [-10,20,30];
					_posZ = random [0.8,1,1.3];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.8,1,1.2]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 100; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "wheelCam": {
					indiCam_var_cameraType = "default";
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [(vehicle actor), [selectRandom [-2,2],-1,-0.5]];
					indiCam_logicInfront attachTo [(vehicle actor), [0,10,1]];
				}; // end of case
				
				case "hoodCamForward": {
					indiCam_var_cameraType = "default";
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1.4;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [(vehicle actor), [selectRandom [-0.3,0.3],0,0.5]];
					indiCam_logicInfront attachTo [(vehicle actor), [0,10,1]];
				}; // end of case
				
				case "hoodCamBackward": {
					indiCam_var_cameraType = "default";
					indiCam_var_takeTime = 20;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = actor;
					indiCam_var_cameraFov = 1.4;
					indiCam_var_maxDistance = 100;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [(vehicle actor), [selectRandom [-0.3,0.3],0.5,0.5]];
				}; // end of case
				
				case "droneCamCar": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.07;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[100,300,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],30,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
			}; // End of switch
		
		}; // End of Speed scenes
		
	}; // End of vehicle scenes
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "									actor in aircraft scenes											";
comment "																										";
comment "	Current altitude checks																				";
comment "	Aircraft on ground or landing: less than 3m															";
comment "	Aircraft low altitude: between 3m and 15m															";
comment "	Aircraft medium altitude: between 15m and 600m														";
comment "	Aircraft high altitude: above 600m																	";
comment "-------------------------------------------------------------------------------------------------------";
	if (indiCam_var_vicValue == 2) then { // Helicopter or plane scenes
		
		if ( ((getPos vehicle actor) select 2) < 3 ) then { // Aircraft on ground or landing scenes
		
			_scene = selectRandom [ // Choose a random scene from the list
										"standardSceneAir",	// Basic example scene
										"flyByClose",		// Close fixed wide fov view
										"landingCam",		// Helicopter close side position third person view
										"smoothFlyByCam"	// Rotating logic with wide fov
									];

			switch (_scene) do {
				
				case "standardSceneAir": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 10; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-50,0,50];
					_posY = random [-25,0,25];
					_posZ = random [1,5,1];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "flyByClose": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-10,0,10];
					_posY = random [25,50,75];
					_posZ = random [1,5,1];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "landingCam": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 10;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = (vehicle actor) modelToWorldWorld [0.3,-10,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 0.5;
					indiCam_var_maxDistance = 500;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					_posX = selectRandom [-3,3];
					_posY = -3;
					_posZ = -0.8;
					indiCam attachTo [(vehicle actor), [_posX,_posY,_posZ]];
					// Start up any necessary logic entities
					[15,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
				}; // end of case
				
				case "smoothFlyByCam": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.3;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = true;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[50,1,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],100,0.2] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
			}; // End of switch
		
		}; // End of low action value scenes
		
		if ( (((getPos vehicle actor) select 2) > 3) && (((getPos vehicle actor) select 2) < 15) ) then { // Aircraft low altitude scenes
		
			_scene = selectRandom [ // Choose a random scene from the list
										"standardSceneAir",	// Basic example scene
										"flyByClose",		// Close fixed wide fov view
										"cheeseCamAir",		// Smooth follow logic with target logic
										"smoothFlyByCam"	// Rotating logic with wide fov
									];

			switch (_scene) do {
				
				case "standardSceneAir": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-200,0,200];
					_posY = random [-100,0,100];
					_posZ = random [1,20,1];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 500; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "flyByClose": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-10,0,10];
					_posY = random [25,50,75];
					_posZ = random [1,5,1];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "cheeseCamAir": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-10,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 500;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-10,1.8]];
					// Start up any necessary logic entities
					[4,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
					[[0.3,-10,4],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "smoothFlyByCam": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.3;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = true;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[50,1,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],100,0.2] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
			}; // End of switch
		
		}; // End of medium action value scenes
		
		if ( (((getPos vehicle actor) select 2) > 15) && (((getPos vehicle actor) select 2) < 600) ) then { // Aircraft medium altitude scenes
		
			_scene = selectRandom [ // Choose a random scene from the list
										"standardSceneAir",	// Basic example scene
										"flyByClose",		// Close fixed wide fov view
										"cheeseCamAir",		// Smooth follow logic with target logic
										"smoothFlyByCam",	// Rotating logic with wide fov
										"flybyFront"		// Flyby from ground perspective from the front
									];

			switch (_scene) do {
				
				case "standardSceneAir": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-200,0,200];
					_posY = random [-100,0,100];
					_posZ = random [1,20,1];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 500; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "flyByClose": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-10,0,10];
					_posY = random [25,50,75];
					_posZ = random [1,5,1];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "cheeseCamAir": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-10,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 500;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-10,1.8]];
					// Start up any necessary logic entities
					[4,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
					[[0.3,-10,4],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "smoothFlyByCam": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.3;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = true;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[50,1,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],100,0.2] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "flybyFront": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					// Set the camera position in relation to actor's current pos and ground or water surface
					private _distance = random [100,500,100];
					private _direction = 0;
					private _posZ = 1.8;
					private _relativePosition = actor getRelPos [_distance,_direction];
					indiCam_var_cameraPos = [(_relativePosition select 0),(_relativePosition select 1),_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.2,0.3,0.4]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 800; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				
			}; // End of switch
		
		}; // End of high action value scenes
		
		if ( (((getPos vehicle actor) select 2) > 600) ) then { // Aircraft high altitude scenes
		
			_scene = selectRandom [ // Choose a random scene from the list
										"standardSceneAir",	// Basic example scene
										"flyByClose",		// Close fixed wide fov view
										"cheeseCamAir",		// Smooth follow logic with target logic
										"smoothFlyByCam"	// Rotating logic with wide fov
									];

			switch (_scene) do {
				
				case "standardSceneAir": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-500,0,500];
					_posY = random [-500,0,500];
					_posZ = random [1,20,1];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 1000; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "flyByClose": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 8; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-75,0,75];
					_posY = random [75,100,125];
					_posZ = random [-10,0,10];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
				case "cheeseCamAir": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 60;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-10,1.8];
					indiCam_var_cameraTarget = indiCam_infrontLogic;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 500;
					indiCam_var_ignoreHiddenActor = false;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_followLogic, [0.3,-10,1.8]];
					// Start up any necessary logic entities
					[4,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
					[[0.3,-10,4],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
				case "smoothFlyByCam": {
				// Advanced chase cam with logic target
					indiCam_var_cameraType = "logics";
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 30;
					indiCam_var_cameraMovementRate = 0;
					indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
					indiCam_var_cameraTarget = indiCam_followLogic;
					indiCam_var_cameraFov = 0.3;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = true;
					// Control wether the camera should be attached to anything
					indiCam_var_cameraAttach = true;
					indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
					// Start up any necessary logic entities
					[50,1,100,0.075] spawn indiCam_cameraLogic_orbitActor;
					[[0.3,-2,1.8],100,0.2] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
				}; // end of case
				
			}; // End of switch
		
		}; // End of very high action value scenes
		
	}; // End of helicopter or plane scenes
	
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "										actor in tank scenes											";
comment "-------------------------------------------------------------------------------------------------------";
	if (indiCam_var_vicValue == 3) then { // Boat scenes
		
		if (indiCam_var_actionValue < 10) then { // Low action value scenes
		
			_scene = selectRandom [
										"standardSceneBoat"// Basic example scene
									];

			switch (_scene) do {
				
				case "standardScene": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-100,0,100]; // Specifies
					_posY = random [-100,0,100];
					_posZ = random [-1,3,10];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
			}; // End of switch
		
		}; // End of low action value scenes
		
		/* Kept for posterity for now. Not really there yet.
		if (indiCam_var_actionValue == 1) then { // Medium action value scenes
		
		}; // End of medium action value scenes
		
		if (indiCam_var_actionValue == 2) then { // High action value scenes
		
		}; // End of high action value scenes
		
		if (indiCam_var_actionValue == 3) then { // Very high action value scenes
		
		}; // End of very high action value scenes
		*/
		
	}; // End of boat scenes


	
comment "-------------------------------------------------------------------------------------------------------";
comment "										actor in boat scenes											";
comment "-------------------------------------------------------------------------------------------------------";
	if (indiCam_var_vicValue == 4) then { // Boat scenes
		
		if ( ((speed vehicle actor) < 3) ) then { // Low action value scenes
		
			_scene = selectRandom [
										"standardSceneBoat"// Basic example scene
									];

			switch (_scene) do {
				
				case "standardScene": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-100,0,100]; // Specifies
					_posY = random [-100,0,100];
					_posZ = random [-1,3,10];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
			}; // End of switch
		
		}; // End of low action value scenes
		
		if ( ((speed vehicle actor) > 3) ) then { // Medium action value scenes
		
			_scene = selectRandom [
										"standardSceneBoat"// Basic example scene
									];

			switch (_scene) do {
				
				case "standardScene": {
					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					_posX = random [-100,0,100]; // Specifies
					_posY = random [-100,0,100];
					_posZ = random [-1,3,10];
					indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
					indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.5,0.74,1]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 200; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
				}; // end of case
				
			}; // End of switch
		
		}; // End of medium action value scenes
		
	}; // End of boat scenes




	
	
	

	

comment "-------------------------------------------------------------------------------------------------------";
comment "										scene prototyping area											";
comment "																										";
private _prototypeScene = false; // Switch this to true to use the prototyping area
if (_prototypeScene) then {
indiCam_var_exitScript = true; // This kills any held scripts
sleep 0.1; // Just giving the scripts time to die
comment "-------------------------------------------------------------------------------------------------------";
// Change the stuff below here



					indiCam_var_cameraType = "default"; // Specifies how the camera will be committed
					indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
					indiCam_var_takeTime = 15; // Duration of scene in seconds
					indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
					// Set the camera position in relation to actor's current pos and ground or water surface
					private _distance = random [100,500,100];
					private _direction = 0;
					private _posZ = 1.8;
					private _relativePosition = actor getRelPos [_distance,_direction];
					indiCam_var_cameraPos = [(_relativePosition select 0),(_relativePosition select 1),_posZ]; // Position of camera
					indiCam_var_cameraTarget = (vehicle actor); // This is the object the camera will be pointed towards
					indiCam_var_cameraAttach = false; // True if scene is using attachTo command
					indiCam_var_cameraFov = random [0.2,0.3,0.4]; // Set FOV, standard Arma FOV is 0.74
					indiCam_var_maxDistance = 500; // Distance from actor to camera that forces a scene switch
					indiCam_var_ignoreHiddenActor = false; // True means scene will be applied regardless of LOS checks
					






comment "-------------------------------------------------------------------------------------------------------";
}; // End of prototyping area
comment "-------------------------------------------------------------------------------------------------------";

	
	
	
	

	
	
	
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "											test the scene												";
comment "-------------------------------------------------------------------------------------------------------";

	// Do all the necessary tests
	if (indiCam_var_disqualifyScene) then {
		
		// If the scene doesn't qualify to be applied as per a check preformed or if it's been disabled, pick a new scene
		if (indiCam_debug) then {systemChat "scene didn't pass qualification - selecting new scene"};
		
	} else {

		// Test the the scene before applying it
		//if (indiCam_debug) then {_debugPoint = createVehicle ["Sign_Sphere100cm_F", indiCam_var_cameraPos, [], 0, "NONE"];};
		_sceneTest = [indiCam_var_cameraPos] call indiCam_fnc_sceneTest; // If the scene test checks out good, this will return true
		
		// If the scene is ok, exit sceneSelect and keep what's stored in global
		// Also make sure the scene doesn't have the same name as the previously committed one
		if (_sceneTest && !(_scene isEqualTo indiCam_var_previousScene)) then {
		
			if (indiCam_debug) then {systemChat format ["Scene selected: %1",_scene]};
				// Store the last used scene in a variable so that it can be prevented to run the very next time
				indiCam_var_previousScene = _scene;
				_runSceneSelect = false;

		} else {

			if (indiCam_debug) then {systemChat "actor obscured or same scene - selecting new scene"};
			
		};
		
	};

};



indiCam_var_sceneSelectDone = true;

