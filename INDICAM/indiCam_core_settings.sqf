/*
 * Author: woofer
 * Declare and set the most commonly used variables.
 *
 * Arguments:
 * None
 *
 * Reutrn Value:
 * None
 *
 * Example:
 * call indicam_core_fnc_settings
 *
 * Public: No
 */

indiCam_devMode = false; // Makes scripts to either run as uncompiled with execVM or to recompile them continuously to speed up development.
indiCam_debug = false; // Switch this to true to enable debug messages in systemChat during operation (can be done in GUI).

indiCam_var_sceneSwitch = true; // Turns scene switching on or off
indiCam_var_sceneHold = false; // True will suspend the timer that switches scenes automatically.
indiCam_var_scriptedSceneChance = 20; // Defines percentage chance of scripted scenes kicking in when detected.

indiCam_var_hiddenActorTime = 4; // Seconds to allow the actor to be hidden before switching scene unless active scene ignores this setting
indiCam_var_actorSwitchSettings = [ // Default setting array for the actor switching. Affects how indiCam_fnc_actorSwitch and actor auto switching.
									5,				// 0 - Actor switch SIDE [0=WEST,1=EAST,2=resistance,3=civilian,4=all,5=actorSide]
									false,			// 1 - Restrict to players only
									-1, 			// 2 - random unit within this proximity of actor (-1 means closest)
									false,			// 3 - Actor auto switch is off/on
									300, 			// 4 - Actor auto switch duration
									WEST 			// 5 - Actor side
								  ];

indiCam_var_situationCheck = 1; // How often, in seconds, the situation check should run. Increase if there is stutter because of it.

if (indiCam_debug) then {systemChat "Settings read"};
