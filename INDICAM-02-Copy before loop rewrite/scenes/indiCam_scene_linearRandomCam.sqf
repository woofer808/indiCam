
				
				case "linearRandomCam": {				
					indiCam_var_cameraType = "logics";
					// Start up the logic entities by spawning a script
					_position = getPos actor;
					_distance = 1;
					_speed = 100; // This is how fast the camera should move between points. Mid value: 100
					_followActor = false;
					[_position,_distance,_speed,_followActor] spawn indiCam_cameraLogic_randomLinear;
					indiCam_var_takeTime = 5;
					indiCam_var_cameraMovementRate = 0.5;
					indiCam_var_cameraPos = actor modelToWorldWorld [0,-20,10];
					indiCam_var_cameraAttach = true;
					indiCam_var_cameraTarget = indiCam_logicA;
					indiCam_var_cameraFov = 1;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = true;
				}; // end of case

				
				