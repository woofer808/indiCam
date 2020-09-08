
/* -------------------------------------------------------------------------------------------------------
 * 										actor in plane
 *
 * 	Current altitude checks
 * 	Aircraft on ground or landing: less than 3m
 * 	Aircraft low altitude: between 3m and 15m
 * 	Aircraft medium altitude: between 15m and 600m
 * 	Aircraft high altitude: above 600m
 * ------------------------------------------------------------------------------------------------------- */


if ( ((getPos vehicle indiCam_actor) select 2) < 3 ) then { // Aircraft on ground or landing scenes

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
			indiCam_var_cameraPos = [-1,-15,3];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.05;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.3;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.5;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-4,0,4]; 				// Specifies the range for the camera position sideways to the actor
			_posY = -50; 							// Specifies the range for the camera position to the front and back of the actor
			_posZ = 2;								// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.03;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [random [-1,0,1],50,2];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.03;			// Defines how tightly the logic will track it's defined position
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
			indiCam_var_cameraPos = [1,150,3];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.01;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.01;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.85;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 15;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-80,-5,-80],random [5,80,5]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = selectRandom [random [-50,-5,-50],random [5,30,5]];	// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_targetPos = [0,20,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.05;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-100,-20,-150],random [20,100,20]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-100,-20,-150],random [20,100,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [100,150,200];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,50,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.2,0.35,0.2];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1500;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // End of switch

}; // End of ground level value scenes

if ( (((getPos vehicle indiCam_actor) select 2) > 3) && (((getPos vehicle indiCam_actor) select 2) < 15) ) then { // Aircraft low altitude scenes

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
			indiCam_var_cameraPos = [-1,-15,3];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.05;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.3;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.5;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-4,0,4]; 				// Specifies the range for the camera position sideways to the actor
			_posY = -50; 							// Specifies the range for the camera position to the front and back of the actor
			_posZ = 2;								// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.03;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [random [-1,0,1],50,2];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.03;			// Defines how tightly the logic will track it's defined position
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
			indiCam_var_cameraPos = [1,150,3];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.01;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.01;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.85;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 15;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-80,-5,-80],random [5,80,5]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = selectRandom [random [-50,-5,-50],random [5,30,5]];	// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_targetPos = [0,20,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.05;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-100,-20,-150],random [20,100,20]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-100,-20,-150],random [20,100,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [100,150,200];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,50,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.2,0.35,0.2];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1500;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // End of switch

}; // End of low altitude value scenes

if ( (((getPos vehicle indiCam_actor) select 2) > 15) && (((getPos vehicle indiCam_actor) select 2) < 600) ) then { // Aircraft low altitude scenes

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"groundWatcherFront",	// Stationary ground watch flyover
								"farFrontFlyBy",		// Stationary far ahead camera looking back
								"flyByPlane",			// Fast stationary camera low drive-by zoomed in
								"standardScene",		// Stationary camera tracking a logic
								"chaseCam",				// Advanced FPS-based chase cam
								"cheeseCam",			// Advanced FPS-based chase cam with logic target
								"faceCam",				// Advanced FPS-based chase cam with logic target
								"skyCam"				// Still camera from far above tracking a slow logic
							];

	switch (indiCam_var_scene) do {
		
		
		case "groundWatcherFront": {
			// Stationary ground watch flyover
			indiCam_var_cameraType = "stationaryCameraAbsoluteZ";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 15;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-30,-10,-30],random [30,10,30]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = random [600,800,600]; 				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [1,5,1];			// Specifies the range for the camera position vertically in absolute height
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,6,1];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.1,0.8,0.1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = true;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case


		case "farFrontFlyBy": {
			// Stationary far ahead camera looking back
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 10;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-30,-10,-30],random [30,10,30]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = random [300,400,300]; 				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [-2,-10,-2];			// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,6,1];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.1,0.2,0.1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = true;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "flyByPlane": {
			// Fast stationary camera low drive-by zoomed in
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 10;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-80,-100,-80],random [80,100,80]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = random [40,60,40]; 				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [6,6,6];			// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,6,1];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.1,0.2,0.1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = true;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "cheeseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-1,-15,3];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.05;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.3;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.5;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-4,0,4]; 				// Specifies the range for the camera position sideways to the actor
			_posY = -50; 							// Specifies the range for the camera position to the front and back of the actor
			_posZ = 2;								// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.03;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [random [-1,0,1],50,2];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.03;			// Defines how tightly the logic will track it's defined position
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
			indiCam_var_cameraPos = [1,150,3];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = ( 0.2 / ((speed indiCam_actor) / 100) );			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.01;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.85;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 15;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-80,-5,-80],random [5,80,5]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = selectRandom [random [-50,-5,-50],random [5,30,5]];	// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_targetPos = [0,20,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.05;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-100,-20,-150],random [20,100,20]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-100,-20,-150],random [20,100,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [100,150,200];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,50,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.2,0.35,0.2];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1500;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // End of switch

}; // End of medium altitude value scenes

if ( (((getPos vehicle indiCam_actor) select 2) > 600) ) then { // Aircraft high altitude scenes

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"highAltitudeChase",// Followcam top-bottom rear with vistas
								"farFrontFlyBy",	// Stationary far ahead camera looking back
								"flyByPlane",		// Fast stationary camera low drive-by zoomed in
								"standardScene",	// Stationary camera tracking a logic
								"chaseCam",			// Advanced FPS-based chase cam
								"cheeseCam",		// Advanced FPS-based chase cam with logic target
								"faceCam",			// Advanced FPS-based chase cam with logic target
								"skyCam"			// Still camera from far above tracking a slow logic
							];

	switch (indiCam_var_scene) do {

		case "highAltitudeChase": {
			// Followcam top-bottom rear with vistas
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 10;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-30,-10,-30],random [30,10,30]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = random [300,400,300]; 				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [-2,-10,-2];			// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,6,1];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.1,0.2,0.1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = true;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "farFrontFlyBy": {
			// Stationary far ahead camera looking back
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 10;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-30,-10,-30],random [30,10,30]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = random [300,400,300]; 				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [-2,-10,-2];			// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,6,1];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.1,0.2,0.1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = true;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "flyByPlane": {
			// Fast stationary camera low drive-by zoomed in
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 10;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-80,-100,-80],random [80,100,80]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = random [40,60,40]; 				// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [6,6,6];			// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,6,1];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.1,0.2,0.1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = true;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case

		
		case "cheeseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [-1,-15,3];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.05;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,10,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.3;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.5;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		case "chaseCam": {
			// Advanced chase cam with logic target updated on every frame
			indiCam_var_cameraType = "followCameraLogicTarget";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			_posX = random [-4,0,4]; 				// Specifies the range for the camera position sideways to the actor
			_posY = -50; 							// Specifies the range for the camera position to the front and back of the actor
			_posZ = 2;								// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.03;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [random [-1,0,1],50,2];	// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.03;			// Defines how tightly the logic will track it's defined position
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
			indiCam_var_cameraPos = [1,150,3];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.01;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,0,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.01;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.85;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "standardScene": {
			// Regular stationary camera tracking a logic target around the actor
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 15;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-80,-5,-80],random [5,80,5]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-150,-20,-150],random [20,150,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = selectRandom [random [-50,-5,-50],random [5,30,5]];	// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_targetPos = [0,20,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.05;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.5,0.74,1];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1000;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
		
		case "skyCam": {
			// Stationary camera in the sky looking down
			indiCam_var_cameraType = "stationaryCameraLogicTarget";
			indiCam_var_disqualifyScene = false;	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;				// Time after which a new scene will be selected
			_posX = selectRandom [random [-100,-20,-150],random [20,100,20]]; 	// Specifies the range for the camera position sideways to the actor
			_posY = selectRandom [random [-100,-20,-150],random [20,100,20]]; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = random [100,150,200];				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];		// Position of camera relative to the actor
			indiCam_var_targetPos = [0,50,1.8];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = random [0.2,0.35,0.2];			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 1500;			// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
		}; // end of case
		
	}; // End of switch

}; // End of high altitude scenes
