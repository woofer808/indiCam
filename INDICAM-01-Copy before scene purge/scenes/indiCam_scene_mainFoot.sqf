
comment "-------------------------------------------------------------------------------------------------------";
comment "										actor on foot scenes											";
comment "-------------------------------------------------------------------------------------------------------";


if (indiCam_var_actionValue == 0) then { // Low action value scenes

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list

								//"randomWideFar",		// Randomized stationary wide shots
								//"droneCamActor",//jittery  		// Angled top-down view that rotates around a follow logic
								//"droneCamPosition",//jittery 	// Angled top-down view that rotates around a fixed position
								//"birdPerson",			// Fixed top-down bird view that targets actor
								//"satellitePersonStill",	// Fixed top-down view that targets point in front of the actor
								//"faceCamFront",			// Fixed wide fovfront view that targets the follow logic
								//"randomNarrowFar",		// Randomized stationary narrow shots
								//"randomWideClose",		// Randomized stationary narrow shots
								//"thirdPersonHigh",		// High third person followcam with logic target
								//"droneCamPerson",		// Basic chase cam with a top-down view
								//"randomWideSmooth",		// Smooth randomized stationary wide shots
								//"randomNarrowSmooth",	// Smooth randomized stationary wide shots for run-bys
								//"nonStabilizedCam",		// Simulated unstable binoculars using linear game logic
								
								"standardScene",		// Stationary camera tracking a logic
								"chaseCam",			// Advanced FPS-based chase cam
								"cheeseCam",		// Advanced FPS-based chase cam with logic target
								"faceCam",			// Advanced FPS-based chase cam with logic target
								"skyCam"			// Still camera from far above tracking a slow logic
							];

	switch (indiCam_var_scene) do {
		
		case "cheeseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-1,-5,2.5];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.6;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,-0.5,2];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0.75,0,1.8];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,5,1];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,3,10];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [-10,0,2];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.3,0.4,0.5];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
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
			_posZ = random [125,150,125];
			indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
			indiCam_var_cameraTarget = actor; // This is the object the camera will be pointed towards
			indiCam_var_cameraAttach = false; // True if scene is using attachTo command
			indiCam_var_cameraFov = random [0.1,0.25,0.35]; // Set FOV, standard Arma FOV is 0.74
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
			_posZ = random [200,300,200];
			indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ]; // Position of camera
			indiCam_var_cameraTarget = [(getPos actor) select 0,((getPos actor) select 1) + 50,(getPos actor) select 2]; // This is the object the camera will be pointed towards
			indiCam_var_cameraAttach = false; // True if scene is using attachTo command
			indiCam_var_cameraFov = random [0.05,0.1,0.12]; // Set FOV, standard Arma FOV is 0.74
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_followLogic, [0,-1,100]];
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = false;
			// Start up any necessary logic entities
			[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
		}; // end of case
		
		case "nonStabilizedCam": {
		// Simulated unstable binoculars using linear game logic
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;
			indiCam_var_cameraMovementRate = 0;
			_posX = selectRandom [random [-350,-350,-350],random [250,350,250]];
			_posY = selectRandom [random [-350,-250,-350],random [250,350,250]];
			_posZ = random [8,12,20];
			indiCam_var_cameraPos = actor modelToWorld [_posX,_posY,_posZ];
			indiCam_var_cameraTarget = indiCam_linearLogic;
			indiCam_var_cameraFov = (random [0.07,0.09,0.1]);
			indiCam_var_maxDistance = 1000;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = false;
			// Start up any necessary logic entities
			[5,5,5,20,0.5,actor] spawn indiCam_cameraLogic_randomLinear; // [x,y,z,speed,proximity,target]
		}; // end of case
		
	}; // end of switch
	
}; // End of low action value scenes

if (indiCam_var_actionValue == 1) then { // Medium action value scenes


			indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								//"standardScene",		// Basic example scene (randomWideMedium)
								//"randomWideFar",		// Randomized stationary wide shots
								//"cheeseCam",			// Advanced chase cam with logic target
								//"actorChase",			// Basic chase cam with actor as target
								//"relativeCam",			// Preforms a contiuous commit alongside camSetRelPos
								//"droneCamActor",//jittery 		// Angled top-down view that rotates around a follow logic
								//"birdPerson",			// Fixed top-down bird view that targets actor
								//"satellitePersonStill",	// Fixed top-down view that targets point in front of the actor
								//"randomNarrowFar",		// Randomized stationary narrow shots
								//"randomWideClose",		// Randomized stationary narrow shots
								//"shoulderCam",			// Intense action shoulder cam to run for short periods of time.
								//"droneCamPerson",		// Basic chase cam with a top-down view
								//"randomWideSmooth",		// Smooth randomized stationary wide shots
								//"randomNarrowSmooth"	// Smooth randomized stationary wide shots for run-bys
								
								"standardScene",		// Stationary camera tracking a logic
								"chaseCam",			// Advanced FPS-based chase cam
								"cheeseCam",		// Advanced FPS-based chase cam with logic target
								"faceCam",			// Advanced FPS-based chase cam with logic target
								"skyCam"			// Still camera from far above tracking a slow logic
								];

	switch (indiCam_var_scene) do {
		
		case "cheeseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-1,-5,2.5];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.6;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,-0.5,2];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0.75,0,1.8];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,5,1];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,3,10];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [-10,0,2];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.3,0.4,0.5];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = false;
			// Start up any necessary logic entities
			[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
		}; // end of case
		
	}; // end of switch


}; // End of medium action value scenes

if (indiCam_var_actionValue == 2) then { // High action value scenes


			indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								//"standardScene",		// Basic example scene (randomWideMedium)
								//"cheeseCam",			// Advanced chase cam with logic target
								//"actorChase",			// Basic chase cam with actor as target
								//"relativeCam",			// Preforms a contiuous commit alongside camSetRelPos
								//"birdPerson",			// Fixed top-down bird view that targets actor
								//"faceCamFront",			// Fixed wide fovfront view that targets the follow logic
								//"randomNarrowFar",		// Randomized stationary narrow shots
								//"randomWideClose",		// Randomized stationary narrow shots
								//"thirdPersonHigh",		// High third person followcam with logic target
								//"randomWideSmooth",		// Smooth randomized stationary wide shots
								//"randomNarrowSmooth"	// Smooth randomized stationary wide shots for run-bys
								
								
								"standardScene",		// Stationary camera tracking a logic
								"chaseCam",			// Advanced FPS-based chase cam
								"cheeseCam",		// Advanced FPS-based chase cam with logic target
								"faceCam",			// Advanced FPS-based chase cam with logic target
								"skyCam"			// Still camera from far above tracking a slow logic
							];

	switch (indiCam_var_scene) do {
		
		case "cheeseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-1,-5,2.5];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.6;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,-0.5,2];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0.75,0,1.8];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,5,1];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,3,10];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [-10,0,2];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.3,0.4,0.5];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = false;
			// Start up any necessary logic entities
			[[0.3,-1,1.8],60,0.2] spawn indiCam_cameraLogic_followLogic;
		}; // end of case
		
	}; // end of switch


}; // End of high action value scenes

if (indiCam_var_actionValue == 3) then { // Very high action value scenes


			indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								//"shoulderCam",			// Intense action shoulder cam to run for short periods of time.
								//"shakyChasePerson"		// By the force of three three logics combined, here comes crappyvision!
								
								
								"standardScene",		// Stationary camera tracking a logic
								"chaseCam",			// Advanced FPS-based chase cam
								"cheeseCam",		// Advanced FPS-based chase cam with logic target
								"faceCam",			// Advanced FPS-based chase cam with logic target
								"skyCam"			// Still camera from far above tracking a slow logic
							];

	switch (indiCam_var_scene) do {
		
		case "cheeseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-1,-5,2.5];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.6;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,-0.5,2];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0.75,0,1.8];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,5,1];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,3,10];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [-10,0,2];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.3,0.4,0.5];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [actor, [0.1,0.1,0.1], "RightHand"];
			// Start up any necessary logic entities
			[3] spawn indiCam_cameraLogic_weaponLogic; // [distance]
		}; // end of case
		
		case "shakyChasePerson": {
			// Cheese cam combined with camera shake
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = actor modelToWorld [0,0,0];
			indiCam_var_cameraTarget = indiCam_linearLogic;
			indiCam_var_cameraFov = 0.7;
			indiCam_var_maxDistance = 1000;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_followLogic, [0,-0,1]];
			// Start up any necessary logic entities
			[[0,-5,0],60,1] spawn indiCam_cameraLogic_followLogicCamera;
			[20,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
			[1,1,0.3,4.5,0.3,actor] spawn indiCam_cameraLogic_randomLinear;
		}; // end of case

	}; // end of switch

}; // End of very high action value scenes

