# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

setprop("/MCDU[0]/F-PLN/left-1", "");
setprop("/MCDU[0]/F-PLN/left-2", "");
setprop("/MCDU[0]/F-PLN/left-3", "");
setprop("/MCDU[0]/F-PLN/left-4", "");
setprop("/MCDU[0]/F-PLN/left-5", "");
setprop("/MCDU[0]/F-PLN/left-6", "");
setprop("/MCDU[0]/F-PLN/center-1", "");
setprop("/MCDU[0]/F-PLN/center-2", "");
setprop("/MCDU[0]/F-PLN/center-3", "");
setprop("/MCDU[0]/F-PLN/center-4", "");
setprop("/MCDU[0]/F-PLN/center-5", "");
setprop("/MCDU[0]/F-PLN/center-6", "");
setprop("/MCDU[0]/F-PLN/right-1", "");
setprop("/MCDU[0]/F-PLN/right-2", "");
setprop("/MCDU[0]/F-PLN/right-3", "");
setprop("/MCDU[0]/F-PLN/right-4", "");
setprop("/MCDU[0]/F-PLN/right-5", "");
setprop("/MCDU[0]/F-PLN/right-6", "");
setprop("/MCDU[0]/F-PLN/left-1c", "w");
setprop("/MCDU[0]/F-PLN/left-2c", "w");
setprop("/MCDU[0]/F-PLN/left-3c", "w");
setprop("/MCDU[0]/F-PLN/left-4c", "w");
setprop("/MCDU[0]/F-PLN/left-5c", "w");
setprop("/MCDU[0]/F-PLN/left-6c", "w");
setprop("/MCDU[0]/F-PLN/center-1c", "w");
setprop("/MCDU[0]/F-PLN/center-2c", "w");
setprop("/MCDU[0]/F-PLN/center-3c", "w");
setprop("/MCDU[0]/F-PLN/center-4c", "w");
setprop("/MCDU[0]/F-PLN/center-5c", "w");
setprop("/MCDU[0]/F-PLN/center-6c", "w");
setprop("/MCDU[0]/F-PLN/right-1c", "w");
setprop("/MCDU[0]/F-PLN/right-2c", "w");
setprop("/MCDU[0]/F-PLN/right-3c", "w");
setprop("/MCDU[0]/F-PLN/right-4c", "w");
setprop("/MCDU[0]/F-PLN/right-5c", "w");
setprop("/MCDU[0]/F-PLN/right-6c", "w");

setprop("/MCDU[1]/F-PLN/left-1", "");
setprop("/MCDU[1]/F-PLN/left-2", "");
setprop("/MCDU[1]/F-PLN/left-3", "");
setprop("/MCDU[1]/F-PLN/left-4", "");
setprop("/MCDU[1]/F-PLN/left-5", "");
setprop("/MCDU[1]/F-PLN/left-6", "");
setprop("/MCDU[1]/F-PLN/center-1", "");
setprop("/MCDU[1]/F-PLN/center-2", "");
setprop("/MCDU[1]/F-PLN/center-3", "");
setprop("/MCDU[1]/F-PLN/center-4", "");
setprop("/MCDU[1]/F-PLN/center-5", "");
setprop("/MCDU[1]/F-PLN/center-6", "");
setprop("/MCDU[1]/F-PLN/right-1", "");
setprop("/MCDU[1]/F-PLN/right-2", "");
setprop("/MCDU[1]/F-PLN/right-3", "");
setprop("/MCDU[1]/F-PLN/right-4", "");
setprop("/MCDU[1]/F-PLN/right-5", "");
setprop("/MCDU[1]/F-PLN/right-6", "");
setprop("/MCDU[1]/F-PLN/left-1c", "w");
setprop("/MCDU[1]/F-PLN/left-2c", "w");
setprop("/MCDU[1]/F-PLN/left-3c", "w");
setprop("/MCDU[1]/F-PLN/left-4c", "w");
setprop("/MCDU[1]/F-PLN/left-5c", "w");
setprop("/MCDU[1]/F-PLN/left-6c", "w");
setprop("/MCDU[1]/F-PLN/center-1c", "w");
setprop("/MCDU[1]/F-PLN/center-2c", "w");
setprop("/MCDU[1]/F-PLN/center-3c", "w");
setprop("/MCDU[1]/F-PLN/center-4c", "w");
setprop("/MCDU[1]/F-PLN/center-5c", "w");
setprop("/MCDU[1]/F-PLN/center-6c", "w");
setprop("/MCDU[1]/F-PLN/right-1c", "w");
setprop("/MCDU[1]/F-PLN/right-2c", "w");
setprop("/MCDU[1]/F-PLN/right-3c", "w");
setprop("/MCDU[1]/F-PLN/right-4c", "w");
setprop("/MCDU[1]/F-PLN/right-5c", "w");
setprop("/MCDU[1]/F-PLN/right-6c", "w");

var discontinuity = "---- F-PLN  DISCONTINUITY ----";
var fpln_end =      "-------  END OF F-PLN  -------";
var altn_fpln_end = "----- END OF  ALTN F-PLN -----";

var r1_active_out = props.globals.getNode("/FMGC/flightplan/r1/active");

var updateFPLN = func(i) {
	if (r1_active_out.getBoolValue()) {
		
	} else {
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-1", fpln_end);
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-2", altn_fpln_end);
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-3", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-4", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-5", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-6", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-1c", "w");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-2c", "w");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-3c", "w");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-4c", "w");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-5c", "w");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-6c", "w");
	}
}
