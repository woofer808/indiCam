					
				case "staticPanCam": {
				// Stationary camera that pans using a logic
					indiCam_var_cameraType = "logics";
					// Start up the logic entities by spawning a script
					_position = getPos actor;
					_radius = 50; // Distance around the actor that the camera should look
					_height = 1.8; // height AGL relative to actor
					_speed = 0.05; // This speed value needs to be redefined to something like mid value 100 - and orbit needs to be constant speed regardless of radius given
					_followSpeed = 110; // Mid range value is 100, higher values means closer to the actor
					[_radius,_height,_speed,_followSpeed] spawn indiCam_cameraLogic_orbitActor;
					indiCam_var_takeTime = 10;
					indiCam_var_cameraMovementRate = 0.5;
					indiCam_var_cameraPos = actor modelToWorldWorld [0,-20,10];
					indiCam_var_cameraAttach = true;
					indiCam_var_cameraTarget = indiCam_logicA;
					indiCam_var_cameraFov = 0.8;
					indiCam_var_maxDistance = 1000;
					indiCam_var_ignoreHiddenActor = true;
				}; // end of case
				
				