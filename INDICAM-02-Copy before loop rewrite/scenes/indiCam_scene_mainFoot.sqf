
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
			indiCam_var_cameraSpeed = 0.2;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
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
			indiCam_var_cameraPos = [(selectRandom [-1,1]),-0.5,1.8];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,2,1.8];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.5;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.6;			// Field of view, standard Arma FOV is 0.74
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
			indiCam_var_cameraSpeed = 0.3;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0.75,0,1.8];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.5;			// Defines how tightly the logic will track it's defined position
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
		
	}; // end of switch

}; // End of very high action value scenes

