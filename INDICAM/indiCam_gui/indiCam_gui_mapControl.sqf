/* ----------------------------------------------------------------------------------------------------
									Actor map selection
   ---------------------------------------------------------------------------------------------------- */

// This function shows ALL units as markes on the map so that one can be selected as actor
// Format:
// [showAllUnitsBool] call indiCam_fnc_mapSelect;
indiCam_fnc_guiMapSide = { // function contains sleep and should be spawned
	player linkItem "ItemMap"; // Just in case the cameraman is spawned without a map

	
	// This will reset the script and kill spawned map markers
	indiCam_var_showMarkers = false;
	sleep 0.5;
	
	// The function needs to be able to set this variable with _this select 0;
	_mapSelectSide = _this select 0;

	
	switch (_mapSelectSide) do {
			// "NONE"	0
			// "WEST" 	1
			// "EAST" 	2
			// "IND"	3
			// "CIV"	4
			// "ALL"	5

			
		case 0: { // NONE
			indiCam_var_showMarkers = false;
		};
			
		case 1: { // WEST
			
			[] spawn { // this contains sleep and thus needs to be spawned
				indiCam_var_showMarkers = true;
				
				while {indiCam_var_showMarkers} do {
					private "_markername";
					private _markerArray = [];
					private _unitArray = [];
				
					// Build the correct array of units depending on if it's only friendlies or if it's all units that are to be shown
					{	// forEach allUnits only pulls alive mans of the four main factions
						if (indiCam_var_mapselectAll) then {_unitArray pushBack _x};
						if (side _x == WEST) then {_unitArray pushBack _x};
					} foreach allUnits;
					
					
					{ // Use the newly created array of units to draw markers on their pos
						// Assign each unit a unique marker
						_markername = format ["indiCamMarker%1",_x];
						_markername = createMarkerLocal [_markername,(position _x)]; 
						_markername setMarkerShapeLocal "ICON"; 
						_markername setMarkerTypeLocal "hd_dot";
						_markername setMarkerSizeLocal [1,1];
						_markerArray pushBack _markername;
					
						// Depending on attributes give the marker shape, color and text
						if ((side _x) == WEST) then {_markername setMarkerColorLocal "ColorWEST"};
						if ((side _x) == EAST) then {_markername setMarkerColorLocal "ColorEAST"};
						if ((side _x) == resistance) then {_markername setMarkerColorLocal "ColorGUER"};
						if ((side _x) == civilian) then {_markername setMarkerColorLocal "ColorCIV"};
						if ((vehicle _x isKindOf "Car")) then {_markername setMarkerTextLocal "Car";};
						if ((vehicle _x isKindOf "Tank")) then {_markername setMarkerTextLocal "Tank";};
						if ((vehicle _x isKindOf "Helicopter")) then {_markername setMarkerTextLocal "Helicopter";};
						if ((vehicle _x isKindOf "Plane")) then {_markername setMarkerTextLocal "Plane";};
						if ((vehicle _x isKindOf "Ship")) then {_markername setMarkerTextLocal "Ship";};
						if (isPlayer _x) then {_playerName = format ["player (%1)",name _x];_markername setMarkerColorLocal "ColorYellow";_markername setMarkerTextLocal str _playerName;};
						if (_x == indiCam_actor) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal "current actor (AI)";};
						if ((_x == indiCam_actor) && (isPlayer _x)) then {_playerName = format ["current actor (%1)",name _x];_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal str _playerName;};
						
					} foreach _unitArray;

					sleep 0.25; // This is the update frequency of the script. onEachFrame didn't pan out well.
				
					{ // Delete all markers before drawing them again
						deleteMarkerLocal _x;
					} foreach _markerArray;
				};
				if (indiCam_debug) then {systemChat "stopping markers..."};
			};
		
		
			onMapSingleClick { // Using the old version of this EH, is that bad?
				private _friendlyUnitsData = [];
				private _allUnitsData = [];

				{ // forEach that splits all the units into separate arrays depending on if we want all or just friendlies
				
					if (side _x == WEST) then {_friendlyUnitsData pushBack [_x,(getPos _x distance2D _pos)]};
					_friendlyUnitsData sort true;
					_unit = ((_friendlyUnitsData select 0) select 0); // Set the unit closest to the clicked position as the actor
					[_unit] call indiCam_fnc_actorSwitch;
					indiCam_var_requestMode = "default";
					
				} forEach allUnits;
			
				hint format ["Actor set to: %1",indiCam_actor];
			
				// Update the text showing who the current actor is
				private _currentActorDisplay = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorDisplay; // Define the displaycontrol
				_currentActorDisplay ctrlSetText format ['Current actor: %1', (name indiCam_actor)];
		
			};

		};// End of case
		
		
	
		case 2: { // EAST
			
			[] spawn { // this contains sleep and thus needs to be spawned
				indiCam_var_showMarkers = true;
				
				while {indiCam_var_showMarkers} do {
					private "_markername";
					private _markerArray = [];
					private _unitArray = [];
				
					// Build the correct array of units depending on if it's only friendlies or if it's all units that are to be shown
					{	// forEach allUnits only pulls alive mans of the four main factions
						if (indiCam_var_mapselectAll) then {_unitArray pushBack _x};
						if (side _x == EAST) then {_unitArray pushBack _x};
					} foreach allUnits;
					
					
					{ // Use the newly created array of units to draw markers on their pos
						// Assign each unit a unique marker
						_markername = format ["indiCamMarker%1",_x];
						_markername = createMarkerLocal [_markername,(position _x)]; 
						_markername setMarkerShapeLocal "ICON"; 
						_markername setMarkerTypeLocal "hd_dot";
						_markername setMarkerSizeLocal [1,1];
						_markerArray pushBack _markername;
					
						// Depending on attributes give the marker shape, color and text
						if ((side _x) == WEST) then {_markername setMarkerColorLocal "ColorWEST"};
						if ((side _x) == EAST) then {_markername setMarkerColorLocal "ColorEAST"};
						if ((side _x) == resistance) then {_markername setMarkerColorLocal "ColorGUER"};
						if ((side _x) == civilian) then {_markername setMarkerColorLocal "ColorCIV"};
						if ((vehicle _x isKindOf "Car")) then {_markername setMarkerTextLocal "Car";};
						if ((vehicle _x isKindOf "Tank")) then {_markername setMarkerTextLocal "Tank";};
						if ((vehicle _x isKindOf "Helicopter")) then {_markername setMarkerTextLocal "Helicopter";};
						if ((vehicle _x isKindOf "Plane")) then {_markername setMarkerTextLocal "Plane";};
						if ((vehicle _x isKindOf "Ship")) then {_markername setMarkerTextLocal "Ship";};
						if (isPlayer _x) then {_markername setMarkerColorLocal "ColorYellow";_markername setMarkerTextLocal "a player";};
						if (_x == indiCam_actor) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal "current actor";};
						if ((_x == indiCam_actor) && (isPlayer _x)) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal  "current actor (a player)";};
						
					} foreach _unitArray;

					sleep 0.25; // This is the update frequency of the script. onEachFrame didn't pan out well.
				
					{ // Delete all markers before drawing them again
						deleteMarkerLocal _x;
					} foreach _markerArray;
				};
				if (indiCam_debug) then {systemChat "stopping markers..."};
			};

			onMapSingleClick { // Using the old version of this EH, is that bad?
				private _friendlyUnitsData = [];
				private _allUnitsData = [];

				{ // forEach that splits all the units into separate arrays depending on if we want all or just friendlies
			
					if (side _x == EAST) then {_friendlyUnitsData pushBack [_x,(getPos _x distance2D _pos)]};
					_friendlyUnitsData sort true;
					_unit = ((_friendlyUnitsData select 0) select 0); // Set the unit closest to the clicked position as the actor
					[_unit] call indiCam_fnc_actorSwitch;
					indiCam_var_requestMode = "default";

				} forEach allUnits;
			
				hint format ["Actor set to: %1",indiCam_actor];
			
				// Update the text showing who the current actor is
				private _currentActorDisplay = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorDisplay; // Define the displaycontrol
				_currentActorDisplay ctrlSetText format ['Current actor: %1', (name indiCam_actor)];
		
			};
			
		};// End of case
		
	
		case 3: { // IND
			
			[] spawn { // this contains sleep and thus needs to be spawned
				indiCam_var_showMarkers = true;
				
				while {indiCam_var_showMarkers} do {
					private "_markername";
					private _markerArray = [];
					private _unitArray = [];
				
					// Build the correct array of units depending on if it's only friendlies or if it's all units that are to be shown
					{	// forEach allUnits only pulls alive mans of the four main factions
						if (indiCam_var_mapselectAll) then {_unitArray pushBack _x};
						if (side _x == resistance) then {_unitArray pushBack _x};
					} foreach allUnits;
					
					
					{ // Use the newly created array of units to draw markers on their pos
						// Assign each unit a unique marker
						_markername = format ["indiCamMarker%1",_x];
						_markername = createMarkerLocal [_markername,(position _x)]; 
						_markername setMarkerShapeLocal "ICON"; 
						_markername setMarkerTypeLocal "hd_dot";
						_markername setMarkerSizeLocal [1,1];
						_markerArray pushBack _markername;
					
						// Depending on attributes give the marker shape, color and text
						if ((side _x) == WEST) then {_markername setMarkerColorLocal "ColorWEST"};
						if ((side _x) == EAST) then {_markername setMarkerColorLocal "ColorEAST"};
						if ((side _x) == resistance) then {_markername setMarkerColorLocal "ColorGUER"};
						if ((side _x) == civilian) then {_markername setMarkerColorLocal "ColorCIV"};
						if ((vehicle _x isKindOf "Car")) then {_markername setMarkerTextLocal "Car";};
						if ((vehicle _x isKindOf "Tank")) then {_markername setMarkerTextLocal "Tank";};
						if ((vehicle _x isKindOf "Helicopter")) then {_markername setMarkerTextLocal "Helicopter";};
						if ((vehicle _x isKindOf "Plane")) then {_markername setMarkerTextLocal "Plane";};
						if ((vehicle _x isKindOf "Ship")) then {_markername setMarkerTextLocal "Ship";};
						if (isPlayer _x) then {_markername setMarkerColorLocal "ColorYellow";_markername setMarkerTextLocal "a player";};
						if (_x == indiCam_actor) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal "current actor";};
						if ((_x == indiCam_actor) && (isPlayer _x)) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal  "current actor (a player)";};
						
					} foreach _unitArray;

					sleep 0.25; // This is the update frequency of the script. onEachFrame didn't pan out well.
				
					{ // Delete all markers before drawing them again
						deleteMarkerLocal _x;
					} foreach _markerArray;
				};
				if (indiCam_debug) then {systemChat "stopping markers..."};
			};
			
			
			onMapSingleClick { // Using the old version of this EH, is that bad?
				private _friendlyUnitsData = [];
				private _allUnitsData = [];

				{ // forEach that splits all the units into separate arrays depending on if we want all or just friendlies
			
					if (side _x == resistance) then {_friendlyUnitsData pushBack [_x,(getPos _x distance2D _pos)]};
					_friendlyUnitsData sort true;
					_unit = ((_friendlyUnitsData select 0) select 0); // Set the unit closest to the clicked position as the actor
					[_unit] call indiCam_fnc_actorSwitch;
					indiCam_var_requestMode = "default";

				} forEach allUnits;
			
				hint format ["Actor set to: %1",indiCam_actor];
			
				// Update the text showing who the current actor is
				private _currentActorDisplay = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorDisplay; // Define the displaycontrol
				_currentActorDisplay ctrlSetText format ['Current actor: %1', (name indiCam_actor)];
		
			};
			
		};// End of case
	
		case 4: { // CIV
			
			[] spawn { // this contains sleep and thus needs to be spawned
				indiCam_var_showMarkers = true;
				
				while {indiCam_var_showMarkers} do {
					private "_markername";
					private _markerArray = [];
					private _unitArray = [];
				
					// Build the correct array of units depending on if it's only friendlies or if it's all units that are to be shown
					{	// forEach allUnits only pulls alive mans of the four main factions
						if (indiCam_var_mapselectAll) then {_unitArray pushBack _x};
						if (side _x == civilian) then {_unitArray pushBack _x};
					} foreach allUnits;
					
					
					{ // Use the newly created array of units to draw markers on their pos
						// Assign each unit a unique marker
						_markername = format ["indiCamMarker%1",_x];
						_markername = createMarkerLocal [_markername,(position _x)]; 
						_markername setMarkerShapeLocal "ICON"; 
						_markername setMarkerTypeLocal "hd_dot";
						_markername setMarkerSizeLocal [1,1];
						_markerArray pushBack _markername;
					
						// Depending on attributes give the marker shape, color and text
						if ((side _x) == WEST) then {_markername setMarkerColorLocal "ColorWEST"};
						if ((side _x) == EAST) then {_markername setMarkerColorLocal "ColorEAST"};
						if ((side _x) == resistance) then {_markername setMarkerColorLocal "ColorGUER"};
						if ((side _x) == civilian) then {_markername setMarkerColorLocal "ColorCIV"};
						if ((vehicle _x isKindOf "Car")) then {_markername setMarkerTextLocal "Car";};
						if ((vehicle _x isKindOf "Tank")) then {_markername setMarkerTextLocal "Tank";};
						if ((vehicle _x isKindOf "Helicopter")) then {_markername setMarkerTextLocal "Helicopter";};
						if ((vehicle _x isKindOf "Plane")) then {_markername setMarkerTextLocal "Plane";};
						if ((vehicle _x isKindOf "Ship")) then {_markername setMarkerTextLocal "Ship";};
						if (isPlayer _x) then {_markername setMarkerColorLocal "ColorYellow";_markername setMarkerTextLocal "a player";};
						if (_x == indiCam_actor) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal "current actor";};
						if ((_x == indiCam_actor) && (isPlayer _x)) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal  "current actor (a player)";};
						
					} foreach _unitArray;

					sleep 0.25; // This is the update frequency of the script. onEachFrame didn't pan out well.
				
					{ // Delete all markers before drawing them again
						deleteMarkerLocal _x;
					} foreach _markerArray;
				};
				if (indiCam_debug) then {systemChat "stopping markers..."};
			};
			
			onMapSingleClick { // Using the old version of this EH, is that bad?
				private _friendlyUnitsData = [];
				private _allUnitsData = [];

				{ // forEach that splits all the units into separate arrays depending on if we want all or just friendlies
			
					if (side _x == civilian) then {_friendlyUnitsData pushBack [_x,(getPos _x distance2D _pos)]};
					_friendlyUnitsData sort true;
					_unit = ((_friendlyUnitsData select 0) select 0); // Set the unit closest to the clicked position as the actor
					[_unit] call indiCam_fnc_actorSwitch;
					indiCam_var_requestMode = "default";

				} forEach allUnits;
			
				hint format ["Actor set to: %1",indiCam_actor];
			
				// Update the text showing who the current actor is
				private _currentActorDisplay = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorDisplay; // Define the displaycontrol
				_currentActorDisplay ctrlSetText format ['Current actor: %1', (name indiCam_actor)];
		
			};
			
		};// End of case
	
		case 5: { // ALL
			
			[] spawn { // this contains sleep and thus needs to be spawned
				indiCam_var_showMarkers = true;
				
				while {indiCam_var_showMarkers} do {
					private "_markername";
					private _markerArray = [];
					private _unitArray = [];
				
					// Build the correct array of units depending on if it's only friendlies or if it's all units that are to be shown
					{	// forEach allUnits only pulls alive mans of the four main factions
						if (indiCam_var_mapselectAll) then {_unitArray pushBack _x};
						if (
							(side _x == west) ||
							(side _x == east) ||
							(side _x == resistance) ||
							(side _x == civilian)
							) then {_unitArray pushBack _x};
					} foreach allUnits;
					
					
					{ // Use the newly created array of units to draw markers on their pos
						// Assign each unit a unique marker
						_markername = format ["indiCamMarker%1",_x];
						_markername = createMarkerLocal [_markername,(position _x)]; 
						_markername setMarkerShapeLocal "ICON"; 
						_markername setMarkerTypeLocal "hd_dot";
						_markername setMarkerSizeLocal [1,1];
						_markerArray pushBack _markername;
					
						// Depending on attributes give the marker shape, color and text
						if ((side _x) == WEST) then {_markername setMarkerColorLocal "ColorWEST"};
						if ((side _x) == EAST) then {_markername setMarkerColorLocal "ColorEAST"};
						if ((side _x) == resistance) then {_markername setMarkerColorLocal "ColorGUER"};
						if ((side _x) == civilian) then {_markername setMarkerColorLocal "ColorCIV"};
						if ((vehicle _x isKindOf "Car")) then {_markername setMarkerTextLocal "Car";};
						if ((vehicle _x isKindOf "Tank")) then {_markername setMarkerTextLocal "Tank";};
						if ((vehicle _x isKindOf "Helicopter")) then {_markername setMarkerTextLocal "Helicopter";};
						if ((vehicle _x isKindOf "Plane")) then {_markername setMarkerTextLocal "Plane";};
						if ((vehicle _x isKindOf "Ship")) then {_markername setMarkerTextLocal "Ship";};
						if (isPlayer _x) then {_markername setMarkerColorLocal "ColorYellow";_markername setMarkerTextLocal "a player";};
						if (_x == indiCam_actor) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal "current actor";};
						if ((_x == indiCam_actor) && (isPlayer _x)) then {_markername setMarkerColorLocal "ColorOrange";_markername setMarkerTextLocal  "current actor (a player)";};
						
					} foreach _unitArray;

					sleep 0.25; // This is the update frequency of the script. onEachFrame didn't pan out well.
				
					{ // Delete all markers before drawing them again
						deleteMarkerLocal _x;
					} foreach _markerArray;
				};
				if (indiCam_debug) then {systemChat "stopping markers..."};
			};
			
			onMapSingleClick { // Using the old version of this EH, is that bad?
				private _friendlyUnitsData = [];
				private _allUnitsData = [];

				{ // forEach that splits all the units into separate arrays depending on if we want all or just friendlies
			
					_friendlyUnitsData pushBack [_x,(getPos _x distance2D _pos)];
					_friendlyUnitsData sort true;
					_unit = ((_friendlyUnitsData select 0) select 0); // Set the unit closest to the clicked position as the actor
					[_unit] call indiCam_fnc_actorSwitch;
					indiCam_var_requestMode = "default";

				} forEach allUnits;
			
				hint format ["Actor set to: %1",indiCam_actor];
			
				// Update the text showing who the current actor is
				private _currentActorDisplay = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorDisplay; // Define the displaycontrol
				_currentActorDisplay ctrlSetText format ['Current actor: %1', (name indiCam_actor)];
		
			}; // End of map click EH
			
		};// End of case
		
		
	}; // End of switch
	
	/* ----------------------------------------------------------------------------------------------------
										actor selection and assignment on map
	   ---------------------------------------------------------------------------------------------------- */
	//openMap [true, false]; // Force a soft map opening
	//indiCam_var_mapOpened = addMissionEventHandler ["Map",{mapClosed = true;indiCam_var_showMarkers = false;}];

	/*
	onMapSingleClick { // Using the old version of this EH, is that bad?
		private _friendlyUnitsData = [];
		private _allUnitsData = [];

		{ // forEach that splits all the units into separate arrays depending on if we want all or just friendlies
		
			if (!indiCam_var_mapselectAll) then {// This is for when the actor can only be on the same side as the cameraman

				if (side _x == side player) then {_friendlyUnitsData pushBack [_x,(getPos _x distance2D _pos)]};
				_friendlyUnitsData sort true;
				_unit = ((_friendlyUnitsData select 0) select 0); // Set the unit closest to the clicked position as the actor
				[_unit] call indiCam_fnc_actorSwitch;
				indiCam_var_requestMode = "default";


			} else {// This is for when the actor can be selected from any unit
			
				_allUnitsData pushBack [_x,(getPos _x distance2D _pos)];
				_allUnitsData sort true;
				_unit = ((_allUnitsData select 0) select 0); // Set the unit closest to the clicked position as the actor
				[_unit] call indiCam_fnc_actorSwitch;
				indiCam_var_requestMode = "default";

			};

		} forEach allUnits;
		
		hint format ["Actor set to: %1",indiCam_actor];
		
		// Update the text showing who the current actor is
		private _currentActorDisplay = (findDisplay indiCam_id_guiDialogMain) displayCtrl indiCam_id_guiActorDisplay; // Define the displaycontrol
		_currentActorDisplay ctrlSetText format ['Current actor: %1', (name indiCam_actor)];
		
	};
	*/
	waitUntil {!dialog};
	onMapSingleClick {};
	
	// This will reset the script and kill spawned map markers
	indiCam_var_showMarkers = false;
	
	//removeMissionEventHandler ["Map", indiCam_var_mapOpened];
	//onMapSingleClick {}; // empty brackets stops the eventhandler?
};
