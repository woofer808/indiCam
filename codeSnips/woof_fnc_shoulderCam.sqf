logicTarget = createVehicle ["Sign_Sphere25cm_F", getpos actor, [], 0, "CAN_COLLIDE"];

shoulderCam = "camera" camCreate (getPos actor);
shoulderCam cameraEffect ["internal","back"];
shoulderCam camSetTarget logicTarget;
camUseNVG false;
showCinemaBorder false;
shoulderCam camCommand "inertia on";


shoulderCam attachTo [actor, [0.1, 0.1, 0.07], "RightHand"];
shoulderCam camSetFov 1;
shoulderCam camCommit 0;



onEachFrame {
	_startPoint = actor modeltoworld [0.3,0.6,1.42];
	_weaponDirection = actor weaponDirection currentWeapon actor;
	_weaponVector = _weaponDirection vectorMultiply 10;
	_weaponVectorEndPos = _startpoint vectorAdd _weaponVector;
	logicTarget setpos _weaponVectorEndPos;
};


RightHandMiddle1
righthand








logic = createVehicle ["Sign_Sphere10cm_F", getpos player, [], 0, "CAN_COLLIDE"];
logic2 = createVehicle ["Sign_Sphere10cm_F", getpos player, [], 0, "CAN_COLLIDE"];
logic3 = createVehicle ["Sign_Sphere10cm_F", getpos player, [], 0, "CAN_COLLIDE"];
logic4 = createVehicle ["Sign_Sphere10cm_F", getpos player, [], 0, "CAN_COLLIDE"];
logic5 = createVehicle ["Sign_Sphere10cm_F", getpos player, [], 0, "CAN_COLLIDE"];

onEachFrame {
_weaponHandPos = player modelToWorld (player selectionPosition ["RightHandMiddle1", "memory"]);
_weaponDirection = vectorNormalized (player weaponDirection currentWeapon player);


_weaponDirectionUp = vectorNormalized [(_weaponDirection select 0)+0.01,(_weaponDirection select 1)+0.01,(_weaponDirection select 2)+0.99];

_weaponVector = _weaponDirection vectorMultiply 1;
_weaponVectorEndPos = _weaponHandPos vectorAdd _weaponVector;

_weaponVectorUp = _weaponDirectionUp vectorMultiply 1;
_weaponVectorUpEndPos = _weaponHandPos vectorAdd _weaponVectorUp;

_weaponNormal = _weaponDirection vectorCrossProduct _weaponDirectionUp;
_weaponVectorNormal = _weaponNormal vectorMultiply 1;
_weaponVectorNormalEndPos = _weaponHandPos vectorAdd _weaponVectorNormal;


_weaponNormalFinal = _weaponNormal vectorCrossProduct _weaponDirection;
_weaponVectorNormalFinal = _weaponNormalFinal vectorMultiply 1;
_weaponVectorNormalEndPosFinal = _weaponHandPos vectorAdd _weaponVectorNormalFinal;



hint str _weaponDirectionUp;

logic setPos _weaponHandPos;
logic2 setpos _weaponVectorEndPos;
logic3 setpos _weaponVectorUpEndPos;
logic4 setpos _weaponVectorNormalEndPos;
drawLine3D [_weaponHandPos,_weaponVectorEndPos, [1,1,0,1]];
drawLine3D [_weaponHandPos,_weaponVectorUpEndPos, [1,0,1,1]];
drawLine3D [_weaponHandPos,_weaponVectorNormalEndPos, [1,0,0,1]];

logic5 setpos _weaponVectorNormalEndPosFinal;
drawLine3D [_weaponHandPos,_weaponVectorNormalEndPosFinal, [1,0,0,1]];

};




















