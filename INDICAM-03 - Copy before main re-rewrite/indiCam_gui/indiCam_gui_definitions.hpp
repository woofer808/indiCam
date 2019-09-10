// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_CHECKBOX			77
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C
#define ST_GROUP_BOX       96
#define ST_GROUP_BOX2      112
#define ST_ROUNDED_CORNER  ST_GROUP_BOX + ST_CENTER
#define ST_ROUNDED_CORNER2 ST_GROUP_BOX2 + ST_CENTER

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4


// Colors
#define COLOR_DARK {0.1,0.1,0.1,1}
#define COLOR_MEDIUM {0.2,0.2,0.2,1}
#define COLOR_LIGHT {0.95,0.95,0.95,1}
#define COLOR_ACCENT {1,1,0,1}

#define COLOR_BUTTON {0.3,0.3,0.3,1}
#define COLOR_BUTTON_MOUSEOVER {0.3,0.3,0.3,1}
#define COLOR_BUTTON_SHADOW {0.7,0.7,0.7,1}

#define COLOR_TEXT_BACKGROUND {0.3,0.3,0.3,0}

// Text
#define TEXT_FONT "PuristaLight"
#define TEXT_SIZE_LARGE (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 2)
#define TEXT_SIZE_MEDIUM (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)
#define TEXT_SIZE_SMALL (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.6)



////////////////////////// MAP CONTROL /////////////////////////////////////
class indiCam_RscMapControl 
{
	access = 0;
	type = CT_MAP_MAIN;
	idc = 51;
	style = 48;
	colorBackground[] = {0.969,0.957,0.949,1};
	colorOutside[] = {0,0,0,1};
	colorText[] = {0,0,0,1};
	font = "TahomaB";
	sizeEx = 0.04;
	colorSea[] = {0.467,0.631,0.851,0.5};
	colorForest[] = {0.624,0.78,0.388,0.5};
	colorRocks[] = {0,0,0,0.3};
	colorCountlines[] = {0.572,0.354,0.188,0.25};
	colorMainCountlines[] = {0.572,0.354,0.188,0.5};
	colorCountlinesWater[] = {0.491,0.577,0.702,0.3};
	colorMainCountlinesWater[] = {0.491,0.577,0.702,0.6};
	colorForestBorder[] = {0,0,0,0};
	colorRocksBorder[] = {0,0,0,0};
	colorPowerLines[] = {0.1,0.1,0.1,1};
	colorRailWay[] = {0.8,0.2,0,1};
	widthRailWay = 1;
	colorNames[] = {0.1,0.1,0.1,0.9};
	colorInactive[] = {1,1,1,0.5};
	colorLevels[] = {0.286,0.177,0.094,0.5};
	colorTracks[] = {0.84,0.76,0.65,0.15};
	colorRoads[] = {0.7,0.7,0.7,1};
	colorMainRoads[] = {0.9,0.5,0.3,1};
	colorTracksFill[] = {0.84,0.76,0.65,1};
	colorRoadsFill[] = {1,1,1,1};
	colorMainRoadsFill[] = {1,0.6,0.4,1};
	colorGrid[] = {0.1,0.1,0.1,0.6};
	colorGridMap[] = {0.1,0.1,0.1,0.6};
	stickX[] = {0.2,{"Gamma",1,1.5}};
	stickY[] = {0.2,{"Gamma",1,1.5}};

	class LineMarker {lineWidthThin = 0.008;lineWidthThick = 0.014;	lineDistanceMin = 3e-005;lineLengthMin = 5;};
	class Legend {colorBackground[] = {1,1,1,0.5};color[] = {0,0,0,1};x = "SafeZoneX + (((safezoneW / safezoneH) min 1.2) / 40)";y = "SafeZoneY + safezoneH - 4.5*((((safezoneW/safezoneH) min 1.2) / 1.2) / 25)";w = "10*(((safezoneW / safezoneH) min 1.2) / 40)";h = "3.5*((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";font = "PuristaMedium";sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";};
	class ActiveMarker {color[] = {0.3,0.1,0.9,1};size = 50;};
	class Command {color[] = {1,1,1,1};icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";size = 18;importance = 1;coefMin = 1;coefMax = 1;};
	class Task {colorCreated[] = {1,1,1,1};colorCanceled[] = {0.7,0.7,0.7,1};colorDone[] = {0.7,1,0.3,1};colorFailed[] = {1,0.3,0.2,1};color[] = {"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])","(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])"};icon = "\A3\ui_f\data\map\mapcontrol\taskIcon_CA.paa";iconCreated = "\A3\ui_f\data\map\mapcontrol\taskIconCreated_CA.paa";iconCanceled = "\A3\ui_f\data\map\mapcontrol\taskIconCanceled_CA.paa";iconDone = "\A3\ui_f\data\map\mapcontrol\taskIconDone_CA.paa";iconFailed = "\A3\ui_f\data\map\mapcontrol\taskIconFailed_CA.paa";size = 27;importance = 1;coefMin = 1;coefMax = 1;};
	class CustomMark {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\custommark_ca.paa";size = 24;importance = 1;coefMin = 1;coefMax = 1;};
	class Tree {color[] = {0.45,0.64,0.33,0.4};icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";size = 12;importance = "0.9 * 16 * 0.05";coefMin = 0.25;coefMax = 4;};
	class SmallTree {color[] = {0.45,0.64,0.33,0.4};icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";size = 12;importance = "0.6 * 12 * 0.05";coefMin = 0.25;coefMax = 4;};
	class Bush {color[] = {0.45,0.64,0.33,0.4};icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";size = "14/2";importance = "0.2 * 14 * 0.05 * 0.05";coefMin = 0.25;coefMax = 4;};
	class Church {color[] = {1,1,1,1};icon = "\A3\ui_f\data\map\mapcontrol\church_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class Chapel {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\Chapel_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class Cross {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\Cross_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class Rock {color[] = {0.1,0.1,0.1,0.8};icon = "\A3\ui_f\data\map\mapcontrol\rock_ca.paa";size = 12;importance = "0.5 * 12 * 0.05";coefMin = 0.25;coefMax = 4;};
	class Bunker {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";size = 14;importance = "1.5 * 14 * 0.05";coefMin = 0.25;coefMax = 4;};
	class Fortress {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";size = 16;importance = "2 * 16 * 0.05";coefMin = 0.25;coefMax = 4;};
	class Fountain {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\fountain_ca.paa";size = 11;importance = "1 * 12 * 0.05";coefMin = 0.25;coefMax = 4;};
	class ViewTower {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\viewtower_ca.paa";size = 16;importance = "2.5 * 16 * 0.05";coefMin = 0.5;coefMax = 4;};
	class Lighthouse {	color[] = {1,1,1,1};icon = "\A3\ui_f\data\map\mapcontrol\lighthouse_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class Quay {color[] = {1,1,1,1};icon = "\A3\ui_f\data\map\mapcontrol\quay_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class Fuelstation {color[] = {1,1,1,1};icon = "\A3\ui_f\data\map\mapcontrol\fuelstation_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class Hospital {color[] = {1,1,1,1};icon = "\A3\ui_f\data\map\mapcontrol\hospital_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class BusStop {color[] = {1,1,1,1};icon = "\A3\ui_f\data\map\mapcontrol\busstop_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class Transmitter {color[] = {1,1,1,1};icon = "\A3\ui_f\data\map\mapcontrol\transmitter_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class Stack {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\stack_ca.paa";size = 20;importance = "2 * 16 * 0.05";coefMin = 0.9;coefMax = 4;};
	class Ruin {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\ruin_ca.paa";size = 16;importance = "1.2 * 16 * 0.05";coefMin = 1;coefMax = 4;};
	class Tourism {color[] = {0,0,0,1};icon = "\A3\ui_f\data\map\mapcontrol\tourism_ca.paa";size = 16;importance = "1 * 16 * 0.05";coefMin = 0.7;coefMax = 4;};
	class Watertower {color[] = {1,1,1,1};icon = "\A3\ui_f\data\map\mapcontrol\watertower_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;};
	class Waypoint {color[] = {0,0,0,1};size = 24;importance = 1;coefMin = 1;coefMax = 1;icon = "\A3\ui_f\data\map\mapcontrol\waypoint_ca.paa";};
	class WaypointCompleted {color[] = {0,0,0,1};size = 24;importance = 1;coefMin = 1;coefMax = 1;icon = "\A3\ui_f\data\map\mapcontrol\waypointCompleted_ca.paa";};

	moveOnEdges = 0; //1;
	x = "SafeZoneXAbs";
	y = "SafeZoneY + 1.5 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	w = "SafeZoneWAbs";
	h = "SafeZoneH - 1.5 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	shadow = 0;
	ptsPerSquareSea = 5;
	ptsPerSquareTxt = 3;
	ptsPerSquareCLn = 10;
	ptsPerSquareExp = 10;
	ptsPerSquareCost = 10;
	ptsPerSquareFor = 9;
	ptsPerSquareForEdge = 9;
	ptsPerSquareRoad = 6;
	ptsPerSquareObj = 9;
	showCountourInterval = 0;
	scaleMin = 0.001;
	scaleMax = 1;
	scaleDefault = 0.16;
	maxSatelliteAlpha = 0.85;
	alphaFadeStartScale = 0.35;
	alphaFadeEndScale = 0.4;
	fontLabel = "PuristaMedium";
	sizeExLabel = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
	fontGrid = "TahomaB";
	sizeExGrid = 0.02;
	fontUnits = "TahomaB";
	sizeExUnits = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
	fontNames = "PuristaMedium";
	sizeExNames = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8) * 2";
	fontInfo = "PuristaMedium";
	sizeExInfo = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
	fontLevel = "TahomaB";
	sizeExLevel = 0.02;text = "#(argb,8,8,3)color(1,1,1,1)";
	//text = "\a3\ui_f\data\map_background2_co.paa";

	class power {icon = "\A3\ui_f\data\map\mapcontrol\power_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;color[] = {1,1,1,1};};
	class powersolar {icon = "\A3\ui_f\data\map\mapcontrol\powersolar_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;color[] = {1,1,1,1};};
	class powerwave {icon = "\A3\ui_f\data\map\mapcontrol\powerwave_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;color[] = {1,1,1,1};};
	class powerwind {icon = "\A3\ui_f\data\map\mapcontrol\powerwind_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;color[] = {1,1,1,1};};
	class shipwreck {icon = "\A3\ui_f\data\map\mapcontrol\shipwreck_CA.paa";size = 24;importance = 1;coefMin = 0.85;coefMax = 1;color[] = {1,1,1,1};};

};

////////////////////////// MAP CONTROL /////////////////////////////////////


class indiCam_RscCombo {

	type = CT_COMBO;
	style = "0x10 + 0x200";
	access = 0;
	h = 0.04;
	w = 0.17;
	x = 0;
	y = 0;
	sizeEx = TEXT_SIZE_MEDIUM;
	font = TEXT_FONT;
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
	colorActive[] = {1,0,0,1};
	colorBackground[] = COLOR_MEDIUM;
	colorDisabled[] = {1,1,1,0.25};
	colorPicture[] = {1,1,1,1};
	colorPictureDisabled[] = {1,1,1,0.25};
	colorPictureRight[] = {1,1,1,1};
	colorPictureRightDisabled[] = {1,1,1,0.25};
	colorPictureRightSelected[] = {1,1,1,1};
	colorPictureSelected[] = {1,1,1,1};
	colorScrollbar[] = {1,0,0,1};
	colorSelect[] = {0,0,0,1};
	colorSelect2Right[] = {0,0,0,1};
	colorSelectBackground[] = {1,1,1,0.7};
	colorSelectRight[] = {0,0,0,1};
	colorText[] = {1,1,1,1};
	colorTextRight[] = {1,1,1,1};
	deletable = 0;
	fade = 0;
	maxHistoryDelay = 1;
	shadow = 0;
	soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1};
	soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1};
	soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};
	wholeHeight = 0.45;

	class ComboScrollBar {
	
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		autoScrollDelay = 5;
		autoScrollEnabled = 0;
		autoScrollRewind = 0;
		autoScrollSpeed = -1;
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		color[] = {1,1,1,1};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		height = 0;
		scrollSpeed = 0.06;
		shadow = 0;
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		width = 0;

	};

};



class indiCam_RscButton {
	idc = -1;
	type = CT_BUTTON;
	style = 2;
	access = 0;
	w = 0.14;
	h = 0.05;
	borderSize = 0;
	colorBackground[] = COLOR_BUTTON;
	colorBackgroundActive[] = COLOR_BUTTON_MOUSEOVER;
	colorBackgroundDisabled[] = {0,0,0,0.5};
	colorBorder[] = {0,0,0,0};
	colorDisabled[] = {1,1,1,0.25};
	colorFocused[] = COLOR_BUTTON;
	colorShadow[] = COLOR_BUTTON_SHADOW;
	colorText[] = COLOR_LIGHT;
	deletable = 0;
	fade = 0;
	font = TEXT_FONT;
	offsetPressedX = 0.001;
	offsetPressedY = 0.001;
	offsetX = 0.002;
	offsetY = 0.002;
	shadow = 2;
	sizeEx = TEXT_SIZE_MEDIUM;
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
	text = "";
	url = "";
	x = 0;
	y = 0;
};



class indiCam_RscText {

	idc = -1;
	type = CT_STATIC;
	access = 0;
	font = TEXT_FONT;
	h = 0.037;
	w = 0.3;
	x = 0;
	y = 0;
	colorBackground[] = COLOR_TEXT_BACKGROUND;//COLOR_LIGHT;
	colorText[] = COLOR_LIGHT;
	SizeEx = TEXT_SIZE_MEDIUM;//"(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	colorShadow[] = {0,0,0,0.5};
	deletable = 0;
	fade = 0;
	fixedWidth = 0;
	linespacing = 1;
	shadow = 1;
	style = ST_MULTI;
	text = "";
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};
	
};



class indiCam_RscSlider {

	type = CT_SLIDER;
	style = SL_HORZ;
	access = 0;
	deletable = 0;
	fade = 0;
	shadow = 0;
	x = 0;
	y = 0;
	w = 0.3;
	h = 0.025;
	color[] = COLOR_ACCENT; 
	coloractive[] = COLOR_ACCENT;
	
};


class indiCam_RscCheckBox {

	idc = -1;
	type = CT_CHECKBOX;
	style = 0;
	x = 0;
	y = 0;
	w = 0.02 * safezoneW;
	h = 0.03 * safezoneH;
	checked = 0;
	color[] = {1,1,1,0.7};
	colorBackground[] = {0,0,0,0};
	colorBackgroundDisabled[] = {0,0,0,0};
	colorBackgroundFocused[] = {0,0,0,0};
	colorBackgroundHover[] = {0,0,0,0};
	colorBackgroundPressed[] = {0,0,0,0};
	colorDisabled[] = {1,1,1,0.2};
	colorFocused[] = {1,1,1,1};
	colorHover[] = {1,1,1,1};
	colorPressed[] = {1,1,1,1};
	deletable = 0;
	soundClick[] = {"",0.1,1};
	soundEnter[] = {"",0.1,1};
	soundEscape[] = {"",0.1,1};
	soundPush[] = {"",0.1,1};
	textureChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureDisabledChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureDisabledUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	textureFocusedChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureFocusedUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	textureHoverChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureHoverUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	texturePressedChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	texturePressedUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	textureUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};
	
};

class indiCam_RscPicture {

	idc = -1;
	type = CT_STATIC;
	access = 0;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	deletable = 0;
	fade = 0;
	fixedWidth = 0;
	font = "TahomaB";
	h = 0.15;
	lineSpacing = 0;
	shadow = 0;
	sizeEx = 0;
	style = 48;
	text = "";
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};
	w = 0.2;
	x = 0;
	y = 0;

};





class indiCam_RscListBox {

	type = CT_LISTBOX;
	font = TEXT_FONT;
	h = 0.3;
	w = 0.3;
	x = 0;
	y = 0;
	sizeEx = TEXT_SIZE_MEDIUM;//"(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	access = 0;
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	autoScrollSpeed = -1;
	colorBackground[] = COLOR_MEDIUM;
	colorDisabled[] = {1,1,1,0.25};
	colorPicture[] = {1,1,1,1};
	colorPictureDisabled[] = {1,1,1,0.25};
	colorPictureRight[] = {1,1,1,1};
	colorPictureRightDisabled[] = {1,1,1,0.25};
	colorPictureRightSelected[] = {1,1,1,1};
	colorPictureSelected[] = {1,1,1,1};
	colorScrollbar[] = {1,0,0,0};
	colorSelect[] = {0,0,0,1};
	colorSelect2[] = COLOR_ACCENT;
	colorSelect2Right[] = {0,0,0,1};
	colorSelectBackground[] = {0.95,0.95,0.95,1};
	colorSelectBackground2[] = {1,1,1,0.5};
	colorSelectRight[] = {0,0,0,1};
	colorShadow[] = {0,0,0,0.5};
	colorText[] = {1,1,1,1};
	colorTextRight[] = {1,1,1,1};
	deletable = 0;
	fade = 0;
	maxHistoryDelay = 1;
	period = 1.2;
	rowHeight = 0;
	shadow = 0;
	soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1};
	style = 16;
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};

	class ListScrollBar {
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		autoScrollDelay = 5;
		autoScrollEnabled = 1;
		autoScrollRewind = 0;
		autoScrollSpeed = -1;
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		color[] = {1,1,1,1};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		height = 0;
		scrollSpeed = 0.06;
		shadow = 0;
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		width = 0;
	};

};