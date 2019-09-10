comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										independent cinematic camera									";
comment "																										";
comment "																										";
comment "	This is the GUI for indiCam	which is the main way to operate the script.							";
comment "	It is written as a stand-alone from the main script so that indiCam can operate without it.			";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";











comment "-------------------------------------------------------------------------------------------------------";
comment "								variables and default settings											";
comment "-------------------------------------------------------------------------------------------------------";

// Control buttons
indiCam_fnc_guiStart = {};

// Current actor display
indiCam_fnc_guiActorText = {};
indiCam_var_guiActorText = indiCam_actor;




// Debug
indiCam_fnc_guiDebug = {};
indiCam_var_guiDebugCheckboxState = false;


// Scene hold
indiCam_fnc_guiSceneHold = {};
indiCam_var_guiSceneHoldCheckboxState = false; // var in camera loop is indiCam_var_sceneHold

// Scripted scenes
indiCam_fnc_scriptedScenes = {};
indiCam_var_scriptedScenesCheckboxState = false;

// Player list
indiCam_fnc_guiPlayerList = {};
indiCam_fnc_guiPlayerListButton = {};
indiCam_var_guiPlayerListListboxState = 0;
indiCam_var_guiPlayerListButton = {};
indiCam_var_guiPlayerListSelectedPlayer = player;
indiCam_var_guiPlayerListArray = [];

// Scene time override
indiCam_fnc_guiSceneOverride = {}; // Run both controls in the same function
indiCam_var_guiSceneOverrideCheckboxState = false;
indiCam_var_guiSceneOverrideSliderState = 150;


// Vision mode
indiCam_fnc_guiVisionMode = {};
indiCam_var_guiVisionModeDropdownState = 0;


// Actor auto switch
indiCam_fnc_guiActorAutoswitch = {};
indiCam_var_guiActorAutoswitchRunning = false;
indiCam_fnc_guiCheckboxActorAutoswitch = {};
indiCam_fnc_guiDropdownActorAutoswitch = {};
indiCam_var_guiActorAutoswitchCheckboxState = false;
indiCam_var_guiActorAutoswitchDropdownState = 0;
indiCam_var_guiActorAutoswitchSliderState = 300;
indiCam_var_guiActorAutoswitchSliderChanged = 999999;


// Map controls
indiCam_fnc_guiMapSide = {};
// Set the initial drop-down state to whatever side the cameraman is on
if (side player == WEST) then {indiCam_var_guiMapSideDropdownState = 1};
if (side player == EAST) then {indiCam_var_guiMapSideDropdownState = 2};
if (side player == resistance) then {indiCam_var_guiMapSideDropdownState = 3};
if (side player == civilian) then {indiCam_var_guiMapSideDropdownState = 4};






comment "-------------------------------------------------------------------------------------------------------";
comment "											variables													";
comment "-------------------------------------------------------------------------------------------------------";
// These numbers has to match what's defined in indiCam_gui_dialogs.hpp
indiCam_id_guiDialogMain = 808;
indiCam_id_guiDebugCheckbox = 818;
indiCam_id_guiDebugText = 819;
indiCam_id_guiMapDisplay = 809;
indiCam_id_guiMapSetActor = 810;
indiCam_id_guiMapSideDropdown = 824;
indiCam_id_guiPlayerList = 812;
indiCam_id_guiPlayerListButton = 813;
indiCam_id_guiActorDisplay = 814;
indiCam_id_guiStartButton = 815;
indiCam_id_guiStopButton = 816;
indiCam_id_guiVisionModeDropdown = 817;
indiCam_id_guiSceneOverrideText = 821;
indiCam_id_guiSceneOverrideSlider = 822;
indiCam_id_guiSceneOverrideCheckbox = 823;
indiCam_id_guiSceneHold = 826;
indiCam_id_guiActorAutoswitchCheckbox = 825;
indiCam_id_guiActorAutoswitchDropdown = 820;
indiCam_id_guiActorAutoswitchSlider = 827;
indiCam_id_guiActorAutoswitchSliderText = 828;
indiCam_id_guiScriptedScenes = 829;
indiCam_id_guiScriptedSceneSlider = 830;
indiCam_id_guiScriptedSceneText = 831;


comment "-------------------------------------------------------------------------------------------------------";
comment "											functions													";
comment "-------------------------------------------------------------------------------------------------------";
// The GUI outputs the following controls to be used in the main indiCam script.
indiCam_gui_dialogControl = compile preprocessFileLineNumbers "INDICAM\indiCam_gui\indiCam_gui_dialogControl.sqf";
indiCam_gui_mapControl = compile preprocessFileLineNumbers "INDICAM\indiCam_gui\indiCam_gui_mapControl.sqf";
[] execVM "INDICAM\indiCam_gui\indiCam_gui_mapControl.sqf";


