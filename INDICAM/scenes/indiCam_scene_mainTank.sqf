
comment "-------------------------------------------------------------------------------------------------------";
comment "										actor in tank scenes											";
comment "																										";
comment "	Current check is a single actionValue of below 10													";
comment "-------------------------------------------------------------------------------------------------------";


if (indiCam_var_actionValue < 10) then { // Low action value scenes

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardScene",	// Stationary camera tracking a logic
								"barrelWatch"		// Looking at a logic in the direction of a barrel
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
			_posX = selectRandom [-3,-2,-1,1,2,3]; 	// Specifies the range for the camera position sideways to the actor
			_posY = -10; 	// Specifies the range for the camera position to the front and back of the actor
			_posZ = 1.5;				// Specifies the range for the camera position vertically from the actor
			indiCam_var_cameraPos = [_posX,_posY,_posZ];	// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.05;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [random [-1,0,1],50,2];	// Position of camera target relative to the actor
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
		
		
		case "barrelWatch": {
			// Advanced follow camera positioned behind and of turret and looking in weapon direction
			indiCam_var_cameraType = "followCameraWeaponLogic";
			indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
			indiCam_var_cameraPos = [0,-20,2];		// Position of camera relative to the actor
			indiCam_var_cameraSpeed = 0.1;			// Defines how tightly the camera will track it's defined position
			indiCam_var_targetPos = [0,20,2];		// Position of camera target relative to the actor
			indiCam_var_targetSpeed = 0.1;			// Defines how tightly the logic will track it's defined position
			indiCam_var_cameraTarget = indiCam_var_proxyTarget;		// The object that the camera is aimed at
			indiCam_var_cameraFov = 0.8;			// Field of view, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
			indiCam_var_ignoreHiddenActor = false;	// True will disable line of sight checks during scene, actor may stay hidden
			indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
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

