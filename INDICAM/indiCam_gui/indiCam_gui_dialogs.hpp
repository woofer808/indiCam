
#define indiCam_id_guiDialogMain 808
#define indiCam_id_guiDebugCheckbox 818
#define indiCam_id_guiMapDisplay 809
#define indiCam_id_guiMapSetActor 810
#define indiCam_id_guiPlayerList 812
#define indiCam_id_guiPlayerListButton 813
#define indiCam_id_guiActorDisplay 814
#define indiCam_id_guiStartButton 815
#define indiCam_id_guiStopButton 816
#define indiCam_id_guiVisionModeDropdown 817
#define indiCam_id_guiDebugText 819
#define indiCam_id_guiSceneOverrideText 821
#define indiCam_id_guiSceneOverrideSlider 822
#define indiCam_id_guiSceneOverrideCheckbox 823
#define indiCam_id_guiMapSideDropdown 824
#define indiCam_id_guiSceneHold 826
#define indiCam_id_guiActorAutoswitchDropdown 820
#define indiCam_id_guiActorAutoswitchCheckbox 825
#define indiCam_id_guiActorAutoswitchSliderText 828
#define indiCam_id_guiActorAutoswitchSlider 827
#define indiCam_id_guiScriptedScenes 829
#define indiCam_id_guiScriptedSceneSlider 830
#define indiCam_id_guiScriptedSceneText 831


// Text size
#define TEXT_SIZE_LARGE (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)
#define TEXT_SIZE_MEDIUM (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)
#define TEXT_SIZE_SMALL (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.6)

class indiCam_gui_dialogMain {
	idd = indiCam_id_guiDialogMain;
	movingenable = false;
	onload = "[] execVM 'indicam\indiCam_gui\indiCam_gui_dialogControl.sqf'";
	onUnload = "";
	
	class controls {
	
		////////////////// Background //////////////////
		
		class indiCam_gui_backgroundMain: indiCam_RscPicture {
			idc = -1;
			text = "#(argb,8,8,3)color(0,0,0,1)";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.5 * safezoneH;
		};
		
		
		

		////////////////// Actor display //////////////////
	
		class indiCam_gui_displayActor: indiCam_RscText {
			idc = indiCam_id_guiActorDisplay;
			text = "current actor";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.23 * safezoneH + safezoneY;
			w = 0.4 * safezoneW;
			h = 0.04 * safezoneH;
			font = "PuristaMedium";
			SizeEx = TEXT_SIZE_LARGE;
			tooltip = "Shows what the current actor is set to";
		};


	
		////////////////// Map controls //////////////////
		
		class indiCam_gui_mapDisplay: indiCam_RscMapControl {
			idc = indiCam_id_guiMapDisplay;
			maxSatelliteAlpha = 0;
			onMouseZChanged = "";
			onMouseButtonDown = "";
			onMouseButtonClick = ""; // This is where we put the closest-actor-search-function (stolen as _this execvm 'mark.sqf')
			x = 0.515469 * safezoneW + safezoneX;
			y = 0.28 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.319 * safezoneH;
		};

		class indiCam_gui_textMapSide: indiCam_RscText {
			idc = -1;
			text = "show side";
			x = 0.57 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			w = 0.058 * safezoneW;
			h = 0.02 * safezoneH;
		};

		class indiCam_gui_setMapSide: indiCam_RscCombo {
			idc = indiCam_id_guiMapSideDropdown;
			text = "Side";
			x = 0.63 * safezoneW + safezoneX;
			y = 0.611 * safezoneH + safezoneY;
			tooltip = "Select side to show on map";
			onLBSelChanged = "[] spawn indiCam_fnc_guiSetMapSide";
		};

		/*
		class indiCam_gui_setActorMap: indiCam_RscButton {
			idc = 1600;
			text = "Set map";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			tooltip = "Set the map selected unit as actor";
			action = "";
		};
		*/

		
		
		
		////////////////// Player selection //////////////////
		
		class indiCam_gui_listActorPlayer: indiCam_RscListbox {
			idc = indiCam_id_guiPlayerList;
			x = 0.45 * safezoneW + safezoneX;
			y = 0.28 * safezoneH + safezoneY;
			w = 0.062 * safezoneW;
			h = 0.319 * safezoneH;
			onLBSelChanged = "[] call indiCam_fnc_guiPlayerList";
		};

		class indiCam_gui_buttonActorPlayer: indiCam_RscButton {
			idc = -1;
			text = "Set as actor";
			x = 0.45 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			tooltip = "Set the selected player as actor";
			action = "[] call indiCam_fnc_guiPlayerListButton";
		};


		
		
		
		
		////////////////// Debug mode //////////////////
		
		class indiCam_gui_guiDebugCheckbox: indiCam_RscCheckbox {
			idc = indiCam_id_guiDebugCheckbox;
			text = "Debug mode";
			x = 0.42 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			tooltip = "Turn debug mode on or off";
			onCheckedChanged = "[] call indiCam_fnc_guiDebug";
			
		};
		
		class indiCam_gui_textDebug: indiCam_RscText {
			idc = -1;
			text = "debug mode";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.65 * safezoneH + safezoneY;
			w = 0.045 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Turn debug mode on or off";
		};

		
		
		
		
		////////////////// Actor auto switch //////////////////
		
		class indiCam_gui_CheckboxRandomizeActorCheckbox: indiCam_RscCheckbox {
			idc = indiCam_id_guiActorAutoswitchCheckbox;
			text = "auto switch actor";
			x = 0.42 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			tooltip = "Enable or disable automatic actor switching.";
			onCheckedChanged = "[] call indiCam_fnc_guiCheckboxActorAutoswitch";
		};
		
		class indiCam_gui_textRandomizeActorCheckbox: indiCam_RscText {
			idc = -1;
			text = "auto switch actor";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Enable or disable automatic actor switching.";
		};

		class indiCam_gui_textRandomizeActor: indiCam_RscText {
			idc = -1;
			text = "randomization";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Select actor randomization method";
		};

		class indiCam_gui_comboRandomizeActor: indiCam_RscCombo {
			idc = indiCam_id_guiActorAutoswitchDropdown;
			text = "switch method";
			x = 0.37 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			tooltip = "Select actor randomization method";
			onLBSelChanged = "[] call indiCam_fnc_guiDropdownActorAutoswitch";
		};
		
		class indiCam_gui_randomizeActorTimeSliderText: indiCam_RscText {
			idc = indiCam_id_guiActorAutoswitchSliderText;
			text = "set duration";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.58 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Sets duration between automatic actor switch.";
		};
		
		class indiCam_gui_randomizeActorTimeSlider: indiCam_RscSlider {
			idc = indiCam_id_guiActorAutoswitchSlider;
			text = "switching time";
			x = 0.31 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Sets duration between automatic actor switch.";
			onSliderPosChanged = "[] call indiCam_fnc_actorAutoSwitchTimeSlider";
		};
		
		
		
		
		/*
		////////////////// Interjection scenes //////////////////
		
		class indiCam_gui_CheckboxRandomizeActorCheckbox: indiCam_RscCheckbox {
			idc = indiCam_id_guiActorAutoswitchCheckbox;
			text = "special scenes";
			x = 0.42 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			tooltip = "Randomize actor";
			onCheckedChanged = "";
		};
		
		class indiCam_gui_textRandomizeActorCheckbox: indiCam_RscText {
			idc = -1;
			text = "special scenes";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Randomize between";
		};

		class indiCam_gui_textRandomizeActor: indiCam_RscText {
			idc = -1;
			text = "chance of special scenes";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Randomize between";
		};
		
		class indiCam_gui_comboRandomizeActor: indiCam_RscCombo {
			idc = indiCam_id_guiActorAutoswitchDropdown;
			text = "chance of special scenes";
			x = 0.37 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			tooltip = "Select randomization method";
			onLBSelChanged = "";
		};
		
		
		class indiCam_gui_sliderRandomizeActor: indiCam_RscSlider {
			idc = indiCam_id_guiSceneOverrideSlider;
			text = "randomization time";
			x = 0.31 * safezoneW + safezoneX;
			y = 0.48 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Set duration between automatic actor switching";
			onSliderPosChanged = "";
		};
		
		*/
		
		
		
		////////////////// Vision mode //////////////////
		
		class indiCam_gui_textVisionMode: indiCam_RscText {
			idc = -1;
			text = "vision mode";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.281 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Choose vision mode";
		};

		class indiCam_gui_visionModeSelect: indiCam_RscCombo {
			idc = indiCam_id_guiVisionModeDropdown;
			text = "vision mode";
			x = 0.37 * safezoneW + safezoneX;
			y = 0.28 * safezoneH + safezoneY;
			tooltip = "Select vision mode";
			onLBSelChanged = "[] call indiCam_fnc_guiVisionMode";
		};

		
		
		
		////////////////// Scene hold //////////////////
		
		class indiCam_gui_checkBoxSceneHoldText: indiCam_RscText {
			idc = -1;
			text = "disable scene switching";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.385 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Prevent automatic scene switching.";
		};		
		
		class indiCam_gui_checkBoxSceneHold: indiCam_RscCheckbox {
			idc = indiCam_id_guiSceneHold;
			text = "disable scene switching";
			x = 0.42 * safezoneW + safezoneX;
			y = 0.38 * safezoneH + safezoneY;
			tooltip = "Prevent automatic scene switching.";
			onCheckedChanged = "[] call indiCam_fnc_guiSceneHold";
		};
		
		
		////////////////// Capture scripted scenes //////////////////
		/*
		class indiCam_gui_checkBoxScriptedScenesText: indiCam_RscText {
			idc = -1;
			text = "capture cinematics";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.345 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Attempt to capture scripted cinematics if detected.";
		};		
		
		class indiCam_gui_checkBoxScriptedScenes: indiCam_RscCheckbox {
			idc = indiCam_id_guiScriptedScenes;
			text = "capture cinematics";
			x = 0.42 * safezoneW + safezoneX;
			y = 0.34 * safezoneH + safezoneY;
			tooltip = "Attempt to capture scripted cinematics if detected.";
			onCheckedChanged = "[] call indiCam_fnc_scriptedScenes";
		};
		*/

		class indiCam_gui_ScriptedSceneText: indiCam_RscText {
			idc = indiCam_id_guiScriptedSceneText;
			text = "Chance: ";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.32 * safezoneH + safezoneY;
			w = 0.14 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Set chance percentage value for cinematics top happen. Lower means less chance of happening. Zero is off.";
		};
		
		class indiCam_gui_ScriptedSceneSlider: indiCam_RscSlider {
			idc = indiCam_id_guiScriptedSceneSlider;
			text = "override time";
			x = 0.31 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Set chance percentage value for cinematics top happen. Lower means less chance of happening. Zero is off.";
			onSliderPosChanged = "[] call indiCam_fnc_scriptedSceneChanceSlider";
		};

		
		
		
		
		////////////////// Scene override timer //////////////////
		
		class indiCam_gui_textTimerOverrideCheckbox: indiCam_RscText {
			idc = -1;
			text = "override scene duration";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.425 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Override pre-defined duration of scenes with a fixed duration.";
		};		
		
		class indiCam_gui_checkBoxOverrideTimer: indiCam_RscCheckbox {
			idc = indiCam_id_guiSceneOverrideCheckbox;
			text = "override timer";
			x = 0.42 * safezoneW + safezoneX;
			y = 0.42 * safezoneH + safezoneY;
			tooltip = "Override pre-defined duration of scenes with a fixed duration.";
			onCheckedChanged = "[] call indiCam_fnc_guiSceneOverride";
		};
		
		class indiCam_gui_textTimerOverride: indiCam_RscText {
			idc = indiCam_id_guiSceneOverrideText;
			text = "fixed duration: 10 seconds";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Override pre-defined duration of scenes with a fixed duration.";
		};
		
		class indiCam_gui_overrideTimeSlider: indiCam_RscSlider {
			idc = indiCam_id_guiSceneOverrideSlider;
			text = "override time";
			x = 0.31 * safezoneW + safezoneX;
			y = 0.48 * safezoneH + safezoneY;
			w = 0.12 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Override pre-defined duration of scenes with a fixed duration.";
			onSliderPosChanged = "[] call indiCam_fnc_guiSceneOverride";
		};
		
		
		
		
		
		
		
		////////////////// Main dialog controls //////////////////
		
		class indiCam_gui_buttonCameraStart: indiCam_RscButton {
			idc = -1;
			text = "start";
			x = 0.30 * safezoneW + safezoneX;
			y = 0.69 * safezoneH + safezoneY;
			tooltip = "";
			action = "[] call indiCam_fnc_guiStart"; // Needs to start everything that has been set in gui such as actor randomization
		};
		
		class indiCam_gui_buttonCameraStop: indiCam_RscButton {
			idc = -1;
			text = "stop";
			x = 0.37 * safezoneW + safezoneX;
			y = 0.69 * safezoneH + safezoneY;
			tooltip = "";
			action = "indiCam_var_requestMode = ""off"""
		};
		
		class indiCam_gui_buttonNextScene: indiCam_RscButton {
			idc = -1;
			text = "next scene";
			x = 0.44 * safezoneW + safezoneX;
			y = 0.69 * safezoneH + safezoneY;
			tooltip = "";
			action = "indiCam_var_requestMode = ""default""";
		};

		class indiCam_gui_buttonManualCamera: indiCam_RscButton {
			idc = -1;
			text = "manual camera";
			x = 0.51 * safezoneW + safezoneX;
			y = 0.69 * safezoneH + safezoneY;
			tooltip = "Engage manual mode. Press L-key to remove crosshair box.";
			action = "[] call indiCam_fnc_guiManualMode"
		};
		
		class indiCam_gui_closeDialog: indiCam_RscButton {
			idc = -1;
			text = "close";
			x = 0.64 * safezoneW + safezoneX;
			y = 0.69 * safezoneH + safezoneY;
			tooltip = "";
			action = "[] call indiCam_fnc_guiClose";
		};
		
		
		
		
		////////////////// script info //////////////////
		
		class indiCam_gui_scriptInfo: indiCam_RscText {
			idc = indiCam_id_guiActorDisplay;
			text = "indiCam 1.32 by woofer";
			x = 0.575 * safezoneW + safezoneX;
			y = 0.7 * safezoneH + safezoneY;
			w = 0.065 * safezoneW;
			h = 0.02 * safezoneH;
			SizeEx = TEXT_SIZE_SMALL;
			tooltip = "";
		};
		

	}; // Close controls
	
}; // Close dialog main