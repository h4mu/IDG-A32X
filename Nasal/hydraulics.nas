# A320 Hydraulic System
# Joshua Davidson (it0uchpods)

#############
# Init Vars #
#############

var hyd_init = func {
	setprop("/controls/hydraulic/eng1-pump", 0);
	setprop("/controls/hydraulic/eng2-pump", 0);
	setprop("/controls/hydraulic/elec-pump-blue", 0);
	setprop("/controls/hydraulic/elec-pump-yellow", 0);
	setprop("/controls/hydraulic/ptu", 1);
	setprop("/controls/hydraulic/rat-man", 0);
	setprop("/controls/hydraulic/rat", 0);
	setprop("/controls/hydraulic/rat-deployed", 0);
	setprop("/systems/hydraulic/ptu-active", 0);
	setprop("/systems/hydraulic/blue-psi", 0);
	setprop("/systems/hydraulic/green-psi", 0);
	setprop("/systems/hydraulic/yellow-psi", 0);
	hyd_timer.start();
}

#######################
# Main Hydraulic Loop #
#######################

var master_hyd = func {
	var eng1_pump_sw = getprop("/controls/hydraulic/eng1-pump");
	var eng2_pump_sw = getprop("/controls/hydraulic/eng2-pump");
	var elec_pump_blue_sw = getprop("/controls/hydraulic/elec-pump-blue");
	var elec_pump_yellow_sw = getprop("/controls/hydraulic/elec-pump-yellow");
	var ptu_sw = getprop("/controls/hydraulic/ptu");
	var rat_man_sw = getprop("/controls/hydraulic/rat-man");
	var blue_psi = getprop("/systems/hydraulic/blue-psi");
	var green_psi = getprop("/systems/hydraulic/green-psi");
	var yellow_psi = getprop("/systems/hydraulic/yellow-psi");
	var rpmapu = getprop("/systems/apu/rpm");
	var stateL = getprop("/engines/engine[0]/state");
	var stateR = getprop("/engines/engine[1]/state");
	var dc_ess = getprop("/systems/electrical/bus/dc-ess");
	var psi_diff = green_psi - yellow_psi;
	var rat = getprop("/controls/hydraulic/rat");
	var ratout = getprop("/controls/hydraulic/rat-deployed");
	var gs = getprop("/velocities/groundspeed-kt");
	
	if (psi_diff > 500 or psi_diff < -500 and ptu_sw) {
		setprop("/systems/hydraulic/ptu-active", 1);
	} else if (psi_diff < 20 and psi_diff > -20) {
		setprop("/systems/hydraulic/ptu-active", 0);
	}

	if ((rat_man_sw == 1) and (gs > 100)) {
		setprop("/controls/hydraulic/rat", 1);
		setprop("/controls/hydraulic/rat-deployed", 1);
	} else if (gs < 100) {
		setprop("/controls/hydraulic/rat", 0);
	}
	
	var ptu_active = getprop("/systems/hydraulic/ptu-active");
	
	if (elec_pump_blue_sw and dc_ess >= 25 and (stateL == 3 or stateR == 3)) {
		if (blue_psi < 2900) {
			setprop("/systems/hydraulic/blue-psi", blue_psi + 100);
		} else {
			setprop("/systems/hydraulic/blue-psi", 3000);
		}
	} else if (gs >= 100 and rat) {
		if (blue_psi < 2400) {
			setprop("/systems/hydraulic/blue-psi", blue_psi + 100);
		} else {
			setprop("/systems/hydraulic/blue-psi", 2500);
		}
	} else {
		if (blue_psi > 1) {
			setprop("/systems/hydraulic/blue-psi", blue_psi - 50);
		} else {
			setprop("/systems/hydraulic/blue-psi", 0);
		}
	}
	
	if (eng1_pump_sw and stateL == 3) {
		if (green_psi < 2900) {
			setprop("/systems/hydraulic/green-psi", green_psi + 100);
		} else {
			setprop("/systems/hydraulic/green-psi", 3000);
		}
	} else if (ptu_active and stateL != 3) {
		if (green_psi < 2900) {
			setprop("/systems/hydraulic/green-psi", green_psi + 100);
		} else {
			setprop("/systems/hydraulic/green-psi", 3000);
		}
	} else {
		if (green_psi > 1) {
			setprop("/systems/hydraulic/green-psi", green_psi - 50);
		} else {
			setprop("/systems/hydraulic/green-psi", 0);
		}
	}
	
	if (eng2_pump_sw and stateR == 3) {
		if (yellow_psi < 2900) {
			setprop("/systems/hydraulic/yellow-psi", yellow_psi + 100);
		} else {
			setprop("/systems/hydraulic/yellow-psi", 3000);
		}
	} else if (elec_pump_yellow_sw and dc_ess >= 25) {
		if (yellow_psi < 2900) {
			setprop("/systems/hydraulic/yellow-psi", yellow_psi + 100);
		} else {
			setprop("/systems/hydraulic/yellow-psi", 3000);
		}
	} else if (ptu_active and stateR != 3) {
		if (yellow_psi < 2900) {
			setprop("/systems/hydraulic/yellow-psi", yellow_psi + 100);
		} else {
			setprop("/systems/hydraulic/yellow-psi", 3000);
		}
	} else {
		if (yellow_psi > 1) {
			setprop("/systems/hydraulic/yellow-psi", yellow_psi - 50);
		} else {
			setprop("/systems/hydraulic/yellow-psi", 0);
		}
	}
}

#######################
# Various Other Stuff #
#######################

setlistener("/controls/gear/gear-down", func {
	var down = getprop("/controls/gear/gear-down");
	if (!down and (getprop("/gear/gear[0]/wow") or getprop("/gear/gear[1]/wow") or getprop("/gear/gear[2]/wow"))) {
		setprop("/controls/gear/gear-down", 1);
	}
});

###################
# Update Function #
###################

var update_hydraulic = func {
	master_hyd();
}

var hyd_timer = maketimer(0.2, update_hydraulic);
