/*

This script is executed remotely by the indiCam machine to a client machine 
It has a mother script named indiCam_fnc_indiCamEHToClient

*/

private _newActor		= _this select 0;
private _clientOwnerID	= _this select 1;
private _indiCamOwnerID = _this select 2;
private _indiCamUID 	= _this select 3; // No UID in singleplayer - renders as "_SP_PLAYER_"



// Set up eventhandlers on this client based on the indicam machine that triggered this script


call compile format ["

_newActor = indiCam_var_network_%1_%2 select 0;

systemchat 'Assigning eventhandlers locally';

private _ehGetInMan = _newActor addEventHandler ['GetInMan',
	{
		[] remoteExec ['indiCam_fnc_EHGetInMan', %2, false];
	}
];

private _ehGetOutMan = _newActor addEventHandler ['GetOutMan',
	{
		[] remoteExec ['indiCam_fnc_EHGetOutMan', %2, false];
	}
];

private _ehFired = _newActor addEventHandler ['Fired',
	{
		[123456] remoteExec ['indiCam_fnc_EHFired', %2, false];
	}
];

private _ehDeleted = _newActor addEventHandler ['Deleted',
	{
		[] remoteExec ['indiCam_fnc_EHDeleted', %2, false];
	}
];

private _ehKilled = _newActor addEventHandler ['Killed',
	{
		[] remoteExec ['indiCam_fnc_EHKilled', %2, false];
	}
];


private _ehArray = 	[
	[%1, 'GetInMan', _ehGetInMan],
	[%1, 'GetOutMan', _ehGetOutMan],
	[%1, 'Fired', _ehFired],
	[%1, 'Deleted', _ehDeleted],
	[%1, 'Killed', _ehKilled]
];

comment 'Send the data back';
[_newActor, _clientOwnerID, _indiCamOwnerID, _indiCamUID, _ehArray] remoteExec ['indiCam_fnc_clientEHToIndiCam', _indiCamOwnerID, false];

", _clientOwnerID, _indiCamOwnerID];

