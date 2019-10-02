/*
 * Author: woofer
 * Continuously checks the actor's current surroundings.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: Ocean <BOOL>
 * 1: Forest <BOOL>
 * 2: Urban <BOOL>
 * 3: Airborne <BOOL>
 *
 * Example:
 * call indiCam_fnc_environmentCheck
 *
 * Public: No
 */

/*
testit = false; 
sleep 0.5; 
testit = true;  
while {testit} do {  
_handle = [] call indiCam_fnc_environmentCheck;  
hint str _handle;  
sleep 0.2;  
};
*/

/*
testit = false; 
sleep 0.5; 
testit = true;  
while {testit} do {  
_objectCount = count (nearestTerrainObjects [player, ["Tree","Bush"], 25]);  
hint str _objectCount;  
sleep 0.2;  
};
*/


/*
testit = false;  
sleep 0.5;  
testit = true;
private _airborneBool = false;   
while {testit} do {   
_oceanBool = surfaceIsWater getPosASL actor; 
private _altitude = 5; 
if (_oceanBool) then { 
 if ((getPosASL player select 2) > _altitude) then {_airborneBool = true} else {_airborneBool = false}; 
} else { 
 if ((getPos player select 2) > _altitude) then {_airborneBool = true} else {_airborneBool = false}; 
}; 
hint str _airborneBool;   
sleep 0.2;   
};
*/

/* ----------------------------------------------------------------------------------------------------
													init												
   ---------------------------------------------------------------------------------------------------- */
private _oceanBool = false;
private _forestBool = false;
private _urbanBool = false;
private _airborneBool = false;


/* ----------------------------------------------------------------------------------------------------
												actor over water												
   ---------------------------------------------------------------------------------------------------- */
// This only checks ocean water. Won't work on inland water.
// Purpose is to know when to use either AGL or ASL.
_oceanBool = surfaceIsWater getPosASL indiCam_actor;


/* ----------------------------------------------------------------------------------------------------
												forest areas												
   ---------------------------------------------------------------------------------------------------- */
// This keeps track if the actor is within a collection of trees and bushes
// A dense Altian forest gets between 25-45 trees and bushes at 25m radius
// About 15 at the edge of the forest

// Count objects of any type within a set raidus
private _treeCount = count (nearestTerrainObjects [indiCam_actor, ["Tree","Bush"], 25]);
if (_treeCount >= 10) then {_forestBool = true} else {_forestBool = false};



/* ----------------------------------------------------------------------------------------------------
												urban areas											
   ---------------------------------------------------------------------------------------------------- */
// This keeps track if the actor is in an urban area by counting houses in the vincinity.

// Above 9 houses within a radius of 50m is an okay approximation of urban area at first glance
// More means that we can see the number change in better resolution as we come into a town or leave it
// Testing 100m on Altis
// Around 20 means at edge of town or industrial area 40-55 most of Altis towns, around 65 means really dense urban area
// In Georgetown, Tanoa at 100m radius:
// 30 at edge to 55-60 around suburb and 75 at the most dense downtown.
// Small town gets 30+ at edge up to 65 in center.
// It all seems to depend on the town outline. 100m is quite a lot in all directions. 

// Count objects of type "house" within a set raidus
private _houseCount = count (nearestObjects [indiCam_actor, ["house"], 100]);
if (_houseCount >= 9) then {_urbanBool = true} else {_urbanBool = false};



/* ----------------------------------------------------------------------------------------------------
													altitude check												
   ---------------------------------------------------------------------------------------------------- */
// This just checks how far above ground or water the player is

private _altitude = 7; // this number determines how high is considered airborne or climbing tall buildings
if (_oceanBool) then {
	if ((getPosASL player select 2) > _altitude) then {_airborneBool = true} else {_airborneBool = false};
} else {
	if ((getPos player select 2) > _altitude) then {_airborneBool = true} else {_airborneBool = false};
};




/* ----------------------------------------------------------------------------------------------------
													return values
   ---------------------------------------------------------------------------------------------------- */
// Not sure if this is going to be a function or if it's gonna be running continuously yet.
// Could spawn different checks with different update timings
// Most likely I'll call this at the start of sceneSelect and/or in individual scenes

_return = 	[
				_oceanBool,
				_forestBool,
				_urbanBool,
				_airborneBool
			];

_return;
