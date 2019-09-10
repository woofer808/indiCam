
comment "-------------------------------------------------------------------------------------------------------";
comment "										actor in vehicle scenes											";
comment "-------------------------------------------------------------------------------------------------------";


if ((speed vehicle actor) < 3 ) then { // Low speed or stationary vehicle

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardSceneCar",		// Basic example scene
								"randomDriveBy",		// Randomized low, close and wide fov angle
								"wheelCam",				// Wheel cam view - the racing equivalent to the Wilhelm scream. Gotta have it.
								//"hoodCamForward",		// Hood cam forward.
								"hoodCamBackward",		// Hood cam backward.
								"droneCamCar",			// Orbiting drone view that follows target.
								"nonStabilizedCamCar"	// Simulated unstable binoculars using linear game logic
							];

	switch (indiCam_var_scene) do {
		
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
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = (actor modelToWorld [0.3,-2,1.8]);
			indiCam_var_cameraTarget = indiCam_infrontLogic;
			indiCam_var_cameraFov = 0.74;
			indiCam_var_maxDistance = 100;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [(vehicle actor), [selectRandom [-2.5,2.5],-2.3,-0.5]];
			// Start up any necessary logic entities
			[50,0.1] spawn indiCam_cameraLogic_infrontLogic;
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [(vehicle actor), [selectRandom [-0.3,0.3],0,0.5]];
			indiCam_infrontLogic attachTo [(vehicle actor), [0,10,1]];
		}; // end of case
		
		case "hoodCamBackward": {
			indiCam_var_cameraType = "default";
			indiCam_var_takeTime = 20;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
			indiCam_var_cameraTarget = actor;
			indiCam_var_cameraFov = 0.8;
			indiCam_var_maxDistance = 100;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [(vehicle actor), [random [-0.3,0,0.3],4,0.2]];
		}; // end of case
		
		case "droneCamCar": {
		// Rotates around actor vehicle
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 30;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
			indiCam_var_cameraTarget = (vehicle actor);
			indiCam_var_cameraFov = 0.07;
			indiCam_var_maxDistance = 1000;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
			// Start up any necessary logic entities
			[100,300,100,0.075] spawn indiCam_cameraLogic_orbitActor;
			//[[0.3,-2,1.8],30,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
		}; // end of case
		
		case "nonStabilizedCamCar": {
		// Simulated unstable binoculars using linear game logic
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;
			indiCam_var_cameraMovementRate = 0;
			_posX = selectRandom [random [-350,-250,-350],random [250,350,250]];
			_posY = selectRandom [random [-350,-250,-350],random [250,350,250]];
			_posZ = random [5,7,10];
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
		
	}; // End of switch

}; // End of no speed scenes

if ( ((speed vehicle actor) > 3) && ((speed vehicle actor) < 50) ) then { // Medium speed

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardSceneCar",	// Basic example scene
								"randomDriveBy",	// Randomized low, close and wide fov angle
								"wheelCam",			// Wheel cam view - the racing equivalent to the Wilhelm scream. Gotta have it.
								//"hoodCamForward",	// Hood cam forward.
								"hoodCamBackward",	// Hood cam backward.
								"droneCamCar"		// Orbiting drone view that follows target.
							];

	switch (indiCam_var_scene) do {
		
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
			// This is an attempt to get the wheel cam going
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = (actor modelToWorld [0.3,-2,1.8]);
			indiCam_var_cameraTarget = indiCam_infrontLogic;
			indiCam_var_cameraFov = 0.74;
			indiCam_var_maxDistance = 100;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [(vehicle actor), [selectRandom [-2.5,2.5],-2.3,-0.5]];
			// Start up any necessary logic entities
			[50,0.1] spawn indiCam_cameraLogic_infrontLogic;
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [(vehicle actor), [selectRandom [-0.3,0.3],0,0.5]];
			indiCam_infrontLogic attachTo [(vehicle actor), [0,10,1]];
		}; // end of case
		
		case "hoodCamBackward": {
			indiCam_var_cameraType = "default";
			indiCam_var_takeTime = 20;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
			indiCam_var_cameraTarget = actor;
			indiCam_var_cameraFov = 0.8;
			indiCam_var_maxDistance = 100;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [(vehicle actor), [random [-0.3,0,0.3],4,0.2]];
		}; // end of case
		
		case "droneCamCar": {
		// Rotates around actor vehicle
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 30;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
			indiCam_var_cameraTarget = (vehicle actor);
			indiCam_var_cameraFov = 0.07;
			indiCam_var_maxDistance = 1000;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
			// Start up any necessary logic entities
			[100,300,100,0.075] spawn indiCam_cameraLogic_orbitActor;
			//[[0.3,-2,1.8],30,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
		}; // end of case
		
	}; // End of switch

}; // End of medium speed scenes

if ( ((speed vehicle actor) > 50) ) then { // Speed of Speed

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardSceneCar",	// Basic example scene
								"randomDriveBy",	// Randomized low, close and wide fov angle
								"wheelCam",			// Wheel cam view - the racing equivalent to the Wilhelm scream. Gotta have it.
								//"hoodCamForward",	// Hood cam forward.
								"hoodCamBackward",	// Hood cam backward.
								"droneCamCar"		// Orbiting drone view that follows target.
							];

	switch (indiCam_var_scene) do {
		
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
			// This is an attempt to get the wheel cam going
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = (actor modelToWorld [0.3,-2,1.8]);
			indiCam_var_cameraTarget = indiCam_infrontLogic;
			indiCam_var_cameraFov = 0.74;
			indiCam_var_maxDistance = 100;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [(vehicle actor), [selectRandom [-2.5,2.5],-2.3,-0.5]];
			// Start up any necessary logic entities
			[50,0.1] spawn indiCam_cameraLogic_infrontLogic;
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [(vehicle actor), [selectRandom [-0.3,0.3],0,0.5]];
			indiCam_infrontLogic attachTo [(vehicle actor), [0,10,1]];
		}; // end of case
		
		case "hoodCamBackward": {
			indiCam_var_cameraType = "default";
			indiCam_var_takeTime = 20;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
			indiCam_var_cameraTarget = actor;
			indiCam_var_cameraFov = 0.8;
			indiCam_var_maxDistance = 100;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [(vehicle actor), [random [-0.3,0,0.3],4,0.2]];
		}; // end of case
		
		case "droneCamCar": {
		// Rotates around actor vehicle
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 30;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = actor modelToWorld [0.3,-2,1.8];
			indiCam_var_cameraTarget = (vehicle actor);
			indiCam_var_cameraFov = 0.07;
			indiCam_var_maxDistance = 1000;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
			// Start up any necessary logic entities
			[100,300,100,0.075] spawn indiCam_cameraLogic_orbitActor;
			//[[0.3,-2,1.8],30,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
		}; // end of case
		
	}; // End of switch

}; // End of Speed scenes


