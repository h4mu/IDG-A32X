# Airbus A3XX FMGC MCDU Bridge

# Copyright (c) 2019 Joshua Davidson (it0uchpods) and Nikolai V. Chr. (Necolatis)

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
var showFromInd = [props.globals.initNode("MCDU[0]/F-PLN/show-from", 0, "BOOL"), props.globals.initNode("MCDU[1]/F-PLN/show-from", 0, "BOOL")];

var TMPY = 5;
var MAIN = 6;
var debug = 0; # Set to 1 to check inner functionality
var active_out = [nil, nil, props.globals.getNode("/FMGC/flightplan[2]/active")];
var num_out = [props.globals.getNode("/FMGC/flightplan[0]/num"), props.globals.getNode("/FMGC/flightplan[1]/num"), props.globals.getNode("/FMGC/flightplan[2]/num")];
var TMPYActive = [props.globals.getNode("/FMGC/internal/tmpy-active[0]"), props.globals.getNode("/FMGC/internal/tmpy-active[1]")];

# Create text items
var StaticText = {
	new: func(type) {
		var in = {parents:[StaticText]};
		in.type = type;
		return in;
	},
	getText: func(i) {
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
	getColor: func(i) {
		return canvas_mcdu.WHITE;
	},
	type: nil,
	pushButtonLeft: func() {
		
	},
	pushButtonRight: func() {
		
	},
};

var MCDUText = {
	new: func(wp, dest) {
		var in = {parents:[MCDUText]};
		in.wp = wp;
		in.dest = dest;
		return in;
	},
	getText: func(i) {
		return me.wp.wp_name;
	},
	getColor: func(i) {
		
		if (TMPYActive[i].getBoolValue()) {
			if (me.dest) {
				return canvas_mcdu.WHITE;
			} else {
				return canvas_mcdu.YELLOW;
			}
		} else {
			if (me.dest) {
				return canvas_mcdu.WHITE;
			} else {
				return canvas_mcdu.GREEN;
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
		if (debug == 1) printf("%d: Line computer created.", in.mcdu);
		return in;
	},
	index: 0,
	planList: [],
	destination: nil,
	destIndex: nil,
	planEnd: nil,
	planNoAlt: nil,
	lines: nil,
	output: [],
	mcdu: nil,
	enableScroll: 0,
	updatePlan: func(fpln) {
		if (debug == 1) printf("oops, this method is not ready yet");
		# Here you make the line instances and put them into me.planList
		me.checkIndex();
		me.updateScroll();
	},
	replacePlan: func(fpln, lines, destIndex) {
		# Here you set another plan, do this when changing plan on display or when destination changes
		if (debug == 1) printf("%d: replacePlan called for %d lines and destIndex %d", me.mcdu, lines, destIndex);
		me.planList = [];
		for (var j = 0; j < fpln.getPlanSize(); j += 1) {
			me.dest = 0;
			if (j == destIndex) {
				me.dest = 1;
			}
			append(me.planList, MCDUText.new(fpln.getWP(j), me.dest));
		}
		me.destination = MCDUText.new(fpln.getWP(destIndex), 1);
		if (debug == 1) printf("%d: dest is: %s", me.mcdu, fpln.getWP(destIndex).wp_name);
		me.planEnd = StaticText.new("fplnEnd");
		me.planNoAlt = StaticText.new("noAltnFpln");
		me.destIndex = destIndex;
		me.initScroll(lines);
	},
	initScroll: func(lines) {
		me.lines = lines;
		me.index = 0;
		me.maxItems = size(me.planList) + 2; # + 2 is for end of plan line and altn end of plan.
		me.enableScroll = lines < me.maxItems;
		if (debug == 1) printf("%d: scroll is %d. Size of plan is %d", me.mcdu, me.enableScroll, size(me.planList));
		me.updateScroll();
	},
	checkIndex: func() {
		if (debug == 1) printf("oops, this method is not ready yet");
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
	scrollDown: func() { # Scroll Up in Thales Manual
		if (debug == 1) printf("%d: scroll down", me.mcdu);
		me.extra = 1;
		if (!me.enableScroll) {
			me.index = 0;
		} else {
			me.index += 1;
			if (me.index > size(me.planList) + 1) {
				me.index = 0;
			}
		}
		me.updateScroll();
	},
	scrollUp: func() { # Scroll Down in Thales Manual
		if (debug == 1) printf("%d: scroll up", me.mcdu);
		me.extra = 1;
		if (!me.enableScroll) {
			me.index = 0;
		} else {
			me.index -= 1;
			if (me.index < 0) {
				me.index = size(me.planList) + 1;
			}
		}
		me.updateScroll();
	},
	updateScroll: func() {
		me.output = [];
		if (me.index <= size(me.planList)+1) {
			var i = 0;
			me.realIndex = me.index-1;
			if (debug == 1) printf("%d: updating display from index %d", me.mcdu, me.realIndex);
			for (i = me.index; i < math.min(size(me.planList), me.index + 5); i += 1) {
				append(me.output, me.planList[i]);
				me.realIndex = i;
			}
			if (debug == 1) printf("%d: populated until wp index %d", me.mcdu,me.realIndex);
			if (me.realIndex < me.destIndex and me.lines == MAIN) {
				# Destination has not been shown yet, now its time (if we show 6 lines)
				append(me.output, me.destination);
				if (debug == 1) printf("%d: added dest at bottom for total of %d lines", me.mcdu, size(me.output));
				return;
			} else if (size(me.output) < me.lines) {
				for (i = me.realIndex+1; size(me.output) < me.lines and i < size(me.planList); i += 1) {
					append(me.output, me.planList[i]);
					me.realIndex = i;
				}
				if (debug == 1) printf("%d: populated after until wp index %d", me.mcdu,me.realIndex);
				if (size(me.output) < me.lines) {
					if (me.realIndex == size(me.planList)-1) {
						# Show the end of plan
						append(me.output, me.planEnd);
						me.realIndex += 1;
						if (debug == 1) printf("%d: added end, wp index=%d", me.mcdu, me.realIndex);
					}
					if (size(me.output) < me.lines and (me.realIndex == size(me.planList))) {
						append(me.output, me.planNoAlt);
						me.realIndex += 1;
						if (debug == 1) printf("%d: added no-alt, wp index=%d", me.mcdu,me.realIndex);
						if (me.enableScroll and size(me.output) < me.lines) {
							# We start wrapping
							for (var j = 0; size(me.output) < me.lines; j += 1) {
								append(me.output, me.planList[j]);
							}							
						}
					}
				}
			}
		}
		if (debug == 1) printf("%d: %d lines", me.mcdu, size(me.output));
	},
};

var MCDULines = [FPLNLineComputer.new(0), FPLNLineComputer.new(1)];

# For testing purposes only -- do not touch!
var test = func {
	var fp = createFlightplan(getprop("sim/aircraft-dir")~"/plan.gpx");
	var desti = int(fp.getPlanSize()*0.5);
	MCDULines[0].replacePlan(fp,6,desti);
	print("Display:");
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("down");MCDULines[0].scrollDown();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
	print("up");MCDULines[0].scrollUp();
	foreach(line;MCDULines[0].output) {
		printf("line: %s",line.getText(0));
	}
}

#test();

var slewFPLN = func(d, i) { # Scrolling function. d is -1 or 1 for direction, and i is instance.
	if (d == 1) {
		MCDULines[i].scrollDown(); # Scroll Up in Thales Manual
		print("scrollDown()");
	} else if (d == -1) {
		MCDULines[i].scrollUp(); # Scroll Down in Thales Manual
		print("scrollUp()");
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
