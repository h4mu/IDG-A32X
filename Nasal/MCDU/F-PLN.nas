# Airbus A3XX FMGC MCDU Bridge

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

var TMPY = 5;
var MAIN = 6;
var num = 0;
var page = "";
var active_out = [nil, nil, props.globals.getNode("/FMGC/flightplan[2]/active")];
var num_out = [props.globals.getNode("/FMGC/flightplan[0]/num"), props.globals.getNode("/FMGC/flightplan[1]/num"), props.globals.getNode("/FMGC/flightplan[2]/num")];
var TMPYActive = [props.globals.getNode("/FMGC/internal/tmpy-active[0]"), props.globals.getNode("/FMGC/internal/tmpy-active[1]")];
var pageProp = [props.globals.getNode("/MCDU[0]/page", 1), props.globals.getNode("/MCDU[1]/page", 1)];

# Create text items
var StaticText = {
	new: func(type) {
		var in = {parents:[StaticText]};
		in.type = type;
		return in;
	},
	getText: func() {
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
	getColor: func() {
		return "wht";
	},
	type: nil,
	pushButtonLeft: func() {
		
	},
	pushButtonRight: func() {
		
	},
};

var MCDUText = {
	new: func(wp) {
		var in = {parents:[MCDUText]};
		in.wp = wp;
		return in;
	},
	getText: func(i) {
		if (TMPYActive[i].getBoolValue()) {
			left1[i].setValue(fmgc.wpID[i][me.wp].getValue());
		} else {
			left1[i].setValue(fmgc.wpID[2][me.wp].getValue());
		}
	},
	getColor: func(i) {
		if (TMPYActive[i].getBoolValue()) {
			if (me.wp == fmgc.arrivalAirportI[i]) {
				return "wht";
			} else {
				return "yel";
			}
		} else {
			if (me.wp == fmgc.arrivalAirportI[2]) {
				return "wht";
			} else {
				return "grn";
			}
		}
	},
	wp: nil,
	pushButtonLeft: func() {
		
	},
	pushButtonRight: func() {
		
	},
};

var FPLNLineComputer = {
	new: func(mcdu) {
		var in = {parents:[FPLNLineComputer]};
		in.mcdu = mcdu;
		printf("%d: Line computer created.",in.mcdu);
		return in;
	},
	index: 0,
	planList: [],
	destination: nil,
	destIndex: nil,
	planEnd: nil,
	lines: nil,
	output: [],
	mcdu: nil,
	enableScroll: 0,
	updatePlan: func(fpln) {
		printf("oops, this method is not ready yet");
		# Here you make the line instances and put them into me.planList
		me.checkIndex();
		me.updateScroll();
	},
	replacePlan: func(fpln, lines, destIndex) {
		# Here you set another plan, do this when changing plan on display or when destination changes
		printf("%d: replacePlan called", me.mcdu);
		me.planList = [];
		for (var j = 0; j < fpln.getPlanSize(); j += 1) {
			append(me.planList, MCDUText.new(fpln.getWP(j)));
		}
		me.destination = MCDUText.new(fpln.getWP(destIndex));
		me.planEnd = StaticText.new("fplnEnd");
		me.destIndex = destIndex;
		me.initScroll(lines);
	},
	initScroll: func(lines) {
		me.lines = lines;
		me.index = 0;
		me.maxItems = size(me.planList) + 2; # + 2 is for end of plan line and no alternate flightplan
		me.enableScroll = lines < me.maxItems;
		printf("%d: scroll is %d. Number of WP is %d", me.mcdu, me.enableScroll, size(me.planList));
		me.updateScroll();
	},
	checkIndex: func() {
		printf("oops, this method is not ready yet");
		if (me.lines == MAIN) {
			me.extra = 2;
		} else {
			me.extra = 1
		}
		if (size(planList) < MAIN) {
			me.index = 0;
		} else if (me.index > size(planList) + me.extra + size(planList) - me.lines - 1) {
			me.index = size(planList) + me.extra + size(planList) - me.lines - 1;
		}
	},
	scrollDown: func() {
		printf("%d: scroll down", me.mcdu);
		me.extra = 1;
		if (!me.enableScroll) {
			me.index = 0;
		} else {
			me.index += 1;
			if (me.index > size(planList)) {
				me.index = 0;
			}
		}
		me.updateScroll();
	},
	scrollUp: func() {
		printf("%d: scroll up", me.mcdu);
		me.extra = 1;
		if (!me.enableScroll) {
			me.index = 0;
		} else {
			me.index -= 1;
			if (me.index < 0) {
				me.index = size(planList);
			}
		}
		me.updateScroll();
	},
	updateScroll: func() {
		me.output = [];
		if (me.index <= size(me.planList)) {
			var i = 0;
			printf("%d: updating display from index %d", me.mcdu, me.index);
			for (i = me.index; i < math.min(size(me.planList), i + 5); i += 1) {
				append(me.output, me.planList[i]);
			}
			printf("%d: populated until wp index %d", me.mcdu,i);
			if (i < me.destIndex and me.lines == MAIN) {
				# Destination has not been shown yet, now its time (if we show 6 lines)
				append(me.output, me.destination);
				printf("%d: added dest at bottom for total of %d lines", me.mcdu, size(me.output));
				return;
			} else if (size(me.output) < me.lines and (i == size(me.planList) - 1 or (me.enableScroll and i == size(me.planList)))) {
				# Show the end of plan
				append(me.output, me.planEnd);
				printf("%d: added end", me.mcdu);
				if (me.enableScroll and size(me.output) < me.lines) {
					# We start wrapping
					for (var j = 0; size(me.output) < me.lines; j += 1) {
						append(me.output, me.planList[j]);
					}
					
				}
			}
		}
		printf("%d: %d lines", me.mcdu, size(me.output));
	},
};

var MCDULines = [FPLNLineComputer.new(0), FPLNLineComputer.new(1)];

var slewFPLN = func(d, i) { # Scrolling function. d is -1 or 1 for direction, and i is instance.
	if (d == 1) {
		MCDULines[i].scrollUp();
	} else if (d == 0) {
		MCDULines[i].scrollDown();
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
