//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: woofer
//////////////////////////////////////////////////////////////////

// Info here: https://community.bistudio.com/wiki/createDiaryRecord
// This is how BI does it in MP missions https://forums.bistudio.com/forums/topic/163884-briefing-and-creatediaryrecord/?do=findComment&comment=2565014


_index = player createDiarySubject ["indiCam","indiCam"];



funcProcessDiaryLink = {
    processDiaryLink createDiaryLink ["indiCam", _this, ""];
};



indiCam_diaryHelp = player createDiaryRecord ["indiCam", ["General help", 
    "
	</br>
	The core usage for indiCam is to record your own gameplay from another computer. But nothing stops you from using your gaming computer from running the camera. The caveat being that while the camera is running, you lose control of your character. So no extra server slots are actually needed to use the script. It's just that whoever is looking through their camera can't be an acive player in the regular way.</br>
	</br>
	The idea for the script is for it to be local to the user. That means that anyone can access his camera at any time independently, whatever other people on the server are doing.</br>
	</br>
	Any extra slots used would be taken up by these extra computers running separate copies of Arma.</br>
	Take me for example:</br>
	I have an extra computer lying around. I also have an extra steam account for which I bought Arma 3.  So I start Arma on that computer, join the same server that I am playing on with my main gaming computer and start the camera.</br>
	Let's call that extra computer the cameraman.</br>
	</br>
	Now in the game I can use the scroll wheel menu with the cameraman to select actor on map.</br>
	The map then opens up and shows markers for all units on the map, BLUFOR, OPFOR, INDEPENDENT and CIV.</br>
	I then click close to one of the markers (within 100m). The closest unit to that point will be the designated actor.</br>
	The map closes automatically so that I can use the scroll wheel menu again to run indiCam.</br>
	</br>
	The camera is now running and is waiting for keypresses.</br>
	- F1 Stop script</br>
	- F2 forces next scene</br>
	- F3 toggles manual camera on/off (camera control is seagull controls in settings)</br>
	- L-key disables focal crosshair</br>
	- F5 for previous vision mode</br>
	- F6 for next vision mode</br>
	</br>
	While the camera is running it will take different things into account.</br>
	- Type of vehicle used by the actor or if he is on foot</br>
	- Elevation when in an aircraft</br>
	- If the eyes of the actor becomes obscured for too long it will switch camera angle</br>
	- If the actor gets too far away from the camera, it will switch camera angle</br>
	- Script pre-checks each angle to see if the camera has line of sight before it tries to switch</br>
	- If it's later than a set amount of time, it will automatically go to night vision</br>
	- If the actor is shooting and on foot, the types of camera angles will adapt to higher level of action and go back to calmer stuff once the action dies down.</br>
	- The script can be plopped into a mission, negating the need for mods</br>
	"
]];



indiCam_diaryControls = player createDiaryRecord ["indiCam", ["Controls", 
    "
	<br/>
	<execute expression='[] execVM ""woof_fnc_indiCam.sqf"";'>Initialize addon</execute><br/>
	<br/>
	<execute expression='runIndiCam = true;'>run camera</execute><br/>
	<br/>
	<execute expression='[] spawn woof_fnc_mapSelect;'>select actor on map</execute><br/>
	<br/>
	<execute expression='actor = player;'>set current player as actor</execute><br/>
	<br/>
	<br/>
	This is going to be some help as related to indiCam.<br/>
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
