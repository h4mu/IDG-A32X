# A3XX PFD

# Copyright (c) 2019 Joshua Davidson (Octal450)

var PFD_1 = nil;
var PFD_2 = nil;
var PFD_1_test = nil;
var PFD_2_test = nil;
var PFD_1_mismatch = nil;
var PFD_2_mismatch = nil;
var PFD1_display = nil;
var PFD2_display = nil;
var updateL = 0;
var updateR = 0;
var elapsedtime = 0;
var ASI = 0;
var ASItrgt = 0;
var ASItrgtdiff = 0;
var ASImax = 0;
var ASItrend = 0;
var altTens = 0;
var altPolarity = "";

# Fetch nodes:
var state1 = props.globals.getNode("/systems/thrust/state1", 1);
var state2 = props.globals.getNode("/systems/thrust/state2", 1);
var throttle_mode = props.globals.getNode("/modes/pfd/fma/throttle-mode", 1);
var pitch_mode = props.globals.getNode("/modes/pfd/fma/pitch-mode", 1);
var pitch_mode_armed = props.globals.getNode("/modes/pfd/fma/pitch-mode-armed", 1);
var pitch_mode2_armed = props.globals.getNode("/modes/pfd/fma/pitch-mode2-armed", 1);
var pitch_mode_armed_box = props.globals.getNode("/modes/pfd/fma/pitch-mode-armed-box", 1);
var pitch_mode2_armed_box = props.globals.getNode("/modes/pfd/fma/pitch-mode2-armed-box", 1);
var roll_mode = props.globals.getNode("/modes/pfd/fma/roll-mode", 1);
var roll_mode_armed = props.globals.getNode("/modes/pfd/fma/roll-mode-armed", 1);
var roll_mode_box = props.globals.getNode("/modes/pfd/fma/roll-mode-box", 1);
var roll_mode_armed_box = props.globals.getNode("/modes/pfd/fma/roll-mode-armed-box", 1);
var thr1 = props.globals.getNode("/controls/engines/engine[0]/throttle-pos", 1);
var thr2 = props.globals.getNode("/controls/engines/engine[1]/throttle-pos", 1);
var wow0 = props.globals.getNode("/gear/gear[0]/wow");
var wow1 = props.globals.getNode("/gear/gear[1]/wow");
var wow2 = props.globals.getNode("/gear/gear[2]/wow");
var pitch = props.globals.getNode("/orientation/pitch-deg", 1);
var roll = props.globals.getNode("/orientation/roll-deg", 1);
var elapsedtime = props.globals.getNode("/sim/time/elapsed-sec", 1);
var acess = props.globals.getNode("/systems/electrical/bus/ac-ess", 1);
var ac2 = props.globals.getNode("/systems/electrical/bus/ac2", 1);
var du1_lgt = props.globals.getNode("/controls/lighting/DU/du1", 1);
var du6_lgt = props.globals.getNode("/controls/lighting/DU/du6", 1);
var acconfig = props.globals.getNode("/systems/acconfig/autoconfig-running", 1);
var acconfig_mismatch = props.globals.getNode("/systems/acconfig/mismatch-code", 1);
var cpt_du_xfr = props.globals.getNode("/modes/cpt-du-xfr", 1);
var fo_du_xfr = props.globals.getNode("/modes/fo-du-xfr", 1);
var eng_out = props.globals.getNode("/systems/thrust/eng-out", 1);
var eng0_state = props.globals.getNode("/engines/engine[0]/state", 1);
var eng1_state = props.globals.getNode("/engines/engine[1]/state", 1);
var alpha_floor = props.globals.getNode("/systems/thrust/alpha-floor", 1);
var toga_lk = props.globals.getNode("/systems/thrust/toga-lk", 1);
var thrust_limit = props.globals.getNode("/controls/engines/thrust-limit", 1);
var flex = props.globals.getNode("/FMGC/internal/flex", 1);
var lvr_clb = props.globals.getNode("/systems/thrust/lvrclb", 1);
var throt_box = props.globals.getNode("/modes/pfd/fma/throttle-mode-box", 1);
var pitch_box = props.globals.getNode("/modes/pfd/fma/pitch-mode-box", 1);
var ap_box = props.globals.getNode("/modes/pfd/fma/ap-mode-box", 1);
var fd_box  = props.globals.getNode("/modes/pfd/fma/fd-mode-box", 1);
var at_box = props.globals.getNode("/modes/pfd/fma/athr-mode-box", 1);
var fbw_law = props.globals.getNode("/it-fbw/law", 1);
var ap_mode = props.globals.getNode("/modes/pfd/fma/ap-mode", 1);
var fd_mode = props.globals.getNode("/modes/pfd/fma/fd-mode", 1);
var at_mode = props.globals.getNode("/modes/pfd/fma/at-mode", 1);
var alt_std_mode = props.globals.getNode("/modes/altimeter/std", 1);
var alt_inhg_mode = props.globals.getNode("/modes/altimeter/inhg", 1);
var alt_hpa = props.globals.getNode("/instrumentation/altimeter/setting-hpa", 1);
var alt_inhg = props.globals.getNode("/instrumentation/altimeter/setting-inhg", 1);
var altitude = props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft", 1);
var altitude_pfd = props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft-pfd", 1);
var alt_diff = props.globals.getNode("/instrumentation/pfd/alt-diff", 1);
var ap_alt = props.globals.getNode("/it-autoflight/internal/alt", 1);
var vs_needle = props.globals.getNode("/instrumentation/pfd/vs-needle", 1);
var vs_digit = props.globals.getNode("/instrumentation/pfd/vs-digit-trans", 1);
var ap_vs_pfd = props.globals.getNode("/it-autoflight/internal/vert-speed-fpm-pfd", 1);
var athr_arm = props.globals.getNode("/modes/pfd/fma/athr-armed", 1);
var FMGC_max_spd = props.globals.getNode("/FMGC/internal/maxspeed", 1);
var ind_spd_kt = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt", 1);
var ind_spd_mach = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach", 1);
var at_mach_mode = props.globals.getNode("/it-autoflight/input/kts-mach", 1);
var at_input_spd_mach = props.globals.getNode("/it-autoflight/input/spd-mach", 1);
var at_input_spd_kts = props.globals.getNode("/it-autoflight/input/spd-kts", 1);
var fd_roll = props.globals.getNode("/it-autoflight/fd/roll-bar", 1);
var fd_pitch = props.globals.getNode("/it-autoflight/fd/pitch-bar", 1);
var decision = props.globals.getNode("/instrumentation/mk-viii/inputs/arinc429/decision-height", 1);
var slip_skid = props.globals.getNode("/instrumentation/pfd/slip-skid", 1);
var FMGCphase = props.globals.getNode("/FMGC/status/phase", 1);
var loc = props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm", 1);
var gs = props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm", 1);
var show_hdg = props.globals.getNode("/it-autoflight/custom/show-hdg", 1);
var ap_hdg = props.globals.getNode("/it-autoflight/input/hdg", 1);
var ap_trk_sw = props.globals.getNode("/it-autoflight/custom/trk-fpa", 1);
var ap_ils_mode = props.globals.getNode("/modes/pfd/ILS1", 1);
var ap_ils_mode2 = props.globals.getNode("/modes/pfd/ILS2", 1);
var loc_in_range = props.globals.getNode("/instrumentation/nav[0]/in-range", 1);
var gs_in_range = props.globals.getNode("/instrumentation/nav[0]/gs-in-range", 1);
var nav0_signalq = props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm", 1);
var hasloc = props.globals.getNode("/instrumentation/nav[0]/nav-loc", 1);
var hasgs = props.globals.getNode("/instrumentation/nav[0]/has-gs", 1);
var pfdrate = props.globals.getNode("/systems/acconfig/options/pfd-rate", 1);
var managed_spd = props.globals.getNode("/it-autoflight/input/spd-managed", 1);
var at_tgt_ias = props.globals.getNode("/FMGC/internal/target-ias-pfd", 1);
var ap1 = props.globals.getNode("/it-autoflight/output/ap1", 1);
var ap2 = props.globals.getNode("/it-autoflight/output/ap2", 1);
var fd1 = props.globals.getNode("/it-autoflight/output/fd1", 1);
var fd2 = props.globals.getNode("/it-autoflight/output/fd2", 1);
var athr = props.globals.getNode("/it-autoflight/output/athr", 1);
var gear_agl = props.globals.getNode("/position/gear-agl-ft", 1);
var aileron_input = props.globals.getNode("/controls/flight/aileron-input-fast", 1);
var elevator_input = props.globals.getNode("/controls/flight/elevator-input-fast", 1);
var adirs0_active = props.globals.getNode("/instrumentation/adirs/adr[0]/active", 1);
var adirs1_active = props.globals.getNode("/instrumentation/adirs/adr[1]/active", 1);
var adirs2_active = props.globals.getNode("/instrumentation/adirs/adr[2]/active", 1);
var ir0_aligned = props.globals.getNode("/instrumentation/adirs/ir[0]/aligned", 1);
var ir1_aligned = props.globals.getNode("/instrumentation/adirs/ir[1]/aligned", 1);
var ir2_aligned = props.globals.getNode("/instrumentation/adirs/ir[2]/aligned", 1);
var att_switch = props.globals.getNode("/controls/switching/ATTHDG", 1);
var air_switch = props.globals.getNode("/controls/switching/AIRDATA", 1);

# Create Nodes:
var vs_needle = props.globals.initNode("/instrumentation/pfd/vs-needle", 0.0, "DOUBLE");
var vs_needle_trans = props.globals.initNode("/instrumentation/pfd/vs-digit-trans", 0.0, "DOUBLE");
var alt_diff = props.globals.initNode("/instrumentation/pfd/alt-diff", 0.0, "DOUBLE");
var heading = props.globals.initNode("/instrumentation/pfd/heading-deg", 0.0, "DOUBLE");
var horizon_pitch = props.globals.initNode("/instrumentation/pfd/horizon-pitch", 0.0, "DOUBLE");
var horizon_ground = props.globals.initNode("/instrumentation/pfd/horizon-ground", 0.0, "DOUBLE");
var hdg_diff = props.globals.initNode("/instrumentation/pfd/hdg-diff", 0.0, "DOUBLE");
var hdg_scale = props.globals.initNode("/instrumentation/pfd/heading-scale", 0.0, "DOUBLE");
var track = props.globals.initNode("/instrumentation/pfd/track-deg", 0.0, "DOUBLE");
var track_diff = props.globals.initNode("/instrumentation/pfd/track-hdg-diff", 0.0, "DOUBLE");
var speed_pred = props.globals.initNode("/instrumentation/pfd/speed-lookahead", 0.0, "DOUBLE");
var du1_test = props.globals.initNode("/instrumentation/du/du1-test", 0, "BOOL");
var du1_test_time = props.globals.initNode("/instrumentation/du/du1-test-time", 0.0, "DOUBLE");
var du1_test_amount = props.globals.initNode("/instrumentation/du/du1-test-amount", 0.0, "DOUBLE");
var du2_test = props.globals.initNode("/instrumentation/du/du2-test", 0, "BOOL");
var du2_test_time = props.globals.initNode("/instrumentation/du/du2-test-time", 0.0, "DOUBLE");
var du2_test_amount = props.globals.initNode("/instrumentation/du/du2-test-amount", 0.0, "DOUBLE");
var du5_test = props.globals.initNode("/instrumentation/du/du5-test", 0, "BOOL");
var du5_test_time = props.globals.initNode("/instrumentation/du/du5-test-time", 0.0, "DOUBLE");
var du5_test_amount = props.globals.initNode("/instrumentation/du/du5-test-amount", 0.0, "DOUBLE");
var du6_test = props.globals.initNode("/instrumentation/du/du6-test", 0, "BOOL");
var du6_test_time = props.globals.initNode("/instrumentation/du/du6-test-time", 0.0, "DOUBLE");
var du6_test_amount = props.globals.initNode("/instrumentation/du/du6-test-amount", 0.0, "DOUBLE");

var canvas_PFD_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});

		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);

			var clip_el = canvas_group.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tran_rect = clip_el.getTransformedBounds();

				var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
				tran_rect[1], # 0 ys
				tran_rect[2], # 1 xe
				tran_rect[3], # 2 ye
				tran_rect[0]); #3 xs
				#   coordinates are top,right,bottom,left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		me.AI_horizon_trans = me["AI_horizon"].createTransform();
		me.AI_horizon_rot = me["AI_horizon"].createTransform();
		
		me.AI_horizon_ground_trans = me["AI_horizon_ground"].createTransform();
		me.AI_horizon_ground_rot = me["AI_horizon_ground"].createTransform();
		
		me.AI_horizon_sky_rot = me["AI_horizon_sky"].createTransform();
		
		me.AI_horizon_hdg_trans = me["AI_heading"].createTransform();
		me.AI_horizon_hdg_rot = me["AI_heading"].createTransform();

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return ["FMA_man","FMA_manmode","FMA_flxtemp","FMA_thrust","FMA_lvrclb","FMA_pitch","FMA_pitcharm","FMA_pitcharm2","FMA_roll","FMA_rollarm","FMA_combined","FMA_ctr_msg","FMA_catmode","FMA_cattype","FMA_nodh","FMA_dh","FMA_dhn","FMA_ap","FMA_fd","FMA_athr",
		"FMA_man_box","FMA_flx_box","FMA_thrust_box","FMA_pitch_box","FMA_pitcharm_box","FMA_roll_box","FMA_rollarm_box","FMA_combined_box","FMA_catmode_box","FMA_cattype_box","FMA_cat_box","FMA_dh_box","FMA_ap_box","FMA_fd_box","FMA_athr_box","FMA_Middle1",
		"FMA_Middle2","ASI_max","ASI_scale","ASI_target","ASI_mach","ASI_mach_decimal","ASI_trend_up","ASI_trend_down","ASI_digit_UP","ASI_digit_DN","ASI_decimal_UP","ASI_decimal_DN","ASI_index","ASI_error","ASI_group","ASI_frame","AI_center","AI_bank",
		"AI_bank_lim","AI_bank_lim_X","AI_pitch_lim","AI_pitch_lim_X","AI_slipskid","AI_horizon","AI_horizon_ground","AI_horizon_sky","AI_stick","AI_stick_pos","AI_heading","AI_agl_g","AI_agl","AI_error","AI_group","FD_roll","FD_pitch","ALT_scale","ALT_target",
		"ALT_target_digit","ALT_one","ALT_two","ALT_three","ALT_four","ALT_five","ALT_digits","ALT_tens","ALT_digit_UP","ALT_digit_DN","ALT_error","ALT_group","ALT_group2","ALT_frame","VS_pointer","VS_box","VS_digit","VS_error","VS_group","QNH","QNH_setting",
		"QNH_std","QNH_box","LOC_pointer","LOC_scale","GS_scale","GS_pointer","CRS_pointer","HDG_target","HDG_scale","HDG_one","HDG_two","HDG_three","HDG_four","HDG_five","HDG_six","HDG_seven","HDG_digit_L","HDG_digit_R","HDG_error","HDG_group","HDG_frame",
		"TRK_pointer"];
	},
	update: func() {
		elapsedtime_act = elapsedtime.getValue();
		if (acess.getValue() >= 110) {
			if (wow0.getValue() == 1) {
				if (acconfig.getValue() != 1 and du1_test.getValue() != 1) {
					du1_test.setValue(1);
					du1_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
					du1_test_time.setValue(elapsedtime_act);
				} else if (acconfig.getValue() == 1 and du1_test.getValue() != 1) {
					du1_test.setValue(1);
					du1_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
					du1_test_time.setValue(elapsedtime_act - 30);
				}
			} else {
				du1_test.setValue(1);
				du1_test_amount.setValue(0);
				du1_test_time.setValue(-100);
			}
		} else {
			du1_test.setValue(0);
		}
		
		if (ac2.getValue() >= 110) {
			if (wow0.getValue() == 1) {
				if (acconfig.getValue() != 1 and du6_test.getValue() != 1) {
					du6_test.setValue(1);
					du6_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
					du6_test_time.setValue(elapsedtime_act);
				} else if (acconfig.getValue() == 1 and du6_test.getValue() != 1) {
					du6_test.setValue(1);
					du6_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
					du6_test_time.setValue(elapsedtime_act - 30);
				}
			} else {
				du6_test.setValue(1);
				du6_test_amount.setValue(0);
				du6_test_time.setValue(-100);
			}
		} else {
			du6_test.setValue(0);
		}
		
		if (acconfig_mismatch.getValue() == "0x000") {
			PFD_1_mismatch.page.hide();
			PFD_2_mismatch.page.hide();
			if (acess.getValue() >= 110 and du1_lgt.getValue() > 0.01) {
				if (du1_test_time.getValue() + du1_test_amount.getValue() >= elapsedtime_act and cpt_du_xfr.getValue() != 1) {
					PFD_1_test.update();
					updateL = 0;
					PFD_1.page.hide();
					PFD_1_test.page.show();
				} else if (du2_test_time.getValue() + du2_test_amount.getValue() >= elapsedtime_act and cpt_du_xfr.getValue() == 1) {
					PFD_1_test.update();
					updateL = 0;
					PFD_1.page.hide();
					PFD_1_test.page.show();
				} else {
					PFD_1.updateFast();
					PFD_1.update();
					updateL = 1;
					PFD_1_test.page.hide();
					PFD_1.page.show();
				}
			} else {
				updateL = 0;
				PFD_1_test.page.hide();
				PFD_1.page.hide();
			}
			if (ac2.getValue() >= 110 and du6_lgt.getValue() > 0.01) {
				if (du6_test_time.getValue() + du6_test_amount.getValue() >= elapsedtime_act and fo_du_xfr.getValue() != 1) {
					PFD_2_test.update();
					updateR = 0;
					PFD_2.page.hide();
					PFD_2_test.page.show();
				} else if (du5_test_time.getValue() + du5_test_amount.getValue() >= elapsedtime_act and fo_du_xfr.getValue() == 1) {
					PFD_2_test.update();
					updateR = 0;
					PFD_2.page.hide();
					PFD_2_test.page.show();
				} else {
					PFD_2.updateFast();
					PFD_2.update();
					updateR = 1;
					PFD_2_test.page.hide();
					PFD_2.page.show();
				}
			} else {
				updateR = 0;
				PFD_2_test.page.hide();
				PFD_2.page.hide();
			}
		} else {
			updateL = 0;
			updateR = 0;
			PFD_1_test.page.hide();
			PFD_1.page.hide();
			PFD_2_test.page.hide();
			PFD_2.page.hide();
			PFD_1_mismatch.update();
			PFD_2_mismatch.update();
			PFD_1_mismatch.page.show();
			PFD_2_mismatch.page.show();
		}
	},
	updateSlow: func() {
		if (updateL) {
			PFD_1.update();
		}
		if (updateR) {
			PFD_2.update();
		}
	},
	updateCommon: func () {
		# FMA MAN TOGA MCT FLX THR
		# Set properties used a lot to a variable to avoid calling getValue() multiple times
		state1_act = state1.getValue();
		state2_act = state2.getValue();
		thrust_limit_act = thrust_limit.getValue();
		alpha_floor_act = alpha_floor.getValue();
		toga_lk_act = toga_lk.getValue();
		thr1_act = thr1.getValue();
		thr2_act = thr2.getValue();
		if (athr.getValue() == 1 and (state1_act == "TOGA" or state1_act == "MCT" or state1_act == "MAN THR" or state2_act == "TOGA" or state2_act == "MCT" or state2_act == "MAN THR") and eng_out.getValue() != 1 and alpha_floor_act != 1 and 
		toga_lk_act != 1) {
			me["FMA_man"].show();
			me["FMA_manmode"].show();
			if (state1_act == "TOGA" or state2_act == "TOGA") {
				me["FMA_flx_box"].hide();
				me["FMA_flxtemp"].hide();
				me["FMA_man_box"].show();
				me["FMA_manmode"].setText("TOGA");
				me["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
			} else if ((state1_act == "MAN THR" and thr1_act >= 0.83) or (state2_act == "MAN THR" and thr2_act >= 0.83)) {
				me["FMA_flx_box"].hide();
				me["FMA_flxtemp"].hide();
				me["FMA_man_box"].show();
				me["FMA_manmode"].setText("THR");
				me["FMA_man_box"].setColor(0.7333,0.3803,0);
			} else if ((state1_act == "MCT" or state2_act == "MCT") and thrust_limit_act != "FLX") {
				me["FMA_flx_box"].hide();
				me["FMA_flxtemp"].hide();
				me["FMA_man_box"].show();
				me["FMA_manmode"].setText("MCT");
				me["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
			} else if ((state1_act == "MCT" or state2_act == "MCT") and thrust_limit_act == "FLX") {
				me["FMA_flxtemp"].setText(sprintf("%s", "+" ~ flex.getValue()));
				me["FMA_man_box"].hide();
				me["FMA_flx_box"].show();
				me["FMA_flxtemp"].show();
				me["FMA_manmode"].setText("FLX            ");
				me["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
			} else if ((state1_act == "MAN THR" and thr1_act < 0.83) or (state2_act == "MAN THR" and thr2_act < 0.83)) {
				me["FMA_flx_box"].hide();
				me["FMA_flxtemp"].hide();
				me["FMA_man_box"].show();
				me["FMA_manmode"].setText("THR");
				me["FMA_man_box"].setColor(0.7333,0.3803,0);
			}
		} else if (athr.getValue() == 1 and (state1_act == "TOGA" or (state1_act == "MCT" and thrust_limit_act == "FLX") or (state1_act == "MAN THR" and thr1_act >= 0.83) or state2_act == "TOGA" or (state2_act == "MCT" and 
		thrust_limit_act == "FLX") or (state2_act == "MAN THR" and thr2_act >= 0.83)) and eng_out.getValue() == 1 and alpha_floor_act != 1 and toga_lk_act != 1) {
			me["FMA_man"].show();
			me["FMA_manmode"].show();
			if (state1_act == "TOGA" or state2_act == "TOGA") {
				me["FMA_flx_box"].hide();
				me["FMA_flxtemp"].hide();
				me["FMA_man_box"].show();
				me["FMA_manmode"].setText("TOGA");
				me["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
			} else if ((state1_act == "MAN THR" and thr1_act >= 0.83) or (state2_act == "MAN THR" and thr2_act >= 0.83)) {
				me["FMA_flx_box"].hide();
				me["FMA_flxtemp"].hide();
				me["FMA_man_box"].show();
				me["FMA_manmode"].setText("THR");
				me["FMA_man_box"].setColor(0.7333,0.3803,0);
			} else if ((state1_act == "MCT" or state2_act == "MCT") and thrust_limit_act == "FLX") {
				me["FMA_flxtemp"].setText(sprintf("%s", "+" ~ flex.getValue()));
				me["FMA_man_box"].hide();
				me["FMA_flx_box"].show();
				me["FMA_flxtemp"].show();
				me["FMA_manmode"].setText("FLX            ");
				me["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
			}
		} else {
			me["FMA_man"].hide();
			me["FMA_manmode"].hide();
			me["FMA_man_box"].hide();
			me["FMA_flx_box"].hide();
			me["FMA_flxtemp"].hide();
		}
		
		if ((state1_act == "CL" and state2_act != "CL") or (state1_act != "CL" and state2_act == "CL") and eng_out.getValue() != 1) {
			me["FMA_lvrclb"].setText("LVR ASYM");
		} else {
			if (eng_out.getValue() == 1) {
				me["FMA_lvrclb"].setText("LVR MCT");
			} else {
				me["FMA_lvrclb"].setText("LVR CLB");
			}
		}
		
		if (athr.getValue() == 1 and lvr_clb.getValue() == 1) {
			me["FMA_lvrclb"].show();
		} else {
			me["FMA_lvrclb"].hide();
		}
	
		# FMA A/THR
		if (alpha_floor_act != 1 and toga_lk_act != 1) {
			if (athr.getValue() == 1 and eng_out.getValue() != 1 and (state1_act == "MAN" or state1_act == "CL") and (state2_act == "MAN" or state2_act == "CL")) {
				me["FMA_thrust"].show();
				if (throt_box.getValue() == 1 and throttle_mode.getValue() != " ") {
					me["FMA_thrust_box"].show();
				} else {
					me["FMA_thrust_box"].hide();
				}
			} else if (athr.getValue() == 1 and eng_out.getValue() == 1 and (state1_act == "MAN" or state1_act == "CL" or (state1_act == "MAN THR" and thr1_act < 0.83) or (state1_act == "MCT" and thrust_limit_act != "FLX")) and 
			(state2_act == "MAN" or state2_act == "CL" or (state2_act == "MAN THR" and thr2_act < 0.83) or (state2_act == "MCT" and thrust_limit_act != "FLX"))) {
				me["FMA_thrust"].show();
				if (throt_box.getValue() == 1 and throttle_mode.getValue() != " ") {
					me["FMA_thrust_box"].show();
				} else {
					me["FMA_thrust_box"].hide();
				}
			} else {
				me["FMA_thrust"].hide();
				me["FMA_thrust_box"].hide();
			}
		} else {
			me["FMA_thrust"].show();
			me["FMA_thrust_box"].show();
		}
		
		if (alpha_floor_act == 1) {
			me["FMA_thrust"].setText("A.FLOOR");
			me["FMA_thrust_box"].setColor(0.7333,0.3803,0);
		} else if (toga_lk_act == 1) {
			me["FMA_thrust"].setText("TOGA LK");
			me["FMA_thrust_box"].setColor(0.7333,0.3803,0);
		} else {
			me["FMA_thrust"].setText(sprintf("%s", throttle_mode.getValue()));
			me["FMA_thrust_box"].setColor(0.8078,0.8039,0.8078);
		}
		
		# FMA Pitch Roll Common
		pitch_mode_act = pitch_mode.getValue(); # only call getValue once per loop, not multiple times
		pitch_mode_armed_act = pitch_mode_armed.getValue();
		pitch_mode2_armed_act = pitch_mode2_armed.getValue();
		roll_mode_act = roll_mode.getValue();
		roll_mode_armed_act = roll_mode_armed.getValue();
		fbw_curlaw = fbw_law.getValue();
		me["FMA_combined"].setText(sprintf("%s", pitch_mode_act));
		
		if (pitch_mode_act == "LAND" or pitch_mode_act == "FLARE" or pitch_mode_act == "ROLL OUT") {
			me["FMA_pitch"].hide();
			me["FMA_roll"].hide();
			me["FMA_pitch_box"].hide();
			me["FMA_roll_box"].hide();
			me["FMA_pitcharm_box"].hide();
			me["FMA_rollarm_box"].hide();
			me["FMA_Middle1"].hide();
			me["FMA_Middle2"].hide();
			if (fbw_curlaw == 2) {
				me["FMA_ctr_msg"].setText("USE MAN PITCH TRIM");
				me["FMA_ctr_msg"].setColor(0.7333,0.3803,0);
				me["FMA_ctr_msg"].show();
			} else if (fbw_curlaw == 3) {
				me["FMA_ctr_msg"].setText("MAN PITCH TRIM ONLY");
				me["FMA_ctr_msg"].setColor(1,0,0);
				me["FMA_ctr_msg"].show();
			} else {
				me["FMA_ctr_msg"].hide();
			}
			me["FMA_combined"].show();
			if (pitch_box.getValue() == 1 and pitch_mode_act != " ") {
				me["FMA_combined_box"].show();
			} else {
				me["FMA_combined_box"].hide();
			}
		} else {
			me["FMA_combined"].hide();
			me["FMA_combined_box"].hide();
			if (fbw_curlaw == 2) {
				me["FMA_ctr_msg"].setText("USE MAN PITCH TRIM");
				me["FMA_ctr_msg"].setColor(0.7333,0.3803,0);
				me["FMA_Middle1"].hide();
				me["FMA_Middle2"].show();
				me["FMA_ctr_msg"].show();
			} else if (fbw_curlaw == 3) {
				me["FMA_ctr_msg"].setText("MAN PITCH TRIM ONLY");
				me["FMA_ctr_msg"].setColor(1,0,0);
				me["FMA_Middle1"].hide();
				me["FMA_Middle2"].show();
				me["FMA_ctr_msg"].show();
			} else {
				me["FMA_ctr_msg"].hide();
				me["FMA_Middle1"].show();
				me["FMA_Middle2"].hide();
			}
			
			if (ap1.getValue() == 1 or ap2.getValue() == 1 or fd1.getValue() == 1 or fd2.getValue() == 1) {
				me["FMA_pitch"].show();
				me["FMA_roll"].show();
			} else {
				me["FMA_pitch"].hide();
				me["FMA_roll"].hide();
			}
			if (pitch_box.getValue() == 1 and pitch_mode_act != " " and (ap1.getValue() == 1 or ap2.getValue() == 1 or fd1.getValue() == 1 or fd2.getValue() == 1)) {
				me["FMA_pitch_box"].show();
			} else {
				me["FMA_pitch_box"].hide();
			}
			if (pitch_mode_armed_act == " " and pitch_mode2_armed_act == " ") {
				me["FMA_pitcharm_box"].hide();
			} else {
				if ((pitch_mode_armed_box.getValue() == 1 or pitch_mode2_armed_box.getValue() == 1) and (ap1.getValue() == 1 or ap2.getValue() == 1 or fd1.getValue() == 1 or fd2.getValue() == 1)) {
					me["FMA_pitcharm_box"].show();
				} else {
					me["FMA_pitcharm_box"].hide();
				}
			}
			if (roll_mode_box.getValue() == 1 and roll_mode_act != " " and (ap1.getValue() == 1 or ap2.getValue() == 1 or fd1.getValue() == 1 or fd2.getValue() == 1)) {
				me["FMA_roll_box"].show();
			} else {
				me["FMA_roll_box"].hide();
			}
			if (roll_mode_armed_box.getValue() == 1 and roll_mode_armed_act != " " and (ap1.getValue() == 1 or ap2.getValue() == 1 or fd1.getValue() == 1 or fd2.getValue() == 1)) {
				me["FMA_rollarm_box"].show();
			} else {
				me["FMA_rollarm_box"].hide();
			}
		}
		
		if (ap1.getValue() == 1 or ap2.getValue() == 1 or fd1.getValue() == 1 or fd2.getValue() == 1) {
			me["FMA_pitcharm"].show();
			me["FMA_pitcharm2"].show();
			me["FMA_rollarm"].show();
		} else {
			me["FMA_pitcharm"].hide();
			me["FMA_pitcharm2"].hide();
			me["FMA_rollarm"].hide();
		}
		
		# FMA Pitch
		me["FMA_pitch"].setText(sprintf("%s", pitch_mode_act));
		me["FMA_pitcharm"].setText(sprintf("%s", pitch_mode_armed_act));
		me["FMA_pitcharm2"].setText(sprintf("%s", pitch_mode2_armed_act));
		
		# FMA Roll
		me["FMA_roll"].setText(sprintf("%s", roll_mode_act));
		me["FMA_rollarm"].setText(sprintf("%s", roll_mode_armed_act));
		
		# FMA CAT DH
		me["FMA_catmode"].hide();
		me["FMA_cattype"].hide();
		me["FMA_catmode_box"].hide();
		me["FMA_cattype_box"].hide();
		me["FMA_cat_box"].hide();
		me["FMA_nodh"].hide();
		me["FMA_dh_box"].hide();
		
		# FMA AP FD ATHR
		me["FMA_ap"].setText(sprintf("%s", ap_mode.getValue()));
		me["FMA_fd"].setText(sprintf("%s", fd_mode.getValue()));
		me["FMA_athr"].setText(sprintf("%s", at_mode.getValue()));
		
		if (athr_arm.getValue() != 1) {
			me["FMA_athr"].setColor(0.8078,0.8039,0.8078);
		} else {
			me["FMA_athr"].setColor(0.0901,0.6039,0.7176);
		}
		
		if (ap_box.getValue() == 1 and ap_mode.getValue() != " ") {
			me["FMA_ap_box"].show();
		} else {
			me["FMA_ap_box"].hide();
		}
		
		if (fd_box.getValue() == 1 and fd_mode.getValue() != " ") {
			me["FMA_fd_box"].show();
		} else {
			me["FMA_fd_box"].hide();
		}
		
		if (at_box.getValue() == 1 and at_mode.getValue() != " ") {
			me["FMA_athr_box"].show();
		} else {
			me["FMA_athr_box"].hide();
		}
		
		# QNH
		if (alt_std_mode.getValue() == 1) {
			me["QNH"].hide();
			me["QNH_setting"].hide();
			me["QNH_std"].show();
			me["QNH_box"].show();
		} else if (alt_inhg_mode.getValue() == 0) {
			me["QNH_setting"].setText(sprintf("%4.0f", alt_hpa.getValue()));
			me["QNH"].show();
			me["QNH_setting"].show();
			me["QNH_std"].hide();
			me["QNH_box"].hide();
		} else if (alt_inhg_mode.getValue() == 1) {
			me["QNH_setting"].setText(sprintf("%2.2f", alt_inhg.getValue()));
			me["QNH"].show();
			me["QNH_setting"].show();
			me["QNH_std"].hide();
			me["QNH_box"].hide();
		}
	},
	updateCommonFast: func() {
		# Airspeed
		ind_spd = ind_spd_kt.getValue();
		# Subtract 30, since the scale starts at 30, but don"t allow less than 0, or more than 420 situations
		if (ind_spd <= 30) {
			ASI = 0;
		} else if (ind_spd >= 420) {
			ASI = 390;
		} else {
			ASI = ind_spd - 30;
		}
		
		FMGC_max = FMGC_max_spd.getValue();
		if (FMGC_max <= 30) {
			ASImax = 0 - ASI;
		} else if (FMGC_max >= 420) {
			ASImax = 390 - ASI;
		} else {
			ASImax = FMGC_max - 30 - ASI;
		}
		
		me["ASI_scale"].setTranslation(0, ASI * 6.6);
		me["ASI_max"].setTranslation(0, ASImax * -6.6);
		
		ind_mach = ind_spd_mach.getValue();
		if (ind_mach >= 0.5) {
			me["ASI_mach_decimal"].show();
			me["ASI_mach"].show();
		} else {
			me["ASI_mach_decimal"].hide();
			me["ASI_mach"].hide();
		}
		
		if (ind_mach >= 0.999) {
			me["ASI_mach"].setText("999");
		} else {
			me["ASI_mach"].setText(sprintf("%3.0f", ind_mach * 1000));
		}
		
		if (managed_spd.getValue() == 1) {
			me["ASI_target"].setColor(0.6901,0.3333,0.7450);
			me["ASI_digit_UP"].setColor(0.6901,0.3333,0.7450);
			me["ASI_decimal_UP"].setColor(0.6901,0.3333,0.7450);
			me["ASI_digit_DN"].setColor(0.6901,0.3333,0.7450);
			me["ASI_decimal_DN"].setColor(0.6901,0.3333,0.7450);
		} else {
			me["ASI_target"].setColor(0.0901,0.6039,0.7176);
			me["ASI_digit_UP"].setColor(0.0901,0.6039,0.7176);
			me["ASI_decimal_UP"].setColor(0.0901,0.6039,0.7176);
			me["ASI_digit_DN"].setColor(0.0901,0.6039,0.7176);
			me["ASI_decimal_DN"].setColor(0.0901,0.6039,0.7176);
		}
		
		tgt_ias = at_tgt_ias.getValue();
		if (tgt_ias <= 30) {
			ASItrgt = 0 - ASI;
		} else if (tgt_ias >= 420) {
			ASItrgt = 390 - ASI;
		} else {
			ASItrgt = tgt_ias - 30 - ASI;
		}
		
		ASItrgtdiff = tgt_ias - ind_spd;
		
		if (ASItrgtdiff >= -42 and ASItrgtdiff <= 42) {
			me["ASI_target"].setTranslation(0, ASItrgt * -6.6);
			me["ASI_digit_UP"].hide();
			me["ASI_decimal_UP"].hide();
			me["ASI_digit_DN"].hide();
			me["ASI_decimal_DN"].hide();
			me["ASI_target"].show();
		} else if (ASItrgtdiff < -42) {
			if (at_mach_mode.getValue() == 1) {
				me["ASI_digit_DN"].setText(sprintf("%3.0f", at_input_spd_mach.getValue() * 1000));
				me["ASI_decimal_UP"].hide();
				me["ASI_decimal_DN"].show();
			} else {
				me["ASI_digit_DN"].setText(sprintf("%3.0f", at_input_spd_kts.getValue()));
				me["ASI_decimal_UP"].hide();
				me["ASI_decimal_DN"].hide();
			}
			me["ASI_digit_DN"].show();
			me["ASI_digit_UP"].hide();
			me["ASI_target"].hide();
		} else if (ASItrgtdiff > 42) {
			if (at_mach_mode.getValue() == 1) {
				me["ASI_digit_UP"].setText(sprintf("%3.0f", at_input_spd_mach.getValue() * 1000));
				me["ASI_decimal_UP"].show();
				me["ASI_decimal_DN"].hide();
			} else {
				me["ASI_digit_UP"].setText(sprintf("%3.0f", at_input_spd_kts.getValue()));
				me["ASI_decimal_UP"].hide();
				me["ASI_decimal_DN"].hide();
			}
			me["ASI_digit_UP"].show();
			me["ASI_digit_DN"].hide();
			me["ASI_target"].hide();
		}
		
		ASItrend = speed_pred.getValue() - ASI;
		me["ASI_trend_up"].setTranslation(0, math.clamp(ASItrend, 0, 50) * -6.6);
		me["ASI_trend_down"].setTranslation(0, math.clamp(ASItrend, -50, 0) * -6.6);
		
		if (ASItrend >= 2) {
			me["ASI_trend_up"].show();
			me["ASI_trend_down"].hide();
		} else if (ASItrend <= -2) {
			me["ASI_trend_down"].show();
			me["ASI_trend_up"].hide();
		} else {
			me["ASI_trend_up"].hide();
			me["ASI_trend_down"].hide();
		}
		
		# Attitude Indicator
		pitch_cur = pitch.getValue();
		roll_cur =  roll.getValue();
		
		me.AI_horizon_trans.setTranslation(0, pitch_cur * 11.825);
		me.AI_horizon_rot.setRotation(-roll_cur * D2R, me["AI_center"].getCenter());
		me.AI_horizon_ground_trans.setTranslation(0, horizon_ground.getValue() * 11.825);
		me.AI_horizon_ground_rot.setRotation(-roll_cur * D2R, me["AI_center"].getCenter());
		me.AI_horizon_sky_rot.setRotation(-roll_cur * D2R, me["AI_center"].getCenter());
		
		me["AI_slipskid"].setTranslation(math.clamp(slip_skid.getValue(), -15, 15) * 7, 0);
		me["AI_bank"].setRotation(-roll_cur * D2R);
		
		if (fbw_law.getValue() == 0) {
			me["AI_bank_lim"].show();
			me["AI_pitch_lim"].show();
			me["AI_bank_lim_X"].hide();
			me["AI_pitch_lim_X"].hide();
		} else {
			me["AI_bank_lim"].hide();
			me["AI_pitch_lim"].hide();
			me["AI_bank_lim_X"].show();
			me["AI_pitch_lim_X"].show();
		}
		
		fd_roll_cur = fd_roll.getValue();
		fd_pitch_cur = fd_pitch.getValue();
		if (fd_roll_cur != nil) {
			me["FD_roll"].setTranslation((fd_roll_cur) * 2.2, 0);
		}
		if (fd_pitch_cur != nil) {
			me["FD_pitch"].setTranslation(0, -(fd_pitch_cur) * 3.8);
		}
		
		gear_agl_cur = gear_agl.getValue();
		
		me["AI_agl"].setText(sprintf("%s", math.round(math.clamp(gear_agl_cur, 0, 2500))));
		
		if (gear_agl_cur <= decision.getValue()) {
			me["AI_agl"].setColor(0.7333,0.3803,0);
		} else {
			me["AI_agl"].setColor(0.0509,0.7529,0.2941);
		}
		
		if (gear_agl_cur <= 2500) {
			me["AI_agl"].show();
		} else {
			me["AI_agl"].hide();
		}
		
		me["AI_agl_g"].setRotation(-roll_cur * D2R);
		
		FMGCphase_act = FMGCphase.getValue();
		if ((wow1.getValue() == 1 or wow2.getValue() == 1) and FMGCphase_act != 0 and FMGCphase_act != 1) {
			me["AI_stick"].show();
			me["AI_stick_pos"].show();
			
		} else if ((wow1.getValue() == 1 or wow2.getValue() == 1) and (FMGCphase_act == 0 or FMGCphase_act == 1) and (eng0_state.getValue() == 3 or eng1_state.getValue() == 3)) {
			me["AI_stick"].show();
			me["AI_stick_pos"].show();
		} else {
			me["AI_stick"].hide();
			me["AI_stick_pos"].hide();
		}
		
		me["AI_stick_pos"].setTranslation(aileron_input.getValue() * 196.8, elevator_input.getValue() * 151.5);
		
		# Altitude
		me.altitude = altitude.getValue();
		me.altOffset = me.altitude / 500 - int(me.altitude / 500);
		me.middleAltText = roundaboutAlt(me.altitude / 100);
		me.middleAltOffset = nil;
		if (me.altOffset > 0.5) {
			me.middleAltOffset = -(me.altOffset - 1) * 243.3424;
		} else {
			me.middleAltOffset = -me.altOffset * 243.3424;
		}
		me["ALT_scale"].setTranslation(0, -me.middleAltOffset);
		me["ALT_scale"].update();
		me["ALT_five"].setText(sprintf("%03d", abs(me.middleAltText+10)));
		me["ALT_four"].setText(sprintf("%03d", abs(me.middleAltText+5)));
		me["ALT_three"].setText(sprintf("%03d", abs(me.middleAltText)));
		me["ALT_two"].setText(sprintf("%03d", abs(me.middleAltText-5)));
		me["ALT_one"].setText(sprintf("%03d", abs(me.middleAltText-10)));
		
		if (altitude.getValue() < 0) {
			altPolarity = "-";
		} else {
			altPolarity = "";
		}
		me["ALT_digits"].setText(sprintf("%s%d", altPolarity, altitude_pfd.getValue()));
		altTens = num(right(sprintf("%02d", altitude.getValue()), 2));
		me["ALT_tens"].setTranslation(0, altTens * 1.392);
		
		ap_alt_cur = ap_alt.getValue();
		alt_diff_cur = alt_diff.getValue();
		if (alt_diff_cur >= -565 and alt_diff_cur <= 565) {
			me["ALT_target"].setTranslation(0, (alt_diff_cur / 100) * -48.66856);
			me["ALT_target_digit"].setText(sprintf("%03d", math.round(ap_alt_cur / 100)));
			me["ALT_digit_UP"].hide();
			me["ALT_digit_DN"].hide();
			me["ALT_target"].show();
		} else if (alt_diff_cur < -565) {
			if (alt_std_mode.getValue() == 1) {
				if (ap_alt_cur < 10000) {
					me["ALT_digit_DN"].setText(sprintf("%s", "FL   " ~ ap_alt_cur / 100));
				} else {
					me["ALT_digit_DN"].setText(sprintf("%s", "FL " ~ ap_alt_cur / 100));
				}
			} else {
				me["ALT_digit_DN"].setText(sprintf("%5.0f", ap_alt_cur));
			}
			me["ALT_digit_DN"].show();
			me["ALT_digit_UP"].hide();
			me["ALT_target"].hide();
		} else if (alt_diff_cur > 565) {
			if (alt_std_mode.getValue() == 1) {
				if (ap_alt_cur < 10000) {
					me["ALT_digit_UP"].setText(sprintf("%s", "FL   " ~ ap_alt_cur / 100));
				} else {
					me["ALT_digit_UP"].setText(sprintf("%s", "FL " ~ ap_alt_cur / 100));
				}
			} else {
				me["ALT_digit_UP"].setText(sprintf("%5.0f", ap_alt_cur));
			}
			me["ALT_digit_UP"].show();
			me["ALT_digit_DN"].hide();
			me["ALT_target"].hide();
		}
		
		# Vertical Speed
		me["VS_pointer"].setRotation(vs_needle.getValue() * D2R);
		
		me["VS_box"].setTranslation(0, vs_digit.getValue());
		
		var vs_pfd_cur = ap_vs_pfd.getValue();
		if (vs_pfd_cur < 2) {
			me["VS_box"].hide();
		} else {
			me["VS_box"].show();
		}
		
		if (vs_pfd_cur < 10) {
			me["VS_digit"].setText(sprintf("%02d", "0" ~ vs_pfd_cur));
		} else {
			me["VS_digit"].setText(sprintf("%02d", vs_pfd_cur));
		}
		
		# ILS		
		me["LOC_pointer"].setTranslation(loc.getValue() * 197, 0);
		
		me["GS_pointer"].setTranslation(0, gs.getValue() * -197);
		
		# Heading
		me.heading = hdg_scale.getValue();
		me.headOffset = me.heading / 10 - int(me.heading / 10);
		me.middleText = roundabout(me.heading / 10);
		me.middleOffset = nil;
		if(me.middleText == 36) {
			me.middleText = 0;
		}
		me.leftText1 = me.middleText == 0?35:me.middleText - 1;
		me.rightText1 = me.middleText == 35?0:me.middleText + 1;
		me.leftText2 = me.leftText1 == 0?35:me.leftText1 - 1;
		me.rightText2 = me.rightText1 == 35?0:me.rightText1 + 1;
		me.leftText3 = me.leftText2 == 0?35:me.leftText2 - 1;
		me.rightText3 = me.rightText2 == 35?0:me.rightText2 + 1;
		if (me.headOffset > 0.5) {
			me.middleOffset = -(me.headOffset - 1) * 98.5416;
		} else {
			me.middleOffset = -me.headOffset * 98.5416;
		}
		me["HDG_scale"].setTranslation(me.middleOffset, 0);
		me["HDG_scale"].update();
		me["HDG_four"].setText(sprintf("%d", me.middleText));
		me["HDG_five"].setText(sprintf("%d", me.rightText1));
		me["HDG_three"].setText(sprintf("%d", me.leftText1));
		me["HDG_six"].setText(sprintf("%d", me.rightText2));
		me["HDG_two"].setText(sprintf("%d", me.leftText2));
		me["HDG_seven"].setText(sprintf("%d", me.rightText3));
		me["HDG_one"].setText(sprintf("%d", me.leftText3));
		
		me["HDG_four"].setFontSize(fontSizeHDG(me.middleText), 1);
		me["HDG_five"].setFontSize(fontSizeHDG(me.rightText1), 1);
		me["HDG_three"].setFontSize(fontSizeHDG(me.leftText1), 1);
		me["HDG_six"].setFontSize(fontSizeHDG(me.rightText2), 1);
		me["HDG_two"].setFontSize(fontSizeHDG(me.leftText2), 1);
		me["HDG_seven"].setFontSize(fontSizeHDG(me.rightText3), 1);
		me["HDG_one"].setFontSize(fontSizeHDG(me.leftText3), 1);
		
		show_hdg_act = show_hdg.getValue();
		hdg_diff_act = hdg_diff.getValue();
		if (show_hdg_act == 1 and hdg_diff_act >= -23.62 and hdg_diff_act <= 23.62) {
			me["HDG_target"].setTranslation((hdg_diff_act / 10) * 98.5416, 0);
			me["HDG_digit_L"].hide();
			me["HDG_digit_R"].hide();
			me["HDG_target"].show();
		} else if (show_hdg_act == 1 and hdg_diff_act < -23.62 and hdg_diff_act >= -180) {
			me["HDG_digit_L"].setText(sprintf("%3.0f", ap_hdg.getValue()));
			me["HDG_digit_L"].show();
			me["HDG_digit_R"].hide();
			me["HDG_target"].hide();
		} else if (show_hdg_act == 1 and hdg_diff_act > 23.62 and hdg_diff_act <= 180) {
			me["HDG_digit_R"].setText(sprintf("%3.0f", ap_hdg.getValue()));
			me["HDG_digit_R"].show();
			me["HDG_digit_L"].hide();
			me["HDG_target"].hide();
		} else {
			me["HDG_digit_L"].hide();
			me["HDG_digit_R"].hide();
			me["HDG_target"].hide();
		}
		
		me["TRK_pointer"].setTranslation((track_diff.getValue() / 10) * 98.5416, 0);
		
		me["CRS_pointer"].hide();
		
		# AI HDG
		me.AI_horizon_hdg_trans.setTranslation(me.middleOffset, horizon_pitch.getValue() * 11.825);
		me.AI_horizon_hdg_rot.setRotation(-roll_cur * D2R, me["AI_center"].getCenter());
		me["AI_heading"].update();
	},
};

var canvas_PFD_1 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_1, canvas_PFD_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		fd1_act = fd1.getValue();
		pitch_mode_cur = pitch_mode.getValue();
		roll_mode_cur = roll_mode.getValue();
		pitch_cur = pitch.getValue();
		roll_cur = roll.getValue();
		wow1_act = wow1.getValue();
		wow2_act = wow2.getValue();
		
		# Errors
		if ((adirs0_active.getValue() == 1) or (air_switch.getValue() == -1 and adirs2_active.getValue() == 1)) {
			me["ASI_group"].show();
			me["ALT_group"].show();
			me["ALT_group2"].show();
			me["ALT_scale"].show();
			me["VS_group"].show();
			me["ASI_error"].hide();
			me["ASI_frame"].setColor(1,1,1);
			me["ALT_error"].hide();
			me["ALT_frame"].setColor(1,1,1);
			me["VS_error"].hide();
		} else {
			me["ASI_error"].show();
			me["ASI_frame"].setColor(1,0,0);
			me["ALT_error"].show();
			me["ALT_frame"].setColor(1,0,0);
			me["VS_error"].show();
			me["ASI_group"].hide();
			me["ALT_group"].hide();
			me["ALT_group2"].hide();
			me["ALT_scale"].hide();
			me["VS_group"].hide();
		}
		
		if ((ir0_aligned.getValue() == 1) or (ir2_aligned.getValue() == 1 and att_switch.getValue() == -1)) {
			me["AI_group"].show();
			me["HDG_group"].show();
			me["AI_error"].hide();
			me["HDG_error"].hide();
			me["HDG_frame"].setColor(1,1,1);
		} else {
			me["AI_error"].show();
			me["HDG_error"].show();
			me["HDG_frame"].setColor(1,0,0);
			me["AI_group"].hide();
			me["HDG_group"].hide();
		}
		
		# FD
		if (fd1_act == 1 and ((!wow1_act and !wow2_act and roll_mode_cur != " ") or roll_mode_cur != " ") and ap_trk_sw.getValue() == 0 and pitch_cur < 25 and pitch_cur > -13 and roll_cur < 45 and roll_cur > -45) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd1_act == 1 and ((!wow1_act and !wow2_act and pitch_mode_cur != " ") or pitch_mode_cur != " ") and ap_trk_sw.getValue() == 0 and pitch_cur < 25 and pitch_cur > -13 and roll_cur < 45 and roll_cur > -45) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		# ILS
		if (ap_ils_mode.getValue() == 1) {
			me["LOC_scale"].show();
			me["GS_scale"].show();
		} else {
			me["LOC_scale"].hide();
			me["GS_scale"].hide();
		}
		
		if (ap_ils_mode.getValue() == 1 and loc_in_range.getValue() == 1 and hasloc.getValue() == 1 and nav0_signalq.getValue() > 0.99) {
			me["LOC_pointer"].show();
		} else {
			me["LOC_pointer"].hide();
		}
		if (ap_ils_mode.getValue() == 1 and gs_in_range.getValue() == 1 and hasgs.getValue() == 1 and nav0_signalq.getValue() > 0.99) {
			me["GS_pointer"].show();
		} else {
			me["GS_pointer"].hide();
		}
		
		me.updateCommon();
	},
	updateFast: func() {
		me.updateCommonFast();
	},
};

var canvas_PFD_2 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_2, canvas_PFD_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		fd2_act = fd2.getValue();
		pitch_mode_cur = pitch_mode.getValue();
		roll_mode_cur = roll_mode.getValue();
		pitch_cur = pitch.getValue();
		roll_cur = roll.getValue();
		wow1_act = wow1.getValue();
		wow2_act = wow2.getValue();
		
		# Errors
		if ((adirs1_active.getValue() == 1) or (air_switch.getValue() == 1 and adirs2_active.getValue() == 1)) {
			me["ASI_group"].show();
			me["ALT_group"].show();
			me["ALT_group2"].show();
			me["ALT_scale"].show();
			me["VS_group"].show();
			me["ASI_error"].hide();
			me["ASI_frame"].setColor(1,1,1);
			me["ALT_error"].hide();
			me["ALT_frame"].setColor(1,1,1);
			me["VS_error"].hide();
		} else {
			me["ASI_error"].show();
			me["ASI_frame"].setColor(1,0,0);
			me["ALT_error"].show();
			me["ALT_frame"].setColor(1,0,0);
			me["VS_error"].show();
			me["ASI_group"].hide();
			me["ALT_group"].hide();
			me["ALT_group2"].hide();
			me["ALT_scale"].hide();
			me["VS_group"].hide();
		}
		
		if ((ir1_aligned.getValue() == 1) or (ir2_aligned.getValue() == 1 and att_switch.getValue() == 1)) {
			me["AI_group"].show();
			me["HDG_group"].show();
			me["AI_error"].hide();
			me["HDG_error"].hide();
			me["HDG_frame"].setColor(1,1,1);
		} else {
			me["AI_error"].show();
			me["HDG_error"].show();
			me["HDG_frame"].setColor(1,0,0);
			me["AI_group"].hide();
			me["HDG_group"].hide();
		}
		
		# FD
		if (fd2_act == 1 and ((!wow1_act and !wow2_act and roll_mode_cur != " ") or roll_mode_cur != " ") and ap_trk_sw.getValue() == 0 and pitch_cur < 25 and pitch_cur > -13 and roll_cur < 45 and roll_cur > -45) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd2_act == 1 and ((!wow1_act and !wow2_act and pitch_mode_cur != " ") or pitch_mode_cur != " ") and ap_trk_sw.getValue() == 0 and pitch_cur < 25 and pitch_cur > -13 and roll_cur < 45 and roll_cur > -45) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		# ILS
		if (ap_ils_mode2.getValue() == 1) {
			me["LOC_scale"].show();
			me["GS_scale"].show();
		} else {
			me["LOC_scale"].hide();
			me["GS_scale"].hide();
		}
		
		if (ap_ils_mode2.getValue() == 1 and loc_in_range.getValue() == 1 and hasloc.getValue() == 1 and nav0_signalq.getValue() > 0.99) {
			me["LOC_pointer"].show();
		} else {
			me["LOC_pointer"].hide();
		}
		if (ap_ils_mode2.getValue() == 1 and gs_in_range.getValue() == 1 and hasgs.getValue() == 1 and nav0_signalq.getValue() > 0.99) {
			me["GS_pointer"].show();
		} else {
			me["GS_pointer"].hide();
		}
		
		me.updateCommon();
	},
	updateFast: func() {
		me.updateCommonFast();
	},
};

var canvas_PFD_1_test = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_1_test]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["Test_white","Test_text"];
	},
	update: func() {
		et = elapsedtime.getValue() or 0;
		if ((du1_test_time.getValue() + 1 >= et) and cpt_du_xfr.getValue() != 1) {
			me["Test_white"].show();
			me["Test_text"].hide();
		} else if ((du2_test_time.getValue() + 1 >= et) and cpt_du_xfr.getValue() != 0) {
			print(du2_test_time.getValue());
			print(elapsedtime.getValue());
			print(cpt_du_xfr.getValue());
			me["Test_white"].show();
			me["Test_text"].hide();
		} else {
			me["Test_white"].hide();
			me["Test_text"].show();
		}
	},
};

var canvas_PFD_2_test = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_2_test]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["Test_white","Test_text"];
	},
	update: func() {
		et = elapsedtime.getValue() or 0;
		if ((du6_test_time.getValue() + 1 >= et) and fo_du_xfr.getValue() != 1) {
			me["Test_white"].show();
			me["Test_text"].hide();
		} else if ((du5_test_time.getValue() + 1 >= et) and fo_du_xfr.getValue() != 0) {
			me["Test_white"].show();
			me["Test_text"].hide();
		} else {
			me["Test_white"].hide();
			me["Test_text"].show();
		}
	},
};

var canvas_PFD_1_mismatch = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_1_mismatch]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["ERRCODE"];
	},
	update: func() {
		me["ERRCODE"].setText(acconfig_mismatch.getValue());
	},
};

var canvas_PFD_2_mismatch = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_2_mismatch]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["ERRCODE"];
	},
	update: func() {
		me["ERRCODE"].setText(acconfig_mismatch.getValue());
	},
};

setlistener("sim/signals/fdm-initialized", func {
	PFD1_display = canvas.new({
		"name": "PFD1",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	PFD2_display = canvas.new({
		"name": "PFD2",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	PFD1_display.addPlacement({"node": "pfd1.screen"});
	PFD2_display.addPlacement({"node": "pfd2.screen"});
	var group_pfd1 = PFD1_display.createGroup();
	var group_pfd1_test = PFD1_display.createGroup();
	var group_pfd1_mismatch = PFD1_display.createGroup();
	var group_pfd2 = PFD2_display.createGroup();
	var group_pfd2_test = PFD2_display.createGroup();
	var group_pfd2_mismatch = PFD2_display.createGroup();

	PFD_1 = canvas_PFD_1.new(group_pfd1, "Aircraft/IDG-A32X/Models/Instruments/PFD/res/pfd.svg");
	PFD_1_test = canvas_PFD_1_test.new(group_pfd1_test, "Aircraft/IDG-A32X/Models/Instruments/Common/res/du-test.svg");
	PFD_1_mismatch = canvas_PFD_1_mismatch.new(group_pfd1_mismatch, "Aircraft/IDG-A32X/Models/Instruments/Common/res/mismatch.svg");
	PFD_2 = canvas_PFD_2.new(group_pfd2, "Aircraft/IDG-A32X/Models/Instruments/PFD/res/pfd.svg");
	PFD_2_test = canvas_PFD_2_test.new(group_pfd2_test, "Aircraft/IDG-A32X/Models/Instruments/Common/res/du-test.svg");
	PFD_2_mismatch = canvas_PFD_2_mismatch.new(group_pfd2_mismatch, "Aircraft/IDG-A32X/Models/Instruments/Common/res/mismatch.svg");
	
	PFD_update.start();
	PFD_update_fast.start();
	
	if (pfdrate.getValue() == 1) {
		rateApply();
	}
});

var rateApply = func {
	PFD_update.restart(0.15 * pfdrate.getValue());
	PFD_update_fast.restart(0.05 * pfdrate.getValue());
}

var PFD_update = maketimer(0.15, func {
	canvas_PFD_base.updateSlow();
});

var PFD_update_fast = maketimer(0.05, func {
	canvas_PFD_base.update();
});

var showPFD1 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(PFD1_display);
}

var showPFD2 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(PFD2_display);
}

var roundabout = func(x) {
	var y = x - int(x);
	return y < 0.5 ? int(x) : 1 + int(x);
};

var roundaboutAlt = func(x) {
	var y = x * 0.2 - int(x * 0.2);
	return y < 0.5 ? 5 * int(x * 0.2) : 5 + 5 * int(x * 0.2);
};

var fontSizeHDG = func(input) {
	var test = input / 3;
	if (test == int(test)) {
		return 42;
	} else {
		return 32;
	}
};