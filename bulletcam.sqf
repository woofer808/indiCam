/*
Bullet Camera Script: bulletcam.sqf

Created By: Big Dawg KS 2/14/2011 ARMA 2 v 1.2
Updated By: Cobra4v320 4/5/2013 ARMA 3 v 1.3

Description:
Shows the path of the bullet in slowmotion until it hits a target or another object.

Parameter(s):
* To exit the camera ingame (while in flight), press the key for ironsights/optics (zero on numberpad)
* To add supported weapons, add MUZZLE classnames to _list (note: classnames are CASE SENSITIVE)
* To disable bullet cam, set BDKS_DisableBulletCam = true
* To disable blur effects, set BDKS_BulletCamNoBlur = true
* To disable particle effects, set BDKS_BulletCamNoParticleFX = true
* To change FOV (zoom), change the value of BDKS_BulletCamFOV (default 0.05). Ex: BDKS_BulletCamFOV = 0.3
* To change time acceleration, change the value of BDKS_BulletCamAccTime (default 0.5). Ex: BDKS_BulletCamAccTime = 0.2 (Note: AccTime only works in Singleplayer)
* To make another unit's (other than local player) bullet cam show for the local player, set unit variable BDKS_ShowBulletCamToPlayer = true, ex: if(local Spotter)then{Sniper setVariable ["BDKS_ShowBulletCamToPlayer",true]}

Example(s):
player addEventHandler ["fired",{_this call compile preprocessFileLineNumbers "bulletCam.sqf"}]
*/
if ((cursorTarget distance player) < 100 || (player findNearestEnemy position player) distance player < 100) exitWith {};

_projectile = nearestObject [_this select 0,_this select 4];

if (count _this >= 7) then {_projectile = _this select 6};

if (call {if (isNil "BDKS_DisableBulletCam") then {true} else {!BDKS_DisableBulletCam}}) then {

if ((_this select 0) == vehicle player || call {if (isNil {(_this select 0) getVariable "BDKS_ShowBulletCamToPlayer"}) then {false} else {(_this select 0) getVariable "BDKS_ShowBulletCamToPlayer"}})then {

	// Add more weapons here
	_list = ["Rocket_04_HE_Plane_CAS_01_F","Rocket_04_AP_Plane_CAS_01_F","Missile_AA_04_Plane_CAS_01_F","Bomb_04_Plane_CAS_01_F","Missile_AGM_02_Plane_CAS_01_F ","srifle_EBR_F","arifle_MXM_F","launch_NLAW_F","launch_RPG32_F","GL_3GL_F","EGLM","mortar_82mm"];

	_type = getText (configFile >> "CfgAmmo" >> (_this select 4) >> "simulation");
	_relPos = [0,-13,0.05];
	_fov = 0.05;
	_accTime = 0.5;

	if (!isNil "BDKS_BulletCamFOV") then {_fov = BDKS_BulletCamFOV};
	if (_type == "shotMissile" || _type == "shotRocket") then {_relPos = [0,-13,5.2]; _fov = 0.5; _accTime = 0.3};
	if (_type == "shotShell") then {_relPos = [0,-10,7.2]; _fov = 0.3; _accTime = 0.9};

	_disablePP = false;
	if (call {if (isNil "BDKS_BulletCamNoBlur")then{false} else {BDKS_DisableBulletCam}}) then {_disablePP = true};

	if (!isNil "BDKS_BulletCamAccTime") then {_accTime = BDKS_BulletCamAccTime};

	_enableParticles = true;
	if (call {if(isNil "BDKS_BulletCamNoParticleFX")then{false}else{BDKS_BulletCamNoParticleFX}}) then {_enableParticles = false};

	if ((_this select 2) in _list && !(isNull _projectile)) then {
		setAccTime _accTime;
		_camera = "camera" camCreate (getPos _projectile);
		_camera cameraEffect ["INTERNAL","BACK"];
		showCinemaBorder false;
		cutText ["","BLACK IN",0.2];
		_pSource = objNull;

		if (_enableParticles && _type == "ShotBullet") then { 
			_pShape = ["\a3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 13, 3, 0];
			_pSize = [0.01,0.05];
			_pColor = [[1,1,1,0.08],[1,1,1,0.16],[1,1,1,0.03],[1,1,1,0]];

			_pSource = "#particlesource" createVehicleLocal (getPos _projectile);
			_pSource attachTo [_projectile,[0,0,0]];
			_pSource setParticleParams [_pShape,"","Billboard",1,0.3,[0,0,0],[0,0,0],0,1,0.79,0.18,_pSize,_pColor,[1000],100,0.01,"","",_projectile,360];
			_pSource setDropInterval 0.001;
		};

		[_projectile,_camera,_relPos,_fov,_pSource,_disablePP] spawn {

			_projectile = _this select 0;
			_camera = _this select 1;
			_relPos = _this select 2;
			_fov = _this select 3;
			_pSource = _this select 4;
			_disablePP = _this select 5;

			_cancel = false;

			while {alive _projectile && alive _camera && !_cancel} do {
				_camera camSetTarget _projectile;
				_camera camSetRelPos _relPos;
				_camera camSetFOV _fov;
				_camera camSetFocus [600,2];
				_camera camCommit 0;

				"RadialBlur" ppEffectAdjust [0.02,0.02,0.1,0.1];
				"RadialBlur" ppEffectCommit 0.01;

				if (!_disablePP) then {"RadialBlur" ppEffectEnable true};
				if (inputAction "optics" != 0) then {_cancel = true};

				sleep 0.001;
			};

			if (alive _camera && !_cancel) then {
				_camera camSetFocus [-(_relPos select 1),1];
				_camera camSetFOV (_fov * 1.6);
				_camera camCommit 1.5;

				"RadialBlur" ppEffectAdjust [0,0,1,1];
				"RadialBlur" ppEffectCommit 0.7;

				sleep 1.39;
			};

			cutText ["","BLACK OUT",0.1];
			sleep 0.11;
			setAccTime 1;
			"RadialBlur" ppEffectEnable false;
			_camera cameraEffect ["TERMINATE","BACK"];
			camDestroy _camera;
			if (!isNull _pSource) then {deleteVehicle _pSource};

			cutText ["","BLACK IN",0.6];
		};
	};
};
};