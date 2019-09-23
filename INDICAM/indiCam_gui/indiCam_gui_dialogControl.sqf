/*

This is my attempt at moving the map to the selected player. Not really needed
mapAnimAdd [1, 0.1, indiCam_var_guiPlayerListSelectedPlayer]; 
mapAnimCommit;
*/


// I don't want to display my markers both on the gui map and the regular map. So close the regular map. gui can't be used at the same time.
openMap [false, false];



// This script is spawned as the dialog is started
// Wait until the dialog has been created before attempting to write to it
waitUntil {dialog};


// Update the text showing who the current actor is
private _currentActorDisplay = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorDisplay; // Define the displaycontrol
_currentActorDisplay ctrlSetText format ['Current actor: %1', (name indiCam_actor)];



comment "-------------------------------------------------------------------------------------------------------";
comment "											START/STOP scripts											";
comment "-------------------------------------------------------------------------------------------------------";
// A script that checks all settings that applies any settings done in GUI before the camera is started 
indiCam_fnc_guiStart = {

	// Only start functions if the camera isn't already running.
	if (!indiCam_running) then {

		// Actually start the camera before launching any other side scripts
		[] execVM "INDICAM\indiCam_core_main.sqf";		
		
		// Scene duration override
		if (indiCam_var_SceneOverrideState) then {
			[] spawn indiCam_fnc_guiSceneOverride;
			if (indiCam_debug) then {systemChat "Scene duration override enabled - starting script";};
		};
		
		if (indiCam_var_actorAutoSwitchCheckboxState) then {
		
			// This is where we enable actor auto switch in main loop
			indiCam_var_actorTimer = time + (indiCam_var_actorSwitchSettings select 4); // actorAutoSwitchDuration
		
		};
		
		// If the override scene duration is in effect, reset the timer properly
		if (indiCam_var_guiSceneOverrideCheckboxState) then {
			indiCam_var_sceneTimer = time + indiCam_var_SceneOverrideDuration;
		};
		
		indiCam_var_sceneList = [];	// Reset the sceneList array before starting the camera from being off
		
		
		
	};
	
};


indiCam_fnc_guiClose = {
	closeDialog 0;
	
	if (indiCam_var_actorAutoSwitchCheckboxState) then {

		// This is where we enable actor auto switch in main loop
		indiCam_var_actorTimer = time + (indiCam_var_actorSwitchSettings select 4); // actorAutoSwitchDuration

	};
	
};


comment "-------------------------------------------------------------------------------------------------------";
comment "										debug mode toggle												";
comment "-------------------------------------------------------------------------------------------------------";
// Upon opening of gui, let the control show the current selected value
private _debugControl = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiDebugCheckbox; // Define the displaycontrol
if (indiCam_var_guiDebugCheckboxState or indiCam_debug) then {
	// Set the checkbox to checked
	_debugControl cbSetChecked true; // Set the stored value
} else {
	// Set the checkbox to unchecked
	_debugControl cbSetChecked false; // Set the stored value
};


// This will fire when the checkbox eventhandler in dialogs is triggered by clicking the checkbox
indiCam_fnc_guiDebug = {
	private _debugControl = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiDebugCheckbox; // Define the displaycontrol
	private _checkedDebug = cbChecked _debugControl; // Checks state of checkbox
	if (_checkedDebug) then {
		indiCam_debug = true;
		systemChat "Debug mode enabled";
	} else {
		indiCam_debug = false;
	};

};



comment "-------------------------------------------------------------------------------------------------------";
comment "										scripted scenes													";
comment "-------------------------------------------------------------------------------------------------------";
// Upon opening of gui, let the control show the current selected value
private _scriptedScenecontrol = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiScriptedScenes; // Define the displaycontrol
if (indiCam_var_scriptedScenesCheckboxState) then {
	// Set the checkbox to checked
	_scriptedScenecontrol cbSetChecked true; // Set the stored value
	indiCam_var_scriptedScenesCheckboxState = true;
} else {
	// Set the checkbox to unchecked
	_scriptedScenecontrol cbSetChecked false; // Set the stored value
	indiCam_var_scriptedScenesCheckboxState = false;
};




// This will fire when the checkbox eventhandler in dialogs is triggered by clicking the checkbox
indiCam_fnc_scriptedScenes = {
	private _control = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiScriptedScenes; // Define the displaycontrol
	private _checkedSceneHold = cbChecked _control; // Checks state of checkbox
	if (_checkedSceneHold) then {
		// If checked
		indiCam_var_scriptedScenesCheckboxState = true;
		if (indiCam_debug) then {systemChat "Scripted scenes enabled.";};
		
		// Start the function immediately if the camera is running. Else spawn upon pressing START.
			if (indiCam_running) then {
			
				// Spawn the script
				if (indiCam_devMode) then {
					[] execVM "INDICAM\indiCam_fnc_actorManager.sqf";
					} else {
					[] spawn indiCam_fnc_actorManager;
				};
				} else {
					// Let the script be spawned by the start button.
				};
	} else {
		// If not checked, just store the value in a global var for until it is needed.
		indiCam_var_scriptedScenesCheckboxState = false;
		if (indiCam_debug) then {systemChat "Scripted scenes disabled.";};
	};
};




// This is code that sets the duration between automatic actor switching
// This functionality is currently only supported by the GUI
_sliderMinChance = 0;
_sliderMaxChance = 100;

_controlSliderChance = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiScriptedSceneSlider; // Define the displaycontrol
_controlSliderChance sliderSetRange [_sliderMinChance, _sliderMaxChance];
_controlSliderChance sliderSetPosition indiCam_var_scriptedSceneChance;


// Define the displaycontrol for the textbox showing current duration
_controlSliderChanceText = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiScriptedSceneText;

// Update the text box with the new value.
_controlSliderChanceText ctrlSetText format ["Chance to capture cinematics: %1%2", indiCam_var_scriptedSceneChance,"%"];



// This function is run by the slider eventhandler onSliderPosChanged
indiCam_fnc_scriptedSceneChanceSlider = {

	// Define the displaycontrol for slider
	_controlSlider = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiScriptedSceneSlider;
	// Get the value the slider was moved to
	_sliderPos = round (sliderPosition _controlSlider);
	
	// Store the new value in the global variable for later use
	indiCam_var_scriptedSceneChance = _sliderPos;
	
	// Define the displaycontrol for the textbox showing current duration
	_controlSliderText = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiScriptedSceneText;
	
	// Update the text box with the new value.
	_controlSliderText ctrlSetText format ["Chance to capture cinematics: %1%2", indiCam_var_scriptedSceneChance,"%"];
	
}; // End of scripted scene slider function

















comment "-------------------------------------------------------------------------------------------------------";
comment "										scene holding													";
comment "-------------------------------------------------------------------------------------------------------";
// This should stop scene switching by setting indiCam_var_sceneHold to true, which will set _future to 999999 in main loop
// I'd prefer it to actually stop on the particular scene that is currently on, but that will require more work
// It also needs to prevent autoswitching from LOS checks and so on. Will also need more work.

// Upon opening of gui, let the control show the current selected value
private _sceneHoldControl = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiSceneHold; // Define the displaycontrol
if (indiCam_var_guiSceneHoldCheckboxState) then {
	// Set the checkbox to checked
	_sceneHoldControl cbSetChecked true; // Set the stored value
	indiCam_var_guiSceneHoldCheckboxState = true;
} else {
	// Set the checkbox to unchecked
	_sceneHoldControl cbSetChecked false; // Set the stored value
	indiCam_var_guiSceneHoldCheckboxState = false;
};


// This will fire when the checkbox eventhandler in dialogs is triggered by clicking the checkbox
indiCam_fnc_guiSceneHold = {
	private _control = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiSceneHold; // Define the displaycontrol
	private _checkedSceneHold = cbChecked _control; // Checks state of checkbox
	if (_checkedSceneHold) then {
		// do what is needed to make sure the scene wont' change
		indiCam_var_sceneHold = true;
		indiCam_var_guiSceneHoldCheckboxState = true;
		indiCam_var_sceneTimer = time + 99999;
		if (indiCam_debug) then {systemChat "Automatic scene switching disabled.";};
	} else {
		// If not checked, just store the value in a global var for until it is needed.
		indiCam_var_sceneHold = false;
		indiCam_var_guiSceneHoldCheckboxState = false;
		indiCam_var_requestMode = "default";
		if (indiCam_debug) then {systemChat "Automatic scene switching enabled.";};
	};
};





comment "-------------------------------------------------------------------------------------------------------";
comment "									scene duration override timer										";
comment "-------------------------------------------------------------------------------------------------------";

// This is code that sets the duration of the overridden scene duration
_sliderMinAutoSwitchScene = 10;
_sliderMaxAutoSwitchScene = 300;

_controlSliderAutoSwitchScene = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiSceneOverrideSlider; // Define the displaycontrol
_controlSliderAutoSwitchScene sliderSetRange [_sliderMinAutoSwitchScene, _sliderMaxAutoSwitchScene];
_controlSliderAutoSwitchScene sliderSetPosition indiCam_var_guiSceneOverrideSliderState;


// Define the displaycontrol for the textbox showing current duration
_controlSliderText = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiSceneOverrideText;

// Update the text box with the new value.
_controlSliderText ctrlSetText format ["duration: %1 seconds", indiCam_var_guiSceneOverrideSliderState];





// This function is run by the slider eventhandler and the checkbox eventhandler in dialogs
indiCam_fnc_guiSceneOverride = {
	_controlSlider = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiSceneOverrideSlider; // Define the displaycontrol
	_controlSliderText = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiSceneOverrideText; // Define the displaycontrol
	_currentValue = round (sliderPosition indiCam_id_guiSceneOverrideSlider);
	indiCam_var_guiSceneOverrideSliderState = _currentValue;
	indiCam_var_SceneOverrideDuration = _currentValue;

	
	_controlSliderText ctrlSetText format ["duration: %1 seconds", _currentValue];
	
	// If the checkbox has been checked, set the new scene timer to this new value immediately
	_control = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiSceneOverrideCheckbox; // Define the displaycontrol
	_checkedOverride = cbChecked _control; // Checks state of checkbox
	if (_checkedOverride) then {
		// do what is needed to override the scene timer with this new value. Will need poking into the main script.
		indiCam_var_guiSceneOverrideCheckboxState = true;
	} else {
		// If not checked, just store the value in a global var for until it is needed.
		indiCam_var_guiSceneOverrideCheckboxState = false;
	};
};





// CHECKBOX
// Upon opening of gui, let the control show the current selected value
private _sceneOverrideTimerControl = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiSceneOverrideCheckbox; // Define the displaycontrol
if (indiCam_var_guiSceneOverrideCheckboxState) then {
	// Set the checkbox to checked
	_sceneOverrideTimerControl cbSetChecked true; // Set the stored value
} else {
	// Set the checkbox to unchecked
	_sceneOverrideTimerControl cbSetChecked false; // Set the stored value
};







comment "-------------------------------------------------------------------------------------------------------";
comment "											vision mode													";
comment "-------------------------------------------------------------------------------------------------------";


indiCam_fnc_guiVisionMode = {
	// Grab the index number corresponding to each vision mode
	private _index = lbCurSel indiCam_id_guiVisionModeDropdown;
	if (indiCam_debug) then {systemChat format ["selection changed to index %1", _index];};
	// Set the dropdown variable to the index number
	indiCam_var_guiVisionModeDropdownState = _index;
	// Call the main indiCam script function that will run the proper code corresponding to the selection
	[_index] call indiCam_fnc_visionMode;
};

// This will populate RscCombo with different vision modes
private _visionModeCombo = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiVisionModeDropdown; // Define the displaycontrol

{
	_visionModeCombo lbAdd _x;
} forEach 	[ // The order is dependent on index number to match function in main indiCam script
			"Automatic", // Will switch between night vision and daylight depending on what situationCheck finds out. probably only time based.
			"Night vision",
			"White Hot",
			"Black Hot",
			"Light Green Hot / Darker Green cold",
			"Black Hot / Darker Green cold",
			"Light Red Hot /Darker Red Cold",
			"Black Hot / Darker Red Cold",
			"White Hot / Darker Red Cold",
			"Thermal (Predator vision)",
			"Forced daylight"
			];

// After loading gui, set the dropdown to it's current value
lbSetCurSel [indiCam_id_guiVisionModeDropdown, indiCam_var_guiVisionModeDropdownState];








comment "-------------------------------------------------------------------------------------------------------";
comment "										Actor auto switch 												";
comment "-------------------------------------------------------------------------------------------------------";

// This is code that sets the duration between automatic actor switching
// This functionality is currently only supported by the GUI
_sliderMinAutoSwitch = 10;
_sliderMaxAutoSwitch = 600;

_controlSliderAutoSwitch = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorAutoswitchSlider; // Define the displaycontrol
_controlSliderAutoSwitch sliderSetRange [_sliderMinAutoSwitch, _sliderMaxAutoSwitch];
_controlSliderAutoSwitch sliderSetPosition indiCam_var_guiActorAutoswitchSliderState;


// Define the displaycontrol for the textbox showing current duration
_controlSliderText = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorAutoswitchSliderText;

// Update the text box with the new value.
_controlSliderText ctrlSetText format ["duration: %1 seconds", indiCam_var_guiActorAutoswitchSliderState];



// This function is run by the slider eventhandler onSliderPosChanged
indiCam_fnc_actorAutoSwitchTimeSlider = {

	// Define the displaycontrol for slider
	_controlSlider = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorAutoswitchSlider;
	// Get the value the slider was moved to
	_sliderPos = round (sliderPosition _controlSlider);
	
	// Store the new value in the global variable for later use
	indiCam_var_guiActorAutoswitchSliderState = _sliderPos;
	indiCam_var_actorSwitchSettings set [4,_sliderPos];
	indiCam_var_guiActorAutoswitchSliderChanged = time;
	
	
	
	if (indiCam_var_actorAutoSwitchCheckboxState) then {
		
			// This is where we enable actor auto switch in main loop
			indiCam_var_actorTimer = time + (indiCam_var_actorSwitchSettings select 4); // actorAutoSwitchDuration
		
		};
	

	// Define the displaycontrol for the textbox showing current duration
	_controlSliderText = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorAutoswitchSliderText;
	
	// Update the text box with the new value.
	_controlSliderText ctrlSetText format ["duration: %1 seconds", indiCam_var_guiActorAutoswitchSliderState];
	
}; // End of auto switch slider function





// Set the checkbox to reflect the current state upon loading gui
private _autoSwitchCheckbox = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorAutoswitchCheckbox; // Define the displaycontrol
if (indiCam_var_actorAutoSwitchCheckboxState) then {
	// Set the checkbox to checked
	_autoSwitchCheckbox cbSetChecked true; // Set the stored value
} else {
	// Set the checkbox to unchecked
	_autoSwitchCheckbox cbSetChecked false; // Set the stored value
};



// This is a function to toggle the checkbox
indiCam_fnc_guiCheckboxActorAutoswitch = {

	private _control = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorAutoswitchCheckbox; // Define the displaycontrol
	private _checkedAutoSwitchCheckbox = cbChecked _control; // Checks state of checkbox
	if (_checkedAutoSwitchCheckbox) then {
		indiCam_var_actorAutoSwitchCheckboxState = true;
		
		
		// This is where we enable actor auto switch in main loop
		indiCam_var_actorSwitchSettings set [3,true]; // actorAutoSwitchBool
		indiCam_var_actorTimer = time + (indiCam_var_actorSwitchSettings select 4); // actorAutoSwitchDuration
		
		
		if (indiCam_debug) then {systemChat "Actor auto switching enabled"};
	} else {
		indiCam_var_actorAutoSwitchCheckboxState = false;
		
		
		// This is where we disable actor autoswitch in main loop
		indiCam_var_actorSwitchSettings set [3,false]; // actorAutoSwitchBool
		indiCam_var_actorTimer = time + 99999; // Set to crazy far in the future as a faux "halted timer"
		
		
		if (indiCam_debug) then {systemChat "Actor auto switching disabled"};
	};

};



indiCam_fnc_guiDropdownActorAutoswitch = {
	// Find out what was just selected in the dropdown
	private _index = lbCurSel indiCam_id_guiActorAutoswitchDropdown;
	// Set the global variable to the currently selected value
	indiCam_var_guiActorAutoswitchDropdownState = _index;
	
	// Store the current selection in the actor switch settings array
	indiCam_var_actorSwitchSettings set [0,_index];
	
	// Update the text showing who the current actor is
	private _currentActorDisplay = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorDisplay; // Define the displaycontrol
	_currentActorDisplay ctrlSetText format ['Current actor: %1', (name indiCam_actor)];
};


private _autoswitchCombo = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorAutoswitchDropdown; // Define the displaycontrol

// Populate RscCombo indiCam_gui_comboRandomizeActor
{
	_autoswitchCombo lbAdd _x;
} forEach 	[ // The order is dependent on index number to match function in main indiCam script
			"Only players",
			"Closest unit",
			"All units",
			"Random unit within proximity",
			"Only players on actor side",
			"Closest unit on actor side",
			"All units on actor side",
			"Random unit within proximity on actor side",
			"Random unit within current group"
			];

// After loading gui, set the dropdown to it's current value
lbSetCurSel [indiCam_id_guiActorAutoswitchDropdown, indiCam_var_guiActorAutoswitchDropdownState];




comment "-------------------------------------------------------------------------------------------------------";
comment "										player selection list											";
comment "-------------------------------------------------------------------------------------------------------";
// Reset the player array
indiCam_var_guiPlayerListArray = [];

// This will generate a list with live players excluding headless clients, but not the cameraman
private _allHCs = entities "HeadlessClient_F";
indiCam_var_guiPlayerListArray = allPlayers - _allHCs;


// Define the displaycontrol
private _playerSelectionList = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiPlayerList;





// Populate the dialog control with the list to generate proper indexes.
private _selectedIndex = 0;
private _playerName = 0;
{
	// Show the short name of the player in the list
	private _playerName = format ["%1(%2)",name _x,side _x];
	_playerSelectionList lbAdd _playerName;
} forEach indiCam_var_guiPlayerListArray;




// This function is called by the eventhandler for the listbox in dialogs
indiCam_fnc_guiPlayerList = {
	// Find out what was just selected in the list
	_selectedIndex = lbCurSel indiCam_id_guiPlayerList; // lbCurSel returns -1 when nothing is selected
	// Store the corresponding player in in variable
	indiCam_var_guiPlayerListSelectedPlayer = (indiCam_var_guiPlayerListArray select _selectedIndex);
};




// This is called from the "actor" button at the player listbox
indiCam_fnc_guiPlayerListButton = {
	// Set the selected player as the actor
	[indiCam_var_guiPlayerListSelectedPlayer] call indiCam_fnc_actorSwitch;
	// Update the text display naming the current actor
	private _currentActorDisplay = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorDisplay; // Define the displaycontrol
	_currentActorDisplay ctrlSetText format ['Current actor: %1', (name indiCam_actor)];
};



// If the actor is any of the selected players in the list, then select that player (otherwise, select none?)
_checkArray = indiCam_actor in indiCam_var_guiPlayerListArray;
if (_checkArray) then {
		_index = indiCam_var_guiPlayerListArray find indiCam_actor;
		_playerSelectionList lbSetCurSel _index;
} else {
	// Actor is not in array. Don't select anyone, or select the topmost unit.
};




	



comment "-------------------------------------------------------------------------------------------------------";
comment "											Manual mode													";
comment "-------------------------------------------------------------------------------------------------------";
indiCam_fnc_guiManualMode = {

closeDialog 0;
[] call indiCam_fnc_manualMode;

};



comment "-------------------------------------------------------------------------------------------------------";
comment "										Map side selector												";
comment "-------------------------------------------------------------------------------------------------------";



// This function is triggered on combo switch eventhandler
indiCam_fnc_guiSetMapSide = {
	// Grab the index number corresponding to the selected side
	private _index = lbCurSel indiCam_id_guiMapSideDropdown;
	if (indiCam_debug) then {systemChat format ["selection changed to index %1", _index];};
	// Set the global variable to the index number (ugh, i know)
	indiCam_var_guiMapSideDropdownState = _index;
	// Call the function which will show markers on the map depending on side selection.
	
	// This needs to be a switch
	switch (_index) do {
	
		case 0: { // NONE
			// This is where we start the map function with NONE showing
			[0] call indiCam_fnc_guiMapSide;
		};
	
		case 1: { // WEST
			// This is where we start the map function with only WEST showing
			[1] call indiCam_fnc_guiMapSide;
		};
	
		case 2: { // EAST;
			// This is where we start the map function with only EAST showing
			[2] call indiCam_fnc_guiMapSide;
		};
	
		case 3: { // IND
			// This is where we start the map function with only IND showing
			[3] call indiCam_fnc_guiMapSide;
		};
	
		case 4: { // CIV
			// This is where we start the map function with only CIV showing
			[4] call indiCam_fnc_guiMapSide;
		};
	
		case 5: { // ALL
			// This is where we start the map function with only ALL showing
			[5] call indiCam_fnc_guiMapSide;
		};
	
	}; // end of switch
	
};


// This will populate RscCombo indiCam_id_guiMapSideDropdown
{_index = lbAdd [indiCam_id_guiMapSideDropdown, _x]
} forEach 	[ // The order is dependent on index number to match function in main indiCam script
			"NONE",	// 0
			"WEST",	// 1
			"EAST",	// 2
			"IND",	// 3
			"CIV",	// 4
			"ALL"	// 5
			];

// After loading gui, set the dropdown to it's current value
lbSetCurSel [indiCam_id_guiMapSideDropdown, indiCam_var_guiMapSideDropdownState];

