// Asrock B760M ITX D4 - Custom IO Faceplate
// All dimensions in mm

// --- User Parameters ---
plate_thickness = 2.0;    // [1.0:0.1:5.0]
wifi_spacing = 12.7;      // Distance between Wi-Fi antennas (12.7mm or 1/2" is standard)
wifi_hole_dia = 10.0;     // Diameter of the Wi-Fi holes (10mm allows the antenna nut to recess)

// --- Standard ATX/ITX IO Shield Outer Dimensions ---
plate_width = 158.75;
plate_height = 44.45;

module io_faceplate() {
    difference() {
        // Main Plate
        cube([plate_width, plate_height, plate_thickness]);

        // HDMI Port
        // Center X = 11.5, Center Y = 6.5
        // Standard width 15mm, height 6mm. Bottom chamfers 2mm.
        translate([11.5, 6.5, 0])
            hdmi_cutout(plate_thickness);

        // DisplayPort
        // Center X = 11.5, Center Y = 19.5
        // Standard width 16mm, height 6mm. Bottom-left chamfer 3mm.
        translate([11.5, 19.5, 0])
            dp_cutout(plate_thickness);

        // Dual USB-A (Left)
        // Center X = 73.1, Center Y = 11.25
        // Width 14.5mm, Height 16.0mm
        translate([73.1, 11.25, 0])
            cut_rect(14.5, 16.0, plate_thickness);

        // Dual USB-A (Right)
        // Center X = 98.5, Center Y = 11.25
        // (Center-to-center distance from the Left USB is exactly 25.4mm)
        translate([98.5, 11.25, 0])
            cut_rect(14.5, 16.0, plate_thickness);

        // Ethernet (RJ45)
        // Stacked directly above Right Dual USB-A
        // Center X = 98.5, Center Y = 28.2
        // Width 16mm, Height 13.5mm
        translate([98.5, 28.2, 0])
            cut_rect(16.0, 13.5, plate_thickness);

        // USB-C
        // Center X = 116.0, Center Y = 5.5
        // Pill shape: width 9.5mm, height 4.2mm
        // Reverted to exactly fit the port barrel based on user request
        translate([116.0, 5.5, 0])
            pill_cutout(9.5, 4.2, plate_thickness);

        // Wi-Fi Antenna Holes
        // Centered vertically around Y = 23.675
        translate([132.0, 23.675 - (wifi_spacing / 2), 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);
        translate([132.0, 23.675 + (wifi_spacing / 2), 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);

        // Audio Jacks
        // Center X = 146.6. Y = 8.75, 20.75, 32.75
        // Vertical pill shape: width 8mm, height 10.5mm
        translate([146.6, 8.75, 0])
            pill_cutout(8, 10.5, plate_thickness);
        translate([146.6, 20.75, 0])
            pill_cutout(8, 10.5, plate_thickness);
        translate([146.6, 32.75, 0])
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
