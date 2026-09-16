// Asrock B760M ITX D4 - Custom IO Faceplate (Inner Insert Size)
// All dimensions in mm

// --- User Parameters ---
plate_thickness = 0.25;    // [1.0:0.1:5.0]
wifi_spacing = 12.7;      // Distance between Wi-Fi antennas (12.7mm or 1/2" is standard)
wifi_hole_dia = 10.0;     // Diameter of the Wi-Fi holes (10mm allows the antenna nut to recess)

// --- ATX Inner Flat Area Dimensions ---
// Standard ATX chassis hole is 158.75 x 44.45.
// The raised metal lip usually takes up ~3mm on each side.
// This leaves an inner flat area of ~152.75 x 38.45.
plate_width = 152.75;
plate_height = 38.45;

// Offset to shift the ports since the plate is now smaller than the original 158.75 x 44.45
x_offset = -3.0;
y_offset = -3.0;

module io_faceplate() {
    difference() {
        // Main Plate
        cube([plate_width, plate_height, plate_thickness]);

        // HDMI Port
        translate([15.5 + x_offset, 7.5 + y_offset, 0])
            hdmi_cutout(plate_thickness);

        // DisplayPort
        translate([15.5 + x_offset, 17.5 + y_offset, 0])
            dp_cutout(plate_thickness);

        // Dual USB-A (Left)
        translate([73.1 + x_offset, 11.25 + y_offset, 0])
            cut_rect(14.5, 16.0, plate_thickness);

        // Dual USB-A (Right)
        translate([98.5 + x_offset, 11.25 + y_offset, 0])
            cut_rect(14.5, 16.0, plate_thickness);

        // Ethernet (RJ45)
        translate([98.5 + x_offset, 28.2 + y_offset, 0])
            cut_rect(16.0, 13.5, plate_thickness);

        // USB-C
        translate([116.0 + x_offset, 5.5 + y_offset, 0])
            pill_cutout(9.5, 4.2, plate_thickness);

        // Wi-Fi Antenna Holes
        translate([132.0 + x_offset, 23.675 + y_offset - (wifi_spacing / 2), 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);
        translate([132.0 + x_offset, 23.675 + y_offset + (wifi_spacing / 2), 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);

        // Audio Jacks
        translate([146.6 + x_offset, 8.75 + y_offset, 0])
            pill_cutout(8, 10.5, plate_thickness);
        translate([146.6 + x_offset, 20.75 + y_offset, 0])
            pill_cutout(8, 10.5, plate_thickness);
        translate([146.6 + x_offset, 32.75 + y_offset, 0])
            pill_cutout(8, 10.5, plate_thickness);
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
    w = 16.0;
    h = 6.0;
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
