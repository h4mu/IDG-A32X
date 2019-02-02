# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

# wht = white, grn = green, blu = blue, amb = amber, yel = yellow
setprop("/MCDU[0]/F-PLN/left-1", "");
setprop("/MCDU[0]/F-PLN/left-1s", "");
setprop("/MCDU[0]/F-PLN/left-2", "");
setprop("/MCDU[0]/F-PLN/left-2s", "");
setprop("/MCDU[0]/F-PLN/left-3", "");
setprop("/MCDU[0]/F-PLN/left-3s", "");
setprop("/MCDU[0]/F-PLN/left-4", "");
setprop("/MCDU[0]/F-PLN/left-4s", "");
setprop("/MCDU[0]/F-PLN/left-5", "");
setprop("/MCDU[0]/F-PLN/left-5s", "");
setprop("/MCDU[0]/F-PLN/left-6", "");
setprop("/MCDU[0]/F-PLN/left-6s", "");
setprop("/MCDU[0]/F-PLN/line-1c", "wht");
setprop("/MCDU[0]/F-PLN/line-2c", "wht");
setprop("/MCDU[0]/F-PLN/line-3c", "wht");
setprop("/MCDU[0]/F-PLN/line-4c", "wht");
setprop("/MCDU[0]/F-PLN/line-5c", "wht");
setprop("/MCDU[0]/F-PLN/line-6c", "wht");

setprop("/MCDU[1]/F-PLN/left-1", "");
setprop("/MCDU[1]/F-PLN/left-1s", "");
setprop("/MCDU[1]/F-PLN/left-2", "");
setprop("/MCDU[1]/F-PLN/left-2s", "");
setprop("/MCDU[1]/F-PLN/left-3", "");
setprop("/MCDU[1]/F-PLN/left-3s", "");
setprop("/MCDU[1]/F-PLN/left-4", "");
setprop("/MCDU[1]/F-PLN/left-4s", "");
setprop("/MCDU[1]/F-PLN/left-5", "");
setprop("/MCDU[1]/F-PLN/left-5s", "");
setprop("/MCDU[1]/F-PLN/left-6", "");
setprop("/MCDU[1]/F-PLN/left-6s", "");
setprop("/MCDU[1]/F-PLN/line-1c", "wht");
setprop("/MCDU[1]/F-PLN/line-2c", "wht");
setprop("/MCDU[1]/F-PLN/line-3c", "wht");
setprop("/MCDU[1]/F-PLN/line-4c", "wht");
setprop("/MCDU[1]/F-PLN/line-5c", "wht");
setprop("/MCDU[1]/F-PLN/line-6c", "wht");

var discontinuity =    "---F-PLN DISCONTINUITY--";
var fpln_end =         "------END OF F-PLN------";
var altn_fpln_end =    "----END OF ALTN F-PLN---";
var no_altn_fpln_end = "------NO ALTN F-PLN-----";

var r1_active_out = props.globals.getNode("/FMGC/flightplan/r1/active");

var updateFPLN = func(i) {
	if (r1_active_out.getBoolValue()) {
		
	} else {
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-1", discontinuity);
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-1s", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-2", fpln_end);
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-2s", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-3", no_altn_fpln_end);
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-3s", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-4", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-4s", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-5", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-5s", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-6", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/left-6s", "");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/line-1c", "wht");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/line-2c", "wht");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/line-3c", "wht");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/line-4c", "wht");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/line-5c", "wht");
		setprop("/MCDU[" ~ i ~ "]/F-PLN/line-6c", "wht");
	}
}
