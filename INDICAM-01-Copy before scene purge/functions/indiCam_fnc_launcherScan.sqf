comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										  indiCam_fnc_launcherScan										";
comment "																										";
comment "	Spawn this script to detect units have pulling out their launcher to cream a hard target.			";
comment "	When the script deem it appropriate, it will interrupt the main loop and force a scene on that unit.";
comment "-------------------------------------------------------------------------------------------------------";

//TODO- Should not attempt scene switch for units too far away from the current camera.

private _activationChance = indiCam_var_scriptedSceneChance;		// Lower percentage number means lower chance of getting a detected AT launcher scene selected for camera.
private _sameActorCooldown = 20;	// If the scripts attempts to run the cooldown on the same unit twice in a row, initiate cooldown instead.
private _functionSpeed = 0.2; 		// Sets how often the script checks for an AT soldier pulling out his launcher.
private _retryDelay = 20; 			// The amount of time the script will wait until it tries to find another AT guy
private _maxDistance = 1500; 		// Sets how far away from the current camera pos the AT guy is allowed to be to qualifys
private _playerChanceFactor = 1.25;	// The factor by which a player has a different chance than an AI unit to get an AT scene started.


// Declaring some vars
private _selectedLast = player;		// Declaring a variable to check against previous time a launcher scene was used.
private _selectedLastTimer = 0;
private _future = 0;


// Eventhandlers:
// IncomingMissile Triggered when a guided missile locked on the target or unguided missile or rocket aimed by AI or actor at the target was fired.
// could keep track of current Actor target for this

// This function returns true when given unit has a loaded launcher in hands
// Result: 0.004ms
indiCam_fnc_checkSecondarySelected = {
	

params [
		["_unit",actor]
		];

private "_returnState";

	_secondaryAmmo = secondaryWeaponMagazine _unit; // Returns an array
	_currentAmmo = currentMagazine _unit; // returns a string
	if ( count _secondaryAmmo > 0 ) then { // Only bother if there is ammo in secondary and the unit is close enough to the current camera
	
		// Check if secondary weapon is in hands by comparing ammo in both currentMagazine and _secondaryAmmo
		if (_currentAmmo isEqualTo (_secondaryAmmo select 0)) then { // _secondaryAmmo is an array, so converted to string
			_returnState = true; // Unit has a loaded rocket equipped in hands
		} else {
			_returnState = false; // Mismatch on ammo types
		};
		
	} else { // Don't bother if the unit is out of ammo.
	
		if (secondaryWeapon _unit != "") then {
			_returnState = false; // Secondary has no ammo in it
		} else {
			_returnState = false; // Unit doesn't have secondary
		};
	};
	
	_returnState;

};






if (indiCam_debug) then {systemChat "starting launcher scan loop"};

comment "-------------------------------------------------------------------------------------------------------";
comment "											loop block													";
comment "-------------------------------------------------------------------------------------------------------";

while {indiCam_runIndiCam} do {
	private _ATArray = []; // Reset the array on each pass

	// Get a unit list
	private _unitArray = [
		false,	// West
		false,	// East
		false,	// Indy
		false,	// CIV
		false,	// All units
		false,	// All players
		true	// All units on current actor's side
	] call indiCam_fnc_actorList; // about 1ms. Don't run too often.

	
	{
		_ATAim = [_x] call indiCam_fnc_checkSecondarySelected; // Takes about 0.001 ms
		if (
		
			(_ATAim) // Check if unit has a loaded launcher
			&& ((_x distance2D indiCam) < _maxDistance) // Check that the selected unit isn't too far away from the camera position.
			
			) then {_ATArray pushBack _x}; // add any unit that fullfills all the above criteria to the list
			
	} forEach _unitArray; // Hey! {_justPlayers = allPlayers - entities "HeadlessClient_F";};

	
	// If there are any units currently holding their launcher, take action
	if ( (count _ATArray) > 0 ) then {
		
		// Pic a random unit from the generated list
		private _selected = selectRandom _ATArray;
		// Roll the dice to see if we are going forward with starting a scene for this unit
		_chance = floor random 100;
		
		// Increase chance for players to be selected by making the dice value lower than the threshold value
		if (isPlayer _selected) then {_chance = _chance / _playerChanceFactor;};
		
		
		// Only run the scene if the chance is lower than the threshold value and it's another unit than last time
		// Also, the unit cannot already be on the cooldown list
		private _cooldownCheck = [_selected,"",true] call indiCam_fnc_unitCooldown;
		
		if ( (_chance < _activationChance) && (_selectedLast != _selected) && !(_cooldownCheck) ) then {
		if (indiCam_debug) then {systemchat format ["cooldown check: %1, actor: %2, chance: %3",_cooldownCheck,_selected,_chance]};
	 
			// Reset the last selected to this failed selected unit
			_selectedLast = _selected;
			// To be used in scripted scene select in order to maintain original actor
			indiCam_var_scriptedActor = _selected;
			// tell the selector what type of scene we're looking for (instead of actionLevel).
			indiCam_var_scriptedSceneType = "ATGuy";
			// Tell situationSelect that scripted scene is at go and to turn on the correct vicValue
			indiCam_var_scriptedScene = true;
			// Stop the currently running scene
			indiCam_var_interruptScene = true;
			// Suspend the script until scene is done and it's time to start checking for AT actions again.
			waitUntil {!indiCam_var_scriptedScene};
	 
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

	
	sleep _functionSpeed;


};


if (indiCam_debug) then {systemChat "stopping launcher scan loop"};