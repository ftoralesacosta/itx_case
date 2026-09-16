// Asrock B760M ITX D4 - Custom IO Faceplate
// All dimensions in mm
//
// Positions below are measured directly off a real test print held against the real
// board (print_over_real_mb_image.png), not derived from the io_shield.svg (that SVG was
// traced from a photo and its absolute scale proved unreliable - see README/session notes).
// Method: the plate's own known real outline (158.75 x 44.45mm) was used to calibrate
// px-to-mm directly on that photo, then each port's cutout/hardware bounding box was
// measured in pixels and converted. Shape sizes cross-checked against real datasheets
// (TE Connectivity stacked-USB-A 7-1773442-0, Wurth USB-C 632722200212, Wurth RP-SMA
// 65503503230503) where available; HDMI/DP chamfer sizes and audio/antenna spacing had no
// public spec found, so those stay measurement-derived. Re-verify against the next test
// print - this is a corrected estimate, not a fully independently-verified drawing.

// --- User Parameters ---
plate_thickness = 0.5;    // [1.0:0.1:5.0]
// Measured antenna-hole spacing (13.6mm) is real-board data, replacing the old 12.7mm
// "1/2 inch" assumption - the real board's antennas sit further apart than that generic
// standard. Hole diameter nudged up slightly (10.0 -> 10.5mm) to match the measured
// cutout's real footprint with a hair more clearance around the connector body.
wifi_spacing = 13.6;
wifi_hole_dia = 10.5;

// --- Standard ATX/ITX IO Shield Outer Dimensions ---
plate_width = 158.75;
plate_height = 44.45;

module io_faceplate() {
    difference() {
        // Main Plate
        cube([plate_width, plate_height, plate_thickness]);

        // HDMI Port - center measured (9.5, 7.6), was (11.5, 6.5). Size unchanged
        // (15x6mm, 2mm bottom chamfers) - measured cutout size already close to this.
        translate([9.5, 7.6, 0])
            hdmi_cutout(plate_thickness);

        // DisplayPort - center measured (10.4, 20.6), was (11.5, 19.5). Size unchanged
        // (16x6mm, 3mm bottom-left chamfer) - no strong evidence to change it.
        translate([10.4, 20.6, 0])
            dp_cutout(plate_thickness);

        // Dual USB-A (Left) - center measured (70.4, 11.1), was (73.1, 11.25).
        // Size (14.5 x 16.0mm) measured to already closely match the real cutout - kept.
        translate([70.4, 11.1, 0])
            cut_rect(14.5, 16.0, plate_thickness);

        // Dual USB-A (Right) - center measured (96.0, 10.4), was (98.5, 11.25).
        // Center-to-center from the left USB pair is now ~25.6mm (measured), still
        // essentially the "exactly 25.4mm" standard spacing - unchanged shape.
        translate([96.0, 10.4, 0])
            cut_rect(14.5, 16.0, plate_thickness);

        // Ethernet (RJ45) - center measured (96.4, 28.6), was (98.5, 28.2).
        // Height reduced 13.5 -> 12.0mm to match the measured real cutout height.
        translate([96.4, 28.6, 0])
            cut_rect(16.0, 12.0, plate_thickness);

        // USB-C - center measured (115.2, 6.8), was (116.0, 5.5). This raises it ~1.3mm
        // vs. the old position (you flagged ~2mm by eye - measurement here landed a bit
        // less than that; worth re-checking on the next print). Pill height trimmed
        // 4.2 -> 3.7mm per USB-C's real port geometry (Wurth 632722200212: 8.94x3.16mm
        // bare port + clearance).
        translate([115.2, 6.8, 0])
            pill_cutout(9.5, 3.7, plate_thickness);

        // Wi-Fi Antenna Holes - X measured 130.1 (was 132.0), vertical center measured
        // 22.0mm (was 23.675). wifi_spacing/wifi_hole_dia set above.
        translate([130.1, 22.0 - (wifi_spacing / 2), 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);
        translate([130.1, 22.0 + (wifi_spacing / 2), 0])
            cut_circle(wifi_hole_dia / 2, plate_thickness);

        // Audio Jacks - switched from vertical pills to plain circles per request: the
        // pill cutouts left a visible gap above/below the actual jack's colored ring
        // (confirmed in the photo), which is exactly what let the spacing look loose.
        // X/Y/spacing all measured from the jacks' own colored-ring pixel centroids
        // (blue/green/pink color detection), all 3 in the SAME reference frame - an
        // earlier pass accidentally anchored center_y on the old PILL CUTOUT's bounding
        // box instead of the real jack centroid, which are ~1.2mm apart and don't mix;
        // that mismatch put every hole about 1.2mm too low. Fixed: center_y now comes
        // from the green (middle) jack's own measured centroid (19.38mm), and spacing
        // from the average blue-green/green-pink centroid gaps (11.34/11.28mm).
        // Circle diameter 7.5mm matches the measured ring diameter (~6.9-7.1mm) + clearance.
        audio_x = 145.3;
        audio_spacing = 11.3;
        audio_center_y = 19.4;
        audio_dia = 7.5;
        translate([audio_x, audio_center_y + audio_spacing, 0])
            cut_circle(audio_dia / 2, plate_thickness);
        translate([audio_x, audio_center_y, 0])
            cut_circle(audio_dia / 2, plate_thickness);
        translate([audio_x, audio_center_y - audio_spacing, 0])
            cut_circle(audio_dia / 2, plate_thickness);
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

// --- SVG reference overlay (positioning guide only - see README/session notes) ---
// io_shield.svg was traced from a photo of the real board; its absolute scale/position
// has known error (systematic ~1-2mm X bias, plus a growing Y error up to ~3.8mm at the
// extremes, consistent with photo perspective distortion - NOT a simple uniform offset).
// Use it only as a rough positioning reference while tweaking cutout centers by hand;
// don't trust it for cutout shapes/sizes (those are already sourced from direct photo
// measurement + real connector datasheets - see comments above).
SHOW_SVG_REFERENCE = true;
// Despite being an unitless/px SVG, this OpenSCAD build (2026.02.19) imports it treating
// 1 SVG unit = 1mm directly - NOT the commonly-documented 96 DPI (1 unit = 0.264583mm)
// conversion. Verified empirically this session (rendered the raw import next to a
// known-size reference cube and measured the actual pixel ratio) after the 96 DPI
// assumption put the reference ~150mm off from the real plate. io_shield.svg is 786x208
// units with no explicit viewBox/units, so native OpenSCAD size = 786 x 208mm directly.
// Scaled here to the real plate footprint. NOT Y-flipped, per explicit correction from
// holding the real board: a from-scratch check this session (top-down render, pixel-
// verified against the known-correct HDMI/DP cutouts) found the Y-flipped version already
// put DisplayPort above HDMI, matching the ASRock manual's own port diagram and an earlier
// test-print photo - so that verification and this instruction directly disagree. Deferring
// to the physical part on purpose: flip removed below. If ports land upside-down again,
// this is the first place to check - re-verify against the real board, not just the manual/
// photo, since those are exactly what conflicted with the correction that landed here.
module svg_reference() {
    if (SHOW_SVG_REFERENCE) {
        svg_native_w = 786;
        svg_native_h = 208;
        sx = plate_width / svg_native_w;
        sy = plate_height / svg_native_h;
        %translate([0, 0, plate_thickness])
            scale([sx, sy, 1])
                import("io_shield.svg");
    }
}

// Instantiate the faceplate
io_faceplate();
svg_reference();
