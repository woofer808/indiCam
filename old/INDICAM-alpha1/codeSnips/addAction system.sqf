
This seems to be a way of storing which addaction is which in Liberation

if (!(_next_truck in _managed_trucks) && (_truck_load > 0)) then {
					_action_id = _next_truck addAction ["<t color='#FFFF00'>" + localize "STR_ACTION_UNLOAD_BOX" + "</t>","scripts\client\ammoboxes\do_unload_truck.sqf","",-500,true,true,"","build_confirmed == 0 && (_this distance _target < 8) && (vehicle player == player)"];
					_next_truck setVariable [ "GRLIB_ammo_truck_action", _action_id, false ];
					_managed_trucks pushback _next_truck;
			};
			
			
			
This seems to be the reason as to why addactions are added when ending AIC remoting
probably only need a {removeallactions player}

	if (_fobdistance < _distfob && alive player && vehicle player == player && (([ player, 3] call F_fetchPermission) || (player == ([] call F_getCommander) || [] call F_isAdmin))) then {
		if (_idact_build == -1) then {
			_idact_build = player addAction ["<t color='#FFFF00'>" + localize "STR_BUILD_ACTION" + "</t> <img size='2' image='res\ui_build.paa'/>","scripts\client\build\open_build_menu.sqf","",-985,false,true,"","build_confirmed == 0"];
		};
		
		
		