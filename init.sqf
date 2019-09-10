

//[] execVM "INDICAM\indiCam_init.sqf"; // initializes indiCam
[] execVM "INDICAM\indiCam_core_init.sqf"; // initializes indiCam


[] spawn { // This stops Niipaa's workshop from displaying a hint at startup
	sleep 1;
	hint "";
};

/*
[] spawn { // This is just to make sure the test script runs automatically in the WIP mission
	sleep 1;
	[] execVM "INDICAM\functions\indiCam_fnc_test.sqf";
};
*/

// Running this a little late to make sure it overwrites whatever the settings in indiCam_core_settings are
[] spawn {
	sleep 1;
	indiCam_devMode = false; // false will use compiled scripts
	systemChat format ["DevMode %1...",indiCam_devMode];
};


