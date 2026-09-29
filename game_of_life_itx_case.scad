// Game of Life ITX case spine. Design notes, sources, parameter reference: README.md.
// dual_HDD branch: two rotated 3.5" drives, no PSU - see README "dual_HDD branch".
include <c14_tool.scad>

SHOW_SPINE      = false;
SHOW_ENCLOSURE  = false;
SHOW_ODD        = false;

used_components = false;

SHOW_MB         = used_components;
SHOW_HDD        = used_components;
SHOW_HDD2       = used_components;  // dual_HDD: 2nd drive (replaces SHOW_GAN_PSU - no PSU here)

SHOW_NEW_SPINE  = true;
SHOW_FRONT_PANEL = true;
SHOW_FRONT_PANEL_LOWER = true;

SPINE_ALPHA     = 0.9;
ENCLOSURE_ALPHA = 0.55;

// dual_HDD: D 178 -> 214.5 on -Y only (front stays at -1; rear = plate rear - 2). Z bottom
// kept at main's -31.33 (set by main's PSU cable gap, which went with the PSU).
ENCLOSURE_SIZE = [170.5, 214.5, 91.83];
ENCLOSURE_POS  = [2.75, -108.25, 14.585];
ENCLOSURE_ROT  = [0, 0, 0];
ENCLOSURE_EDGE_R = 1.0;

MB_SIZE = [170, 170, 38];
MB_POS  = [3, -87.8, 34.6];  // Y is a literal (panel defined later): PCB edge sits MB_PANEL_GAP behind the panel; warned on drift
MB_ROT  = [0, 0, 0];

HDD_SIZE = [101.6, 146.99, 26.11];
// dual_HDD: rotated 90deg (main: [0,0,0]) - length along world X, so HDD_SIZE[0] is the Y depth.
HDD_ROT  = [0, 0, 90];
// Y is a literal (panel defined later): front face HDD_PANEL_GAP behind the panel's back face,
// -2.5 - 1.7 - 50.8 = -55; front_panel_lower() warns on drift. X -5 -> drive X -78.5 .. 68.5.
HDD_POS  = [-5, -55, -9.98];
HDD_PANEL_GAP = 1.7;  // free, but >= ~1.29 or HDD1's front standoff ramps poke through the face (warned)
// 2nd drive: same model/holes/standoffs, HDD_STACK_GAP of air behind HDD1. The two facing
// standoff rows sit 7.26mm apart and merge (one standoff group in new_spine()).
HDD_STACK_GAP = 0.9;  // free
HDD2_POS = [HDD_POS[0], HDD_POS[1] - HDD_SIZE[0] - HDD_STACK_GAP, HDD_POS[2]];  // derived (Y -157.5); HDD_SIZE[0] = Y depth only at ROT 90

ODD_SIZE = [128, 129, 12.7];
ODD_POS  = [30, -70, -50];
ODD_ROT  = [0, 0, 0];

// dual_HDD: GaN PSU, its 24-pin cluster, SC Shift adaptors and the 500W fit-check block removed.

MB_PCB_THICK   = 1.6;
MB_PCB_TOP_Z   = MB_POS[2] - MB_SIZE[2]/2 + MB_PCB_THICK;

// dual_HDD: rear -177 -> -213.5 (3.38mm past HDD2's rear standoffs) = the print height too.
SPINE_PLATE_POS  = [2.31, -107.75, 8.1];  // front edge (Y -2.0) must overlap the panel (back face -2.5) or the spine prints floating
SPINE_PLATE_SIZE = [170.6, 211.5, 3];  // X extent is overridden by SPINE_PLATE_NX_X / PX_X
SPINE_PLATE_MARGIN_X = 0;

// dual_HDD taper re-tune (see README): AFTERs are measured from the rear edge, which moved
// 36.5mm; PX/NX AFTER 56.5 keeps the rear taper-back at Y -157, clear of the MB rear standoff ramps.
SPINE_PLATE_PX_X = MB_POS[0] + MB_SIZE[0]/2 - 2.0;
SPINE_PLATE_NX_X = MB_POS[0] - MB_SIZE[0]/2 + 2.0;
SPINE_PLATE_TAPER_PX_BEFORE = 41;
SPINE_PLATE_TAPER_PX_RUN = 20;
SPINE_PLATE_TAPER_PX_AFTER = 56.5;  // main: 20
SPINE_PLATE_TAPER_PX_DEPTH = 30;

// dual_HDD: notch X -30 .. 32, floor Y -188.5 - ~2mm clear of HDD2's rear standoffs on each
// side. (main: 7 / 38 / 44.4 / 38 - would cut straight through them.)
SPINE_PLATE_TAPER_NY_BEFORE = 50;
SPINE_PLATE_TAPER_NY_RUN = 25;
SPINE_PLATE_TAPER_NY_AFTER = 54;
SPINE_PLATE_TAPER_NY_DEPTH = 25;

// dual_HDD: off (main: true). At X 30 .. 76 its floor (Y -206.5) cuts ~3.6mm into HDD2's
// +X rear standoff (-Y edge -210.12). Parameters kept as on main.
SPINE_PLATE_TAPER_NY2_ENABLE = false;
SPINE_PLATE_TAPER_NY2_BEFORE = 110;
SPINE_PLATE_TAPER_NY2_RUN    = 3;
SPINE_PLATE_TAPER_NY2_AFTER  = 10;
SPINE_PLATE_TAPER_NY2_DEPTH  = 7;

SPINE_PLATE_TAPER_NX_BEFORE = 53.0;
SPINE_PLATE_TAPER_NX_RUN = 28;
SPINE_PLATE_TAPER_NX_AFTER = 56.5;  // main: 55
SPINE_PLATE_TAPER_NX_DEPTH = 28;

STANDOFF_R      = 3.5;
STANDOFF_HOLE_R = 1.9;
STANDOFF_MARGIN = 8;
STANDOFF_RAMP_RUN_FACTOR = 1.0;  // 1.0 = 45deg, self-supporting

MB_HEAT_INSERT          = true;
MB_INSERT_HOLE_DIA      = 4.0;
MB_INSERT_LEN           = 5.7;
MB_INSERT_DEPTH_EXTRA   = 1.0;
MB_INSERT_MIN_WALL      = 1.8;
MB_STANDOFF_R = MB_HEAT_INSERT ? max(STANDOFF_R, MB_INSERT_HOLE_DIA/2 + MB_INSERT_MIN_WALL) : STANDOFF_R;

MB_HOLES_X_SHIFT = 0;
MB_HOLES_RAW = [
    [-79.16,  75.47],
    [ 78.14,  52.57],
    [-79.13, -79.13],
    [ 78.14, -79.13],
];
MB_HOLES = [for (p = MB_HOLES_RAW) [p[0] + MB_HOLES_X_SHIFT, p[1]]];

HDD_HOLE_X_INSET  = 3.18;  // SFF-8301 A5
HDD_HOLE_Y_FRONT  = 41.28;  // SFF-8301 A7, from the connector end
HDD_HOLE_Y_PITCH  = 76.20;  // SFF-8301 A13 (A6 = 44.45 for middle-pair-only drives)
// dual_HDD: connector end of both drives - true = world -X (local +Y), false = +X (local -Y,
// main's convention). Only valid for HDD_ROT = [0,0,90]. true leaves just 4mm to the -X face
// (+X has 19.5); false moves every HDD standoff 11.77mm -X and needs a taper re-tune (warned).
HDD_SATA_FACING_NEG_X = true;
HDD_HOLES = let(
        hx = HDD_SIZE[0]/2 - HDD_HOLE_X_INSET,
        s  = HDD_SATA_FACING_NEG_X ? 1 : -1,
        y1 = s * (HDD_SIZE[1]/2 - HDD_HOLE_Y_FRONT),  // pair nearest the connector end
        y2 = y1 - s * HDD_HOLE_Y_PITCH
    ) [[hx,y1], [hx,y2], [-hx,y1], [-hx,y2]];
HDD_STANDOFF_HOLE_R = 2.3;
HDD_STANDOFF_R = 5;
HDD_ORING_OD = 7.24;
HDD_ORING_CS = 1.78;
HDD_ORING_POCKET_CLEARANCE = 0.4;
HDD_ORING_POCKET_DIA   = HDD_ORING_OD + HDD_ORING_POCKET_CLEARANCE;
HDD_ORING_POCKET_DEPTH = 1.56;

// dual_HDD: GAN_PSU_HOLES / GAN_STANDOFF_* / GAN_ORING_* / GAN_SCREW_CS_* removed with the PSU.

// Uses MB_PCB_TOP_Z, so this block must stay below the MB derived block.
CPU_COOLER_HEIGHT = 37.0;
CPU_COOLER_FAN_D  = 92.0;  // assumed (AXP90 class) - verify; FAN_PANEL_GAP scales with it

FAN_PANEL_GAP = 5.0;  // don't go below ~4 without redoing the vent numbers

CPU_COOLER_TOP_Z  = MB_PCB_TOP_Z + CPU_COOLER_HEIGHT;
FAN_PANEL_INNER_Z = CPU_COOLER_TOP_Z + FAN_PANEL_GAP;

FRONT_PANEL_TOP_Z_STL = 55;  // reference only, unused
FRONT_PANEL_TOP_Z     = FAN_PANEL_INNER_Z;
FRONT_PANEL_THICKNESS = 2.5;  // front face at Y=0

FRONT_PANEL_IO_OFFSET = [-72.01, 86.99, -2.83, 41.67];  // [x_min, x_max, z_min, z_max] from MB_POS[0] / mb_bottom

IO_SHIELD_STL_FILE = "asrock_b860i_io_shield.stl";
IO_SHIELD_STL_SIZE = [155.0, 40.5];  // must match the STL bbox exactly - larger cuts a slot across the panel
IO_SHIELD_EDGE_INSET = 1.0;  // must stay < the nearest port's distance to the shield edge
IO_SHIELD_Z_SHIFT = 2.0;

IO_POCKET_DEPTH  = 1.2;
IO_POCKET_MARGIN = 2.0;
IO_POCKET_SCREW_WALL = 1.0;
IO_POCKET_EXTRA_NX = 2.5;
IO_POCKET_EXTRA_PZ = 3.0;
MB_PANEL_GAP = 0.3;
IO_PORT_OVERHANG = 1.0;
IO_PORT_CLEARANCE = 0.5;
USB_C_RELIEF        = true;
USB_C_RELIEF_SIZE   = [13.0, 7.0];   // overmold opening [w, h], pill
USB_C_RELIEF_CENTER = [116.14, 5.25];  // USB-C centre in shield-STL coords
// dual_HDD: C14 off by default - no PSU to feed, and its body (to Y -28.6) runs into HDD1.
// true restores main's socket/screw/flange cuts + grill width; front_panel_lower() warns on the clash.
C14_ENABLE = false;
USE_SNAP_IN_C14 = false;
SHOW_C14_SOCKET = used_components && C14_ENABLE;
C14_STL_FILE = USE_SNAP_IN_C14 ? "c14_snap-fit_socket.stl" : "c14_socket.stl";
C14_POS = [-52.5, -2, -9.83];
C14_ROT = [270, 180, 0];
C14_SNAP_CUTOUT_W = 28.0;
C14_SNAP_CUTOUT_H = 20.5;
C14_SCREW_PITCH = 42.0;  // runs along world X for C14_ROT = [270,180,0]; re-check if ROT changes
C14_SCREW_R = 1.75;
// dual_HDD: rearmost body point in STL-local z (= world Y offset from C14_POS[1] at this ROT),
// measured off the two STLs. HDD1 clash check only.
C14_BODY_LOCAL_Z_MIN = USE_SNAP_IN_C14 ? -23.0 : -26.6;

C14_SCREW_CS_DIA   = 6.4;
C14_SCREW_CS_ANGLE = 90;
module c14_screw_holes() {
    cs_r     = C14_SCREW_CS_DIA / 2;
    cs_depth = countersink_depth(C14_SCREW_R, C14_SCREW_CS_DIA, C14_SCREW_CS_ANGLE);
    for (s = [-1, 1])
        translate([C14_POS[0] + s*C14_SCREW_PITCH/2, 0, C14_POS[2]]) {
            rotate([90, 0, 0])
                cylinder(r = C14_SCREW_R, h = 50, center = true, $fn = 32);
            translate([0, -cs_depth, 0])
                rotate([-90, 0, 0])
                    cylinder(h = cs_depth, r1 = C14_SCREW_R, r2 = cs_r, $fn = 48);
            rotate([-90, 0, 0])
                cylinder(h = 1, r = cs_r, $fn = 48);
        }
}

C14_FLANGE_LOCAL_Z   = [-3.0, 0.0];
C14_FLANGE_CLEARANCE = 0.3;
module c14_flange_pocket() {
    if (!USE_SNAP_IN_C14)
        translate(C14_POS)
            rotate(C14_ROT)
                translate([0, 0, C14_FLANGE_LOCAL_Z[0]])
                    linear_extrude(height = C14_FLANGE_LOCAL_Z[1] - C14_FLANGE_LOCAL_Z[0])
                        offset(r = C14_FLANGE_CLEARANCE)
                            offset(delta = -2) offset(r = 2)  // closes the screw holes
                                projection(cut = true)
                                    translate([0, 0, -(C14_FLANGE_LOCAL_Z[0] + C14_FLANGE_LOCAL_Z[1])/2])
                                        import(C14_STL_FILE);
}

FRONT_PANEL_SCREW_X_INSET = 5.0;
FRONT_PANEL_SCREW_Z_INSET = 5.0;
FRONT_PANEL_SCREW_R       = 1.7;
FRONT_PANEL_SCREW_CS_DIA   = 6.4;
FRONT_PANEL_SCREW_CS_ANGLE = 90;
FRONT_PANEL_SCREW_GRILL_WALL = 1.2;

module panel_screw_hole(x, z, r, cs_dia, cs_angle) {
    cs_r = cs_dia / 2;
    cs_depth = countersink_depth(r, cs_dia, cs_angle);
    translate([x, -FRONT_PANEL_THICKNESS - 1, z])
        rotate([-90, 0, 0])
            cylinder(h = FRONT_PANEL_THICKNESS + 2, r = r, $fn = 24);
    translate([x, -cs_depth, z])
        rotate([-90, 0, 0])
            cylinder(h = cs_depth, r1 = r, r2 = cs_r, $fn = 48);
    translate([x, 0, z])
        rotate([-90, 0, 0])
            cylinder(h = 1, r = cs_r, $fn = 48);
}

FRONT_PANEL_MOUNT_OFFSET_UPPER = [[0, 0], [0, 0], [0, 0]];  // [dx, dz]: -X corner, mid, +X corner
FRONT_PANEL_MOUNT_OFFSET_LOWER = [[0, 0], [0, 0], [0, 0]];  // [dx, dz]: -X corner, mid, +X corner

function front_panel_mount_x() = [
    ENCLOSURE_POS[0] - ENCLOSURE_SIZE[0]/2 + FRONT_PANEL_SCREW_X_INSET,
    ENCLOSURE_POS[0],
    ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2 - FRONT_PANEL_SCREW_X_INSET,
];
function front_panel_mount_holes_upper() =
    let(xs = front_panel_mount_x(), z = FRONT_PANEL_TOP_Z - FRONT_PANEL_SCREW_Z_INSET,
        o = FRONT_PANEL_MOUNT_OFFSET_UPPER)
    [for (i = [0 : 2]) [xs[i] + o[i][0], z + o[i][1]]];
function front_panel_mount_holes_lower() =
    let(xs = front_panel_mount_x(),
        z = ENCLOSURE_POS[2] - ENCLOSURE_SIZE[2]/2 + FRONT_PANEL_SCREW_Z_INSET,
        o = FRONT_PANEL_MOUNT_OFFSET_LOWER)
    [for (i = [0 : 2]) [xs[i] + o[i][0], z + o[i][1]]];

module front_panel_mount_holes(pts) {
    for (p = pts)
        panel_screw_hole(p[0], p[1], FRONT_PANEL_SCREW_R,
            FRONT_PANEL_SCREW_CS_DIA, FRONT_PANEL_SCREW_CS_ANGLE);
}

// The shield projection is solid WITH holes; its complement inside an inset square is the holes only.
module io_port_holes_2d() {
    difference() {
        translate([IO_SHIELD_EDGE_INSET, IO_SHIELD_EDGE_INSET])
            square(IO_SHIELD_STL_SIZE - 2*[IO_SHIELD_EDGE_INSET, IO_SHIELD_EDGE_INSET]);
        projection(cut = false)
            import(IO_SHIELD_STL_FILE);
    }
}

module front_panel_upper(show, plate_bot, col, alpha) {
    if (show) {
        x_min = ENCLOSURE_POS[0] - ENCLOSURE_SIZE[0]/2;
        x_max = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2;
        mb_bottom = MB_POS[2] - MB_SIZE[2]/2;
        io = [
            MB_POS[0] + FRONT_PANEL_IO_OFFSET[0],
            MB_POS[0] + FRONT_PANEL_IO_OFFSET[1],
            mb_bottom + FRONT_PANEL_IO_OFFSET[2],
            mb_bottom + FRONT_PANEL_IO_OFFSET[3],
        ];

        // Shield local y=0 is its HDMI/DP (low) end, which lands on world Z under rotate([90,0,0]).
        shield_x = (io[0] + io[1])/2 - IO_SHIELD_STL_SIZE[0]/2;
        shield_z = (io[2] + io[3])/2 - IO_SHIELD_STL_SIZE[1]/2 + IO_SHIELD_Z_SHIFT;

        mb_front_y = MB_POS[1] + MB_SIZE[1]/2;
        mb_gap = -FRONT_PANEL_THICKNESS - mb_front_y;
        if (abs(mb_gap - MB_PANEL_GAP) > 0.01)
            echo(str("WARNING: PCB front edge is ", mb_gap, "mm behind the panel, not MB_PANEL_GAP = ",
                     MB_PANEL_GAP, ". Set MB_POS[1] to ",
                     -FRONT_PANEL_THICKNESS - MB_PANEL_GAP - MB_SIZE[1]/2, "."));
        if (mb_gap < 0)
            echo(str("WARNING: PCB front edge (Y ", mb_front_y, ") is INSIDE the front panel."));
        port_room = mb_gap + IO_POCKET_DEPTH;
        if (IO_PORT_OVERHANG + IO_PORT_CLEARANCE > port_room + 0.001)
            echo(str("WARNING: IO connectors stick out ", IO_PORT_OVERHANG,
                     "mm past the PCB but there's only ", port_room,
                     "mm to the pocket floor (want ", IO_PORT_CLEARANCE,
                     "mm clearance). Deepen IO_POCKET_DEPTH or grow MB_PANEL_GAP."));

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, plate_bot])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, FRONT_PANEL_TOP_Z - plate_bot]);
                translate([shield_x, 0.5, shield_z])
                    rotate([90, 0, 0])
                        linear_extrude(height = FRONT_PANEL_THICKNESS + 2.5)
                            io_port_holes_2d();
                // Lets the plug overmold pass the face: USB-C only allows ~0.26mm between receptacle and exterior.
                if (USB_C_RELIEF)
                    translate([shield_x + USB_C_RELIEF_CENTER[0], 0.5, shield_z + USB_C_RELIEF_CENTER[1]])
                        rotate([90, 0, 0])
                            linear_extrude(height = FRONT_PANEL_THICKNESS + 2.5)
                                hull() for (s = [-1, 1])
                                    translate([s * (USB_C_RELIEF_SIZE[0] - USB_C_RELIEF_SIZE[1])/2, 0])
                                        circle(d = USB_C_RELIEF_SIZE[1], $fn = 48);

                if (IO_POCKET_DEPTH > 0)
                    translate([shield_x, -FRONT_PANEL_THICKNESS + IO_POCKET_DEPTH, shield_z])
                        rotate([90, 0, 0])
                            linear_extrude(height = IO_POCKET_DEPTH + 1)
                                difference() {
                                    // Shifted copies stretch the pocket by IO_POCKET_EXTRA_NX on -X and IO_POCKET_EXTRA_PZ on +Z only.
                                    hull() for (d = [[0, 0], [-IO_POCKET_EXTRA_NX, 0], [0, IO_POCKET_EXTRA_PZ]]) translate(d)
                                    // Hull of per-column bands (PCB top .. highest opening) = one rectangle over the cluster.
                                    offset(delta = IO_POCKET_MARGIN)
                                        hull()
                                        intersection() {
                                            minkowski() {
                                                io_port_holes_2d();
                                                translate([-0.005, -500]) square([0.01, 1000]);
                                            }
                                            hull() {
                                                minkowski() {
                                                    io_port_holes_2d();
                                                    translate([-500, -0.005]) square([1000, 0.01]);
                                                }
                                                translate([-500, MB_PCB_TOP_Z - shield_z])
                                                    square([1000, 0.01]);
                                            }
                                        }
                                    for (p = front_panel_mount_holes_upper())
                                        translate([p[0] - shield_x, p[1] - shield_z])
                                            circle(r = FRONT_PANEL_SCREW_CS_DIA/2 + IO_POCKET_SCREW_WALL, $fn = 48);
                                }

                if (C14_ENABLE) {  // dual_HDD: off by default
                    translate(C14_POS)
                        rotate(C14_ROT)
                            c14_solid_tool();

                    c14_screw_holes();
                    c14_flange_pocket();
                }

                front_panel_mount_holes(front_panel_mount_holes_upper());
            }
    }
}

// dual_HDD: GAN_CABLE_CUTOUT_* / GAN_FRONT_MOUNT_* / FRONT_VENT_* removed with the PSU (they
// were already disabled in front_panel_lower() on main).

SPINE_LIGHTENING_MODE = "diamond";  // "honeycomb" or "diamond"
SPINE_LIGHTENING_MARGIN_PX = 3;
SPINE_LIGHTENING_MARGIN_NX = 3;
SPINE_LIGHTENING_MARGIN_PY = 0;
SPINE_LIGHTENING_MARGIN_NY = 3;

SPINE_LIGHTENING_STANDOFF_PROTECT_FUDGE = 0.3;
SPINE_HONEYCOMB_HEX_R  = 4;
SPINE_HONEYCOMB_WALL   = 1.4;
SPINE_GRID_SLOT_W = 8;
SPINE_GRID_SLOT_H = 8;
SPINE_GRID_WALL   = 1.5;
SPINE_LIGHTENING_NY_INLAY_SCALE = 0.3;

LIFE_BLOCK   = [[0,0],[1,0], [0,1],[1,1]];
LIFE_BEEHIVE = [[1,0],[2,0], [0,1],[3,1], [1,2],[2,2], [0,0],[3,0],[0,2],[3,2]];
LIFE_POND    = [[1,0],[2,0], [0,1],[3,1], [0,2],[3,2], [1,3],[2,3]];
LIFE_HEX_RING = [[1,0],[2,0], [0,1],[3,1], [1,2],[2,2]];

ARROW_GT_2 = [[0,0], [0,1], [-1,0]];
ARROW_GT_3 = [[0,0], [0,1],[0,2], [-1,0],[-2,0]];
ARROW_LT_2 = [[0,0], [1,0], [0,-1]];
ARROW_LT_3 = [[0,0], [1,0],[2,0], [0,-1],[0,-2]];

GOL_OFF = [];

HDD_GRILL_MODE = "diamond";  // "honeycomb" or "diamond"
// dual_HDD: C14 off -> whole face less 2mm per side (X -80.5 .. 86); on -> main's 108 @ 32.
HDD_GRILL_W = C14_ENABLE ? 108 : 166.5;
HDD_GRILL_POS_X = C14_ENABLE ? 32 : 2.75;  // 2.75 = ENCLOSURE_POS[0]
HDD_GRILL_MARGIN_TOP    = 9;
HDD_GRILL_MARGIN_BOTTOM = 6.83;

HDD_GRILL_HEX_R  = 4;
HDD_GRILL_WALL   = 1.25;
HDD_GRILL_DIAMOND_SLOT_W = 4;
HDD_GRILL_DIAMOND_SLOT_H = 4;

function diamond_anchor(x, y) = [x + y, y - x];

GOL_Grill_1_SHAPE  = LIFE_HEX_RING;
GOL_Grill_1_ANCHOR = diamond_anchor(4, -1);
GOL_Grill_2_SHAPE  = LIFE_HEX_RING;
GOL_Grill_2_ANCHOR = diamond_anchor(-1, -1);
GOL_Grill_3_SHAPE  = LIFE_HEX_RING;
GOL_Grill_3_ANCHOR = diamond_anchor(-6, -1);
GOL_Grill_4_SHAPE  = GOL_OFF;
GOL_Grill_4_ANCHOR = diamond_anchor(-3, 0);

FRONT_PANEL_CORNER_INFILL_X = 13;
FRONT_PANEL_CORNER_INFILL_Z = 13;

function lightening_protect_dist(wp, protect_pts, protect_rects) =
    min(concat(
        [for (c = protect_pts) max(norm([wp[0] - c[0], wp[1] - c[1]]) - c[2], 0)],
        [for (r = protect_rects)
            norm([max(r[0] - wp[0], wp[0] - r[2], 0), max(r[1] - wp[1], wp[1] - r[3], 0)])],
        [1e9]
    ));

function point_seg_dist(p, a, b) =
    let(ab = b - a, t = (ab*ab > 0) ? max(0, min(1, ((p - a)*ab) / (ab*ab))) : 0)
    norm(p - (a + t*ab));

function point_polyline_dist(p, pts) =
    min([for (i = [0 : len(pts) - 2]) point_seg_dist(p, pts[i], pts[i + 1])]);

function life_pattern_protect_pts(cells, anchor, pitch_x, pitch_y, world_rot) =
    [for (c = cells)
        let(x = (anchor[0] + c[0]) * pitch_x, y = (anchor[1] + c[1]) * pitch_y)
        [cos(world_rot)*x - sin(world_rot)*y, sin(world_rot)*x + cos(world_rot)*y, 0]];

function standoff_lightening_protect(pos, local_pts, rot_z, r, z_from, z_to, nx_limit, px_limit, ny_limit, py_limit) =
    let(
        run = abs(z_to - z_from) * STANDOFF_RAMP_RUN_FACTOR,
        pts = world_holes(pos, local_pts, rot_z),
        needed = [for (wp = pts)
            !(wp[0] + r <= nx_limit || wp[0] - r >= px_limit ||
              wp[1] + r + run <= ny_limit || wp[1] - r >= py_limit)]
    )
    [
        [for (i = [0 : len(pts) - 1]) if (needed[i]) [pts[i][0], pts[i][1], r]],
        [for (i = [0 : len(pts) - 1]) if (needed[i])
            [pts[i][0] - r, pts[i][1] + r, pts[i][0] + r, pts[i][1] + r + run]]
    ];

module honeycomb_2d(w, h, hex_r, wall, protect_pts=[], protect_rects=[], protect_fudge=0, world_rot=0, world_translate=[0,0]) {
    r_tile = hex_r + wall / sqrt(3);
    pitch_x = 1.5 * r_tile;
    pitch_y = sqrt(3) * r_tile;
    n_cols = ceil(w / pitch_x) + 2;
    n_rows = ceil(h / pitch_y) + 2;
    apothem = hex_r * cos(30);
    intersection() {
        union() {
            for (i = [-n_cols : n_cols]) {
                x = i * pitch_x;
                y_off = (i % 2 == 0) ? 0 : pitch_y / 2;
                for (j = [-n_rows : n_rows]) {
                    y = j * pitch_y + y_off;
                    wp = [cos(world_rot)*x - sin(world_rot)*y, sin(world_rot)*x + cos(world_rot)*y] + world_translate;
                    if (lightening_protect_dist(wp, protect_pts, protect_rects) >= apothem - protect_fudge) {
                        translate([x, y])
                            circle(r = hex_r, $fn = 6);
                    }
                }
            }
        }
        square([w, h], center = true);
    }
}

module grid_2d(w, h, slot_w, slot_h, wall, protect_pts=[], protect_rects=[], protect_fudge=0, world_rot=0, world_translate=[0,0],
                inlay_edge_pts=[], inlay_scale=1) {
    pitch_x = slot_w + wall;
    pitch_y = slot_h + wall;
    n_cols = ceil(w / pitch_x) + 1;
    n_rows = ceil(h / pitch_y) + 1;
    apothem = min(slot_w, slot_h) / 2;
    inlay_reach = sqrt(pow(slot_w, 2) + pow(slot_h, 2)) / 2;
    intersection() {
        union() {
            for (i = [-n_cols : n_cols]) {
                for (j = [-n_rows : n_rows]) {
                    x = i * pitch_x;
                    y = j * pitch_y;
                    wp = [cos(world_rot)*x - sin(world_rot)*y, sin(world_rot)*x + cos(world_rot)*y] + world_translate;
                    if (lightening_protect_dist(wp, protect_pts, protect_rects) >= apothem - protect_fudge) {
                        translate([x, y]) {
                            if (len(inlay_edge_pts) >= 2 && point_polyline_dist(wp, inlay_edge_pts) < inlay_reach) {
                                grid_2d(slot_w, slot_h, slot_w * inlay_scale, slot_h * inlay_scale, wall * inlay_scale);
                            } else {
                                square([slot_w, slot_h], center = true);
                            }
                        }
                    }
                }
            }
        }
        square([w, h], center = true);
    }
}

module front_panel_lower(show, plate_top, col, alpha) {
    if (show) {
        x_min = ENCLOSURE_POS[0] - ENCLOSURE_SIZE[0]/2;
        x_max = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2;
        z_min = ENCLOSURE_POS[2] - ENCLOSURE_SIZE[2]/2;
        // dual_HDD (replaces main's PSU cable-gap check): HDD1 front face -> panel back face.
        hdd1_front_y = HDD_POS[1] + HDD_SIZE[0]/2;  // HDD_SIZE[0] = Y depth at HDD_ROT [0,0,90]
        hdd1_gap = -FRONT_PANEL_THICKNESS - hdd1_front_y;
        if (abs(hdd1_gap - HDD_PANEL_GAP) > 0.01)
            echo(str("WARNING: HDD1 front face is ", hdd1_gap, "mm behind the panel, not HDD_PANEL_GAP = ",
                     HDD_PANEL_GAP, ". Set HDD_POS[1] to ",
                     -FRONT_PANEL_THICKNESS - HDD_PANEL_GAP - HDD_SIZE[0]/2, "."));
        // Y-only: anywhere the socket fits on this panel is inside HDD1's X/Z footprint.
        c14_rear_y = C14_POS[1] + C14_BODY_LOCAL_Z_MIN;
        if (C14_ENABLE && c14_rear_y < hdd1_front_y)
            echo(str("WARNING: C14_ENABLE is on, but the socket body reaches Y ", c14_rear_y, " - ",
                     hdd1_front_y - c14_rear_y, "mm into HDD1 (front face at Y ", hdd1_front_y,
                     "). Move the drives back (HDD_PANEL_GAP) or keep C14_ENABLE off."));

        grill_w = HDD_GRILL_W;
        grill_x = HDD_GRILL_POS_X;
        grill_z_min = HDD_POS[2] - HDD_SIZE[2]/2 - HDD_GRILL_MARGIN_BOTTOM;
        grill_z_max = HDD_POS[2] + HDD_SIZE[2]/2 + HDD_GRILL_MARGIN_TOP;
        grill_h = grill_z_max - grill_z_min;
        grill_z = (grill_z_min + grill_z_max) / 2;

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, z_min])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, plate_top - z_min]);

                if (C14_ENABLE) {  // dual_HDD: off by default
                    translate(C14_POS)
                        rotate(C14_ROT)
                            c14_solid_tool();

                    c14_screw_holes();
                    c14_flange_pocket();
                }
                front_panel_mount_holes(front_panel_mount_holes_lower());

                // Grill-local frame: x = X - grill_x, y = -(Z - grill_z). The protect test is centre vs apothem, but a rotated cell reaches its circumradius - hence this extra.
                grill_cell_corner_extra = (HDD_GRILL_MODE == "diamond")
                    ? sqrt(pow(HDD_GRILL_DIAMOND_SLOT_W, 2) + pow(HDD_GRILL_DIAMOND_SLOT_H, 2))/2
                        - min(HDD_GRILL_DIAMOND_SLOT_W, HDD_GRILL_DIAMOND_SLOT_H)/2
                    : HDD_GRILL_HEX_R * (1 - cos(30));
                grill_screw_protect = [for (p = concat(front_panel_mount_holes_lower(), front_panel_mount_holes_upper()))
                    [p[0] - grill_x, -(p[1] - grill_z),
                     FRONT_PANEL_SCREW_CS_DIA/2 + FRONT_PANEL_SCREW_GRILL_WALL + grill_cell_corner_extra]];

                translate([grill_x, -FRONT_PANEL_THICKNESS - 1, grill_z])
                    rotate([-90, 0, 0])
                        linear_extrude(height = FRONT_PANEL_THICKNESS + 2)
                            difference() {
                                if (HDD_GRILL_MODE == "diamond") {
                                    grill_diamond_span = sqrt(pow(grill_w, 2) + pow(grill_h, 2));
                                    grill_life_pitch = [HDD_GRILL_DIAMOND_SLOT_W + HDD_GRILL_WALL, HDD_GRILL_DIAMOND_SLOT_H + HDD_GRILL_WALL];
                                    gol_grill_slots = [
                                        [GOL_Grill_1_SHAPE, GOL_Grill_1_ANCHOR], [GOL_Grill_2_SHAPE, GOL_Grill_2_ANCHOR],
                                        [GOL_Grill_3_SHAPE, GOL_Grill_3_ANCHOR], [GOL_Grill_4_SHAPE, GOL_Grill_4_ANCHOR],
                                    ];
                                    grill_life_protect = [for (s = gol_grill_slots) if (len(s[1]) > 0)
                                        for (p = life_pattern_protect_pts(s[0], s[1], grill_life_pitch[0], grill_life_pitch[1], 45)) p];
                                    intersection() {
                                        rotate(45)
                                            grid_2d(grill_diamond_span, grill_diamond_span,
                                                HDD_GRILL_DIAMOND_SLOT_W, HDD_GRILL_DIAMOND_SLOT_H, HDD_GRILL_WALL,
                                                concat(grill_life_protect, grill_screw_protect), [], 0, 45);
                                        square([grill_w, grill_h], center = true);
                                    }
                                } else {
                                    honeycomb_2d(grill_w, grill_h, HDD_GRILL_HEX_R, HDD_GRILL_WALL, grill_screw_protect);
                                }
                            }
            }
    }
}

module labeled_box(size, pos, rot, show, col, alpha=1) {
    if (show) {
        translate(pos)
            rotate(rot)
                color(col, alpha)
                    cube(size, center=true);
    }
}

module enclosure_ref(size, pos, rot, show, col, alpha, edge_r) {
    if (show) {
        translate(pos)
            rotate(rot)
                color(col, alpha)
                    box_wireframe(size, edge_r);
    }
}

module box_wireframe(size, r) {
    x = size[0] / 2;
    y = size[1] / 2;
    z = size[2] / 2;
    corners = [
        [-x,-y,-z], [x,-y,-z], [x,y,-z], [-x,y,-z],
        [-x,-y, z], [x,-y, z], [x,y, z], [-x,y, z],
    ];
    edges = [
        [0,1],[1,2],[2,3],[3,0],
        [4,5],[5,6],[6,7],[7,4],
        [0,4],[1,5],[2,6],[3,7],
    ];
    for (e = edges) {
        hull() {
            translate(corners[e[0]]) sphere(r=r, $fn=12);
            translate(corners[e[1]]) sphere(r=r, $fn=12);
        }
    }
}

function rot2d(p, deg) = [p[0]*cos(deg) - p[1]*sin(deg), p[0]*sin(deg) + p[1]*cos(deg)];

function world_holes(pos, local_pts, rot_z) =
    [for (p = local_pts) let(wc = rot2d(p, rot_z)) [pos[0] + wc[0], pos[1] + wc[1]]];

function countersink_depth(r, cs_dia, cs_angle) = (cs_dia/2 - r) / tan(cs_angle/2);

function spine_plate_px_edge(y) =
    let(
        full  = SPINE_PLATE_PX_X,
        narrow = full - SPINE_PLATE_TAPER_PX_DEPTH,
        y_max = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2,
        y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_PX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_PX_RUN,
        bbe = y_min + SPINE_PLATE_TAPER_PX_AFTER,
        bte = bbe + SPINE_PLATE_TAPER_PX_RUN
    )
    (y > fbe) ? full :
    (y > fte) ? full - (full - narrow) * (fbe - y) / SPINE_PLATE_TAPER_PX_RUN :
    (y > bte) ? narrow :
    (y > bbe) ? full - (full - narrow) * (y - bbe) / SPINE_PLATE_TAPER_PX_RUN :
    full;

function spine_plate_nx_edge(y) =
    let(
        full  = SPINE_PLATE_NX_X,
        narrow = full + SPINE_PLATE_TAPER_NX_DEPTH,
        y_max = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2,
        y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_NX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_NX_RUN,
        bbe = y_min + SPINE_PLATE_TAPER_NX_AFTER,
        bte = bbe + SPINE_PLATE_TAPER_NX_RUN
    )
    (y > fbe) ? full :
    (y > fte) ? full + (narrow - full) * (fbe - y) / SPINE_PLATE_TAPER_NX_RUN :
    (y > bte) ? narrow :
    (y > bbe) ? full + (narrow - full) * (y - bbe) / SPINE_PLATE_TAPER_NX_RUN :
    full;

function spine_plate_ny_taper_cut(x, before, run, after, depth) =
    let(
        lbe = SPINE_PLATE_NX_X + before,
        lte = lbe + run,
        rbe = SPINE_PLATE_PX_X - after,
        rte = rbe - run
    )
    (x < lbe) ? 0 :
    (x < lte) ? depth * (x - lbe) / run :
    (x < rte) ? depth :
    (x < rbe) ? depth * (rbe - x) / run :
    0;

function spine_plate_ny_cut1(x) = spine_plate_ny_taper_cut(x,
    SPINE_PLATE_TAPER_NY_BEFORE, SPINE_PLATE_TAPER_NY_RUN, SPINE_PLATE_TAPER_NY_AFTER, SPINE_PLATE_TAPER_NY_DEPTH);
function spine_plate_ny_cut2(x) = SPINE_PLATE_TAPER_NY2_ENABLE ? spine_plate_ny_taper_cut(x,
    SPINE_PLATE_TAPER_NY2_BEFORE, SPINE_PLATE_TAPER_NY2_RUN, SPINE_PLATE_TAPER_NY2_AFTER, SPINE_PLATE_TAPER_NY2_DEPTH) : 0;

function spine_plate_ny_edge(x) =
    (SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2) + max(spine_plate_ny_cut1(x), spine_plate_ny_cut2(x));

function _sort_uniq(v) = len(v) <= 1 ? v :
    let(p = v[floor(len(v)/2)])
    concat(_sort_uniq([for (e = v) if (e < p) e]), [p], _sort_uniq([for (e = v) if (e > p) e]));

// Includes NY/NY2 slope crossings, where max() kinks between breakpoints.
function spine_plate_ny_breaks() =
    let(
        x_min = SPINE_PLATE_NX_X,
        x_max = SPINE_PLATE_PX_X,
        t1 = [SPINE_PLATE_TAPER_NY_BEFORE, SPINE_PLATE_TAPER_NY_RUN, SPINE_PLATE_TAPER_NY_AFTER],
        t2 = [SPINE_PLATE_TAPER_NY2_BEFORE, SPINE_PLATE_TAPER_NY2_RUN, SPINE_PLATE_TAPER_NY2_AFTER],
        pts = function (t) [x_min + t[0], x_min + t[0] + t[1], x_max - t[2] - t[1], x_max - t[2]],
        raw = concat([x_min, x_max], pts(t1), SPINE_PLATE_TAPER_NY2_ENABLE ? pts(t2) : []),
        b = _sort_uniq([for (x = raw) min(max(x, x_min), x_max)]),
        d = function (x) spine_plate_ny_cut1(x) - spine_plate_ny_cut2(x),
        cross = [for (i = [0 : len(b) - 2])
                    let(d0 = d(b[i]), d1 = d(b[i+1]))
                    if (d0 * d1 < 0) b[i] + (b[i+1] - b[i]) * d0 / (d0 - d1)]
    )
    _sort_uniq(concat(b, cross));

function spine_plate_px_edge_points(margin, y_pad = 50) =
    let(
        y_max = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2,
        y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_PX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_PX_RUN,
        bbe = y_min + SPINE_PLATE_TAPER_PX_AFTER,
        bte = bbe + SPINE_PLATE_TAPER_PX_RUN
    )
    [
        [spine_plate_px_edge(y_max) - margin, y_max + y_pad],
        [spine_plate_px_edge(y_max) - margin, y_max],
        [spine_plate_px_edge(fbe) - margin, fbe],
        [spine_plate_px_edge(fte) - margin, fte],
        [spine_plate_px_edge(bte) - margin, bte],
        [spine_plate_px_edge(bbe) - margin, bbe],
        [spine_plate_px_edge(y_min) - margin, y_min],
        [spine_plate_px_edge(y_min) - margin, y_min - y_pad],
    ];

function spine_plate_nx_edge_points(margin, y_pad = 50) =
    let(
        y_max = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2,
        y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_NX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_NX_RUN,
        bbe = y_min + SPINE_PLATE_TAPER_NX_AFTER,
        bte = bbe + SPINE_PLATE_TAPER_NX_RUN
    )
    [
        [spine_plate_nx_edge(y_max) + margin, y_max + y_pad],
        [spine_plate_nx_edge(y_max) + margin, y_max],
        [spine_plate_nx_edge(fbe) + margin, fbe],
        [spine_plate_nx_edge(fte) + margin, fte],
        [spine_plate_nx_edge(bte) + margin, bte],
        [spine_plate_nx_edge(bbe) + margin, bbe],
        [spine_plate_nx_edge(y_min) + margin, y_min],
        [spine_plate_nx_edge(y_min) + margin, y_min - y_pad],
    ];

function spine_plate_ny_edge_points(margin, x_pad = 50) =
    let(
        x_min = SPINE_PLATE_NX_X,
        x_max = SPINE_PLATE_PX_X
    )
    concat(
        [[x_min - x_pad, spine_plate_ny_edge(x_min) + margin]],
        [for (x = spine_plate_ny_breaks()) [x, spine_plate_ny_edge(x) + margin]],
        [[x_max + x_pad, spine_plate_ny_edge(x_max) + margin]]
    );

function spine_plate_outline() =
    let(
        plate_y = SPINE_PLATE_POS[1],
        plate_d = SPINE_PLATE_SIZE[1],
        plate_x_min = SPINE_PLATE_NX_X,
        plate_y_min = plate_y - plate_d/2,
        plate_y_max = plate_y + plate_d/2,
        px_edge = SPINE_PLATE_PX_X,
        px_narrow_x = px_edge - SPINE_PLATE_TAPER_PX_DEPTH,
        px_taper_front_start_y = plate_y_max - SPINE_PLATE_TAPER_PX_BEFORE,
        px_taper_front_end_y   = px_taper_front_start_y - SPINE_PLATE_TAPER_PX_RUN,
        px_taper_back_start_y  = plate_y_min + SPINE_PLATE_TAPER_PX_AFTER,
        px_taper_back_end_y    = px_taper_back_start_y + SPINE_PLATE_TAPER_PX_RUN,

        nx_inset_x = plate_x_min + SPINE_PLATE_TAPER_NX_DEPTH,
        nx_taper_front_start_y = plate_y_max - SPINE_PLATE_TAPER_NX_BEFORE,
        nx_taper_front_end_y   = nx_taper_front_start_y - SPINE_PLATE_TAPER_NX_RUN,
        nx_taper_back_start_y  = plate_y_min + SPINE_PLATE_TAPER_NX_AFTER,
        nx_taper_back_end_y    = nx_taper_back_start_y + SPINE_PLATE_TAPER_NX_RUN
    )
    concat(
    [for (x = spine_plate_ny_breaks()) [x, spine_plate_ny_edge(x)]],
    [
        // Must match spine_plate_px_edge() / nx_edge().
        [px_edge, px_taper_back_start_y],
        [px_narrow_x, px_taper_back_end_y],
        [px_narrow_x, px_taper_front_end_y],
        [px_edge, px_taper_front_start_y],
        [px_edge, plate_y_max],
        [plate_x_min, plate_y_max],
        [plate_x_min, nx_taper_front_start_y],
        [nx_inset_x, nx_taper_front_end_y],
        [nx_inset_x, nx_taper_back_end_y],
        [plate_x_min, nx_taper_back_start_y],
    ]);

module spine_plate_taper_warnings() {
    y_len = SPINE_PLATE_SIZE[1];
    ny_len = SPINE_PLATE_PX_X - SPINE_PLATE_NX_X;
    for (t = [["PX", SPINE_PLATE_TAPER_PX_BEFORE, SPINE_PLATE_TAPER_PX_RUN, SPINE_PLATE_TAPER_PX_AFTER, y_len],
              ["NX", SPINE_PLATE_TAPER_NX_BEFORE, SPINE_PLATE_TAPER_NX_RUN, SPINE_PLATE_TAPER_NX_AFTER, y_len],
              ["NY", SPINE_PLATE_TAPER_NY_BEFORE, SPINE_PLATE_TAPER_NY_RUN, SPINE_PLATE_TAPER_NY_AFTER, ny_len],
              if (SPINE_PLATE_TAPER_NY2_ENABLE)
              ["NY2", SPINE_PLATE_TAPER_NY2_BEFORE, SPINE_PLATE_TAPER_NY2_RUN, SPINE_PLATE_TAPER_NY2_AFTER, ny_len]]) {
        used = t[1] + 2*t[2] + t[3];
        if (used > t[4])
            echo(str("WARNING: SPINE_PLATE_TAPER_", t[0], " BEFORE + 2*RUN + AFTER = ", used,
                     " exceeds the edge length ", t[4], " by ", used - t[4],
                     " - the two tapers cross and the plate outline self-intersects."));
    }
    plate_x_max = SPINE_PLATE_POS[0] + (SPINE_PLATE_SIZE[0] - 2*SPINE_PLATE_MARGIN_X)/2;
    plate_y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2;
    front_x_max = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2;
    // dual_HDD: MB / HDD1 / HDD2 (main: MB / HDD / GaN). Main's "NY waist flush with the GaN
    // standoffs" drift check went with the PSU.
    standoff_sets = [["MB",   MB_POS,   MB_HOLES,  MB_ROT[2],  MB_STANDOFF_R],
                     ["HDD",  HDD_POS,  HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R],
                     ["HDD2", HDD2_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R]];
    // The -Y edge is piecewise linear, so its max over a standoff's X span sits at the span's ends
    // or at a breakpoint inside it - dual_HDD samples those breakpoints too (the NY notch sits
    // between HDD2's rear standoffs, 2mm off each).
    for (set = standoff_sets)
        for (wp = world_holes(set[1], set[2], set[3])) {
            xs = concat([for (dx = [-set[4], 0, set[4]]) wp[0] + dx],
                        [for (b = spine_plate_ny_breaks()) if (abs(b - wp[0]) < set[4]) b]);
            ny_edge_here = max([for (x = xs) spine_plate_ny_edge(x)]);
            if (wp[1] - set[4] < ny_edge_here - 0.01)
                echo(str("WARNING: SPINE_PLATE_TAPER_NY/NY2 cuts past a ", set[0], " standoff at [",
                    wp[0], ",", wp[1], "] - standoff -Y edge = ", wp[1] - set[4],
                    ", plate -Y edge there = ", ny_edge_here, " - this standoff may be disconnected from the plate."));
        }
    for (set = standoff_sets)
        for (wp = world_holes(set[1], set[2], set[3])) {
            nx_edge_here = spine_plate_nx_edge(wp[1]);
            if (wp[0] - set[4] < nx_edge_here - 0.01)
                echo(str("WARNING: SPINE_PLATE_NX_X / TAPER_NX_DEPTH (", SPINE_PLATE_TAPER_NX_DEPTH,
                    ") cuts past a ", set[0], " standoff at [", wp[0], ",", wp[1],
                    "] - standoff -X edge = ", wp[0] - set[4], ", plate -X edge there = ",
                    nx_edge_here, " - this standoff may be disconnected from the plate."));
        }
    for (set = standoff_sets)
        for (wp = world_holes(set[1], set[2], set[3])) {
            px_edge_here = spine_plate_px_edge(wp[1]);
            if (wp[0] + set[4] > px_edge_here + 0.01)
                echo(str("WARNING: SPINE_PLATE_TAPER_PX_DEPTH (", SPINE_PLATE_TAPER_PX_DEPTH,
                    ") cuts past a ", set[0], " standoff at [", wp[0], ",", wp[1],
                    "] - standoff +X edge = ", wp[0] + set[4], ", plate +X edge there = ",
                    px_edge_here, " - this standoff may be disconnected from the plate."));
        }
}

module standoff_ramp(wx, wy, r, z_from, z_to, plate_z, run) {
    EPS = 0.02;
    h = abs(z_to - z_from);
    zmin = min(z_from, z_to);
    union() {
        hull() {
            translate([wx, wy, zmin])
                cylinder(h = h, r = r, $fn = 24);
            translate([wx - r, wy + r, zmin])
                cube([2*r, EPS, h]);
        }
        hull() {
            translate([wx - r, wy + r, zmin])
                cube([2*r, EPS, h]);
            translate([wx - r, wy + r + run, plate_z - EPS/2])
                cube([2*r, EPS, EPS]);
        }
    }
}

module standoff_pegs(pos, local_pts, rot_z, r, z_from, z_to) {
    h = abs(z_to - z_from);
    run = h * STANDOFF_RAMP_RUN_FACTOR;
    zmin = min(z_from, z_to);
    for (wp = world_holes(pos, local_pts, rot_z)) {
        wx = wp[0];
        wy = wp[1];
        translate([wx, wy, zmin])
            cylinder(h = h, r = r, $fn = 24);
        standoff_ramp(wx, wy, r, z_from, z_to, z_from, run);
    }
}

module standoff_holes(pos, local_pts, rot_z, hole_r, z_from, z_to) {
    h = abs(z_to - z_from);
    zmin = min(z_from, z_to);
    for (wp = world_holes(pos, local_pts, rot_z)) {
        translate([wp[0], wp[1], zmin - 0.5])
            cylinder(h = h + 1, r = hole_r, $fn = 24);
    }
}

module standoffs(pos, local_pts, rot_z, r, hole_r, z_from, z_to) {
    difference() {
        standoff_pegs(pos, local_pts, rot_z, r, z_from, z_to);
        standoff_holes(pos, local_pts, rot_z, hole_r, z_from, z_to);
    }
}

module mb_insert_bores(mb_bottom) {
    if (MB_HEAT_INSERT) {
        depth = MB_INSERT_LEN + MB_INSERT_DEPTH_EXTRA;
        plate_bot_z = SPINE_PLATE_POS[2] - SPINE_PLATE_SIZE[2]/2;
        wall = MB_STANDOFF_R - MB_INSERT_HOLE_DIA/2;
        if (wall < MB_INSERT_MIN_WALL - 0.001)
            echo(str("WARNING: MB insert wall is ", wall, "mm (< MB_INSERT_MIN_WALL ", MB_INSERT_MIN_WALL, ")."));
        if (mb_bottom - depth < plate_bot_z + 1)
            echo(str("WARNING: MB insert bore bottom Z ", mb_bottom - depth, " leaves < 1mm of plate (plate bottom ",
                     plate_bot_z, ") - use a shorter insert."));
        for (wp = world_holes(MB_POS, MB_HOLES, MB_ROT[2]))
            translate([wp[0], wp[1], mb_bottom - depth])
                cylinder(h = depth + 0.5, r = MB_INSERT_HOLE_DIA/2, $fn = 32);
    }
}

module new_spine(show, col, alpha) {
    if (show) {
        mb_bottom = MB_POS[2] - MB_SIZE[2]/2;
        hdd_top   = HDD_POS[2] + HDD_SIZE[2]/2;
        hdd2_top  = HDD2_POS[2] + HDD_SIZE[2]/2;  // dual_HDD (replaces gan_top); = hdd_top while HDD2 shares HDD1's Z
        plate_x   = SPINE_PLATE_POS[0];
        plate_y   = SPINE_PLATE_POS[1];
        plate_z   = SPINE_PLATE_POS[2];
        plate_w   = SPINE_PLATE_SIZE[0] - 2*SPINE_PLATE_MARGIN_X;
        plate_d   = SPINE_PLATE_SIZE[1];
        plate_t   = SPINE_PLATE_SIZE[2];
        plate_top = plate_z + plate_t/2;
        plate_bot = plate_z - plate_t/2;
        spine_plate_taper_warnings();
        // dual_HDD (replaces main's GaN peg-length check): HDD standoff ramps run +Y toward the
        // front face (the print bed); flag any tip past Y 0. Ramp run as in standoff_pegs().
        for (hs = [[HDD_POS, hdd_top], [HDD2_POS, hdd2_top]])
            for (wp = world_holes(hs[0], HDD_HOLES, HDD_ROT[2])) {
                ramp_tip_y = wp[1] + HDD_STANDOFF_R
                    + abs(plate_bot - (hs[1] + HDD_ORING_POCKET_DEPTH)) * STANDOFF_RAMP_RUN_FACTOR;
                if (ramp_tip_y > 0)
                    echo(str("WARNING: HDD standoff ramp at [", wp[0], ",", wp[1], "] ends at Y ", ramp_tip_y,
                             ", past the front face (Y 0). Grow HDD_PANEL_GAP (and HDD_POS[1] with it)."));
            }
        plate_outline = spine_plate_outline();

        color(col, alpha) {
            difference() {
                translate([0, 0, plate_z])
                    linear_extrude(height = plate_t, center = true)
                        polygon(plate_outline);
                for (pos = [HDD_POS, HDD2_POS])  // dual_HDD: both drives (GaN holes/countersinks removed)
                    for (wp = world_holes(pos, HDD_HOLES, HDD_ROT[2])) {
                        wx = wp[0];
                        wy = wp[1];
                        translate([wx, wy, plate_bot - 0.5])
                            cylinder(h = plate_t + 1, r = HDD_STANDOFF_HOLE_R, $fn = 24);
                    }
                // The insert bore is deeper than the 6mm peg, so it also cuts the plate.
                mb_insert_bores(mb_bottom);
                lightening_px_limit = (ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2) - SPINE_LIGHTENING_MARGIN_PX;
                lightening_nx_limit = SPINE_PLATE_NX_X + SPINE_LIGHTENING_MARGIN_NX;
                lightening_py_limit = (plate_y + plate_d/2) - SPINE_LIGHTENING_MARGIN_PY;
                lightening_ny_limit = (plate_y - plate_d/2) + SPINE_LIGHTENING_MARGIN_NY;
                lightening_box_w = lightening_px_limit - lightening_nx_limit;
                lightening_box_d = lightening_py_limit - lightening_ny_limit;
                lightening_px_edge_pts = spine_plate_px_edge_points(SPINE_LIGHTENING_MARGIN_PX);
                lightening_px_region = concat(
                    lightening_px_edge_pts,
                    [[-100000, lightening_px_edge_pts[len(lightening_px_edge_pts) - 1][1]],
                     [-100000, lightening_px_edge_pts[0][1]]]
                );
                lightening_nx_edge_pts = spine_plate_nx_edge_points(SPINE_LIGHTENING_MARGIN_NX);
                lightening_nx_region = concat(
                    lightening_nx_edge_pts,
                    [[100000, lightening_nx_edge_pts[len(lightening_nx_edge_pts) - 1][1]],
                     [100000, lightening_nx_edge_pts[0][1]]]
                );
                lightening_ny_edge_pts = spine_plate_ny_edge_points(SPINE_LIGHTENING_MARGIN_NY);
                lightening_ny_region = concat(
                    lightening_ny_edge_pts,
                    [[lightening_ny_edge_pts[len(lightening_ny_edge_pts) - 1][0], 100000],
                     [lightening_ny_edge_pts[0][0], 100000]]
                );
                lightening_box_center = [(lightening_nx_limit + lightening_px_limit)/2, (lightening_ny_limit + lightening_py_limit)/2];
                mb_lightening_protect = standoff_lightening_protect(MB_POS, MB_HOLES, MB_ROT[2], MB_STANDOFF_R, plate_top, mb_bottom,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                hdd_lightening_protect = standoff_lightening_protect(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                hdd2_lightening_protect = standoff_lightening_protect(HDD2_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd2_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                lightening_protect_pts = concat(mb_lightening_protect[0], hdd_lightening_protect[0], hdd2_lightening_protect[0]);
                lightening_protect_rects = concat(mb_lightening_protect[1], hdd_lightening_protect[1], hdd2_lightening_protect[1]);
                translate([0, 0, plate_bot - 0.5])
                    linear_extrude(height = plate_t + 1)
                        intersection() {
                            translate(lightening_box_center)
                                square([lightening_box_w, lightening_box_d], center = true);
                            polygon(lightening_px_region);
                            polygon(lightening_nx_region);
                            polygon(lightening_ny_region);
                            if (SPINE_LIGHTENING_MODE == "diamond") {
                                diamond_span = sqrt(pow(lightening_box_w, 2) + pow(lightening_box_d, 2));
                                translate(lightening_box_center)
                                    rotate(45)
                                        grid_2d(diamond_span, diamond_span,
                                            SPINE_GRID_SLOT_W, SPINE_GRID_SLOT_H, SPINE_GRID_WALL,
                                            lightening_protect_pts, lightening_protect_rects, SPINE_LIGHTENING_STANDOFF_PROTECT_FUDGE,
                                            45, lightening_box_center,
                                            SPINE_LIGHTENING_NY_INLAY_SCALE > 0 ? lightening_ny_edge_pts : [],
                                            SPINE_LIGHTENING_NY_INLAY_SCALE);
                            } else {
                                translate(lightening_box_center)
                                    honeycomb_2d(
                                        lightening_box_w, lightening_box_d,
                                        SPINE_HONEYCOMB_HEX_R, SPINE_HONEYCOMB_WALL,
                                        lightening_protect_pts, lightening_protect_rects, SPINE_LIGHTENING_STANDOFF_PROTECT_FUDGE,
                                        0, lightening_box_center);
                            }
                        }
            }

            difference() {
                standoffs(MB_POS, MB_HOLES, MB_ROT[2], MB_STANDOFF_R, STANDOFF_HOLE_R, plate_top, mb_bottom);
                mb_insert_bores(mb_bottom);
            }

            difference() {
                union() {
                    // Unioned before drilling so one part's ramps can't refill another's bores.
                    // dual_HDD: HDD1's rear and HDD2's front rows are 7.26mm apart and overlap, so
                    // they MUST share this group (main: HDD + GaN).
                    standoff_pegs(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd_top + HDD_ORING_POCKET_DEPTH);
                    standoff_pegs(HDD2_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd2_top + HDD_ORING_POCKET_DEPTH);
                }
                standoff_holes(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_HOLE_R, plate_bot, hdd_top + HDD_ORING_POCKET_DEPTH);
                standoff_holes(HDD2_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_HOLE_R, plate_bot, hdd2_top + HDD_ORING_POCKET_DEPTH);
            }

            front_panel_upper(SHOW_FRONT_PANEL, plate_bot, col, alpha);
            front_panel_lower(SHOW_FRONT_PANEL_LOWER, plate_top, col, alpha);

        }
    }
}

module spine_ref(show, pos, rot, alpha) {
    if (show) {
        translate(pos)
            rotate(rot)
                color("SlateGray", alpha)
                    import("4.7-Fish_-_spine.stl");
    }
}

if (SHOW_C14_SOCKET) {
    color("LawnGreen")
    translate(C14_POS)
        rotate(C14_ROT)
            import(C14_STL_FILE);
}

spine_ref(SHOW_SPINE, [80, 0, 0], [0, -90, 0], SPINE_ALPHA);
new_spine(SHOW_NEW_SPINE, "Orange", 1);

enclosure_ref(ENCLOSURE_SIZE, ENCLOSURE_POS, ENCLOSURE_ROT, SHOW_ENCLOSURE, "Gray", ENCLOSURE_ALPHA, ENCLOSURE_EDGE_R);

labeled_box(MB_SIZE,  MB_POS,  MB_ROT,  SHOW_MB,  "Blue");
labeled_box(HDD_SIZE, HDD_POS, HDD_ROT, SHOW_HDD, "Red");
labeled_box(HDD_SIZE, HDD2_POS, HDD_ROT, SHOW_HDD2, "Red");
labeled_box(ODD_SIZE, ODD_POS, ODD_ROT, SHOW_ODD, "Cyan");
// dual_HDD: GaN PSU / SC adaptor / 500W boxes and gan_adaptor_report() removed with the PSU.

cooler_clearance_report();

module cooler_clearance_report() {
    mb_env_top   = MB_POS[2] + MB_SIZE[2]/2;
    encl_top     = ENCLOSURE_POS[2] + ENCLOSURE_SIZE[2]/2;
    budget_slack = encl_top - FRONT_PANEL_TOP_Z;

    echo(str("Cooler stack: PCB top ", MB_PCB_TOP_Z, " + ", CPU_COOLER_HEIGHT,
             "mm cooler = fan top ", CPU_COOLER_TOP_Z,
             "; + ", FAN_PANEL_GAP, "mm intake gap => panel inner face ",
             FAN_PANEL_INNER_Z, "."));
    echo(str("=> FRONT_PANEL_TOP_Z = ", FRONT_PANEL_TOP_Z,
             " (was ", FRONT_PANEL_TOP_Z_STL, " off the reference STL, delta ",
             FRONT_PANEL_TOP_Z - FRONT_PANEL_TOP_Z_STL, "mm)."));
    echo(str("=> vent honeycomb: cell <= ", FAN_PANEL_GAP,
             "mm, ~1.0mm webs, CHAMFER the intake side, perforate out to ~",
             CPU_COOLER_FAN_D + 4*FAN_PANEL_GAP, "mm square over the fan."));

    if (FAN_PANEL_GAP < 4.0) {
        echo(str("WARNING: FAN_PANEL_GAP ", FAN_PANEL_GAP,
                 "mm is below the ~4mm floor. The vent cell must shrink to match, ",
                 "open area collapses, and the panel starts eating the fan's ",
                 "static pressure head. Re-run the numbers before committing."));
    }
    if (mb_env_top < CPU_COOLER_TOP_Z) {
        echo(str("WARNING: MB envelope top ", mb_env_top, " is ",
                 CPU_COOLER_TOP_Z - mb_env_top, "mm BELOW the real cooler top ",
                 CPU_COOLER_TOP_Z, ". Raise MB_SIZE[2] to ",
                 MB_SIZE[2] + (CPU_COOLER_TOP_Z - mb_env_top),
                 " so the render stops implying clearance that is not there."));
    }
    if (budget_slack < 0) {
        echo(str("WARNING: panel top ", FRONT_PANEL_TOP_Z, " overshoots the ",
                 "enclosure budget top ", encl_top, " by ", -budget_slack,
                 "mm. Grow ENCLOSURE_SIZE[2] to ",
                 ENCLOSURE_SIZE[2] - budget_slack, "."));
    } else {
        echo(str("=> ", budget_slack, "mm of enclosure budget left above the panel."));
    }
}
