// Asrock B760M ITX D4 - Custom IO Faceplate (Inner Insert Size)
// All dimensions in mm

// --- Outer Plate Parameters ---
plate_thickness = 0.25;    // [1.0:0.1:5.0]

// We derived plate_height from the Ethernet-to-top gap constraint (8.0mm)
// We added 1.5mm to the bottom of the plate, increasing total height.
plate_width = 154.75; 
plate_height = 40.75; // Was 39.25 + 1.5mm added to bottom


// ==========================================
// --- Port Layout Parameters ---
// ==========================================

// --- DisplayPort & HDMI ---
dp_w = 17.5;
dp_h = 7.0;
hdmi_w = 15.0;
hdmi_h = 6.0;

// Constraints:
// DP left edge is 3.3mm from left plate edge
dp_x = 3.3 + (dp_w / 2);
// HDMI left edge is 5.15mm from left plate edge
hdmi_x = 5.15 + (hdmi_w / 2);

// Master Y-Location for the Video Ports (Change this to raise both of them together!)
// Shifted +1.5mm to maintain absolute position since bottom edge moved down 1.5mm
hdmi_y = 5.5; 
// Gap between DP bottom and HDMI top is 5.25mm
dp_y = hdmi_y + (hdmi_h / 2) + 5.5 + (dp_h / 2);


// --- USB-A & Ethernet Stacks ---
// Width and Height Sizes
stack_w = 15.0;           
usb_a_h = 7.0;            
eth_h = 12.75;            

// Y-Locations & Gaps
usb_gap = 1.5;            
eth_gap = usb_gap;        

// Constraint: USB-C bottom and USB-A bottoms align. 
// Change this single variable to move all of them up or down together!
// Shifted +1.5mm to maintain absolute position since bottom edge moved down 1.5mm
usb_bottom_gap = 2.5;

usbc_w = 10.5;
usbc_h = 4.5;
usbc_y = usb_bottom_gap + (usbc_h / 2);
usb_bottom_y = usb_bottom_gap + (usb_a_h / 2);

// Calculated Y-Locations for the rest of the stack
usb_top_y = usb_bottom_y + (usb_a_h / 2) + usb_gap + (usb_a_h / 2);
eth_y = usb_top_y + (usb_a_h / 2) + eth_gap + (eth_h / 2);

// X-Locations
// Preserving the absolute X of the Left Stack from your last edit (77.0 - 1.5 offset = 75.5)
stack_left_x = 71.5;

// Constraint: Left stack is 9.6mm to the left of the right stack (edge to edge)
stack_right_x = stack_left_x + (stack_w / 2) + 9.6 + (stack_w / 2);

// Constraint: Right stack is 4.25mm to the left of the USB-C left edge
usbc_x = stack_right_x + (stack_w / 2) + 4.25 + (usbc_w / 2);


// --- Wi-Fi Antenna Holes ---
// Preserving the absolute X from your edits
wifi_x = 128.0;
wifi_hole_dia = 10.0;
wifi_gap = 5.7;           // Constraint: 5.7mm edge-to-edge gap between the holes

// Constraint: 5.5mm gap from top plate edge to the top edge of the top Wi-Fi hole
wifi_top_edge = plate_height - 6;
wifi_2_y = wifi_top_edge - (wifi_hole_dia / 2);
wifi_1_y = wifi_2_y - (wifi_hole_dia / 2) - wifi_gap - (wifi_hole_dia / 2);


// --- Audio Jacks ---
audio_x = 142.1;

audio_gap = 1.6;          // Constraint: 1.6mm edge-to-edge gap between analog audio jacks

audio_1_w = 8.0;
audio_1_h = 9.0;
audio_2_w = 8.0;
audio_2_h = 9.5;
audio_3_w = 8.0;
audio_3_h = 9.5;

// Constraint: 5.75mm gap from top plate edge to top edge of the top audio jack
audio_top_edge = plate_height - 5.75;
audio_3_y = audio_top_edge - (audio_3_h / 2);

// Calculated middle audio jack Y
audio_2_y = audio_3_y - (audio_3_h / 2) - audio_gap - (audio_2_h / 2);

// Calculated bottom audio jack Y
audio_1_y = audio_2_y - (audio_2_h / 2) - audio_gap - (audio_1_h / 2);


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

        // --- Left USB Stack (2x USB-A) ---
        translate([stack_left_x, usb_bottom_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        translate([stack_left_x, usb_top_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);

        // --- Right USB Stack (Ethernet + 2x USB-A) ---
        translate([stack_right_x, usb_bottom_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        translate([stack_right_x, usb_top_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        // Ethernet (RJ45)
        translate([stack_right_x, eth_y, 0])
            cut_rect(stack_w, eth_h, plate_thickness);

        // USB-C
        translate([usbc_x, usbc_y, 0])
            pill_cutout(usbc_w, usbc_h, plate_thickness);

        // Wi-Fi Antenna Holes
        translate([wifi_x, wifi_1_y, 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);
        translate([wifi_x, wifi_2_y, 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);

        // Audio Jacks
        translate([audio_x, audio_1_y, 0])
            pill_cutout(audio_1_w, audio_1_h, plate_thickness);
        translate([audio_x, audio_2_y, 0])
            pill_cutout(audio_2_w, audio_2_h, plate_thickness);
        translate([audio_x, audio_3_y, 0])
            pill_cutout(audio_3_w, audio_3_h, plate_thickness);
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

// Instantiate the faceplate
io_faceplate();
