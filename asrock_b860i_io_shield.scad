// Asrock B860I - Custom IO Faceplate
// All dimensions in mm

// =========================================================================
// === 📏 CALIPER MEASUREMENT VARIABLES 📏 ===
// Measure these physically with calipers and update the values below!
// The layout will automatically constrain and recalculate itself.
// =========================================================================

// --- 1. OVERALL PLATE BOUNDARIES ---
plate_thickness = 0.25;    
plate_width = 154.75;      // Overall width of the 3D printed insert
plate_height = 40.75;      // Overall height of the 3D printed insert

// --- 2. PORT SIZES (W x H) ---
dp_w = 17.5;
dp_h = 7.0;
hdmi_w = 15.0;
hdmi_h = 6.0;
usbc_w = 10.5;
usbc_h = 4.5;
usb_a_w = 15.0;            // All USB-A ports (and stack widths)
usb_a_h = 7.0;
eth_w = 15.0;              // Ethernet width (usually matches USB-A)
eth_h = 12.75;             // Ethernet height
wifi_hole_dia = 10.0;      // Diameter of the antenna holes
audio_w = 8.0;             // Audio jack pill width
audio_h_bottom = 9.0;      // Bottom audio jack height
audio_h_middle = 9.5;      // Middle audio jack height
audio_h_top = 9.5;         // Top audio jack height

// --- 3. VERTICAL (Y-AXIS) EDGE GAPS ---
bottom_edge_to_hdmi_bottom = 2.5;     // Gap from plate bottom edge to HDMI bottom edge
hdmi_top_to_dp_bottom = 5.5;          // Gap between HDMI top and DP bottom
bottom_edge_to_usb_bottoms = 2.5;     // Gap from plate bottom edge to the bottom of the lowest USB-C / USB-A ports
usbc_to_usba_gap = 2.5;               // Custom vertical gap between USB-C and the USB-A port directly above it
usb_to_usb_gap = 1.5;                 // Standard vertical gap between USB-A ports (and between USB-A and Ethernet)
wifi_gap = 5.7;                       // Edge-to-edge gap between the two Wi-Fi holes
top_edge_to_wifi_top = 6.0;           // Gap from plate top edge to the top edge of the upper Wi-Fi hole
audio_gap = 1.6;                      // Edge-to-edge gap between the audio jacks
top_edge_to_audio_top = 5.75;         // Gap from plate top edge to the top edge of the upper audio jack

// --- 4. HORIZONTAL (X-AXIS) CENTER-TO-CENTER DISTANCES ---
// Measured directly from the physical centerlines of the metal housings!
left_edge_to_video_center = 12.65;  // Base anchor point
video_to_usbc_1g_center = 22.74;    // Distance from Video center to Stack 1 center
usbc_1g_to_dual_usb_center = 42.09; // Distance from Stack 1 center to Stack 2 center
dual_usb_to_quad_usb_center = 26.89;// Distance from Stack 2 center to Stack 3 center
quad_usb_to_wifi_center = 15.05;    // Distance from Stack 3 center to Wifi center
wifi_to_audio_center = 13.18;       // Distance from Wifi center to Audio center
// --- USB Stack X-Coordinate Math ---
// --- Video Stack Math ---
dp_x = left_edge_to_video_center - 0.6; // Slight offset for DP
hdmi_x = left_edge_to_video_center;
hdmi_y = bottom_edge_to_hdmi_bottom + (hdmi_h / 2);
dp_y = hdmi_y + (hdmi_h / 2) + hdmi_top_to_dp_bottom + (dp_h / 2);

usbc_1g_stack_x = left_edge_to_video_center + video_to_usbc_1g_center;
dual_usb_2_5g_stack_x = usbc_1g_stack_x + usbc_1g_to_dual_usb_center;
quad_usb_stack_x = dual_usb_2_5g_stack_x + dual_usb_to_quad_usb_center;
wifi_x = quad_usb_stack_x + quad_usb_to_wifi_center;
audio_x = wifi_x + wifi_to_audio_center;
// --- USB Stack Y-Coordinate Math ---
// Standard stack bases
usbc_y = bottom_edge_to_usb_bottoms + (usbc_h / 2);
usb_1_y = bottom_edge_to_usb_bottoms + (usb_a_h / 2);
usb_2_y = usb_1_y + (usb_a_h / 2) + usb_to_usb_gap + (usb_a_h / 2);
usb_3_y = usb_2_y + (usb_a_h / 2) + usb_to_usb_gap + (usb_a_h / 2);
usb_4_y = usb_3_y + (usb_a_h / 2) + usb_to_usb_gap + (usb_a_h / 2);

// Ethernet Tops
eth_above_2_y = usb_2_y + (usb_a_h / 2) + usb_to_usb_gap + (eth_h / 2);

// USBC Stack custom gaps
usbc_stack_usb_y = usbc_y + (usbc_h / 2) + usbc_to_usba_gap + (usb_a_h / 2);
usbc_stack_eth_y = usbc_stack_usb_y + (usb_a_h / 2) + usb_to_usb_gap + (eth_h / 2);

// --- Wi-Fi Math ---
wifi_top_edge = plate_height - top_edge_to_wifi_top;
wifi_2_y = wifi_top_edge - (wifi_hole_dia / 2);
wifi_1_y = wifi_2_y - (wifi_hole_dia / 2) - wifi_gap - (wifi_hole_dia / 2);

// --- Audio Math ---
audio_top_edge = plate_height - top_edge_to_audio_top;
audio_3_y = audio_top_edge - (audio_h_top / 2);
audio_2_y = audio_3_y - (audio_h_top / 2) - audio_gap - (audio_h_middle / 2);
audio_1_y = audio_2_y - (audio_h_middle / 2) - audio_gap - (audio_h_bottom / 2);


// ==========================================
// --- Main Module ---
// ==========================================

module io_faceplate() {
    difference() {
        // Main Plate
        cube([plate_width, plate_height, plate_thickness]);

        // HDMI Port
        translate([hdmi_x, hdmi_y, 0])
            hdmi_cutout(plate_thickness);

        // DisplayPort
        translate([dp_x, dp_y, 0])
            dp_cutout(plate_thickness);

        // --- Stack 1: USB-C + USB-A + 1G ETH ---
        translate([usbc_1g_stack_x, usbc_y, 0])
            pill_cutout(usbc_w, usbc_h, plate_thickness);
        translate([usbc_1g_stack_x, usbc_stack_usb_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([usbc_1g_stack_x, usbc_stack_eth_y, 0])
            cut_rect(eth_w, eth_h, plate_thickness);


        // --- Stack 2: 2x USB-A + 2.5G Ethernet ---
        translate([dual_usb_2_5g_stack_x, usb_1_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([dual_usb_2_5g_stack_x, usb_2_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([dual_usb_2_5g_stack_x, eth_above_2_y, 0])
            cut_rect(eth_w, eth_h, plate_thickness);

        // --- Stack 3: 4x USB-A ---
        translate([quad_usb_stack_x, usb_1_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([quad_usb_stack_x, usb_2_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([quad_usb_stack_x, usb_3_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);
        translate([quad_usb_stack_x, usb_4_y, 0])
            cut_rect(usb_a_w, usb_a_h, plate_thickness);

        // Wi-Fi Antenna Holes
        translate([wifi_x, wifi_1_y, 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);
        translate([wifi_x, wifi_2_y, 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);

        // Audio Jacks
        translate([audio_x, audio_1_y, 0])
            pill_cutout(audio_w, audio_h_bottom, plate_thickness);
        translate([audio_x, audio_2_y, 0])
            pill_cutout(audio_w, audio_h_middle, plate_thickness);
        translate([audio_x, audio_3_y, 0])
            pill_cutout(audio_w, audio_h_top, plate_thickness);
    }
}

// --- Helper Modules for Port Shapes ---

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
    c = 2.0; // chamfer
    
    points = [
        [-w/2, h/2],            // Top-Left
        [w/2, h/2],             // Top-Right
        [w/2, -h/2 + c],        // Right-Chamfer Start
        [w/2 - c, -h/2],        // Bottom-Right
        [-w/2 + c, -h/2],       // Bottom-Left
        [-w/2, -h/2 + c]        // Left-Chamfer Start
    ];
    translate([0, 0, -1])
        linear_extrude(t + 2)
            polygon(points);
}

module dp_cutout(t) {
    w = 17.5;
    h = 7.0;
    c = 3.0; // chamfer
    
    points = [
        [-w/2, h/2],            // Top-Left
        [w/2, h/2],             // Top-Right
        [w/2, -h/2],            // Bottom-Right
        [-w/2 + c, -h/2],       // Bottom-Left chamfer end
        [-w/2, -h/2 + c]        // Left chamfer start
    ];
    translate([0, 0, -1])
        linear_extrude(t + 2)
            polygon(points);
}

module pill_cutout(w, h, t) {
    translate([0, 0, -1])
    linear_extrude(t + 2) {
        if (w > h) {
            // Horizontal pill
            r = h / 2;
            hull() {
                translate([-w/2 + r, 0]) circle(r=r, $fn=64);
                translate([w/2 - r, 0]) circle(r=r, $fn=64);
            }
        } else {
            // Vertical pill
            r = w / 2;
            hull() {
                translate([0, -h/2 + r]) circle(r=r, $fn=64);
                translate([0, h/2 - r]) circle(r=r, $fn=64);
            }
        }
    }
}

// Instantiate the faceplate, mirrored horizontally so Video is on +X and Audio is on -X
translate([plate_width, 0, 0])
    mirror([1, 0, 0])
        io_faceplate();
