# Airbus A3XX MCDU

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

# Lowercase "g" is a degree symbol in the MCDU font.
# wht = white, grn = green, blu = blue, amb = amber, yel = yellow
var left1 = [props.globals.initNode("MCDU[0]/F-PLN/left-1", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-1", "", "STRING")];
var left2 = [props.globals.initNode("MCDU[0]/F-PLN/left-2", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-2", "", "STRING")];
var left3 = [props.globals.initNode("MCDU[0]/F-PLN/left-3", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-3", "", "STRING")];
var left4 = [props.globals.initNode("MCDU[0]/F-PLN/left-4", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-4", "", "STRING")];
var left5 = [props.globals.initNode("MCDU[0]/F-PLN/left-5", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-5", "", "STRING")];
var left6 = [props.globals.initNode("MCDU[0]/F-PLN/left-6", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-6", "", "STRING")];
var left1s = [props.globals.initNode("MCDU[0]/F-PLN/left-1s", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-1s", "", "STRING")];
var left2s = [props.globals.initNode("MCDU[0]/F-PLN/left-2s", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-2s", "", "STRING")];
var left3s = [props.globals.initNode("MCDU[0]/F-PLN/left-3s", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-3s", "", "STRING")];
var left4s = [props.globals.initNode("MCDU[0]/F-PLN/left-4s", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-4s", "", "STRING")];
var left5s = [props.globals.initNode("MCDU[0]/F-PLN/left-5s", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-5s", "", "STRING")];
var left6s = [props.globals.initNode("MCDU[0]/F-PLN/left-6s", "", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/left-6s", "", "STRING")];
var line1c = [props.globals.initNode("MCDU[0]/F-PLN/line-1c", "wht", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/line-1c", "wht", "STRING")];
var line2c = [props.globals.initNode("MCDU[0]/F-PLN/line-2c", "wht", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/line-2c", "wht", "STRING")];
var line3c = [props.globals.initNode("MCDU[0]/F-PLN/line-3c", "wht", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/line-3c", "wht", "STRING")];
var line4c = [props.globals.initNode("MCDU[0]/F-PLN/line-4c", "wht", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/line-4c", "wht", "STRING")];
var line5c = [props.globals.initNode("MCDU[0]/F-PLN/line-5c", "wht", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/line-5c", "wht", "STRING")];
var line6c = [props.globals.initNode("MCDU[0]/F-PLN/line-6c", "wht", "STRING"), props.globals.initNode("MCDU[1]/F-PLN/line-6c", "wht", "STRING")];
var showFromInd = [props.globals.initNode("MCDU[0]/F-PLN/show-from", 0, "BOOL"), props.globals.initNode("MCDU[1]/F-PLN/show-from", 0, "BOOL")];

var discontinuity =    "---F-PLN DISCONTINUITY--";
var fpln_end =         "------END OF F-PLN------";
var altn_fpln_end =    "----END OF ALTN F-PLN---";
var no_altn_fpln_end = "------NO ALTN F-PLN-----";

var num = 0;
var page = "";
var active_out = [nil, nil, props.globals.getNode("/FMGC/flightplan[2]/active")];
var num_out = [props.globals.getNode("/FMGC/flightplan[0]/num"), props.globals.getNode("/FMGC/flightplan[1]/num"), props.globals.getNode("/FMGC/flightplan[2]/num")];
var TMPYActive = [props.globals.getNode("/FMGC/internal/tmpy-active[0]"), props.globals.getNode("/FMGC/internal/tmpy-active[1]")];
var TMPYActive_out = [props.globals.initNode("/MCDU[0]/tmpy-active", 0, "BOOL"), props.globals.initNode("/MCDU[1]/tmpy-active", 0, "BOOL")];
var pageProp = [props.globals.getNode("/MCDU[0]/page", 1), props.globals.getNode("/MCDU[1]/page", 1)];

# Create text items
var StaticText = {
	new: func (type) {
		var i = {parents:[StaticText]};
		i.type = type;
		return i;
	},
	getText: func {
		if (me.type == "discontinuity") {
			return "---F-PLN DISCONTINUITY--";
		} else if (me.type == "fplnEnd") {
			return "------END OF F-PLN------";
		} else if (me.type == "altnFplnEnd") {
			return "----END OF ALTN F-PLN---";
		} else if (me.type == "noAltnFpln") {
			return "------NO ALTN F-PLN-----";
		}
	},
	getColor: func {
		return "wht";
	},
	type: nil,
};

var slewFPLN = func(d, i) {
	
}

var updateFPLN = func(i) {
	page = pageProp[i].getValue();
	
	if (active_out[2].getBoolValue()) {
		
		TMPYActive_out[i].setBoolValue(TMPYActive[i].getBoolValue());
	} else {
		left1[i].setValue("");
		left1s[i].setValue("");
		left2[i].setValue("");
		left2s[i].setValue("");
		left3[i].setValue("");
		left3s[i].setValue("");
		left4[i].setValue("");
		left4s[i].setValue("");
		left5[i].setValue("");
		left5s[i].setValue("");
		left6[i].setValue("");
		left6s[i].setValue("");
		TMPYActive_out[i].setBoolValue(0);
	}
}

# Button and Inputs
var FPLNButton = func(s, key, i) {
	if (s == "L") {
		
	} else if (s == "R") {
		
	}
}

var notInDataBase = func(i) {
	if (getprop("/MCDU[" ~ i ~ "]/scratchpad") != "NOT IN DATABASE") {
		setprop("/MCDU[" ~ i ~ "]/last-scratchpad", getprop("/MCDU[" ~ i ~ "]/scratchpad"));
	}
	setprop("/MCDU[" ~ i ~ "]/scratchpad-msg", 1);
	setprop("/MCDU[" ~ i ~ "]/scratchpad", "NOT IN DATABASE");
}
