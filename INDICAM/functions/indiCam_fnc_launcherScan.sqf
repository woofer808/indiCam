/*
 * Author: woofer
 * Spawn this script to detect units have pulling out their launcher to cream a hard target.
 * When the script deem it appropriate, it will force an AT scene on that unit.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * spawn indiCam_fnc_launcherScan
 *
 * Public: No
 */

/* ----------------------------------------------------------------------------------------------------
		Long loop unit list to keep a unit list up to date.											
   ---------------------------------------------------------------------------------------------------- */

// Build a list of units that are close enough and AT capable
indiCam_fnc_launcherScanUnitList = { // 0.21 ms @ 100 units
private _longCycle = 30; // Defines how often this loop should run
	
	while {indiCam_running} do {
		
		// Collect all the units minus the cameraman in case he starts the camera with AT in hand
		private _unitArray = (allUnits - [player]);
		private _ATArray = [];
		
		// Only gather units that are close enough to the camera
		{
			// Pull only units from the desired side
			if (
				((indiCam_actor distance2D _x) < 750) &&
				(secondaryWeapon _x != "")
			) then {_ATArray pushBack _x};
		} forEach _unitArray;
		
		
		// Handle the case where the list is empty
		
		
		indiCam_var_launcherScanArray = _ATArray;
		
		sleep _longCycle;
		
	};
	
};
[] spawn indiCam_fnc_launcherScanUnitList; // Spawn this to run in background until camera is stopped

/* ----------------------------------------------------------------------------------------------------
		Short loop unit list and action.										
   ---------------------------------------------------------------------------------------------------- */

// Check the current list for units that have the launcher in hand
indiCam_fnc_launcherScanCheckList = { // 0.35 ms @ 100 units
	private _shortCycle = 2; // Defines how often this loop should run
	private _activationChance = indiCam_var_scriptedSceneChance; // Lower percentage number means lower chance of getting a detected AT launcher scene selected for 
	private _playerChanceFactor = 1.5; // The higher this value, the more chance a scene will start because the selected unit is a player.
	private _selectedLast = player;		// Declaring a variable to check against previous time a launcher scene was used.
	private _ATout = [];

	while {indiCam_running} do {
	
		_ATout = []; // Reset this on every loop
	
		// Check the current list of units for ones that currently have a loaded AT in hands
		{
			_secondaryAmmo = secondaryWeaponMagazine _x; // Returns an array
			_currentAmmo = currentMagazine _x; // returns a string
			if ( count _secondaryAmmo > 0 ) then { // Only bother if there is ammo in secondary and the unit is close enough to the current camera
			
				// Check if secondary weapon is in hands by comparing ammo in both currentMagazine and _secondaryAmmo
				if (_currentAmmo isEqualTo (_secondaryAmmo select 0)) then { // _secondaryAmmo is an array, so converted to string
					
					// Now that there is an actor with his junk out, put him in a list and see if there are more
					_ATout pushBack _x;
					
				} else {
					// Mismatch on ammo types since comparing rifle to launcher, do nothing
				};
				
			} else { // Don't bother if the unit is out of ammo.
			
				if (secondaryWeapon _x != "") then {
					// Secondary has no ammo in it, do nothing this is for players pulling out their launcher empty
				} else {
					// Unit doesn't have secondary, do nothing.
				};
			};
		} forEach indiCam_var_launcherScanArray;
		
		
		
		
		
		// If there are any units currently holding their launcher, take action
		if ( (count _ATout) > 0 && !indiCam_var_scriptedSceneRunning) then {
			
			// Pic a random unit from the generated list
			private _selected = selectRandom _ATout;
			// Roll the dice to see if we are going forward with starting a scene for this unit
			private _chance = floor random 100;
			
			// Increase chance for players to be selected by making the dice value lower than the threshold value
			if (isPlayer _selected) then {_chance = _chance / _playerChanceFactor};
			
			
			// Only run the scene if the chance is lower than the threshold value and it's another unit than last time
			// Also, the unit cannot already be on the cooldown list
			private _cooldownCheck = [_selected,30,true] call indiCam_fnc_unitCooldown;
			
			if ( (_chance < _activationChance) && (_selectedLast != _selected) && !(_cooldownCheck) ) then {
			if (indiCam_debug) then {systemchat format ["cooldown check: %1, actor: %2, chance: %3",_cooldownCheck,_selected,_chance]};
		 
				// Reset the last selected to this failed selected unit
				_selectedLast = _selected;
				
				indiCam_var_scriptedSceneRunning = true;
				["ATGuy", _selected] spawn indiCam_scene_selectScripted;
				
				// Suspend the script until scene is done and it's time to start checking for AT actions again.
				waitUntil {!indiCam_var_scriptedSceneRunning};
		 
			} else {
			
				// Not lucky enough, skip activating scripted AT launcher scene.
				if (_chance > _activationChance) then {
					if (indiCam_debug) then {systemChat "Not enough luck, skipping AT scene"};
					// Reset the last selected to this failed selected unit
					_selectedLast = _selected;
				};
				
				// This unit has already been used, add it to the cooldown list
				if (_selectedLast == _selected) then {
					[_selected,30] call indiCam_fnc_unitCooldown;
					if (indiCam_debug) then {systemChat "Unit was used last time, skipping AT scene"};
				};
				
			};
		
		};
		
		sleep _shortCycle;
		
	};
	
	if (indiCam_debug) then {systemChat "stopping indiCam_fnc_launcherScan"};
	
};
[] spawn indiCam_fnc_launcherScanCheckList;

if (indiCam_debug) then {systemChat "starting indiCam_fnc_launcherScan"};
