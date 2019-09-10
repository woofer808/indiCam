comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "											   diary entries											";
comment "																										";
comment "																										";
comment "	Contains all the diary entries with information and script execution for indiCam					";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
// Info here: https://community.bistudio.com/wiki/createDiaryRecord
// This is how BI does it in MP missions https://forums.bistudio.com/forums/topic/163884-briefing-and-creatediaryrecord/?do=findComment&comment=2565014


_index = player createDiarySubject ["indiCam","indiCam"];



funcProcessDiaryLink = {
    processDiaryLink createDiaryLink ["indiCam", _this, ""];
};



indiCam_diaryControls = player createDiaryRecord ["indiCam", ["Controls", 
    "
	<br/>
	<execute expression='[] execVM ""INDICAM\indiCam_main.sqf"";'>start camera</execute><br/>
	<br/>
	<execute expression='[] spawn indiCam_fnc_mapSelectFriendly;'>set friendly actor on map</execute><br/>
	<br/>
	<execute expression='[] spawn indiCam_fnc_mapSelectAll;'>set ANY actor on map</execute><br/>
	<br/>
	<br/>
	Keypresses for when indiCam is running.<br/>
	<br/>
	Keypress F1 - Stop camera<br/>
	Keypress F2 - Force next scene<br/>
	Keypress F3 - Toggle manual camera control on/off<br/>
	Keypress L - Toggle camera crosshair on/off<br/>
	<br/>
	Keypress F5 - Previous view mode<br/>
	Keypress F6 - Next view mode<br/>
	<br/>
	"
]];

indiCam_diaryHelp = player createDiaryRecord ["indiCam", ["General help", 
    "
	<br/>
	The core idea for indiCam is to use a separate computer to record secondary gameplay footage around a player on a multiplayer server without the need to manually move the camera around.</br>
	<br/>
	<br/>
	It stems from me wanting a secondary perspective to mix with my regular first-person footage in a video editor. <br/>
	<br/>
	So it turns the game into an automatic camera robot. Once it has been started, it will follow a unit around while automatically switching between camera angles depending on situation and visibility of the target unit. The target unit can be a player or AI as well as any faction. Any player with access to the script can use it, as long as the user is logged into the correct server or single player scenario.</br>
	<br/>
	<br/>
	The camera will completely take up the screen and the computer running it will not be able to participate in regular gameplay.</br>
	<br/>
	<br/>
	indiCam is short for independent camera. It needs to run independently on a separate computer that has Arma installed and cannot be use.</br>
	<br/>
	<br/>
	Possible usage:</br>
	- Observe another player on a multiplayer server.</br>
	- Observe an AI on a multiplayer server.</br>
	- Observe an AI in a single player game.</br>
	<br/>
	<br/>
	<br/>
	love<br/>
	woofer<br/>
	"
]];


