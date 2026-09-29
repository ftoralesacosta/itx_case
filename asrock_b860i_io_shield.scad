// Asrock B860I IO faceplate. Caliper-measured, mm. Layout below is derived from these.
plate_thickness = 2.5;
plate_width = 155.00;
plate_height = 40.50;

dp_w = 17.5;
dp_h = 7.0;
hdmi_w = 15.0;
hdmi_h = 6.0;
usbc_w = 10.5;
usbc_h = 4.5;
usbc_x_offset = 0.36-0.6;  // the physical USB-C port is off-centre in its stack
usb_a_w = 15.0;
usb_a_h = 6.6;
eth_w = 15.0;
eth_h = 12.35;
wifi_hole_dia = 10.0;  // layout value - hole centres derive from it, leave at 10.0
wifi_hole_growth = 1.0;  // extra cut diameter only; centres unchanged
audio_w = 8.0;
audio_h_bottom = 9.0;
audio_h_middle = 9.5;
audio_h_top = 9.5;

bottom_edge_to_hdmi_bottom = 2.25;
hdmi_top_to_dp_bottom = 5.5;
bottom_edge_to_usb_bottoms = 2.45;
bottom_edge_to_stack1_bottom = 3.00;
usbc_to_usba_gap = 3.5;
usb_to_usb_gap = 1.9;
wifi_gap = 10.5;
top_edge_to_wifi_top = 5.55;
audio_gap = 1.6;
top_edge_to_audio_top = 5.75;

// X gaps are between metal housings.
left_edge_to_dp_left = 6.25;
left_edge_to_hdmi_left = 8.10;
hdmi_right_to_usbc_stack_left = 8.50;
usbc_stack_right_to_dual_usb_left = 28.50;
dual_usb_right_to_quad_usb_left = 13.50;
quad_usb_right_to_wifi_left = 3.05;
right_edge_to_audio_right = 10.40;
dp_x = left_edge_to_dp_left + (17.5 / 2);  // 17.5 = DP width
hdmi_x = left_edge_to_hdmi_left + (15.0 / 2);  // 15.0 = HDMI width
hdmi_y = bottom_edge_to_hdmi_bottom + (hdmi_h / 2);
dp_y = hdmi_y + (hdmi_h / 2) + hdmi_top_to_dp_bottom + (dp_h / 2);

usbc_1g_stack_x = (left_edge_to_hdmi_left + 15.0) + hdmi_right_to_usbc_stack_left + (15.0 / 2);
dual_usb_2_5g_stack_x = (usbc_1g_stack_x + 7.5) + usbc_stack_right_to_dual_usb_left + (15.0 / 2);
quad_usb_stack_x = (dual_usb_2_5g_stack_x + 7.5) + dual_usb_right_to_quad_usb_left + (15.0 / 2);
wifi_x_shift = 0.5;  // + = toward +X in the final mirrored STL (hence subtracted below)
wifi_x = (quad_usb_stack_x + 7.5) + quad_usb_right_to_wifi_left + (10.0 / 2) - wifi_x_shift;
audio_x = plate_width - right_edge_to_audio_right - (8.0 / 2);
usbc_y = bottom_edge_to_stack1_bottom + (usbc_h / 2);
usb_1_y = bottom_edge_to_usb_bottoms + (usb_a_h / 2);
usb_2_y = usb_1_y + (usb_a_h / 2) + usb_to_usb_gap + (usb_a_h / 2);
usb_3_y = usb_2_y + (usb_a_h / 2) + usb_to_usb_gap + (usb_a_h / 2);
usb_4_y = usb_3_y + (usb_a_h / 2) + usb_to_usb_gap + (usb_a_h / 2);

eth_above_2_y = usb_2_y + (usb_a_h / 2) + usb_to_usb_gap + (eth_h / 2);

usbc_stack_usb_y = usbc_y + (usbc_h / 2) + usbc_to_usba_gap + (usb_a_h / 2);
usbc_stack_eth_y = usbc_stack_usb_y + (usb_a_h / 2) + usb_to_usb_gap + (eth_h / 2);

wifi_top_edge = plate_height - top_edge_to_wifi_top;
wifi_2_y = wifi_top_edge - (wifi_hole_dia / 2);
wifi_1_y = wifi_2_y - (wifi_hole_dia / 2) - wifi_gap - (wifi_hole_dia / 2);

audio_top_edge = plate_height - top_edge_to_audio_top;
audio_3_y = audio_top_edge - (audio_h_top / 2);
audio_2_y = audio_3_y - (audio_h_top / 2) - audio_gap - (audio_h_middle / 2);
audio_1_y = audio_2_y - (audio_h_middle / 2) - audio_gap - (audio_h_bottom / 2);

module io_faceplate() {
    difference() {
        cube([plate_width, plate_height, plate_thickness]);

        translate([hdmi_x, hdmi_y, 0])
            hdmi_cutout(plate_thickness);

        translate([dp_x, dp_y, 0])
            dp_cutout(plate_thickness);

        translate([usbc_1g_stack_x + usbc_x_offset, usbc_y, 0])
            pill_cutout(usbc_w, usbc_h, plate_thickness);
        translate([usbc_1g_stack_x, usbc_stack_usb_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([usbc_1g_stack_x, usbc_stack_eth_y, 0])
            cut_rect(eth_w, eth_h, plate_thickness);

        translate([dual_usb_2_5g_stack_x, usb_1_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([dual_usb_2_5g_stack_x, usb_2_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([dual_usb_2_5g_stack_x, eth_above_2_y, 0])
            cut_rect(eth_w, eth_h, plate_thickness);

        translate([quad_usb_stack_x, usb_1_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([quad_usb_stack_x, usb_2_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([quad_usb_stack_x, usb_3_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([quad_usb_stack_x, usb_4_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);

        translate([wifi_x, wifi_1_y, 0])
            cut_circle((wifi_hole_dia + wifi_hole_growth) / 2, plate_thickness);
        translate([wifi_x, wifi_2_y, 0])
            cut_circle((wifi_hole_dia + wifi_hole_growth) / 2, plate_thickness);

        translate([audio_x, audio_1_y, 0])
            pill_cutout(audio_w, audio_h_bottom, plate_thickness);
        translate([audio_x, audio_2_y, 0])
            pill_cutout(audio_w, audio_h_middle, plate_thickness);
        translate([audio_x, audio_3_y, 0])
            pill_cutout(audio_w, audio_h_top, plate_thickness);
    }
}

module cut_rect(w, h, t) {
    translate([0, 0, -1])
        linear_extrude(t + 2)
            square([w, h], center=true);
}

module cut_circle(r, t) {
    translate([0, 0, -1])
        linear_extrude(t + 2)
            circle(r=r, $fn=64);
}

module hdmi_cutout(t) {
    w = 15.0;
    h = 6.0;
    c = 2.0;

    points = [
        [-w/2, h/2],
        [w/2, h/2],
        [w/2, -h/2 + c],
        [w/2 - c, -h/2],
        [-w/2 + c, -h/2],
        [-w/2, -h/2 + c]
    ];
    translate([0, 0, -1])
        linear_extrude(t + 2)
            polygon(points);
}

module dp_cutout(t) {
    w = 17.5;
    h = 7.0;
    c = 3.0;

    points = [
        [-w/2, h/2],
        [w/2, h/2],
        [w/2, -h/2],
        [-w/2 + c, -h/2],
        [-w/2, -h/2 + c]
    ];
    translate([0, 0, -1])
        linear_extrude(t + 2)
            polygon(points);
}

module pill_cutout(w, h, t) {
    translate([0, 0, -1])
    linear_extrude(t + 2) {
        if (w > h) {
            r = h / 2;
            hull() {
                translate([-w/2 + r, 0]) circle(r=r, $fn=64);
                translate([w/2 - r, 0]) circle(r=r, $fn=64);
            }
        } else {
            r = w / 2;
            hull() {
                translate([0, -h/2 + r]) circle(r=r, $fn=64);
                translate([0, h/2 - r]) circle(r=r, $fn=64);
            }
        }
    }
}

// Mirrored so video is on +X and audio on -X.
translate([plate_width, 0, 0])
    mirror([1, 0, 0])
        io_faceplate();
