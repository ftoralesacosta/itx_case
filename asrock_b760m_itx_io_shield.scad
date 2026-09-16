// Asrock B760M ITX D4 - Custom IO Faceplate (Inner Insert Size)
// All dimensions in mm

// --- Outer Plate Parameters ---
plate_thickness = 0.25;    // [1.0:0.1:5.0]

// Standard ATX chassis hole is 158.75 x 44.45.
// We are using a 2mm inset from the standard outer edge on all sides.
// We added 0.5mm to the left and 1.5mm to the right
plate_width = 154.75; 
plate_height = 40.45;

// Offset to shift the ports since the plate is smaller than the original 158.75 x 44.45
// Left edge moved by 0.5mm, so x_offset increases by 0.5mm
x_offset = -1.5;
// We added 2mm to bottom edge and removed 2mm from top edge, so y_offset increases by 2.0mm
y_offset = 0.0;


// ==========================================
// --- Port Layout Parameters ---
// ==========================================

// --- DisplayPort & HDMI ---
dp_x = 17.5;
dp_y = 18.;
hdmi_x = 17.5;
hdmi_y = 6.;

// --- USB-A & Ethernet Stacks ---
// Width and Height Sizes
stack_w = 15.0;           // Both Ethernet and USB-A cutouts share this width
usb_a_h = 7.0;            // Height of a single USB-A cutout (measured 7mm)
eth_h = 12.75;            // Height of the Ethernet cutout (measured 12.75mm)

// X-Locations
stack_left_x = 77.0;
stack_right_x = 100.5;

// Y-Locations & Gaps
usb_gap = 1.0;            // Gap between Bottom and Top USB-A
eth_gap = usb_gap;        // Gap between Top USB-A and Ethernet

// Master Y-Location for the stacks (Center of the Bottom USB-A)
usb_bottom_y = 6.6; 

// Calculated Y-Locations for the rest of the stack based on the gaps
usb_top_y = usb_bottom_y + (usb_a_h / 2) + usb_gap + (usb_a_h / 2);
eth_y = usb_top_y + (usb_a_h / 2) + eth_gap + (eth_h / 2);


// --- USB-C ---
usbc_x = 117.0;
usbc_w = 10.5;
usbc_h = 4.5;
// Center Y is mathematically locked so its bottom edge aligns with Bottom USB-A's bottom edge
usbc_y = (usb_bottom_y - (usb_a_h / 2)) + (usbc_h / 2);

// --- Wi-Fi Antenna Holes ---
wifi_x = 130.4;
wifi_1_y = 20.5;
wifi_2_y = 23.5;
wifi_spacing = 12.7;
wifi_hole_dia = 10.0;

// --- Audio Jacks ---
audio_x = 143.6;

audio_1_y = 9;
audio_1_w = 8.0;
audio_1_h = 9;

audio_2_y = 19.25;
audio_2_w = 8.0;
audio_2_h = 9.5;

audio_3_y = 30;
audio_3_w = 8.0;
audio_3_h = 9.5;


// ==========================================
// --- Main Module ---
// ==========================================

module io_faceplate() {
    difference() {
        // Main Plate
        cube([plate_width, plate_height, plate_thickness]);

        // HDMI Port
        translate([hdmi_x + x_offset, hdmi_y + y_offset, 0])
            hdmi_cutout(plate_thickness);

        // DisplayPort
        translate([dp_x + x_offset, dp_y + y_offset, 0])
            dp_cutout(plate_thickness);

        // --- Left USB Stack (2x USB-A) ---
        // Bottom USB-A
        translate([stack_left_x + x_offset, usb_bottom_y + y_offset, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        // Top USB-A
        translate([stack_left_x + x_offset, usb_top_y + y_offset, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);

        // --- Right USB Stack (Ethernet + 2x USB-A) ---
        // Bottom USB-A
        translate([stack_right_x + x_offset, usb_bottom_y + y_offset, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        // Top USB-A
        translate([stack_right_x + x_offset, usb_top_y + y_offset, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        // Ethernet (RJ45)
        translate([stack_right_x + x_offset, eth_y + y_offset, 0])
            cut_rect(stack_w, eth_h, plate_thickness);

        // USB-C
        translate([usbc_x + x_offset, usbc_y + y_offset, 0])
            pill_cutout(usbc_w, usbc_h, plate_thickness);

        // Wi-Fi Antenna Holes
        translate([wifi_x + x_offset, wifi_1_y + y_offset - (wifi_spacing / 2), 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);
        translate([wifi_x + x_offset, wifi_2_y + y_offset + (wifi_spacing / 2), 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);

        // Audio Jacks
        translate([audio_x + x_offset, audio_1_y + y_offset, 0])
            pill_cutout(audio_1_w, audio_1_h, plate_thickness);
        translate([audio_x + x_offset, audio_2_y + y_offset, 0])
            pill_cutout(audio_2_w, audio_2_h, plate_thickness);
        translate([audio_x + x_offset, audio_3_y + y_offset, 0])
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
