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
var geoPosPrev = geo.Coord.new();
var courseDistanceFrom = nil;
var courseDistanceFromPrev = nil;
var sizeWP = nil;
var magTrueError = 0;
var arrivalAirportI = 0;
var altFeet = props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft", 1);
var r1_active_out = props.globals.initNode("/FMGC/flightplan/r1/active", 0, "BOOL");
var r1_currentWP_out = props.globals.initNode("/FMGC/flightplan/r1/current-wp", 0, "INT");
var r1_currentLeg_out = props.globals.initNode("/FMGC/flightplan/r1/current-leg", "", "STRING");
var r1_currentLegCourse_out = props.globals.initNode("/FMGC/flightplan/r1/current-leg-course", 0, "DOUBLE");
var r1_currentLegDist_out = props.globals.initNode("/FMGC/flightplan/r1/current-leg-dist", 0, "DOUBLE");
var r1_currentLegCourseMag_out = props.globals.initNode("/FMGC/flightplan/r1/current-leg-course-mag", 0, "DOUBLE");
var r1_arrivalLegDist_out = props.globals.initNode("/FMGC/flightplan/r1/arrival-leg-dist", 0, "DOUBLE");
var r1_num_out = props.globals.initNode("/FMGC/flightplan/r1/num", 0, "INT");
var toFromSet = props.globals.initNode("/FMGC/internal/tofrom-set", 0, "BOOL");
var magHDG = props.globals.getNode("/orientation/heading-magnetic-deg", 1);
var trueHDG = props.globals.getNode("/orientation/heading-deg", 1);
var FMGCdep = props.globals.getNode("/FMGC/internal/dep-arpt", 1);
var FMGCarr = props.globals.getNode("/FMGC/internal/arr-arpt", 1);

# props.nas for flightplan
var wpID = [props.globals.initNode("/FMGC/flightplan/r1/wp[0]/id", "", "STRING")];
var wpLat = [props.globals.initNode("/FMGC/flightplan/r1/wp[0]/lat", 0, "DOUBLE")];
var wpLon = [props.globals.initNode("/FMGC/flightplan/r1/wp[0]/lon", 0, "DOUBLE")];
var wpCourse = [props.globals.initNode("/FMGC/flightplan/r1/wp[0]/course", 0, "DOUBLE")];
var wpDistance = [props.globals.initNode("/FMGC/flightplan/r1/wp[0]/distance", 0, "DOUBLE")];
var wpCoursePrev = [props.globals.initNode("/FMGC/flightplan/r1/wp[0]/course-from-prev", 0, "DOUBLE")];
var wpDistancePrev = [props.globals.initNode("/FMGC/flightplan/r1/wp[0]/distance-from-prev", 0, "DOUBLE")];

var flightplan = {
	reset: func() {
#		me.reset0();
		me.reset1();
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
			
			me.checkWPOutputs();
		}
	},
	insertFix: func(wp, i) {
		var pos = findFixesByID(wp);
		if (pos != nil and size(pos) > 0) {
			r1.insertWP(createWPFrom(pos[0]), i);
			me.checkWPOutputs();
		}
	},
	insertNavaid: func(nav, i) {
		var pos = findNavaidsByID(nav);
		if (pos != nil and size(pos) > 0) {
			r1.insertWP(createWPFrom(pos[0]), i);
			me.checkWPOutputs();
		}
	},
	deleteWP: func(i) {
		if (r1.getPlanSize() > 2 and wpID[i].getValue() != FMGCdep.getValue() and wpID[i].getValue() != FMGCarr.getValue()) { # Not allowed to remove departure or arrival airport
			r1.deleteWP(i);
			canvas_nd.A3XXRouteDriver.triggerSignal("fp-removed");
		}
	},
	checkWPOutputs: func() {
		canvas_nd.A3XXRouteDriver.triggerSignal("fp-added");
		sizeWP = size(wpID);
		for (var counter = sizeWP; counter < r1.getPlanSize(); counter += 1) {
			append(wpID, props.globals.initNode("/FMGC/flightplan/r1/wp[" ~ counter ~ "]/id", "", "STRING"));
			append(wpLat, props.globals.initNode("/FMGC/flightplan/r1/wp[" ~ counter ~ "]/lat", 0, "DOUBLE"));
			append(wpLon, props.globals.initNode("/FMGC/flightplan/r1/wp[" ~ counter ~ "]/lon", 0, "DOUBLE"));
			append(wpCourse, props.globals.initNode("/FMGC/flightplan/r1/wp[" ~ counter ~ "]/course", 0, "DOUBLE"));
			append(wpDistance, props.globals.initNode("/FMGC/flightplan/r1/wp[" ~ counter ~ "]/distance", 0, "DOUBLE"));
			append(wpCoursePrev, props.globals.initNode("/FMGC/flightplan/r1/wp[" ~ counter ~ "]/course-from-prev", 0, "DOUBLE"));
			append(wpDistancePrev, props.globals.initNode("/FMGC/flightplan/r1/wp[" ~ counter ~ "]/distance-from-prev", 0, "DOUBLE"));
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
			
			magTrueError = magHDG.getValue() - trueHDG.getValue();
			r1_currentLegCourseMag_out.setValue(r1_currentLegCourseDist[0] + magTrueError); # Convert to Magnetic
			
			for (var i = 0; i < r1.getPlanSize(); i += 1) {
				wpID[i].setValue(r1.getWP(i).wp_name);
				wpLat[i].setValue(r1.getWP(i).wp_lat);
				wpLon[i].setValue(r1.getWP(i).wp_lon);
				courseDistanceFrom = r1.getWP(i).courseAndDistanceFrom(geoPos);
				wpCourse[i].setValue(courseDistanceFrom[0]);
				wpDistance[i].setValue(courseDistanceFrom[1]);
				if (i > 0) { # Impossible to do from the first WP
					geoPosPrev.set_latlon(r1.getWP(i - 1).lat, r1.getWP(i - 1).lon, altFeet.getValue() * 0.3048);
					courseDistanceFromPrev = r1.getWP(i).courseAndDistanceFrom(geoPosPrev);
					wpCoursePrev[i].setValue(courseDistanceFromPrev[0]);
					wpDistancePrev[i].setValue(courseDistanceFromPrev[1]);
				} else { # So if its the first WP, we just use current position instead
					wpCoursePrev[i].setValue(courseDistanceFrom[0]);
					wpDistancePrev[i].setValue(courseDistanceFrom[1]);
				}
				
				if (wpID[i].getValue() == FMGCarr.getValue()) {
					arrivalAirportI = i;
				}
			}
			
			r1_arrivalLegDist_out.setValue(wpDistance[arrivalAirportI].getValue());
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
		
		mcdu.updateFPLN(0);
		mcdu.updateFPLN(1);
	},
};

var outputPropsTimer = maketimer(0.4, flightplan.outputProps);
