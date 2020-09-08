
/* Ripppe's debug


RAP_fnc_debugLog = {
    params ["_message", ["_arguments", []]];
    if (RAP_DEBUG_ON) then {
        private _formattedMsg = if ([_arguments] call RAP_fnc_isEmptyArray) then {
            _message;
        } else {
            private _messageArr = [_message];
            _messageArr append _arguments;
            format _messageArr;
        };
        _formattedMsg = ["DEBUG",  _formattedMsg] joinString " --- ";

        if (isMultiplayer) then {
        _formattedMsg remoteExec ["systemChat", 0, true];
        } else {
            systemChat _formattedMsg;
        };
    };
};


RipppeToday at 2:31 PM
@woofer here are the two example use cases for my debug logging:

["Create new patrol group at %1 from composition %2", [_location, _composition]] call RAP_fnc_debugLog;
If you want to format (inject params) to your debug message use this

["Initializing new patrol"] call RAP_fnc_debugLog;

*/



// So what do we want it to do?
// I want a simple as frig just debug thing
// Every function should contain a local variable with it's name
// Maybe pass code to this file?

// I will probably want to externally force information put into screen and into log.


// ["message string",_toScreenBool,_toLogBool] call indiCam_fnc_debug;

private _message = 	_this select 0;
private _toScreen = _this select 1;
private _toLog = 	_this select 2;


// Put together the information needed for the report.



if (indiCam_debug && _toScreen) then {systemchat format [_message]};
if (_toLog) then {diag_log format [_message]};
