// Actor on foot

if (indiCam_var_actionValue == 0) then { // Low action value scenes

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardScene",	// Stationary camera tracking a logic
								"chaseCam",			// Advanced FPS-based chase cam
								"cheeseCam",		// Advanced FPS-based chase cam with logic target
								"faceCam",			// Advanced FPS-based chase cam with logic target
								"skyCam",			// Still camera from far above tracking a slow logic
								"followCamHigh",	// Highly positioned follow camera
								"birdPerson",		// High above camera tightly following actor
								"randomWideFar",	// Smooth randomized stationary narrow shots for wide shot scenes
								"randomNarrowFar",	// Smooth randomized stationary narrow shots for zoomed in scenes
								"randomNarrowClose",// Smooth randomized stationary wide shots for run-bys
								"stationaryFrontRandom",// Regular stationary camera tracking a logic target in front of the actor
								"satellitePerson"	// Satellite type follow camera
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
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
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
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
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
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
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
			indiCam_var_cameraPos = [-10,0,2];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.3,0.4,0.5];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "followCamHigh": {
			// Highly positioned follow camera
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 		// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;					// Time after which a new scene will be selected
			_posX = random [-15,0,15]; 					// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [(random [-20,-15,-10]),(random [40,35,30])]; // Specifies the range for the camera position to the front and back of the actor
			_posZ = random [15,20,25];					// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.1;				// Defines how tightly the camera will track it's defined position (higher is closer)
			indiCam_var_targetPos = [0,10,2];			// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;				// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;	// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.6;				// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 500;				// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;		// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;			// Control whether the camera should be attached to anything
		}; // end of case
		
		case "birdPerson": {
			// High above camera tightly following actor
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 		// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;					// Time after which a new scene will be selected
			_posZ = random [50,75,100];					// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [0.5,-1.5,_posZ];// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.1;				// Defines how tightly the camera will track it's defined position (higher is closer)
			indiCam_var_targetPos = [0,0,1.7];			// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;				// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;	// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.15,0.3,0.35];	// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 500;				// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;		// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;			// Control whether the camera should be attached to anything
		}; // end of case
		
		case "randomWideFar": {
			// Smooth randomized stationary narrow shots for wide shot scenes
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 15;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-150,-100,-150],random [-150,-100,-150]]; // Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-150,-100,-150],random [-150,-100,-150]];	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [20,50,75];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ]; // Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;	// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.15,0.2,0.3];	// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 600;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "randomNarrowFar": {
			// Smooth randomized stationary narrow shots for zoomed in scenes
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 30;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-150,-100,-150],random [-150,-100,-150]]; // Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-150,-100,-150],random [-150,-100,-150]];	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [20,50,75];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ]; // Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;	// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.03,0.06,0.09]; // Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 600;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "randomNarrowClose": {
			// Smooth randomized stationary narrow shots for run-bys
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-15,-2,-15],random [2,15,2]]; // Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-15,-10,-15],random [10,15,10]];	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [0.5,1,2];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ]; // Position of camera relative to the actor
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.6;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;	// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.1,0.2,0.3]; // Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 600;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "satellitePerson": {
			// Satellite type follow camera
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 		// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;					// Time after which a new scene will be selected
			_posZ = random [150,175,200];					// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [0.5,-1.5,_posZ];// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.1;				// Defines how tightly the camera will track it's defined position (higher is closer)
			indiCam_var_targetPos = [0,0,1.7];			// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.5;				// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;	// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.05,0.07,0.1];	// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;				// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;		// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;			// Control whether the camera should be attached to anything
		}; // end of case

		case "stationaryFrontRandom": {
			// Regular stationary camera tracking a logic target in front of the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-2,0,2]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [5,20,30];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,2,5];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // end of switch
	
}; // End of low action value scenes

if (indiCam_var_actionValue == 1) then { // Medium action value scenes


			indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardScene",	// Stationary camera tracking a logic
								"chaseCam",			// Advanced FPS-based chase cam
								"cheeseCam",		// Advanced FPS-based chase cam with logic target
								"faceCam",			// Advanced FPS-based chase cam with logic target
								"skyCam",			// Still camera from far above tracking a slow logic
								"followTight",		// Smooth non-jerky follow cam with closeup
								"stationaryFrontRandom",// Regular stationary camera tracking a logic target in front of the actor
								"followClose"		// Close over-shoulder follow
								
								];

	switch (indiCam_var_scene) do {
		
		case "cheeseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 40;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-1,-5,2.5];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.6;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 40;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,-0.5,2];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.3;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0.75,0,1.8];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.5;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 40;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,5,1];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 40;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-10,0,2];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];			// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.3,0.4,0.5];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "followTight": {
			// Smooth non-jerky follow cam with closeup
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 		// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 40;					// Time after which a new scene will be selected
			indiCam_var_cameraPos = [0.5,-1.5,2];// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.1;				// Defines how tightly the camera will track it's defined position (higher is closer)
			indiCam_var_targetPos = [0,-0.5,1.7];			// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;				// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;	// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.4;				// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 500;				// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;		// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;			// Control whether the camera should be attached to anything
		}; // end of case
		
		case "followClose": {
			// Close over-shoulder follow
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 		// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 40;					// Time after which a new scene will be selected
			_posX = selectRandom [-0.5,0.5]; 			// Specifies the range for the camera position sideways to the actor
			_posY = -1; 								// Specifies the range for the camera position to the front and back of the actor
			
			// Height is dependent on actor stance, check and set it accordingly
			_posZ = selectRandom [1.5,1.6];
			if ( (stance indiCam_actor) == ("UNDEFINED") ) then {_posZ = 20};
			if ( (stance indiCam_actor) == ("") ) then {_posZ = 10};
			if ( (stance indiCam_actor) == ("PRONE") ) then {_posZ = 0.5};			
			if ( (stance indiCam_actor) == ("CROUCH") ) then {_posZ = selectRandom [1,0.5]};
			if ( (stance indiCam_actor) == ("STAND") ) then {_posZ = selectRandom [1.5,1,0.5]};
			
			indiCam_var_cameraPos = [_posX,_posY,_posZ];// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.6;				// Defines how tightly the camera will track it's defined position (higher is closer)
			indiCam_var_targetPos = [_posX,(-1*_posY),_posZ];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.6;				// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;	// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.5;				// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 500;				// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;		// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;			// Control whether the camera should be attached to anything
		}; // end of case

		case "stationaryFrontRandom": {
			// Regular stationary camera tracking a logic target in front of the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 40;				// Time after which a new scene will be selected
			_posX = random [-5,0,5]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [5,10,15];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,2,4];					// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];			// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // end of switch


}; // End of medium action value scenes

if (indiCam_var_actionValue == 2) then { // High action value scenes


			indiCam_var_scene = selectRandom [ // Choose a random scene from the list

								"standardScene",	// Stationary camera tracking a logic
								"chaseCam",			// Advanced FPS-based chase cam
								"cheeseCam",		// Advanced FPS-based chase cam with logic target
								"faceCam",			// Advanced FPS-based chase cam with logic target
								"lowCloseCam",		// Advanced FPS-based chase cam with logic target
								"skyCam"			// Still camera from far above tracking a slow logic
							];

	switch (indiCam_var_scene) do {
		
		case "cheeseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 30;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-1,-5,2.5];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.6;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 30;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,-0.5,2];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0.75,0,1.8];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 30;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,5,1];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 30;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-10,0,2];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case

		case "lowCloseCam": {
			// Advanced chase cam with logic target updated on every frame
			// Regular stationary camera tracking a logic target around the actor close and low in higher action levels
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-5,-2,-5],random [3,2,3]]; // Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-5,-2,-5],random [5,2,5]];	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [0.4,1,0.4];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ]; // Position of camera relative to the actor
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.6;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;	// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.3,0.4,0.5]; // Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 10;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
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
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-1,-5,2.5];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.6;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,-0.5,2];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0.75,0,1.8];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,5,1];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.5;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.74;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-10,0,2];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.2;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 100;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 10;				// Time after which a new scene will be selected
			_posX = random [-40,0,40]; 				// Specifies the range for the camera position sideways to the actor
			_posY = random [-40,0,40];				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.3,0.4,0.5];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // end of switch

}; // End of very high action value scenes
