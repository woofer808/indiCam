
comment "-------------------------------------------------------------------------------------------------------";
comment "										actor in vehicle scenes											";
comment "-------------------------------------------------------------------------------------------------------";


if ((speed vehicle indiCam_actor) < 3 ) then { // Low speed or stationary vehicle

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardScene",	// Stationary camera tracking a logic
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
			indiCam_var_targetSpeed = 0.5;			// Defines how tightly the logic will track it's defined position
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
			_posX = random [-4,0,4]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [-5,-4]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = 2;				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.1;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [random [-1,0,1],30,2];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.3;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,30,3];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.1;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
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
			indiCam_var_takeTime = 12;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-40,-5,-40],random [5,40,5]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-80,-20,-80],random [20,80,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,5,1];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 200;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,10,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.2,0.35,0.45];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1500;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // End of switch

}; // End of no speed scenes

if ( ((speed vehicle indiCam_actor) > 3) && ((speed vehicle indiCam_actor) < 50) ) then { // Medium speed

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
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
			indiCam_var_targetSpeed = 0.5;			// Defines how tightly the logic will track it's defined position
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
			_posX = random [-4,0,4]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [-5,-4]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = 2;				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.05;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [random [-1,0,1],30,2];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.05;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.2;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,30,3];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.1;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
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
			indiCam_var_takeTime = 12;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-40,-5,-40],random [5,40,5]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-80,-20,-80],random [20,80,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,5,1];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 200;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,20,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.2,0.35,0.45];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1500;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // End of switch

}; // End of medium speed scenes

if ( ((speed vehicle indiCam_actor) > 50) ) then { // Speed of Speed

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
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
			indiCam_var_cameraSpeed = 0.05;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,20,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
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
			_posX = random [-4,0,4]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [-5,-4]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = 2;				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.05;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [random [-1,0,1],30,2];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.05;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.2;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "faceCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [1,30,3];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.1;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
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
			indiCam_var_takeTime = 12;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-40,-5,-40],random [5,40,5]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-80,-20,-80],random [20,80,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,5,1];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_targetPos = [0,5,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.15;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 200;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [40,60,80];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,40,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.05;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.2,0.35,0.45];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1500;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // End of switch

}; // End of Speed scenes


