
comment "-------------------------------------------------------------------------------------------------------";
comment "										actor in plane scenes											";
comment "																										";
comment "	Current altitude checks																				";
comment "	Aircraft on ground or landing: less than 3m															";
comment "	Aircraft low altitude: between 3m and 15m															";
comment "	Aircraft medium altitude: between 15m and 600m														";
comment "	Aircraft high altitude: above 600m																	";
comment "-------------------------------------------------------------------------------------------------------";


if ( ((getPos vehicle actor) select 2) < 3 ) then { // Aircraft on ground or landing scenes

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardSceneAir",	// Basic example scene
								"flyByClose",		// Close fixed wide fov view
								"landingCam",		// Helicopter close side position third person view
								"smoothFlyByCam"	// Rotating logic with wide fov
							];

	switch (indiCam_var_scene) do {
		
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
			// Control whether the camera should be attached to anything
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
			// Start up any necessary logic entities
			[50,1,100,0.075] spawn indiCam_cameraLogic_orbitActor;
			[[0.3,-2,1.8],100,0.2] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
		}; // end of case
		
	}; // End of switch

}; // End of low action value scenes

if ( (((getPos vehicle actor) select 2) > 3) && (((getPos vehicle actor) select 2) < 15) ) then { // Aircraft low altitude scenes

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardSceneAir",	// Basic example scene
								"flyByClose",		// Close fixed wide fov view
								"cheeseCamAir",		// Smooth follow logic with target logic
								"smoothFlyByCam"	// Rotating logic with wide fov
							];

	switch (indiCam_var_scene) do {
		
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_followLogic, [0.3,-10,1.8]];
			// Start up any necessary logic entities
			[4,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
			[[0.3,-10,4],110,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera 0<movement) ]
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
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_orbitLogic, [0.3,-2,1.8]];
			// Start up any necessary logic entities
			[50,1,100,0.075] spawn indiCam_cameraLogic_orbitActor;
			[[0.3,-2,1.8],100,0.2] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
		}; // end of case
		
	}; // End of switch

}; // End of medium action value scenes

if ( (((getPos vehicle actor) select 2) > 15) && (((getPos vehicle actor) select 2) < 600) ) then { // Aircraft medium altitude scenes

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardSceneAir",	// Basic example scene
								"flyByClose",		// Close fixed wide fov view
								"cheeseCamAir",		// Smooth follow logic with target logic
								"flybyFront",		// Flyby from ground perspective from the front
								"behindmedium",		// Third person non-tilting camera from rear
								"frontmedium",		// Third person non-tilting camera from front
								"closeFollow"
							];

	switch (indiCam_var_scene) do {
		
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
			indiCam_var_maxDistance = 1500;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_followLogic, [0.3,-10,1.8]];
			// Start up any necessary logic entities
			[4,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
			[[0.3,-10,4],80,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
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
		
		case "behindmedium": {
		// Advanced chase cam with logic target
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = (vehicle actor) modelToWorldWorld [0,-20,5];
			indiCam_var_cameraTarget = indiCam_infrontLogic;
			indiCam_var_cameraFov = 0.5;
			indiCam_var_maxDistance = 500;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			_posX = 0;
			_posY = -50;
			_posZ = selectRandom [-5,5,-10,10];
			indiCam attachTo [(vehicle actor), [_posX,_posY,_posZ]];
			// Start up any necessary logic entities
			[200,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
		}; // end of case
		
		case "frontmedium": {
		// Advanced chase cam with logic target
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = (vehicle actor) modelToWorldWorld [0,-20,5];
			indiCam_var_cameraTarget = indiCam_infrontLogic;
			indiCam_var_cameraFov = 0.5;
			indiCam_var_maxDistance = 500;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			_posX = 0;
			_posY = 50;
			_posZ = selectRandom [-5,5,-10,10];
			indiCam attachTo [(vehicle actor), [_posX,_posY,_posZ]];
			// Start up any necessary logic entities
			[-200,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
		}; // end of case
		
		case "closeFollow": {
		// Advanced chase cam with logic target
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = (vehicle actor) modelToWorldWorld [0,-300,100];
			indiCam_var_cameraTarget = indiCam_infrontLogic;
			indiCam_var_cameraFov = 0.2;
			indiCam_var_maxDistance = 1000;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			_posX = 0;
			_posY = -300;
			_posZ = 100;
			indiCam attachTo [indiCam_cameraLogic_followLogicCamera, [_posX,_posY,_posZ]];
			// Start up any necessary logic entities
			[100,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
			[[_posX,_posY,_posZ],35,25] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera
		}; // end of case
		
		
	}; // End of switch

}; // End of high action value scenes

if ( (((getPos vehicle actor) select 2) > 600) ) then { // Aircraft high altitude scenes

	indiCam_var_scene = selectRandom [ // Choose a random scene from the list
								"standardSceneAir",	// Basic example scene
								"flyByClose",		// Close fixed wide fov view
								"cheeseCamAir",		// Smooth follow logic with target logic
								"behindmedium",		// Third person non-tilting camera from rear
								"frontmedium",		// Third person non-tilting camera from front
								"closeFollow"
							];

	switch (indiCam_var_scene) do {
		
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
			indiCam_var_maxDistance = 1500;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_followLogic, [0.3,-10,1.8]];
			// Start up any necessary logic entities
			[4,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
			[[0.3,-10,4],80,1] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera movement) ]
		}; // end of case
		
		case "behindmedium": {
		// Advanced chase cam with logic target
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = (vehicle actor) modelToWorldWorld [0,-20,5];
			indiCam_var_cameraTarget = indiCam_infrontLogic;
			indiCam_var_cameraFov = 0.5;
			indiCam_var_maxDistance = 500;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			_posX = 0;
			_posY = -75;
			_posZ = selectRandom [-10,10,-20,20];
			indiCam attachTo [(vehicle actor), [_posX,_posY,_posZ]];
			// Start up any necessary logic entities
			[200,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
		}; // end of case
		
		case "behindmedium": {
		// Advanced chase cam with logic target
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = (vehicle actor) modelToWorldWorld [0,-20,5];
			indiCam_var_cameraTarget = indiCam_infrontLogic;
			indiCam_var_cameraFov = 0.5;
			indiCam_var_maxDistance = 500;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			_posX = 0;
			_posY = 75;
			_posZ = selectRandom [-10,10,-20,20];
			indiCam attachTo [(vehicle actor), [_posX,_posY,_posZ]];
			// Start up any necessary logic entities
			[-200,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
		}; // end of case
		
	case "closeFollow": {
		// Advanced chase cam with logic target
			indiCam_var_cameraType = "logics";
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 20;
			indiCam_var_cameraMovementRate = 0;
			indiCam_var_cameraPos = (vehicle actor) modelToWorldWorld [0,-300,100];
			indiCam_var_cameraTarget = indiCam_infrontLogic;
			indiCam_var_cameraFov = 0.2;
			indiCam_var_maxDistance = 1000;
			indiCam_var_ignoreHiddenActor = false;
			// Control whether the camera should be attached to anything
			indiCam_var_cameraAttach = true;
			_posX = 0;
			_posY = -300;
			_posZ = 100;
			indiCam attachTo [indiCam_cameraLogic_followLogicCamera, [_posX,_posY,_posZ]];
			// Start up any necessary logic entities
			[100,0.1] spawn indiCam_cameraLogic_infrontLogic; // [distance, rate of target movement]
			[[_posX,_posY,_posZ],35,25] spawn indiCam_cameraLogic_followLogicCamera; // [ (relative position to actor) , (rate of camera
		}; // end of case
		
	}; // End of switch

}; // End of very high action value scenes

