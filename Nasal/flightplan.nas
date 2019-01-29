# A3XX FMGC Flightplan System
# Copyright (c) 2019 Joshua Davidson (it0uchpods)
# This thing replaces the Route Manager, it's far from finished though
print("System: You are using an experimental version of the IDG-A32X. Things may go TERRIBLY WRONG!");
print("System: FMGC Dev Version - Copyright (c) 2019 Joshua Davidson (it0uchpods)");

# r0 = TEMP FP
# r1 = ACTIVE FP
var r1 = createFlightplan();
var wpDep = nil;
var wpArr = nil;
var pos = nil;
var r1_currentWP = 0;
var r1_currentLeg = nil;
var r1_currentLegCourseDist = 0;
var geoPos = nil;
var r1_active_out = props.globals.initNode("/FMGC/flightplan/r1/active", 0, "BOOL");
var r1_currentWP_out = props.globals.initNode("/FMGC/flightplan/r1/current-wp", 0, "INT");
var r1_currentLeg_out = props.globals.initNode("/FMGC/flightplan/r1/current-leg", "", "STRING");
var r1_currentLegCourse_out = props.globals.initNode("/FMGC/flightplan/r1/current-leg-course", 0, "DOUBLE");
var r1_currentLegDist_out = props.globals.initNode("/FMGC/flightplan/r1/current-leg-dist", 0, "DOUBLE");
var r1_num_out = props.globals.initNode("/FMGC/flightplan/r1/num", 0, "INT");
var toFromSet = props.globals.initNode("/FMGC/internal/tofrom-set", 0, "BOOL");

var flightplan = {
	initProps: func() {
		
	},
	reset: func() {
#		me.reset0();
		me.reset1();
		me.initProps();
	},
	reset1: func() {
		r1.cleanPlan();
		r1.departure = nil;
		r1.destination = nil;
		r1_currentWP = 0;
		r1_currentWPData = nil;
		r1_currentLeg = nil;
	},
	updateARPT: func(dep, arr, n) {
		if (n == 1) { # Which flightplan?
			me.reset1();
			
			# Set Departure ARPT
			if (dep != nil) {
				r1.departure = airportinfo(dep);
				r1_currentWP = 0;
			} else {
				r1.departure = nil;
				r1_currentWP = 0;
			}
			
			# Set Arrival ARPT
			if (arr != nil) {
				r1.destination = airportinfo(arr);
			} else {
				r1.destination = nil;
			}
		}
	},
	insertFix: func(wp, i) {
		var pos = findFixesByID(wp);
		if (pos != nil and size(pos) > 0) {
			r1.insertWP(createWPFrom(pos[0]), i);
		}
	},
	insertNavaid: func(nav, i) {
		var pos = findNavaidsByID(nav);
		if (pos != nil and size(pos) > 0) {
			r1.insertWP(createWPFrom(pos[0]), i);
		}
	},
	outputProps: func() {
		geoPos = geo.aircraft_position();
		
		if (r1_currentWP > r1.getPlanSize()) {
			r1_currentWP = r1.getPlanSize();
		}
		
		if (toFromSet.getBoolValue() and r1.departure != nil and r1.destination != nil) {
			if (r1_active_out.getBoolValue() != 1) {
				r1_active_out.setBoolValue(1);
			}
			
			if (r1_num_out.getValue() != r1.getPlanSize()) {
				r1_num_out.setValue(r1.getPlanSize());
			}
			
			r1_currentLeg = r1.getWP(r1_currentWP).wp_name;
			if (r1_currentLeg_out.getValue() != r1_currentLeg) {
				r1_currentLeg_out.setValue(r1_currentLeg);
			}
			
			r1_currentLegCourseDist = r1.getWP(r1_currentWP).courseAndDistanceFrom(geoPos);
			r1_currentLegCourse_out.setValue(r1_currentLegCourseDist[0]);
			r1_currentLegDist_out.setValue(r1_currentLegCourseDist[1]);
			
			for (var i = 0; i < r1.getPlanSize(); i += 1) {
				setprop("/FMGC/flightplan/r1/wp[" ~ i ~ "]/id", r1.getWP(i).wp_name);
				setprop("/FMGC/flightplan/r1/wp[" ~ i ~ "]/course", r1.getWP(i).courseAndDistanceFrom(geoPos)[0]);
				setprop("/FMGC/flightplan/r1/wp[" ~ i ~ "]/distance", r1.getWP(i).courseAndDistanceFrom(geoPos)[1]);
			}
		} else {
			if (r1_active_out.getBoolValue() != 0) {
				r1_active_out.setBoolValue(0);
			}
			
			if (r1_num_out.getValue() != 0) {
				r1_num_out.setValue(0);
			}
			
			if (r1_currentLeg_out.getValue() != "") {
				r1_currentLeg_out.setValue("");
			}
		}
		
		if (r1_currentWP != nil) {
			if (r1_currentWP_out.getValue() != r1_currentWP) {
				r1_currentWP_out.setValue(r1_currentWP);
			}
		} else {
			if (r1_currentWP_out.getValue() != 0) {
				r1_currentWP_out.setValue(0);
			}
		}
	},
};

flightplan.initProps();
var outputPropsTimer = maketimer(0.4, flightplan.outputProps);
