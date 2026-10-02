// Shared model for spine.scad and io_plate.scad. Opened directly it shows the live assembly. Design notes: README.md.
include <c14_tool.scad>

ASSEMBLY_PREVIEW = true;   // part files set this false

SHOW_SPINE      = false;
SHOW_ENCLOSURE  = false;
SHOW_ODD        = false;

used_components = true;

SHOW_MB         = used_components;
SHOW_HDD        = used_components;
SHOW_GAN_PSU    = used_components;

SHOW_FRONT_PANEL = true;
SHOW_FRONT_PANEL_LOWER = true;

SPINE_ALPHA     = 0.9;
ENCLOSURE_ALPHA = 0.55;

ENCLOSURE_SIZE = [170.5, 178, 91.96];
ENCLOSURE_POS  = [2.75, -90, 14.52];
FRONT_PANEL_PSU_CABLE_GAP = 10.5;
ENCLOSURE_ROT  = [0, 0, 0];
ENCLOSURE_EDGE_R = 1.0;

MB_SIZE = [170, 170, 38];
MB_POS  = [3, -87.8, 34.6];  // Y is a literal (panel defined later): PCB edge sits MB_PANEL_GAP behind the panel; warned on drift
MB_ROT  = [0, 0, 0];

HDD_SIZE = [101.6, 146.99, 26.11];
HDD_POS  = [-27.38, -97, -9.98];
HDD_ROT  = [0, 0, 0];

ODD_SIZE = [128, 129, 12.7];
ODD_POS  = [30, -70, -50];
ODD_ROT  = [0, 0, 0];

GAN_PSU_SIZE = [170, 55, 25];  // [D, W, H] - ROT 90 turns D along world Y
GAN_PSU_POS  = [52.5, -89, -8.46];  // Z is a literal (plate defined later); new_spine() warns on drift
GAN_PSU_ROT  = [0, 0, 90];

GAN_24PIN_LEN   = 51.0;
GAN_24PIN_W     = 10.0;
GAN_24PIN_HDR_H = 11.0;
GAN_24PIN_INSET = 8.0;

MB_PCB_THICK   = 1.6;
MB_PCB_TOP_Z   = MB_POS[2] - MB_SIZE[2]/2 + MB_PCB_THICK;
GAN_PSU_REAR_Y = GAN_PSU_POS[1] - GAN_PSU_SIZE[0]/2;  // local X is world Y at ROT 90
GAN_PSU_BOT_Z  = GAN_PSU_POS[2] - GAN_PSU_SIZE[2]/2;
GAN_24PIN_POS  = [GAN_PSU_POS[0],
                  GAN_PSU_REAR_Y + GAN_24PIN_INSET,
                  GAN_PSU_BOT_Z - GAN_24PIN_HDR_H/2];

SHOW_GAN_BLOCKS   = false;
SC_ADAPTOR_SIZE   = [52, 32, 22];
SC_ADAPTOR_OFFSET = 32;
GAN_BLOCK_ROT     = [0, 0, 0];

GAN_BLOCK1_SIZE = SC_ADAPTOR_SIZE;
GAN_BLOCK1_POS  = [GAN_24PIN_POS[0],
                   GAN_24PIN_POS[1] - SC_ADAPTOR_SIZE[1]/2,
                   GAN_PSU_BOT_Z - SC_ADAPTOR_SIZE[2]/2];

GAN_BLOCK2_SIZE = SC_ADAPTOR_SIZE;
GAN_BLOCK2_POS  = [GAN_BLOCK1_POS[0],
                   GAN_BLOCK1_POS[1],
                   MB_PCB_TOP_Z + SC_ADAPTOR_SIZE[2]/2];

SC_JUNCTION_Y      = GAN_24PIN_POS[1] - SC_ADAPTOR_OFFSET;
MB_24PIN_IMPLIED   = [GAN_BLOCK1_POS[0], SC_JUNCTION_Y + SC_ADAPTOR_OFFSET, MB_PCB_TOP_Z];
SC_CABLE_FREE_SPAN = MB_PCB_TOP_Z - GAN_PSU_BOT_Z;

SC_MIN_SPAN_FLAT  = 45.0;
SC_MIN_SPAN_ROUND = 70.0;

SHOW_GAN_PSU_500W = false;
GAN_PSU_500W_SIZE = [200.2, 55, 40];

SPINE_PLATE_POS  = [2.31, -89.75, 8.1];  // literal: front edge must equal -(FRONT_PANEL_THICKNESS + SPINE_PANEL_GAP); warned on drift
SPINE_PLATE_SIZE = [170.6, 174.5, 3];  // X extent is overridden by SPINE_PLATE_NX_X / PX_X
SPINE_PLATE_MARGIN_X = 0;

SPINE_PLATE_PX_X = MB_POS[0] + MB_SIZE[0]/2 - 2.0;
SPINE_PLATE_NX_X = MB_POS[0] - MB_SIZE[0]/2 + 2.0;
SPINE_PLATE_TAPER_PX_BEFORE = 41;
SPINE_PLATE_TAPER_PX_RUN = 20;
SPINE_PLATE_TAPER_PX_AFTER = 20;
SPINE_PLATE_TAPER_PX_DEPTH = 30;

SPINE_PLATE_TAPER_NY_BEFORE = 7;
SPINE_PLATE_TAPER_NY_RUN = 38;
SPINE_PLATE_TAPER_NY_AFTER = 44.4;
SPINE_PLATE_TAPER_NY_DEPTH = 38.0;

SPINE_PLATE_TAPER_NY2_ENABLE = true;
SPINE_PLATE_TAPER_NY2_BEFORE = 110;
SPINE_PLATE_TAPER_NY2_RUN    = 3;
SPINE_PLATE_TAPER_NY2_AFTER  = 10;
SPINE_PLATE_TAPER_NY2_DEPTH  = 7;

SPINE_PLATE_TAPER_NX_BEFORE = 53.0;
SPINE_PLATE_TAPER_NX_RUN = 28;
SPINE_PLATE_TAPER_NX_AFTER = 55;
SPINE_PLATE_TAPER_NX_DEPTH = 28;

STANDOFF_R      = 3.5;
STANDOFF_HOLE_R = 1.9;
STANDOFF_MARGIN = 8;
STANDOFF_RAMP_RUN_FACTOR = 1.0;  // 1.0 = 45deg, self-supporting

// One heat-set insert for the whole build: the MB holes and the spine <-> I/O plate joints both use these.
MB_INSERT_HOLE_DIA      = 3.6;  // M3 x 4 x 4 (OD 4.0); set to the insert listing's recommended hole
MB_INSERT_LEN           = 4.0;  // M3 x 4; the MB boss under each hole grows with it (warned vs PSU / HDD / C14)
MB_INSERT_EXTRA         = 0.9;  // extra bore depth below the insert for displaced plastic (bore is open below)
MB_BOSS_CHAMFER         = 0.5;  // 45deg chamfer on the MB boss's bottom edge
MB_INSERT_MIN_WALL      = 1.8;
MB_STANDOFF_H           = 6.0;  // real part: M3 x 6 brass hex standoff (M-F, 3-4 mm male thread); MB_POS[2] must put the PCB underside this far above the plate (warned)
MB_INSERT_RING_R = MB_INSERT_HOLE_DIA/2 + MB_INSERT_MIN_WALL;

MB_HOLES_X_SHIFT = 0;
MB_HOLES_RAW = [
    [-79.16,  75.47],
    [ 78.14,  52.57],
    [-79.13, -79.13],
    [ 78.14, -79.13],
];
MB_HOLES = [for (p = MB_HOLES_RAW) [p[0] + MB_HOLES_X_SHIFT, p[1]]];

HDD_HOLE_X_INSET  = 3.18;  // SFF-8301 A5
HDD_HOLE_Y_FRONT  = 41.28;  // SFF-8301 A7, from the connector (-Y) end
HDD_HOLE_Y_PITCH  = 76.20;  // SFF-8301 A13 (A6 = 44.45 for middle-pair-only drives)
HDD_HOLES = let(
        hx = HDD_SIZE[0]/2 - HDD_HOLE_X_INSET,
        y1 = -HDD_SIZE[1]/2 + HDD_HOLE_Y_FRONT,
        y2 = y1 + HDD_HOLE_Y_PITCH
    ) [[hx,y1], [hx,y2], [-hx,y1], [-hx,y2]];
HDD_STANDOFF_HOLE_R = 2.3;
HDD_STANDOFF_R = 5;
HDD_ORING_OD = 7.24;
HDD_ORING_CS = 1.78;
HDD_ORING_POCKET_CLEARANCE = 0.4;
HDD_ORING_POCKET_DIA   = HDD_ORING_OD + HDD_ORING_POCKET_CLEARANCE;
HDD_ORING_POCKET_DEPTH = 1.56;

GAN_PSU_HOLES = [
    [ 71,  16.65],
    [-73,  16.65],
    [ 71, -16.65],
    [-73, -16.65],
];
GAN_STANDOFF_HOLE_R = 1.9;
GAN_STANDOFF_R = 5;
GAN_STANDOFF_H = 1.0;
// Same O-ring as the HDD (AS568-007) - one part for both.
GAN_ORING_OD = HDD_ORING_OD;
GAN_ORING_CS = HDD_ORING_CS;
GAN_ORING_POCKET_CLEARANCE = 0.4;
GAN_ORING_POCKET_DIA   = GAN_ORING_OD + GAN_ORING_POCKET_CLEARANCE;
GAN_ORING_POCKET_DEPTH = HDD_ORING_POCKET_DEPTH;
GAN_SCREW_CS_DIA   = 6.4;
GAN_SCREW_CS_ANGLE = 90;

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
IO_SHIELD_Z_SHIFT = 0.0;

IO_POCKET_DEPTH  = 1.2;
IO_POCKET_MARGIN = 2.0;
IO_POCKET_SCREW_WALL = 1.0;
IO_POCKET_EXTRA_NX = 2.5;
IO_POCKET_EXTRA_PZ = 5.0;  // fixed to the Wi-Fi housing: re-add any IO_SHIELD_Z_SHIFT change here with opposite sign
MB_PANEL_GAP = 0.3;
IO_PORT_OVERHANG = 1.0;
IO_PORT_CLEARANCE = 0.5;
USB_C_RELIEF        = true;
USB_C_RELIEF_SIZE   = [13.0, 7.0];   // overmold opening [w, h], pill
USB_C_RELIEF_CENTER = [116.14, 5.25];  // USB-C centre in shield-STL coords
USE_SNAP_IN_C14 = false;
SHOW_C14_SOCKET = used_components;
C14_STL_FILE = USE_SNAP_IN_C14 ? "c14_snap-fit_socket.stl" : "c14_socket.stl";
C14_POS = [-52.5, -2, -9.83];
C14_ROT = [270, 180, 0];
C14_SNAP_CUTOUT_W = 28.0;
C14_SNAP_CUTOUT_H = 20.5;
C14_SCREW_PITCH = 42.0;  // runs along world X for C14_ROT = [270,180,0]; re-check if ROT changes
C14_SCREW_R = 1.75;

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

// Spine <-> I/O plate joints: M3 flat heads through the panel into heat inserts in bosses on the spine's front edge.
// One X list drives both the panel countersinks and the spine bosses, so they always line up.
//SPINE_PANEL_SCREW_X      = [-68, -24, 20];
SPINE_PANEL_SCREW_X      = [-70, 0, 84];
SPINE_PANEL_GAP          = 0.0;
SPINE_PANEL_SCREW_LEN    = 10;  // flat head: length includes the head
SPINE_PANEL_INSERT_DIA   = MB_INSERT_HOLE_DIA;  // same insert as the MB holes
SPINE_PANEL_INSERT_LEN   = MB_INSERT_LEN;
SPINE_PANEL_INSERT_EXTRA = 1.0;
SPINE_PANEL_INSERT_WALL  = 1.8;
SPINE_PANEL_TIP_CLEARANCE = 1.0;
SPINE_PANEL_BOSS_END     = 1.5;
SPINE_PANEL_MIN_CLEARANCE = 0.5;

SPINE_PANEL_BOSS_R  = SPINE_PANEL_INSERT_DIA/2 + SPINE_PANEL_INSERT_WALL;
SPINE_PANEL_PLATE_TOP_Z = SPINE_PLATE_POS[2] + SPINE_PLATE_SIZE[2]/2;
SPINE_PANEL_PLATE_BOT_Z = SPINE_PLATE_POS[2] - SPINE_PLATE_SIZE[2]/2;
// Bore sits one wall under the MB face so the boss stays flush with it (spine prints MB face down).
SPINE_PANEL_SCREW_Z = SPINE_PANEL_PLATE_TOP_Z - SPINE_PANEL_BOSS_R;
SPINE_PANEL_FRONT_Y = -FRONT_PANEL_THICKNESS - SPINE_PANEL_GAP;
SPINE_PANEL_BORE_LEN = max(SPINE_PANEL_INSERT_LEN + SPINE_PANEL_INSERT_EXTRA,
                           SPINE_PANEL_SCREW_LEN - FRONT_PANEL_THICKNESS - SPINE_PANEL_GAP + SPINE_PANEL_TIP_CLEARANCE);
SPINE_PANEL_BOSS_LEN = SPINE_PANEL_BORE_LEN + SPINE_PANEL_BOSS_END;

// Spine channel: two ribs on the I/O plate's back face, above and below the spine's front edge.
SPINE_RIB_ENABLE          = true;
SPINE_RIB_DEPTH           = 2.0;   // how far the ribs stand off the panel back (Y)
SPINE_RIB_THICK           = 1.6;   // rib thickness (Z)
SPINE_RIB_CLEARANCE       = 0.2;   // per side, rib to spine plate
SPINE_RIB_RAMP            = 1.5;   // 45deg root ramp on each rib's outer side; capped at SPINE_RIB_DEPTH
SPINE_RIB_LEAD_IN         = 0.4;   // chamfer on the channel side of each rib tip
SPINE_RIB_NOTCH_CLEARANCE = 0.3;   // lower-rib gap each side of a joint boss (X)
SPINE_RIB_X_INSET         = 0;     // trims both rib ends in from the spine's front-edge width
SPINE_RIB_MB_CLEARANCE    = 2.0;   // upper rib to the MB PCB underside (through-hole pins)
HDD_GRILL_RIB_GAP         = 1.25;  // solid face between the grill top and the lower rib's footprint

SPINE_RIB_ROOT_Y   = -FRONT_PANEL_THICKNESS;
SPINE_RIB_TIP_Y    = SPINE_RIB_ROOT_Y - SPINE_RIB_DEPTH;
SPINE_RIB_RAMP_EFF = max(min(SPINE_RIB_RAMP, SPINE_RIB_DEPTH), 0);
SPINE_RIB_UPPER_Z  = [SPINE_PANEL_PLATE_TOP_Z + SPINE_RIB_CLEARANCE, SPINE_PANEL_PLATE_TOP_Z + SPINE_RIB_CLEARANCE + SPINE_RIB_THICK];
SPINE_RIB_LOWER_Z  = [SPINE_PANEL_PLATE_BOT_Z - SPINE_RIB_CLEARANCE - SPINE_RIB_THICK, SPINE_PANEL_PLATE_BOT_Z - SPINE_RIB_CLEARANCE];
SPINE_RIB_UPPER_FOOT_Z = SPINE_RIB_UPPER_Z[1] + SPINE_RIB_RAMP_EFF;  // highest point on the panel back
SPINE_RIB_LOWER_FOOT_Z = SPINE_RIB_LOWER_Z[0] - SPINE_RIB_RAMP_EFF;  // lowest point on the panel back

function spine_rib_x() = [spine_plate_nx_edge(SPINE_PANEL_FRONT_Y - 0.01) + SPINE_RIB_X_INSET,
                          spine_plate_px_edge(SPINE_PANEL_FRONT_Y - 0.01) - SPINE_RIB_X_INSET];

// YZ profile; s = +1 upper rib (ramp above), -1 lower rib (ramp below). Root sinks 0.01 into the panel.
function spine_rib_profile(s) =
    let(z_in  = s > 0 ? SPINE_RIB_UPPER_Z[0] : SPINE_RIB_LOWER_Z[1],
        z_out = s > 0 ? SPINE_RIB_UPPER_Z[1] : SPINE_RIB_LOWER_Z[0],
        yr = SPINE_RIB_ROOT_Y + 0.01, yt = SPINE_RIB_TIP_Y,
        li = min(SPINE_RIB_LEAD_IN, SPINE_RIB_THICK/2, SPINE_RIB_DEPTH/2),
        rp = SPINE_RIB_RAMP_EFF)
    [[yr, z_in], [yt + li, z_in], [yt, z_in + s*li], [yt, z_out],
     [SPINE_RIB_ROOT_Y - rp, z_out], [SPINE_RIB_ROOT_Y, z_out + s*rp], [yr, z_out + s*rp]];

module spine_ribs() {
    if (SPINE_RIB_ENABLE) {
        xs = spine_rib_x();
        notch_hw = SPINE_PANEL_BOSS_R + SPINE_RIB_NOTCH_CLEARANCE;
        for (s = [1, -1])
            difference() {
                translate([xs[0], 0, 0]) rotate([90, 0, 90])
                    linear_extrude(height = xs[1] - xs[0]) polygon(spine_rib_profile(s));
                if (s < 0)
                    for (x = SPINE_PANEL_SCREW_X)
                        translate([x - notch_hw, SPINE_RIB_TIP_Y - 1, SPINE_RIB_LOWER_FOOT_Z - 1])
                            cube([2*notch_hw, SPINE_RIB_DEPTH + 1.02, SPINE_RIB_LOWER_Z[1] - SPINE_RIB_LOWER_FOOT_Z + 2]);
            }
    }
}

// Lowest Z of the lower rib at Y = y (between root and tip).
function spine_rib_lower_bottom_at(y) =
    let(ramp_end = SPINE_RIB_ROOT_Y - SPINE_RIB_RAMP_EFF)
    y <= ramp_end ? SPINE_RIB_LOWER_Z[0] : SPINE_RIB_LOWER_Z[0] - (y - ramp_end);

module spine_rib_checks() {
    if (SPINE_RIB_ENABLE) {
        xs = spine_rib_x();
        if (SPINE_RIB_RAMP > SPINE_RIB_DEPTH)
            echo(str("WARNING: SPINE_RIB_RAMP ", SPINE_RIB_RAMP, " exceeds SPINE_RIB_DEPTH ", SPINE_RIB_DEPTH, " - capped to the depth."));
        if (SPINE_LIGHTENING_MARGIN_PY < SPINE_RIB_DEPTH)
            echo(str("WARNING: SPINE_LIGHTENING_MARGIN_PY ", SPINE_LIGHTENING_MARGIN_PY, " < SPINE_RIB_DEPTH ", SPINE_RIB_DEPTH,
                     " - the spine edge inside the channel is not solid."));
        // Components below the lower rib: [name, x span, front Y, top Z].
        for (b = [["GaN PSU", [GAN_PSU_POS[0] - GAN_PSU_SIZE[1]/2, GAN_PSU_POS[0] + GAN_PSU_SIZE[1]/2],
                   GAN_PSU_POS[1] + GAN_PSU_SIZE[0]/2, GAN_PSU_POS[2] + GAN_PSU_SIZE[2]/2],
                  ["HDD", [HDD_POS[0] - HDD_SIZE[0]/2, HDD_POS[0] + HDD_SIZE[0]/2],
                   HDD_POS[1] + HDD_SIZE[1]/2, HDD_POS[2] + HDD_SIZE[2]/2],
                  ["C14 body", [C14_POS[0] - C14_BODY_HALF_W, C14_POS[0] + C14_BODY_HALF_W],
                   0, C14_POS[2] + C14_BODY_TOP_DZ]])
            if (_span_overlap(xs[0], xs[1], b[1][0], b[1][1]) && b[2] > SPINE_RIB_TIP_Y) {
                gap = spine_rib_lower_bottom_at(min(b[2], SPINE_RIB_ROOT_Y)) - b[3];
                echo(str("Spine rib: lower rib is ", gap, "mm above the ", b[0], "."));
                if (gap < SPINE_PANEL_MIN_CLEARANCE)
                    echo(str("WARNING: lower spine rib is only ", gap, "mm above the ", b[0],
                             " (< SPINE_PANEL_MIN_CLEARANCE ", SPINE_PANEL_MIN_CLEARANCE, "). Reduce SPINE_RIB_THICK / RAMP."));
            }
        pcb_bot = MB_POS[2] - MB_SIZE[2]/2;
        pcb_front_y = MB_POS[1] + MB_SIZE[1]/2;
        upper_top = SPINE_RIB_UPPER_Z[1] + max(SPINE_RIB_RAMP_EFF - (SPINE_RIB_ROOT_Y - min(pcb_front_y, SPINE_RIB_ROOT_Y)), 0);
        mb_gap = pcb_bot - upper_top;
        echo(str("Spine rib: upper rib is ", mb_gap, "mm below the MB PCB."));
        if (mb_gap < SPINE_RIB_MB_CLEARANCE)
            echo(str("WARNING: upper spine rib is only ", mb_gap, "mm below the MB PCB (< SPINE_RIB_MB_CLEARANCE ",
                     SPINE_RIB_MB_CLEARANCE, "). Reduce SPINE_RIB_THICK / RAMP."));
        if (SPINE_RIB_UPPER_FOOT_Z > MB_PCB_TOP_Z - IO_POCKET_MARGIN - 1.0)
            echo(str("WARNING: upper spine rib foot (Z ", SPINE_RIB_UPPER_FOOT_Z, ") is within 1mm of the I/O pocket."));
    }
}

// Measured from c14_socket.stl at C14_POS / C14_ROT: body X +-25.0, top at C14_POS[2] + 11.0. Re-measure for the right-angle socket.
C14_BODY_HALF_W   = 25.0;
C14_BODY_TOP_DZ   = 11.0;
C14_BODY_DEPTH    = 28.6;

function spine_panel_screw_pts() = [for (x = SPINE_PANEL_SCREW_X) [x, SPINE_PANEL_SCREW_Z]];

module spine_panel_screw_holes() {
    front_panel_mount_holes(spine_panel_screw_pts());
}

module spine_panel_bosses() {
    r = SPINE_PANEL_BOSS_R;
    for (x = SPINE_PANEL_SCREW_X)
        hull() {
            translate([x, SPINE_PANEL_FRONT_Y, SPINE_PANEL_SCREW_Z])
                rotate([90, 0, 0])
                    cylinder(h = SPINE_PANEL_BOSS_LEN, r = r, $fn = 48);
            translate([x - r, SPINE_PANEL_FRONT_Y - SPINE_PANEL_BOSS_LEN, SPINE_PANEL_PLATE_BOT_Z])
                cube([2*r, SPINE_PANEL_BOSS_LEN, SPINE_PLATE_SIZE[2]]);
        }
}

module spine_panel_boss_bores() {
    for (x = SPINE_PANEL_SCREW_X)
        translate([x, SPINE_PANEL_FRONT_Y + 0.5, SPINE_PANEL_SCREW_Z])
            rotate([90, 0, 0]) {
                cylinder(h = SPINE_PANEL_INSERT_LEN + SPINE_PANEL_INSERT_EXTRA + 0.5, r = SPINE_PANEL_INSERT_DIA/2, $fn = 32);
                cylinder(h = SPINE_PANEL_BORE_LEN + 0.5, r = FRONT_PANEL_SCREW_R, $fn = 24);
            }
}

// Footprint [x0, y0, x1, y1] kept solid by the lightening pattern.
function spine_panel_boss_protect_rects(wall) =
    [for (x = SPINE_PANEL_SCREW_X)
        [x - SPINE_PANEL_BOSS_R - wall, SPINE_PANEL_FRONT_Y - SPINE_PANEL_BOSS_LEN - wall,
         x + SPINE_PANEL_BOSS_R + wall, SPINE_PANEL_FRONT_Y + 1]];

function _span_overlap(a0, a1, b0, b1) = min(a1, b1) > max(a0, b0);

// XZ gap from the D-shaped boss at x to a component top at Z `top` spanning X [a0, a1]; negative = overlap.
function spine_panel_boss_gap(x, a0, a1, top) =
    let(r  = SPINE_PANEL_BOSS_R,
        dz = max(SPINE_PANEL_SCREW_Z - top, 0),
        round_part = norm([max(a0 - x, x - a1, 0), dz]) - r,
        flat_part  = norm([max(a0 - (x + r), (x - r) - a1, 0), dz]))
    min(round_part, flat_part);

function _rect_pt_dist(x0, x1, y0, y1, p) = norm([max(x0 - p[0], p[0] - x1, 0), max(y0 - p[1], p[1] - y1, 0)]);

module spine_panel_joint_checks() {
    r = SPINE_PANEL_BOSS_R;
    by0 = SPINE_PANEL_FRONT_Y - SPINE_PANEL_BOSS_LEN;
    by1 = SPINE_PANEL_FRONT_Y;
    plate_front = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2;
    plate_rear  = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2;
    if (abs(plate_front - SPINE_PANEL_FRONT_Y) > 0.01)
        echo(str("WARNING: spine front edge is Y ", plate_front, ", not -(FRONT_PANEL_THICKNESS + SPINE_PANEL_GAP) = ",
                 SPINE_PANEL_FRONT_Y, ". Set SPINE_PLATE_POS[1] to ", (SPINE_PANEL_FRONT_Y + plate_rear)/2,
                 " and SPINE_PLATE_SIZE[1] to ", SPINE_PANEL_FRONT_Y - plate_rear, " to keep the rear edge at ", plate_rear, "."));
    gan_x = [GAN_PSU_POS[0] - GAN_PSU_SIZE[1]/2, GAN_PSU_POS[0] + GAN_PSU_SIZE[1]/2];
    gan_y = [GAN_PSU_POS[1] - GAN_PSU_SIZE[0]/2, GAN_PSU_POS[1] + GAN_PSU_SIZE[0]/2];
    gan_top = GAN_PSU_POS[2] + GAN_PSU_SIZE[2]/2;
    hdd_x = [HDD_POS[0] - HDD_SIZE[0]/2, HDD_POS[0] + HDD_SIZE[0]/2];
    hdd_y = [HDD_POS[1] - HDD_SIZE[1]/2, HDD_POS[1] + HDD_SIZE[1]/2];
    hdd_top = HDD_POS[2] + HDD_SIZE[2]/2;
    c14_x = [C14_POS[0] - C14_BODY_HALF_W, C14_POS[0] + C14_BODY_HALF_W];
    c14_y = [C14_POS[1] - C14_BODY_DEPTH, 0];
    c14_top = C14_POS[2] + C14_BODY_TOP_DZ;
    case_x = [ENCLOSURE_POS[0] - ENCLOSURE_SIZE[0]/2, ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2];
    cs_r = FRONT_PANEL_SCREW_CS_DIA/2;
    pocket_bot = MB_PCB_TOP_Z - IO_POCKET_MARGIN;
    standoffs = concat(
        [for (wp = world_holes(HDD_POS, HDD_HOLES, HDD_ROT[2])) ["HDD standoff", wp, HDD_STANDOFF_R]],
        [for (wp = world_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2])) ["GaN standoff", wp, GAN_STANDOFF_R]]);
    for (x = SPINE_PANEL_SCREW_X) {
        bx0 = x - r;
        bx1 = x + r;
        for (b = [["GaN PSU", gan_x, gan_y, gan_top], ["HDD", hdd_x, hdd_y, hdd_top], ["C14 body", c14_x, c14_y, c14_top]])
            if (_span_overlap(by0, by1, b[2][0], b[2][1])) {
                gap = spine_panel_boss_gap(x, b[1][0], b[1][1], b[3]);
                if (gap < 2)
                    echo(str("Spine joint X ", x, ": boss is ", gap, "mm from the ", b[0], "."));
                if (gap < SPINE_PANEL_MIN_CLEARANCE)
                    echo(str("WARNING: spine joint boss at X ", x, (gap < 0 ? " overlaps" : " is only " ), (gap < 0 ? "" : str(gap, "mm from")),
                             " the ", b[0], " (< SPINE_PANEL_MIN_CLEARANCE ", SPINE_PANEL_MIN_CLEARANCE, "). Move it in SPINE_PANEL_SCREW_X."));
            }
        for (k = standoffs)
            if (_rect_pt_dist(bx0, bx1, by0, by1, k[1]) < k[2] + 0.01)
                echo(str("WARNING: spine joint boss at X ", x, " overlaps the ", k[0], " at [", k[1][0], ",", k[1][1], "]."));
        // MB insert bores are re-cut after the bosses, so only the joint's own insert bore can clash with them.
        for (wp = world_holes(MB_POS, MB_HOLES, MB_ROT[2])) {
            bore_gap = _rect_pt_dist(x - SPINE_PANEL_INSERT_DIA/2, x + SPINE_PANEL_INSERT_DIA/2,
                                     SPINE_PANEL_FRONT_Y - SPINE_PANEL_BORE_LEN, SPINE_PANEL_FRONT_Y, wp) - MB_INSERT_HOLE_DIA/2;
            if (bore_gap < SPINE_PANEL_MIN_CLEARANCE)
                echo(str("WARNING: spine joint insert bore at X ", x, " is ", bore_gap, "mm from the MB insert bore at [",
                         wp[0], ",", wp[1], "] (< SPINE_PANEL_MIN_CLEARANCE ", SPINE_PANEL_MIN_CLEARANCE, ")."));
        }
        if (bx0 < case_x[0] - 0.01 || bx1 > case_x[1] + 0.01)
            echo(str("WARNING: spine joint boss at X ", x, " spans X ", bx0, "..", bx1, ", past the case side (X ",
                     case_x[0], "..", case_x[1], ") - it would hit the side wall."));
        if (bx0 < spine_plate_nx_edge(SPINE_PANEL_FRONT_Y - 0.01) || bx1 > spine_plate_px_edge(SPINE_PANEL_FRONT_Y - 0.01))
            echo(str("Spine joint X ", x, ": boss hangs past the spine plate's front edge (fine)."));
        if (_span_overlap(x - cs_r, x + cs_r, c14_x[0], c14_x[1]) && SPINE_PANEL_SCREW_Z - cs_r < c14_top + 1.0)
            echo(str("WARNING: spine joint countersink at X ", x, " is within 1mm of the C14 flange (top Z ", c14_top, ")."));
        if (SPINE_PANEL_SCREW_Z + cs_r > pocket_bot - 1.0)
            echo(str("WARNING: spine joint countersink at X ", x, " is within 1mm of the I/O pocket."));
    }
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

                translate(C14_POS)
                    rotate(C14_ROT)
                        c14_solid_tool();

                c14_screw_holes();
                c14_flange_pocket();

                front_panel_mount_holes(front_panel_mount_holes_upper());
            }
    }
}

GAN_CABLE_CUTOUT_W = 20;
GAN_CABLE_CUTOUT_H = 15;
GAN_FRONT_MOUNT_MARGIN = 6;
GAN_FRONT_MOUNT_R = 1.5;
GAN_FRONT_MOUNT_CS_DIA   = 6.4;
GAN_FRONT_MOUNT_CS_ANGLE = 90;

FRONT_VENT_POS   = [-48, 2];
FRONT_VENT_SIZE  = [16, 5];
FRONT_VENT_SLOT_W = 1.6;
FRONT_VENT_WALL   = 1.6;

SPINE_LIGHTENING_MODE = "diamond";  // "honeycomb" or "diamond"
SPINE_LIGHTENING_MARGIN_PX = 3;
SPINE_LIGHTENING_MARGIN_NX = 3;
SPINE_LIGHTENING_MARGIN_PY = 3;
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
HDD_GRILL_W = 108;
HDD_GRILL_POS_X = 32;
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
        psu_cable_gap = (GAN_PSU_POS[2] - GAN_PSU_SIZE[2]/2) - z_min;
        if (abs(psu_cable_gap - FRONT_PANEL_PSU_CABLE_GAP) > 0.01)
            echo(str("WARNING: panel bottom is ", psu_cable_gap, "mm below the PSU, not FRONT_PANEL_PSU_CABLE_GAP = ",
                     FRONT_PANEL_PSU_CABLE_GAP, ". Shift ENCLOSURE_SIZE[2]/POS[2] (top fixed) so the bottom is at ",
                     GAN_PSU_POS[2] - GAN_PSU_SIZE[2]/2 - FRONT_PANEL_PSU_CABLE_GAP, "."));
        cable_w = GAN_CABLE_CUTOUT_W;
        cable_h = GAN_CABLE_CUTOUT_H;
        cable_x = GAN_PSU_POS[0];
        cable_z = GAN_PSU_POS[2];

        mount_hx = GAN_PSU_SIZE[1]/2 - GAN_FRONT_MOUNT_MARGIN;
        mount_hz = GAN_PSU_SIZE[2]/2 - GAN_FRONT_MOUNT_MARGIN;
        mount_pts = [
            [GAN_PSU_POS[0] + mount_hx, GAN_PSU_POS[2] + mount_hz],
            [GAN_PSU_POS[0] + mount_hx, GAN_PSU_POS[2] - mount_hz],
            [GAN_PSU_POS[0] - mount_hx, GAN_PSU_POS[2] + mount_hz],
            [GAN_PSU_POS[0] - mount_hx, GAN_PSU_POS[2] - mount_hz],
        ];

                grill_w = HDD_GRILL_W;
        grill_x = HDD_GRILL_POS_X;
        grill_z_min = HDD_POS[2] - HDD_SIZE[2]/2 - HDD_GRILL_MARGIN_BOTTOM;
        // With the spine ribs on, the grill top sits HDD_GRILL_RIB_GAP below the lower rib's footprint (HDD_GRILL_MARGIN_TOP is unused).
        grill_z_max = SPINE_RIB_ENABLE ? SPINE_RIB_LOWER_FOOT_Z - HDD_GRILL_RIB_GAP
                                       : HDD_POS[2] + HDD_SIZE[2]/2 + HDD_GRILL_MARGIN_TOP;
        grill_h = grill_z_max - grill_z_min;
        grill_z = (grill_z_min + grill_z_max) / 2;

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, z_min])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, plate_top - z_min]);

                translate(C14_POS)
                    rotate(C14_ROT)
                        c14_solid_tool();

                c14_screw_holes();
                c14_flange_pocket();
                front_panel_mount_holes(front_panel_mount_holes_lower());

                // Grill-local frame: x = X - grill_x, y = -(Z - grill_z). The protect test is centre vs apothem, but a rotated cell reaches its circumradius - hence this extra.
                grill_cell_corner_extra = (HDD_GRILL_MODE == "diamond")
                    ? sqrt(pow(HDD_GRILL_DIAMOND_SLOT_W, 2) + pow(HDD_GRILL_DIAMOND_SLOT_H, 2))/2
                        - min(HDD_GRILL_DIAMOND_SLOT_W, HDD_GRILL_DIAMOND_SLOT_H)/2
                    : HDD_GRILL_HEX_R * (1 - cos(30));
                grill_screw_protect = [for (p = concat(front_panel_mount_holes_lower(), front_panel_mount_holes_upper(), spine_panel_screw_pts()))
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
    gan_world_ys  = [for (wp = world_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2])) wp[1]];
    gan_y_min_edge = min(gan_world_ys) - GAN_STANDOFF_R;
    ny_narrow_y = plate_y_min + SPINE_PLATE_TAPER_NY_DEPTH;
    if (abs(ny_narrow_y - gan_y_min_edge) > 0.01) {
        echo(str("WARNING: SPINE_PLATE_TAPER_NY_DEPTH (", SPINE_PLATE_TAPER_NY_DEPTH,
            ") no longer matches the flush-with-GaN-standoffs depth (gan_y_min_edge = ", gan_y_min_edge,
            ", would need NY_DEPTH = ", gan_y_min_edge - plate_y_min,
            ") - the -Y taper's waist is no longer flush with the GaN PSU standoffs."));
    }
    for (set = [["MB",  MB_POS,      MB_HOLES,      MB_ROT[2],      MB_INSERT_RING_R],
                ["HDD", HDD_POS,     HDD_HOLES,     HDD_ROT[2],     HDD_STANDOFF_R],
                ["GaN", GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_R]])
        for (wp = world_holes(set[1], set[2], set[3])) {
            // Smallest distance (in Y) between the standoff circle's -Y rim and the -Y edge, sampled across the circle.
            rim_gap = min([for (i = [0 : 40]) let(dx = set[4] * (i/20 - 1))
                           (wp[1] - sqrt(max(set[4]*set[4] - dx*dx, 0))) - spine_plate_ny_edge(wp[0] + dx)]);
            if (rim_gap < -0.01)
                echo(str("WARNING: SPINE_PLATE_TAPER_NY/NY2 cuts ", -rim_gap, "mm into the ", set[0], " standoff at [",
                    wp[0], ",", wp[1], "] - this standoff may be disconnected from the plate."));
        }
    for (set = [["MB",  MB_POS,      MB_HOLES,      MB_ROT[2],      MB_INSERT_RING_R],
                ["HDD", HDD_POS,     HDD_HOLES,     HDD_ROT[2],     HDD_STANDOFF_R],
                ["GaN", GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_R]])
        for (wp = world_holes(set[1], set[2], set[3])) {
            nx_edge_here = spine_plate_nx_edge(wp[1]);
            if (wp[0] - set[4] < nx_edge_here - 0.01)
                echo(str("WARNING: SPINE_PLATE_NX_X / TAPER_NX_DEPTH (", SPINE_PLATE_TAPER_NX_DEPTH,
                    ") cuts past a ", set[0], " standoff at [", wp[0], ",", wp[1],
                    "] - standoff -X edge = ", wp[0] - set[4], ", plate -X edge there = ",
                    nx_edge_here, " - this standoff may be disconnected from the plate."));
        }
    for (set = [["MB",  MB_POS,      MB_HOLES,      MB_ROT[2],      MB_INSERT_RING_R],
                ["HDD", HDD_POS,     HDD_HOLES,     HDD_ROT[2],     HDD_STANDOFF_R],
                ["GaN", GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_R]])
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

function mb_plate_top_z() = SPINE_PLATE_POS[2] + SPINE_PLATE_SIZE[2]/2;
function mb_plate_bot_z() = SPINE_PLATE_POS[2] - SPINE_PLATE_SIZE[2]/2;
function mb_boss_bot_z()  = min(mb_plate_top_z() - MB_INSERT_LEN - MB_INSERT_EXTRA, mb_plate_bot_z());

module mb_insert_bores() {
    for (wp = world_holes(MB_POS, MB_HOLES, MB_ROT[2]))
        translate([wp[0], wp[1], mb_boss_bot_z() - 0.5])
            cylinder(h = mb_plate_top_z() - mb_boss_bot_z() + 1, r = MB_INSERT_HOLE_DIA/2, $fn = 32);
}

// Bosses under the plate so the MB insert can be longer than the plate is thick.
module mb_insert_bosses() {
    bot = mb_boss_bot_z();
    h = mb_plate_bot_z() - bot;
    c = min(MB_BOSS_CHAMFER, h);
    if (h > 0.01)
        for (wp = world_holes(MB_POS, MB_HOLES, MB_ROT[2]))
            translate([wp[0], wp[1], bot]) {
                cylinder(h = c, r1 = MB_INSERT_RING_R - c, r2 = MB_INSERT_RING_R, $fn = 48);
                translate([0, 0, c]) cylinder(h = h - c + 0.01, r = MB_INSERT_RING_R, $fn = 48);
            }
}

module mb_boss_checks() {
    bot = mb_boss_bot_z();
    r = MB_INSERT_RING_R;
    for (wp = world_holes(MB_POS, MB_HOLES, MB_ROT[2]))
        for (b = [["GaN PSU", [GAN_PSU_POS[0] - GAN_PSU_SIZE[1]/2, GAN_PSU_POS[0] + GAN_PSU_SIZE[1]/2],
                   [GAN_PSU_POS[1] - GAN_PSU_SIZE[0]/2, GAN_PSU_POS[1] + GAN_PSU_SIZE[0]/2], GAN_PSU_POS[2] + GAN_PSU_SIZE[2]/2],
                  ["HDD", [HDD_POS[0] - HDD_SIZE[0]/2, HDD_POS[0] + HDD_SIZE[0]/2],
                   [HDD_POS[1] - HDD_SIZE[1]/2, HDD_POS[1] + HDD_SIZE[1]/2], HDD_POS[2] + HDD_SIZE[2]/2],
                  ["C14 body", [C14_POS[0] - C14_BODY_HALF_W, C14_POS[0] + C14_BODY_HALF_W],
                   [C14_POS[1] - C14_BODY_DEPTH, 0], C14_POS[2] + C14_BODY_TOP_DZ]])
            if (_rect_pt_dist(b[1][0], b[1][1], b[2][0], b[2][1], wp) < r) {
                gap = bot - b[3];
                echo(str("MB boss at [", wp[0], ",", wp[1], "]: bottom Z ", bot, " is ", gap, "mm above the ", b[0], "."));
                if (gap < SPINE_PANEL_MIN_CLEARANCE)
                    echo(str("WARNING: MB insert boss at [", wp[0], ",", wp[1], "] is only ", gap, "mm above the ", b[0],
                             " (< SPINE_PANEL_MIN_CLEARANCE ", SPINE_PANEL_MIN_CLEARANCE, "). Shorten MB_INSERT_LEN / MB_INSERT_EXTRA."));
            }
}

module new_spine(show, col, alpha) {
    if (show) {
        mb_bottom = MB_POS[2] - MB_SIZE[2]/2;
        hdd_top   = HDD_POS[2] + HDD_SIZE[2]/2;
        gan_top   = GAN_PSU_POS[2] + GAN_PSU_SIZE[2]/2;
        plate_x   = SPINE_PLATE_POS[0];
        plate_y   = SPINE_PLATE_POS[1];
        plate_z   = SPINE_PLATE_POS[2];
        plate_w   = SPINE_PLATE_SIZE[0] - 2*SPINE_PLATE_MARGIN_X;
        plate_d   = SPINE_PLATE_SIZE[1];
        plate_t   = SPINE_PLATE_SIZE[2];
        plate_top = plate_z + plate_t/2;
        plate_bot = plate_z - plate_t/2;
        spine_plate_taper_warnings();
        gan_peg_h = plate_bot - (gan_top + GAN_ORING_POCKET_DEPTH);
        if (abs(gan_peg_h - GAN_STANDOFF_H) > 0.01)
            echo(str("WARNING: GaN standoff pegs are ", gan_peg_h, "mm, not GAN_STANDOFF_H = ",
                     GAN_STANDOFF_H, ". Set GAN_PSU_POS[2] to ",
                     plate_bot - GAN_STANDOFF_H - GAN_ORING_POCKET_DEPTH - GAN_PSU_SIZE[2]/2, "."));
        if (abs((mb_bottom - plate_top) - MB_STANDOFF_H) > 0.01)
            echo(str("WARNING: PCB underside is ", mb_bottom - plate_top, "mm above the plate, not MB_STANDOFF_H = ",
                     MB_STANDOFF_H, ". Set MB_POS[2] to ", plate_top + MB_STANDOFF_H + MB_SIZE[2]/2,
                     " (the I/O cut-outs follow MB_POS)."));
        plate_outline = spine_plate_outline();

        spine_panel_joint_checks();
        mb_boss_checks();

        color(col, alpha) difference() {
          union() {
            difference() {
                translate([0, 0, plate_z])
                    linear_extrude(height = plate_t, center = true)
                        polygon(plate_outline);
                for (wp = world_holes(HDD_POS, HDD_HOLES, HDD_ROT[2])) {
                    wx = wp[0];
                    wy = wp[1];
                    translate([wx, wy, plate_bot - 0.5])
                        cylinder(h = plate_t + 1, r = HDD_STANDOFF_HOLE_R, $fn = 24);
                }
                for (wp = world_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2])) {
                    wx = wp[0];
                    wy = wp[1];
                    translate([wx, wy, plate_bot - 0.5])
                        cylinder(h = plate_t + 1, r = GAN_STANDOFF_HOLE_R, $fn = 24);
                    gan_cs_depth = countersink_depth(GAN_STANDOFF_HOLE_R, GAN_SCREW_CS_DIA, GAN_SCREW_CS_ANGLE);
                    translate([wx, wy, plate_top - gan_cs_depth])
                        cylinder(h = gan_cs_depth, r1 = GAN_STANDOFF_HOLE_R, r2 = GAN_SCREW_CS_DIA/2, $fn = 48);
                    translate([wx, wy, plate_top - 0.001])
                        cylinder(h = 1, r = GAN_SCREW_CS_DIA/2, $fn = 48);
                }
                mb_insert_bores();
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
                mb_lightening_protect = standoff_lightening_protect(MB_POS, MB_HOLES, MB_ROT[2], MB_INSERT_RING_R, plate_top, plate_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                hdd_lightening_protect = standoff_lightening_protect(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                gan_lightening_protect = standoff_lightening_protect(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_R, plate_bot, gan_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                lightening_protect_pts = concat(mb_lightening_protect[0], hdd_lightening_protect[0], gan_lightening_protect[0]);
                lightening_protect_rects = concat(mb_lightening_protect[1], hdd_lightening_protect[1], gan_lightening_protect[1],
                                                  spine_panel_boss_protect_rects(SPINE_GRID_WALL));
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

            spine_panel_bosses();
            mb_insert_bosses();

            difference() {
                union() {
                    // Unioned before drilling so one part's ramps can't refill another's bores.
                    standoff_pegs(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd_top + HDD_ORING_POCKET_DEPTH);

                        standoff_pegs(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_R, plate_bot, gan_top + GAN_ORING_POCKET_DEPTH);
                }
                standoff_holes(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_HOLE_R, plate_bot, hdd_top + HDD_ORING_POCKET_DEPTH);

                    standoff_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_HOLE_R, plate_bot, gan_top + GAN_ORING_POCKET_DEPTH);
            }

          }
          spine_panel_boss_bores();
          mb_insert_bores();
        }
    }
}

module io_plate(show, col, alpha) {
    if (show) {
        plate_top = SPINE_PLATE_POS[2] + SPINE_PLATE_SIZE[2]/2;
        plate_bot = SPINE_PLATE_POS[2] - SPINE_PLATE_SIZE[2]/2;
        spine_rib_checks();
        color(col, alpha) difference() {
            union() {
                front_panel_upper(SHOW_FRONT_PANEL, plate_bot, col, alpha);
                front_panel_lower(SHOW_FRONT_PANEL_LOWER, plate_top, col, alpha);
                spine_ribs();
            }
            spine_panel_screw_holes();
        }
    }
}

// Reference bodies, component boxes and reports shared by spine.scad and io_plate.scad.
module render_references() {
    if (SHOW_C14_SOCKET)
        color("LawnGreen")
            translate(C14_POS)
                rotate(C14_ROT)
                    import(C14_STL_FILE);
    spine_ref(SHOW_SPINE, [80, 0, 0], [0, -90, 0], SPINE_ALPHA);
    enclosure_ref(ENCLOSURE_SIZE, ENCLOSURE_POS, ENCLOSURE_ROT, SHOW_ENCLOSURE, "Gray", ENCLOSURE_ALPHA, ENCLOSURE_EDGE_R);
    labeled_box(MB_SIZE,  MB_POS,  MB_ROT,  SHOW_MB,  "Blue");
    labeled_box(HDD_SIZE, HDD_POS, HDD_ROT, SHOW_HDD, "Red");
    labeled_box(ODD_SIZE, ODD_POS, ODD_ROT, SHOW_ODD, "Cyan");
    labeled_box(GAN_PSU_SIZE, GAN_PSU_POS, GAN_PSU_ROT, SHOW_GAN_PSU, "#222222");
    labeled_box(GAN_BLOCK1_SIZE, GAN_BLOCK1_POS, GAN_BLOCK_ROT, SHOW_GAN_BLOCKS, "Yellow");
    labeled_box(GAN_BLOCK2_SIZE, GAN_BLOCK2_POS, GAN_BLOCK_ROT, SHOW_GAN_BLOCKS, "Orange");
    labeled_box(GAN_PSU_500W_SIZE, GAN_PSU_POS, GAN_PSU_ROT, SHOW_GAN_PSU_500W, "Purple", 0.5);
    gan_adaptor_report();
    cooler_clearance_report();
}

// Other part's STL in grey: world coords, so it lines up. Set SHOW_OTHER_PART = false before exporting.
module other_part(file, show) {
    if (show) {
        echo(str("NOTE: showing ", file, " in grey - set SHOW_OTHER_PART = false before exporting."));
        color("Gray") import(file);
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

module gan_adaptor_report() {
    if (SHOW_GAN_BLOCKS) {
        plate_rear_y = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2;
        adaptor_rear_y = GAN_BLOCK1_POS[1] - SC_ADAPTOR_SIZE[1]/2;
        chase_depth  = plate_rear_y - adaptor_rear_y;
        mb_rear_y    = MB_POS[1] - MB_SIZE[1]/2;

        echo(str("GaN 24-pin header at [", GAN_24PIN_POS[0], ",", GAN_24PIN_POS[1],
                 ",", GAN_24PIN_POS[2], "], firing -Z into open air."));
        echo(str("Adaptor sockets meet at Y = ", SC_JUNCTION_Y,
                 "; socket-to-socket span = ", SC_CABLE_FREE_SPAN,
                 "mm - that IS the cable length to order."));
        echo(str("=> ASSUMES the MB 24-pin sits at [", MB_24PIN_IMPLIED[0], ",",
                 MB_24PIN_IMPLIED[1], ",", MB_24PIN_IMPLIED[2],
                 "] - i.e. ", mb_rear_y - MB_24PIN_IMPLIED[1] < 0
                     ? str(abs(mb_rear_y - MB_24PIN_IMPLIED[1]), "mm in from the board's rear edge")
                     : "BEYOND the board's rear edge (impossible)",
                 ". UNCONFIRMED against the real B860I - verify before cutting the chase."));
        echo(str("=> rear cable chase must reach ", chase_depth,
                 "mm past the plate's rear edge (plate rear Y = ", plate_rear_y, ")."));

        if (SC_CABLE_FREE_SPAN < SC_MIN_SPAN_FLAT) {
            echo(str("WARNING: span ", SC_CABLE_FREE_SPAN, "mm is below the ~",
                     SC_MIN_SPAN_FLAT, "mm floor even for a flat/ribbon custom cable. ",
                     "Open the PSU-to-board separation by ",
                     SC_MIN_SPAN_FLAT - SC_CABLE_FREE_SPAN,
                     "mm, or drop the MB-side adaptor and U-route instead."));
        } else if (SC_CABLE_FREE_SPAN < SC_MIN_SPAN_ROUND) {
            echo(str("NOTE: span ", SC_CABLE_FREE_SPAN,
                     "mm needs a FLAT/ribbon custom cable - too short for a round ",
                     "bundle (~", SC_MIN_SPAN_ROUND, "mm floor, incl. the HDPLEX in-box short cable). ",
                     "For a round cable, open the separation by ",
                     SC_MIN_SPAN_ROUND - SC_CABLE_FREE_SPAN, "mm."));
        }
        if (adaptor_rear_y > plate_rear_y) {
            echo(str("WARNING: the adaptor junction at Y = ", SC_JUNCTION_Y,
                     " still overlaps the spine plate (rear edge ", plate_rear_y,
                     ") - the plate needs a notch here, or the PSU must shift -Y."));
        }
    }
}

if (ASSEMBLY_PREVIEW) {
    new_spine(true, "Orange", 1);
    io_plate(true, "Orange", 1);
    render_references();
}
