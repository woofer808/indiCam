/*
 * Author: woofer
 * Finds an ASL point in space that has a line of sight onto two objects.
 *
 * Arguments:
 * 0: UnitA <OBJECT>
 * 1: UnitB <OBJECT>
 * 2: Start <ASL POS>
 *
 * Reutrn Value:
 * Visible <BOOL>
 *
 * Example:
 * [player, otherUnit, [100,100,10]] call indiCam_fnc_twopointLOS
 *
 * Public: No
 */

// ~0.12 ms

params [ 			// Vars passed to this function
		"_unitA",	// Pos ASL or object
		"_unitB",	// Pos ASL or object
		"_startPos"	// Pos ASL (assumes between the two points if no param given)
		];

private _ASLvisible = false;
private _AGLvisible = false;
private _posOne = [];
private _posTwo = [];
private _testPos = [];
private _distance = ( (_unitA distance2D _unitB) * 0.5 );
private _return = false;
private _returnTest = false;

// Check type of inputs and adjust for errors
if ( (typeName _unitA) == "OBJECT" ) then {_posOne = getPosASL _unitA} else {systemChat "indiCam_fnc_twopointLOS param 0 needs to be object"};
if ( (typeName _unitB) == "OBJECT" ) then {_posTwo = getPosASL _unitB} else {systemChat "indiCam_fnc_twopointLOS param 1 needs to be object"};


if ( (typeName _startPos) == "ARRAY" ) then {
	// All is fine, do nothing for now
} else { // Didn't get a vector (or got nothing) in the third param, assume midpoint
	_vector = _posTwo vectordiff _posOne; // Get vector between the two units with a length of their mutual distance from each other
	_vector = _vector vectorMultiply 0.5; // Make the vector half its length
	_startPos = _posOne vectorAdd _vector; // Put the vector on the position of the first unit to get a midpoint
};




// Start condition is now _posOne, _posTwo and _startPos.
// Move the midpoint around within a sphere with a radius of half the distance between the two points.
// Do that until a point is found that has line of sight to both or too many tries have been done.

private _iteration = 0;
while {
		(!_returnTest) &&		// Try as long as _return value is false -AND-
		(_iteration < 100)	// This is how many tries we allow before giving up and simply returning false
} do {
	_iteration = _iteration + 1; // Count up one on the iteration
	
	
	// Find out what our position delta interval is. Should be related to the distance between _unitA and _unitB
	
	
	// Make a position to test that isn't too far from the original _startPoint
	_deltaX = random [-_distance,0,_distance];
	_deltaY = random [-_distance,0,_distance];
	_deltaZ = random [1,_distance,_distance * 2];
	_testPos = _startPos vectorAdd [_deltaX,_deltaY,_deltaZ];
	
	// Assume ASL and do the line intersect checks accordingly
	_losOne = lineIntersectsSurfaces [_testPos, _posOne, (vehicle _unitA), (vehicle _unitB)];
	_losTwo = lineIntersectsSurfaces [_testPos, _posTwo, (vehicle _unitA), (vehicle _unitB)];
	
	// If none of the two intersect checks found anything, return the position in ASL
	if ( (count _losOne == 0) && (count _losTwo == 0) ) then {
		_return = _startPos; // Return position if both positions are visible from the startPoint
		_returnTest = true;
	} else {
		_return = false; // Return false if either of the two positions is hidden from startPoint
	};

};
_return;
