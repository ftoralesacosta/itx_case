// Asrock B860I - Custom IO Faceplate
// All dimensions in mm

// --- Outer Plate Parameters ---
plate_thickness = 0.25;    // [1.0:0.1:5.0]

// Kept from B760M
plate_width = 154.75; 
plate_height = 40.75; 


// ==========================================
// --- Port Layout Parameters ---
// ==========================================

// --- DisplayPort & HDMI ---
dp_w = 17.5;
dp_h = 7.0;
hdmi_w = 15.0;
hdmi_h = 6.0;

// Constraints:
dp_x = 3.3 + (dp_w / 2);
hdmi_x = 5.15 + (hdmi_w / 2);
hdmi_y = 5.5; 
dp_y = hdmi_y + (hdmi_h / 2) + 5.5 + (dp_h / 2);


// --- USB & Ethernet Stacks ---
// Width and Height Sizes
stack_w = 15.0;           
usb_a_h = 7.0;            
eth_h = 12.75;            
usbc_w = 10.5;
usbc_h = 4.5;

// Y-Locations & Gaps
usb_gap = 1.5;            
eth_gap = usb_gap;        
usb_bottom_gap = 2.5;

// Stack Y-Coordinates from bottom to top
usbc_y = usb_bottom_gap + (usbc_h / 2);
usb_1_y = usb_bottom_gap + (usb_a_h / 2);
usb_2_y = usb_1_y + (usb_a_h / 2) + usb_gap + (usb_a_h / 2);
usb_3_y = usb_2_y + (usb_a_h / 2) + usb_gap + (usb_a_h / 2);
usb_4_y = usb_3_y + (usb_a_h / 2) + usb_gap + (usb_a_h / 2);

// Ethernet for the left_usb_stack
eth_above_2_y = usb_2_y + (usb_a_h / 2) + eth_gap + (eth_h / 2);

// --- 2.5G Ethernet Stack Calculations (USB-C + USB-A + 2.5G ETH) ---
// Since this stack matches the overall height of the standard left_usb_stack, 
// we can mathematically calculate exactly what the two identical gaps inside must be!
stack_top_y = eth_above_2_y + (eth_h / 2);
total_stack_height = stack_top_y - usb_bottom_gap;
available_gap_space = total_stack_height - usbc_h - usb_a_h - eth_h;
gap_2_5g = available_gap_space / 2;

stack_2_5g_usb_y = usbc_y + (usbc_h / 2) + gap_2_5g + (usb_a_h / 2);
stack_2_5g_eth_y = stack_2_5g_usb_y + (usb_a_h / 2) + gap_2_5g + (eth_h / 2);


// --- X-Locations for Stacks ---
// You can adjust these to perfectly space out your B860I layout!
stack_2_5g_x = 40.0;       // USB-C + USB-A + 2.5G ETH
left_usb_stack_x = 70.0;   // 2x USB-A + Ethernet
right_usb_stack_x = 100.0; // 4x USB-A


// --- Wi-Fi Antenna Holes ---
wifi_x = 128.0;
wifi_hole_dia = 10.0;
wifi_gap = 5.7;

wifi_top_edge = plate_height - 6;
wifi_2_y = wifi_top_edge - (wifi_hole_dia / 2);
wifi_1_y = wifi_2_y - (wifi_hole_dia / 2) - wifi_gap - (wifi_hole_dia / 2);


// --- Audio Jacks ---
audio_x = 142.1;
audio_gap = 1.6;

audio_1_w = 8.0;
audio_1_h = 9.0;
audio_2_w = 8.0;
audio_2_h = 9.5;
audio_3_w = 8.0;
audio_3_h = 9.5;

audio_top_edge = plate_height - 5.75;
audio_3_y = audio_top_edge - (audio_3_h / 2);
audio_2_y = audio_3_y - (audio_3_h / 2) - audio_gap - (audio_2_h / 2);
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

        // --- 2.5G Ethernet Stack (USB-C + USB-A + ETH) ---
        translate([stack_2_5g_x, usbc_y, 0])
            pill_cutout(usbc_w, usbc_h, plate_thickness);
        translate([stack_2_5g_x, stack_2_5g_usb_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        translate([stack_2_5g_x, stack_2_5g_eth_y, 0])
            cut_rect(stack_w, eth_h, plate_thickness);


        // --- Left USB Stack (2x USB-A + Ethernet) ---
        translate([left_usb_stack_x, usb_1_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        translate([left_usb_stack_x, usb_2_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        translate([left_usb_stack_x, eth_above_2_y, 0])
            cut_rect(stack_w, eth_h, plate_thickness);

        // --- Right USB Stack (4x USB-A) ---
        translate([right_usb_stack_x, usb_1_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        translate([right_usb_stack_x, usb_2_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        translate([right_usb_stack_x, usb_3_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);
        translate([right_usb_stack_x, usb_4_y, 0])
            cut_rect(stack_w, usb_a_h, plate_thickness);

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

// Instantiate the faceplate, mirrored horizontally so Video is on +X and Audio is on -X
translate([plate_width, 0, 0])
    mirror([1, 0, 0])
        io_faceplate();
