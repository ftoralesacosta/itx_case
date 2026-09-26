include <c14_tool.scad>
// Game of Life ITX Case - ITX layout study. See README.md for context/conventions.

/* ---------- global toggles ---------- */
SHOW_SPINE      = false;          // original reference STL
SHOW_ENCLOSURE  = false;
SHOW_ODD        = false;


used_components = false;

SHOW_MB         = used_components;
SHOW_HDD        = used_components;
SHOW_GAN_PSU    = used_components;


SHOW_NEW_SPINE  = true;
SHOW_FRONT_PANEL = true;   // upper (MB-side) I/O panel
SHOW_FRONT_PANEL_LOWER = true; // lower (HDD/GaN) panel

SPINE_ALPHA     = 0.9;
ENCLOSURE_ALPHA = 0.55;

/* ---------- enclosure (outer volume budget) ---------- */
ENCLOSURE_SIZE = [170, 178, 85];   // [W, D, H] - W/X flush with the MB PCB (MB_SIZE[0])
ENCLOSURE_POS  = [3, -90, 18];     // X = MB_POS[0]; was [171 @ 2.5], 1mm proud of the MB on -X
ENCLOSURE_ROT  = [0, 0, 0];
ENCLOSURE_EDGE_R = 1.0;

/* ---------- motherboard ---------- */
MB_SIZE = [170, 170, 38];
MB_POS  = [3, -90, 34.6];
MB_ROT  = [0, 0, 0];

/* ---------- HDD (replaces GPU) ---------- */
HDD_SIZE = [101.6, 146.99, 26.11]; // 3.5" HDD envelope [W, D, H]
HDD_POS  = [-27.38, -92, -9.98];
HDD_ROT  = [0, 0, 0];

/* ---------- ODD (unused placeholder, see README) ---------- */
ODD_SIZE = [128, 129, 12.7];
ODD_POS  = [30, -70, -50];
ODD_ROT  = [0, 0, 0];

/* ---------- GaN PSU (HDPLEX 250W GaN AIO ATX) ---------- */

GAN_PSU_SIZE = [170, 55, 25]; // [D, W, H]
GAN_PSU_POS  = [56.5, -90, -10];
GAN_PSU_ROT  = [0, 0, 90];

/* ---------- GaN PSU DC output cluster ---------- */
// HDPLEX puts all four DC output headers - 24-pin (Molex 46207-1024), 8-pin EPS,
// 8-pin PCIe, 4-pin SATA - on ONE of the two 170x55 faces, clustered within ~30mm
// of ONE 55mm end, firing perpendicular to that face.
// In this build that face is -Z (pointing away from the plate, into open air) and
// the cluster is at the REAR (-Y) end. Consistent with the AC pigtail exiting the
// opposite (front) end toward the front-panel C14.
GAN_24PIN_LEN   = 51.0;  // Mini-Fit Jr 12x2 @ 4.2mm pitch - real
GAN_24PIN_W     = 10.0;  // real
GAN_24PIN_HDR_H = 11.0;  // header protrusion beyond the PSU face - real, approx
GAN_24PIN_INSET = 8.0;   // free - 24-pin centre, measured in from the rear end

// derived - do not hand-edit
MB_PCB_THICK   = 1.6;                                  // real
MB_PCB_TOP_Z   = MB_POS[2] - MB_SIZE[2]/2 + MB_PCB_THICK;
GAN_PSU_REAR_Y = GAN_PSU_POS[1] - GAN_PSU_SIZE[0]/2;   // local X (170) is world Y at ROT 90
GAN_PSU_BOT_Z  = GAN_PSU_POS[2] - GAN_PSU_SIZE[2]/2;
GAN_24PIN_POS  = [GAN_PSU_POS[0],
                  GAN_PSU_REAR_Y + GAN_24PIN_INSET,
                  GAN_PSU_BOT_Z - GAN_24PIN_HDR_H/2];

/* ---------- SC Shift 180 degree adaptors ---------- */
// Singularity Computers "Shift Motherboard 24pin 180 Degree Adaptor Short",
// SKU SC-A-180-24-S, USD 24.50. Rigid dual-layer PCB.
// L52 x W32 x H22 - the 32mm is the LATERAL OFFSET between the two connectors,
// NOT a length. (The non-"Short" variant is 42 x 52 x 22: same 22mm height,
// 52mm offset.) One on each header turns the two sockets to face each other.
//SHOW_GAN_BLOCKS   = SHOW_GAN_PSU;
SHOW_GAN_BLOCKS   = false;
SC_ADAPTOR_SIZE   = [52, 32, 22]; // real
SC_ADAPTOR_OFFSET = 32;           // real - runs along world -Y here
GAN_BLOCK_ROT     = [0, 0, 0];

// PSU-side: mates onto the down-facing 24-pin, turns it to face UP, offset into
// -Y so the socket clears the plate's rear edge.
GAN_BLOCK1_SIZE = SC_ADAPTOR_SIZE;
GAN_BLOCK1_POS  = [GAN_24PIN_POS[0],
                   GAN_24PIN_POS[1] - SC_ADAPTOR_SIZE[1]/2,
                   GAN_PSU_BOT_Z - SC_ADAPTOR_SIZE[2]/2];

// MB-side: mates onto the up-facing MB 24-pin, turns it to face DOWN, landing its
// socket directly above the PSU adaptor's socket.
// NOTE: this assumes the MB 24-pin is at MB_24PIN_IMPLIED (echoed below). That
// position is NOT yet confirmed against the real B860I - see the echo.
GAN_BLOCK2_SIZE = SC_ADAPTOR_SIZE;
GAN_BLOCK2_POS  = [GAN_BLOCK1_POS[0],
                   GAN_BLOCK1_POS[1],
                   MB_PCB_TOP_Z + SC_ADAPTOR_SIZE[2]/2];

// Where the two sockets meet, and what the board would have to look like for it.
SC_JUNCTION_Y      = GAN_24PIN_POS[1] - SC_ADAPTOR_OFFSET;
MB_24PIN_IMPLIED   = [GAN_BLOCK1_POS[0], SC_JUNCTION_Y + SC_ADAPTOR_OFFSET, MB_PCB_TOP_Z];
SC_CABLE_FREE_SPAN = MB_PCB_TOP_Z - GAN_PSU_BOT_Z;   // socket face to socket face

// 24-pin cables are specified connector-face to connector-face, so the span above
// IS the cable length to order. Practical floors, by construction - see README:
SC_MIN_SPAN_FLAT  = 45.0;  // flat/ribbon custom, bends in one plane
SC_MIN_SPAN_ROUND = 70.0;  // round bundle - the HDPLEX in-box short cable is ~70


// Fit-check ATX PSU.
SHOW_GAN_PSU_500W = false;
GAN_PSU_500W_SIZE = [200.2, 55, 40]; // [D, W, H]

/* ---------- new spine (see README for design background) ---------- */
// Plate footprint is separate from standoff POS - see README.
// Y: front edge at -2.0, rear at -177. The front edge must reach INTO the front
// panel (back face at -FRONT_PANEL_THICKNESS = -2.5) - it used to stop at -3.0,
// leaving a 0.5mm gap: in the print orientation (front face on the bed) the whole
// spine was a floating body starting mid-air (slicer: "empty layer" + stability).
SPINE_PLATE_POS  = [2.31, -89.5, 8.1]; // [x, y, z]  (y was -90)
SPINE_PLATE_SIZE = [170.6, 175, 3]; // [w, d, t]     (d was 174)
SPINE_PLATE_MARGIN_X = 0; // X-only inset applied on top of POS/SIZE, each side

// 3 trapezoidal edge tapers (+X, -Y, -X), copied from the reference STL. See README.
// Plate's +X edge, before any taper. Single source of truth for the outline, the
// taper-aware edge functions, and the lightening boundary - see spine_plate_outline().
SPINE_PLATE_PX_X = MB_POS[0] + MB_SIZE[0]/2 - 2.0; // derived - 2mm inside the MB edge
// Plate's -X edge, before any taper - mirror of SPINE_PLATE_PX_X, so the MB PCB
// overhangs the plate by 2mm on both sides. Supersedes SPINE_PLATE_POS[0]/SIZE[0]
// (and SPINE_PLATE_MARGIN_X) for the outline's X extent.
SPINE_PLATE_NX_X = MB_POS[0] - MB_SIZE[0]/2 + 2.0; // derived - 2mm inside the MB edge
SPINE_PLATE_TAPER_PX_BEFORE = 41; // was 40; +1 when the plate front edge moved -3 -> -2
SPINE_PLATE_TAPER_PX_RUN = 20;
SPINE_PLATE_TAPER_PX_AFTER = 20;  
SPINE_PLATE_TAPER_PX_DEPTH = 30; // flush-with-HDD-standoffs target; new_spine() warns on drift

SPINE_PLATE_TAPER_NY_BEFORE = 7;
SPINE_PLATE_TAPER_NY_RUN = 38;
SPINE_PLATE_TAPER_NY_AFTER = 44.4;  
SPINE_PLATE_TAPER_NY_DEPTH = 38.0; // 

SPINE_PLATE_TAPER_NX_BEFORE = 50;
SPINE_PLATE_TAPER_NX_RUN = 10;
SPINE_PLATE_TAPER_NX_AFTER = 60;   
SPINE_PLATE_TAPER_NX_DEPTH = 30;



STANDOFF_R      = 3.5;  // mounting standoff outer radius
STANDOFF_HOLE_R = 1.9;  // M3 clearance radius
STANDOFF_MARGIN = 8;    // fallback corner inset where no real hole spec is known
STANDOFF_RAMP_RUN_FACTOR = 1.0; // ramp horizontal run = peg height x this (1.0 = 45 degree self-supporting slope)

// Real screw-hole patterns, local [x,y] offsets. See README for sourcing.
// MB_HOLES_RAW's edge insets are 5.84mm (-X) / 6.86mm (+X). Test fit showed the
// real board sitting ~1mm proud of the -X front-panel face - consistent with
// those two insets being mirrored (6.86 - 5.84 = 1.02). MB_HOLES_X_SHIFT moves
// the standoff pattern (NOT the board/panel) so the PCB lands flush with the face.
// +shift moves standoffs -> +X, which carries the board +X. Set 0 to revert.
MB_HOLES_X_SHIFT = 1.02;
MB_HOLES_RAW = [
    [-79.16,  75.47],
    [ 78.14,  52.57],
    [-79.13, -79.13],
    [ 78.14, -79.13],
];
MB_HOLES = [for (p = MB_HOLES_RAW) [p[0] + MB_HOLES_X_SHIFT, p[1]]];

// SFF-8301 Rev 1.9, Fig 3-1 / Table 3-1 (bottom holes, 6-32 UNC):
//   A5 = 3.18   hole centre in from each long side  (so A4 = 95.25 across)
//   A7 = 41.28  connector end -> first (required) pair
//   A6 = 44.45  first pair -> optional middle pair   } both measured FROM the
//   A13 = 76.20 first pair -> optional far pair      } A7 pair, NOT the drive end
// (Previously A13 was applied from the drive end, putting the 2nd pair only
// 34.92mm behind the 1st instead of 76.20.) Connector end is the -Y end here.
// Seagate Exos (SATA) uses the A7 + A13 pairs -> 95.25 x 76.20 rectangle.
HDD_HOLE_X_INSET  = 3.18;   // SFF-8301 A5
HDD_HOLE_Y_FRONT  = 41.28;  // SFF-8301 A7 - from the connector end
HDD_HOLE_Y_PITCH  = 76.20;  // SFF-8301 A13 (use 44.45 = A6 for drives with only the middle pair)
HDD_HOLES = let(
        hx = HDD_SIZE[0]/2 - HDD_HOLE_X_INSET,
        y1 = -HDD_SIZE[1]/2 + HDD_HOLE_Y_FRONT,
        y2 = y1 + HDD_HOLE_Y_PITCH
    ) [[hx,y1], [hx,y2], [-hx,y1], [-hx,y2]];
// 6-32 UNC, not M3 - see README hardware table + vibration-isolation notes.
HDD_STANDOFF_HOLE_R = 2.3;
HDD_STANDOFF_R = 5;
HDD_ORING_OD = 7.24; // AS568-007
HDD_ORING_CS = 1.78;
HDD_ORING_POCKET_CLEARANCE = 0.4;
HDD_ORING_POCKET_DIA   = HDD_ORING_OD + HDD_ORING_POCKET_CLEARANCE;
HDD_ORING_POCKET_DEPTH = 1.56; // ~12.5% O-ring compression - see README

GAN_PSU_HOLES = [
    [ 71,  16.65],
    [-73,  16.65],
    [ 71, -16.65],
    [-73, -16.65],
];
GAN_STANDOFF_HOLE_R = 1.9; // M3 clearance with O-ring margin.
GAN_STANDOFF_R = 5;
// PSU thermal break O-rings.
GAN_ORING_OD = 7.14; // 9/32"
GAN_ORING_CS = 1.59; // 1/16"
GAN_ORING_POCKET_CLEARANCE = 0.4;
GAN_ORING_POCKET_DIA   = GAN_ORING_OD + GAN_ORING_POCKET_CLEARANCE;
GAN_ORING_POCKET_DEPTH = 1.43;

/* ---------- CPU cooler + fan intake clearance ---------- */
// Downdraft cooler sitting on the board, fan on top firing -Z into the CPU.
// Depends on MB_PCB_TOP_Z, so this block has to come after the MB derived block.
CPU_COOLER_HEIGHT = 37.0; // real - Thermalright low-profile, PCB top to fan top
CPU_COOLER_FAN_D  = 92.0; // real, assumed - AXP90 class. Verify; FAN_PANEL_GAP scales with it.

// Clearance from the fan's intake face to the inner face of the panel above it.
// 5mm is the knee of the gap-vs-open-area curve for a chamfered honeycomb vent:
// below it the vent cell size (which must be <= the gap, or the blades see jets)
// gets small enough that the webs eat the open area and the vent starts consuming
// a serious fraction of the fan's static pressure. See README "Fan intake clearance".
FAN_PANEL_GAP = 5.0; // free, but do not go below ~4 without re-running the numbers

// derived - do not hand-edit
CPU_COOLER_TOP_Z  = MB_PCB_TOP_Z + CPU_COOLER_HEIGHT;
FAN_PANEL_INNER_Z = CPU_COOLER_TOP_Z + FAN_PANEL_GAP;

/* ---------- front panel ---------- */
// Top edge used to be hard-coded to 55, measured off the reference STL. It is now
// driven by the fan intake clearance: the top edge IS the plane the side/top panel
// lands on, so it has to sit FAN_PANEL_GAP above the cooler.
FRONT_PANEL_TOP_Z_STL = 55;  // measured off the reference STL - kept for reference only
FRONT_PANEL_TOP_Z     = FAN_PANEL_INNER_Z;
FRONT_PANEL_THICKNESS = 2.5; // Y depth, front face at Y=0

// MB rear-IO rectangle, offset from MB_POS/mb_bottom so it moves with the board.
FRONT_PANEL_IO_OFFSET = [-72.01, 86.99, -2.83, 41.67]; // [x_min, x_max, z_min, z_max]

// Direct Motherboard IO port cutout.
IO_SHIELD_STL_FILE = "asrock_b860i_io_shield.stl";
IO_SHIELD_STL_SIZE = [155.0, 40.5]; // [w, h] - real, measured off the STL's bounding box.
// (Was [154.75, 40.75]. The extra 0.25mm of height cut a hairline slot straight
// across the panel at z~55.3 - invisible while the panel topped out at 55, exposed
// once FRONT_PANEL_TOP_Z became cooler-driven. See front_panel_upper().)
// Inset of the complement square used to extract port holes from the shield. Keeps
// any residual size/tessellation mismatch at the shield's outline from cutting an
// edge slot. Must stay smaller than the nearest port's distance to the shield edge.
IO_SHIELD_EDGE_INSET = 1.0; // free
// Test-fit correction for the IO port cutouts, world Z (+ = up). First print had the
// ports sitting ~2.0mm (-X end) / ~1.5mm (+X end) ABOVE their cutouts. 2.0 taken from
// the -X end: it has an MB standoff 9.5mm from the IO edge so the board can't flex
// there, while the +X end's nearest standoff is ~32mm back (free to deflect toward
// the cutout, reading low). Moves only the cutouts - not the board or the panel.
IO_SHIELD_Z_SHIFT = 2.0;

// --- C14 Power Socket ---
USE_SNAP_IN_C14 = false;
SHOW_C14_SOCKET = used_components;
C14_STL_FILE = USE_SNAP_IN_C14 ? "c14_snap-fit_socket.stl" : "c14_socket.stl";
C14_POS = [-52.5, -2, -8.0]; 
C14_ROT = [270, 180, 0]; 
C14_SNAP_CUTOUT_W = 28.0;
C14_SNAP_CUTOUT_H = 20.5;
C14_SCREW_PITCH = 42.0; 
C14_SCREW_R = 1.75;

// The pitch runs along world X, NOT Z: with C14_ROT = [270,180,0] the STL's flange
// holes land at [C14_POS[0] +/- 21, *, C14_POS[2]] (verified by locating the hole
// rings in the transformed STL). If C14_ROT changes, re-check this axis.
//
// Mounting: socket goes in from INSIDE, eared flange against the panel's back face.
// M3 x 10 90deg countersunk screw from outside -> panel -> flange -> M3 nyloc nut.
// The flange holes are plain 3.2mm clearance, not tapped, so the nut is required.
C14_SCREW_CS_DIA   = 6.4; // matches FRONT_PANEL_SCREW_CS_DIA - M3 flat head is ~6.0 nominal
C14_SCREW_CS_ANGLE = 90;
module c14_screw_holes() {
    cs_r     = C14_SCREW_CS_DIA / 2;
    cs_depth = countersink_depth(C14_SCREW_R, C14_SCREW_CS_DIA, C14_SCREW_CS_ANGLE);
    for (s = [-1, 1])
        translate([C14_POS[0] + s*C14_SCREW_PITCH/2, 0, C14_POS[2]]) {
            rotate([90, 0, 0])
                cylinder(r = C14_SCREW_R, h = 50, center = true, $fn = 32);
            // Cone reaches full cs_r exactly AT the outer face (Y=0), so the head
            // sits flush - not proud. Short cylinder above just cleans the face.
            translate([0, -cs_depth, 0])
                rotate([-90, 0, 0])
                    cylinder(h = cs_depth, r1 = C14_SCREW_R, r2 = cs_r, $fn = 48);
            rotate([-90, 0, 0])
                cylinder(h = 1, r = cs_r, $fn = 48);
        }
}

// Pocket for the socket's eared mounting flange in the panel's BACK face.
// The socket's front face is flush with the outside of the case (Y=0) - that is the
// datum and must not move. c14_solid_tool() already pockets the 2mm front lip, but
// the eared flange behind it spans Y -5..-2 while the panel's back face is at
// -FRONT_PANEL_THICKNESS (-2.5): 0.5mm of interference. Rather than shifting the
// socket, cut the flange's own outline into the back face, floor exactly at the
// flange's front face, so the socket seats with its front still at Y=0.
// Outline is sliced from the STL mid-flange (local z = -1.5; flange is local
// z -3..0), holes closed, then grown by the same 0.3mm fit clearance as the tool.
// Screw-mount STL only - the snap-in variant has no eared flange.
C14_FLANGE_LOCAL_Z   = [-3.0, 0.0]; // real - measured off c14_socket.stl
C14_FLANGE_CLEARANCE = 0.3;         // matches c14_solid_tool()
module c14_flange_pocket() {
    if (!USE_SNAP_IN_C14)
        translate(C14_POS)
            rotate(C14_ROT)
                translate([0, 0, C14_FLANGE_LOCAL_Z[0]])
                    linear_extrude(height = C14_FLANGE_LOCAL_Z[1] - C14_FLANGE_LOCAL_Z[0])
                        offset(r = C14_FLANGE_CLEARANCE)
                            offset(delta = -2) offset(r = 2)   // close the screw holes
                                projection(cut = true)
                                    translate([0, 0, -(C14_FLANGE_LOCAL_Z[0] + C14_FLANGE_LOCAL_Z[1])/2])
                                        import(C14_STL_FILE);
}


// Front-panel mounting screws: M3 x 90deg countersunk, head flush at Y=0.
// 5 holes: every outer corner EXCEPT the GaN PSU corner (+X, -Z), plus one at
// mid-X on the top (+Z) and bottom (-Z) edges. See front_panel_mount_holes_*().
// Insets are to the hole CENTRE; the countersink edge lands at inset - CS_DIA/2
// (5 - 3.2 = 1.8mm) from the panel edge. (Was 3.5/4.0 -> 0.3/0.8mm of wall.)
FRONT_PANEL_SCREW_X_INSET = 5.0;
FRONT_PANEL_SCREW_Z_INSET = 5.0;
FRONT_PANEL_SCREW_R       = 1.7;  // M3 clearance (3.4mm) - was 1.5, a thread-forming fit
FRONT_PANEL_SCREW_CS_DIA   = 6.4;
FRONT_PANEL_SCREW_CS_ANGLE = 90;
// Minimum solid wall kept between the countersink and any HDD grill diamond cell.
FRONT_PANEL_SCREW_GRILL_WALL = 1.2;

// Screw clearance hole. Cone reaches full cs_r exactly AT the outer face (Y=0),
// so the head sits flush - same geometry as c14_screw_holes(). (Previously the
// cone hit cs_r at Y=+0.5, leaving the head 0.5mm proud.)
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

// Per-hole [dx, dz] nudge (mm), applied on top of the inset-derived position.
// World axes: +dx = +X, +dz = up. The HDD grill keep-out follows automatically.
FRONT_PANEL_MOUNT_OFFSET_UPPER = [[0, 0], [0, 0], [0, 0]]; // top edge:    -X corner, mid-X, +X corner
FRONT_PANEL_MOUNT_OFFSET_LOWER = [[-1.5, -1.5], [23., 0]];         // bottom edge: -X corner, mid-X

// Mounting hole [x, z] positions, split per panel. Derived from the enclosure
// X extent (flush with the MB PCB) and each panel's outer Z edge, plus the
// FRONT_PANEL_MOUNT_OFFSET_* nudges above.
function front_panel_mount_x() = [
    ENCLOSURE_POS[0] - ENCLOSURE_SIZE[0]/2 + FRONT_PANEL_SCREW_X_INSET,  // -X
    ENCLOSURE_POS[0],                                                    // mid-X (IO face centre)
    ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2 - FRONT_PANEL_SCREW_X_INSET,  // +X
];
// Upper panel, +Z edge: -X corner, mid, +X corner.
function front_panel_mount_holes_upper() =
    let(xs = front_panel_mount_x(), z = FRONT_PANEL_TOP_Z - FRONT_PANEL_SCREW_Z_INSET,
        o = FRONT_PANEL_MOUNT_OFFSET_UPPER)
    [for (i = [0 : 2]) [xs[i] + o[i][0], z + o[i][1]]];
// Lower panel, -Z edge: -X corner, mid. The +X corner is the GaN PSU - skipped.
function front_panel_mount_holes_lower() =
    let(xs = front_panel_mount_x(),
        z = ENCLOSURE_POS[2] - ENCLOSURE_SIZE[2]/2 + FRONT_PANEL_SCREW_Z_INSET,
        o = FRONT_PANEL_MOUNT_OFFSET_LOWER)
    [for (i = [0 : 1]) [xs[i] + o[i][0], z + o[i][1]]];

module front_panel_mount_holes(pts) {
    for (p = pts)
        panel_screw_hole(p[0], p[1], FRONT_PANEL_SCREW_R,
            FRONT_PANEL_SCREW_CS_DIA, FRONT_PANEL_SCREW_CS_ANGLE);
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


        // Shield STL centered within the real IO rectangle (io[]). The shield's own local
        // [x,y] = [width, height]; local y=0 is its HDMI/DP (low) end, matching this file's
        // world Z convention directly under rotate([90,0,0]) below - verified by render
        // (DP ends up above HDMI, matching the ASRock manual/board).
        shield_x = (io[0] + io[1])/2 - IO_SHIELD_STL_SIZE[0]/2;
        shield_z = (io[2] + io[3])/2 - IO_SHIELD_STL_SIZE[1]/2 + IO_SHIELD_Z_SHIFT;

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, plate_bot])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, FRONT_PANEL_TOP_Z - plate_bot]);
                // Precise per-port IO shield cutout - see IO_SHIELD_STL_* above. Flattened
                // to 2D (projection) and re-extruded through the panel's own real thickness,
                // rather than relying on the STL's own 0.25mm export thickness. The shield's
                // own projection is solid plate WITH holes - subtracting that directly would
                // cut away everything BUT the ports; take the complement (holes only) first.
                translate([shield_x, 0.5, shield_z])
                    rotate([90, 0, 0])
                        linear_extrude(height = FRONT_PANEL_THICKNESS + 2.5)
                            difference() {
                                // inset so the shield's own outline never becomes a cut
                                translate([IO_SHIELD_EDGE_INSET, IO_SHIELD_EDGE_INSET])
                                    square(IO_SHIELD_STL_SIZE - 2*[IO_SHIELD_EDGE_INSET, IO_SHIELD_EDGE_INSET]);
                                projection(cut = false)
                                    import(IO_SHIELD_STL_FILE);
                            }

                // C14 Socket Cutout (Uses the exact solid bounding tool mathematically extracted from the STL)
                translate(C14_POS)
                    rotate(C14_ROT)
                        c14_solid_tool();

                // C14 Mounting Screw Holes (Pitch = 42.0mm)
                // Punched manually just in case the STL's screw holes don't pierce completely through the panel thickness.
                c14_screw_holes();
                c14_flange_pocket();

                // Mounting screws - top edge (-X corner, mid-X, +X corner).
                front_panel_mount_holes(front_panel_mount_holes_upper());
            }
    }
}

/* ---------- front panel, lower portion (HDD/GaN PSU side) ---------- */
// GaN cable cutout + front-mount screws are unverified placeholders - see README.
GAN_CABLE_CUTOUT_W = 20;
GAN_CABLE_CUTOUT_H = 15;
GAN_FRONT_MOUNT_MARGIN = 6;
GAN_FRONT_MOUNT_R = 1.5;
GAN_FRONT_MOUNT_CS_DIA   = 6.4;
GAN_FRONT_MOUNT_CS_ANGLE = 90;

// Front panel MB<->GaN airflow grill, cut through the panel's Y thickness. See README.
FRONT_VENT_POS   = [-48, 2];
FRONT_VENT_SIZE  = [16, 5];
FRONT_VENT_SLOT_W = 1.6;
FRONT_VENT_WALL   = 1.6;

// Divider plate lightening/vent pattern. See README ("Divider plate lightening pattern").
SPINE_LIGHTENING_MODE = "diamond";
// Per-side stop limit (PX/NX/NY = taper edges, PY = flat). Real limits, can go to 0/negative.
SPINE_LIGHTENING_MARGIN_PX = 3;
SPINE_LIGHTENING_MARGIN_NX = 3;
SPINE_LIGHTENING_MARGIN_PY = 0;
SPINE_LIGHTENING_MARGIN_NY = 3;

// Per-cell standoff+ramp protection threshold (0 = protect on any touch). See README.
SPINE_LIGHTENING_STANDOFF_PROTECT_FUDGE = 0.3;
SPINE_HONEYCOMB_HEX_R  = 4;
SPINE_HONEYCOMB_WALL   = 1.4;
// "diamond" mode's own cell size - a square grid (grid_2d()) rotated 45deg
SPINE_GRID_SLOT_W = 8;
SPINE_GRID_SLOT_H = 8;
SPINE_GRID_WALL   = 1.5;
// Diamonds along the -Y margin get subdivided to this scale (0 disables). See README.
SPINE_LIGHTENING_NY_INLAY_SCALE = 0.3;

// Game of Life grill shapes.
LIFE_BLOCK   = [[0,0],[1,0], [0,1],[1,1]]; // solid 2x2 - already fully edge-connected
LIFE_BEEHIVE = [[1,0],[2,0], [0,1],[3,1], [1,2],[2,2], [0,0],[3,0],[0,2],[3,2]];
LIFE_POND    = [[1,0],[2,0], [0,1],[3,1], [0,2],[3,2], [1,3],[2,3]]; // ring / "0"
LIFE_HEX_RING = [[1,0],[2,0], [0,1],[3,1], [1,2],[2,2]]; // hex "0", unbridged

// Chevron grill shapes.
ARROW_GT_2 = [[0,0], [0,1], [-1,0]];
ARROW_GT_3 = [[0,0], [0,1],[0,2], [-1,0],[-2,0]];
ARROW_LT_2 = [[0,0], [1,0], [0,-1]];
ARROW_LT_3 = [[0,0], [1,0],[2,0], [0,-1],[0,-2]];

GOL_OFF = []; // set a GOL_Grill_*_SHAPE to this to turn that slot off

// HDD ventilation grill (front panel). See README.
HDD_GRILL_MODE = "diamond"; // "honeycomb" or "diamond"
HDD_GRILL_W = 108; // Width of the HDD grill
HDD_GRILL_POS_X = 32; // Center X position of the HDD grill
HDD_GRILL_MARGIN_TOP    = 9;
HDD_GRILL_MARGIN_BOTTOM = 0;

HDD_GRILL_HEX_R  = 4;
HDD_GRILL_WALL   = 1.25; // shared by both modes
HDD_GRILL_DIAMOND_SLOT_W = 4;
HDD_GRILL_DIAMOND_SLOT_H = 4;


// Helper to map intuitive [X, Y] grid steps (horizontal/vertical) into the rotated diamond grid's coordinates.
function diamond_anchor(x, y) = [x + y, y - x];

// Grill solid anchors.
GOL_Grill_1_SHAPE  = LIFE_HEX_RING; // "0" ring, +X side
GOL_Grill_1_ANCHOR = diamond_anchor(5, -1); // changed from (5, -1) to (-5, -1) to mirror to -X side
GOL_Grill_2_SHAPE  = GOL_OFF;
GOL_Grill_2_ANCHOR = diamond_anchor(0, -1);
GOL_Grill_3_SHAPE  = LIFE_HEX_RING;
GOL_Grill_3_ANCHOR = diamond_anchor(-5, -1);
GOL_Grill_4_SHAPE  = GOL_OFF;
GOL_Grill_4_ANCHOR = diamond_anchor(-3, 0);

// Corner screw guard.
FRONT_PANEL_CORNER_INFILL_X = 13;
FRONT_PANEL_CORNER_INFILL_Z = 13;

// Bounds check.
function lightening_protect_dist(wp, protect_pts, protect_rects) =
    min(concat(
        [for (c = protect_pts) max(norm([wp[0] - c[0], wp[1] - c[1]]) - c[2], 0)],
        [for (r = protect_rects)
            norm([max(r[0] - wp[0], wp[0] - r[2], 0), max(r[1] - wp[1], wp[1] - r[3], 0)])],
        [1e9]
    ));

// Distance from p to the nearest segment of a polyline. See README ("Hex/grid tiling helpers").
function point_seg_dist(p, a, b) =
    let(ab = b - a, t = (ab*ab > 0) ? max(0, min(1, ((p - a)*ab) / (ab*ab))) : 0)
    norm(p - (a + t*ab));

function point_polyline_dist(p, pts) =
    min([for (i = [0 : len(pts) - 2]) point_seg_dist(p, pts[i], pts[i + 1])]);

// Grid cell projection.
function life_pattern_protect_pts(cells, anchor, pitch_x, pitch_y, world_rot) =
    [for (c = cells)
        let(x = (anchor[0] + c[0]) * pitch_x, y = (anchor[1] + c[1]) * pitch_y)
        [cos(world_rot)*x - sin(world_rot)*y, sin(world_rot)*x + cos(world_rot)*y, 0]];

// PCB clearance bounding box.
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

// Hexagon grill generator.
module honeycomb_2d(w, h, hex_r, wall, protect_pts=[], protect_rects=[], protect_fudge=0, world_rot=0, world_translate=[0,0]) {
    r_tile = hex_r + wall / sqrt(3);
    pitch_x = 1.5 * r_tile;      // column spacing
    pitch_y = sqrt(3) * r_tile;  // row spacing
    n_cols = ceil(w / pitch_x) + 2;
    n_rows = ceil(h / pitch_y) + 2;
    apothem = hex_r * cos(30);
    intersection() {
        union() {
            // flat-top hex ($fn=6, angle 0) -> alternating columns offset by half a row.
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

// Square grill generator.
module grid_2d(w, h, slot_w, slot_h, wall, protect_pts=[], protect_rects=[], protect_fudge=0, world_rot=0, world_translate=[0,0],
                inlay_edge_pts=[], inlay_scale=1) {
    pitch_x = slot_w + wall;
    pitch_y = slot_h + wall;
    n_cols = ceil(w / pitch_x) + 1;
    n_rows = ceil(h / pitch_y) + 1;
    apothem = min(slot_w, slot_h) / 2;
    inlay_reach = sqrt(pow(slot_w, 2) + pow(slot_h, 2)) / 2; // cell's own circumradius
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
        grill_z_max = HDD_POS[2] + HDD_SIZE[2]/2 + HDD_GRILL_MARGIN_TOP;
        grill_h = grill_z_max - grill_z_min;
        grill_z = (grill_z_min + grill_z_max) / 2;

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, z_min])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, plate_top - z_min]);

                // C14 Socket Cutout (Uses the exact solid bounding tool mathematically extracted from the STL)
                translate(C14_POS)
                    rotate(C14_ROT)
                        c14_solid_tool();

                // C14 Mounting Screw Holes (Pitch = 42.0mm)
                // Punched manually just in case the STL's screw holes don't pierce completely through the panel thickness.
                c14_screw_holes();
                c14_flange_pocket();
                /* 
                // GaN PSU power cable opening
                translate([cable_x - cable_w/2, -FRONT_PANEL_THICKNESS - 1, cable_z - cable_h/2])
                    cube([cable_w, FRONT_PANEL_THICKNESS + 2, cable_h]); */
                /* 
                // GaN PSU front-mounting screws
                for (p = mount_pts) {
                    panel_screw_hole(p[0], p[1], GAN_FRONT_MOUNT_R,
                        GAN_FRONT_MOUNT_CS_DIA, GAN_FRONT_MOUNT_CS_ANGLE);
                } */
                /* 
                // front ventilation grill - see FRONT_VENT_* above
                fvent_cols = floor(FRONT_VENT_SIZE[0] / (FRONT_VENT_SLOT_W + FRONT_VENT_WALL));
                fvent_grid_w = fvent_cols * FRONT_VENT_SLOT_W + (fvent_cols - 1) * FRONT_VENT_WALL;
                fvent_x0 = FRONT_VENT_POS[0] - fvent_grid_w/2;
                fvent_z0 = FRONT_VENT_POS[1] - FRONT_VENT_SIZE[1]/2;
                for (c = [0 : fvent_cols - 1]) {
                    translate([
                        fvent_x0 + c * (FRONT_VENT_SLOT_W + FRONT_VENT_WALL),
                        -FRONT_PANEL_THICKNESS - 1,
                        fvent_z0
                    ])
                        cube([FRONT_VENT_SLOT_W, FRONT_PANEL_THICKNESS + 2, FRONT_VENT_SIZE[1]]);
                } */
                // Mounting screws - bottom edge (-X corner, mid-X). No +X: GaN PSU corner.
                front_panel_mount_holes(front_panel_mount_holes_lower());

                // HDD grill
                // Keep-out around the mounting screws: any grill cell that would come
                // within FRONT_PANEL_SCREW_GRILL_WALL of a countersink is left solid.
                // Grill-local 2D frame: x = world X - grill_x, y = -(world Z - grill_z)
                // (rotate([-90,0,0]) maps local +Y to world -Z). The (circumradius -
                // apothem) term is because the protect test is against the cell centre
                // vs. apothem, but a rotated cell's corner reaches out to its circumradius.
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

/* ================= modules ================= */

module labeled_box(size, pos, rot, show, col, alpha=1) {
    if (show) {
        translate(pos)
            rotate(rot)
                color(col, alpha)
                    cube(size, center=true);
    }
}

// Enclosure debug frame.
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

// Local [x,y] hole points rotated by rot_z and offset by pos.
function world_holes(pos, local_pts, rot_z) =
    [for (p = local_pts) let(wc = rot2d(p, rot_z)) [pos[0] + wc[0], pos[1] + wc[1]]];

function countersink_depth(r, cs_dia, cs_angle) = (cs_dia/2 - r) / tan(cs_angle/2);

// Real (taper-aware) plate edge X at world Y - keep in sync with spine_plate_outline().
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

function spine_plate_ny_edge(x) =
    let(
        full  = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
        narrow = full + SPINE_PLATE_TAPER_NY_DEPTH,
        x_min = SPINE_PLATE_NX_X,
        x_max = SPINE_PLATE_PX_X,
        lbe = x_min + SPINE_PLATE_TAPER_NY_BEFORE,
        lte = lbe + SPINE_PLATE_TAPER_NY_RUN,
        rbe = x_max - SPINE_PLATE_TAPER_NY_AFTER,
        rte = rbe - SPINE_PLATE_TAPER_NY_RUN
    )
    (x < lbe) ? full :
    (x < lte) ? full + (narrow - full) * (x - lbe) / SPINE_PLATE_TAPER_NY_RUN :
    (x < rte) ? narrow :
    (x < rbe) ? full + (narrow - full) * (rbe - x) / SPINE_PLATE_TAPER_NY_RUN :
    full;

// Spine edge polygon.
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
        x_max = SPINE_PLATE_PX_X,
        lbe = x_min + SPINE_PLATE_TAPER_NY_BEFORE,
        lte = lbe + SPINE_PLATE_TAPER_NY_RUN,
        rbe = x_max - SPINE_PLATE_TAPER_NY_AFTER,
        rte = rbe - SPINE_PLATE_TAPER_NY_RUN
    )
    [
        [x_min - x_pad, spine_plate_ny_edge(x_min) + margin],
        [x_min, spine_plate_ny_edge(x_min) + margin],
        [lbe, spine_plate_ny_edge(lbe) + margin],
        [lte, spine_plate_ny_edge(lte) + margin],
        [rte, spine_plate_ny_edge(rte) + margin],
        [rbe, spine_plate_ny_edge(rbe) + margin],
        [x_max, spine_plate_ny_edge(x_max) + margin],
        [x_max + x_pad, spine_plate_ny_edge(x_max) + margin],
    ];

// Taper-aware spine outline.
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
        
        ny_narrow_y = plate_y_min + SPINE_PLATE_TAPER_NY_DEPTH,
        ny_taper_left_start_x  = plate_x_min + SPINE_PLATE_TAPER_NY_BEFORE,
        ny_taper_left_end_x    = ny_taper_left_start_x + SPINE_PLATE_TAPER_NY_RUN,
        ny_taper_right_start_x = px_edge - SPINE_PLATE_TAPER_NY_AFTER,
        ny_taper_right_end_x   = ny_taper_right_start_x - SPINE_PLATE_TAPER_NY_RUN,
        
        nx_inset_x = plate_x_min + SPINE_PLATE_TAPER_NX_DEPTH,
        nx_taper_front_start_y = plate_y_max - SPINE_PLATE_TAPER_NX_BEFORE,
        nx_taper_front_end_y   = nx_taper_front_start_y - SPINE_PLATE_TAPER_NX_RUN,
        nx_taper_back_start_y  = plate_y_min + SPINE_PLATE_TAPER_NX_AFTER,
        nx_taper_back_end_y    = nx_taper_back_start_y + SPINE_PLATE_TAPER_NX_RUN
    )
    [
        [plate_x_min, plate_y_min],
        [ny_taper_left_start_x, plate_y_min],
        [ny_taper_left_end_x, ny_narrow_y],
        [ny_taper_right_end_x, ny_narrow_y],
        [ny_taper_right_start_x, plate_y_min],
        // +X taper (restored - dropped when px_edge moved off the enclosure wall).
        // Same breakpoints as spine_plate_px_edge(), so outline and lightening agree.
        [px_edge, plate_y_min],
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
    ];

// Drift/connectivity self-checks for the taper DEPTHs above. See README.
module spine_plate_taper_warnings() {
    // BEFORE + 2*RUN + AFTER must fit along the edge, or the two tapers cross and
    // the outline polygon self-intersects.
    y_len = SPINE_PLATE_SIZE[1];
    ny_len = SPINE_PLATE_PX_X - SPINE_PLATE_NX_X;
    for (t = [["PX", SPINE_PLATE_TAPER_PX_BEFORE, SPINE_PLATE_TAPER_PX_RUN, SPINE_PLATE_TAPER_PX_AFTER, y_len],
              ["NX", SPINE_PLATE_TAPER_NX_BEFORE, SPINE_PLATE_TAPER_NX_RUN, SPINE_PLATE_TAPER_NX_AFTER, y_len],
              ["NY", SPINE_PLATE_TAPER_NY_BEFORE, SPINE_PLATE_TAPER_NY_RUN, SPINE_PLATE_TAPER_NY_AFTER, ny_len]]) {
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
    // warn if the -X edge/taper cuts any standoff loose (mirror of the +X check below)
    for (set = [["MB",  MB_POS,      MB_HOLES,      MB_ROT[2],      STANDOFF_R],
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
    // warn if the +X taper cuts any standoff loose (it really cuts the plate now)
    for (set = [["MB",  MB_POS,      MB_HOLES,      MB_ROT[2],      STANDOFF_R],
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





// 45deg print-support ramp fused to a standoff's +Y side. See README ("Print orientation").
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

// Just the solid pegs+ramps, no holes cut yet - see standoffs()/standoff_holes() below.
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

// Just the through-holes, sized to pair with standoff_pegs() above.
module standoff_holes(pos, local_pts, rot_z, hole_r, z_from, z_to) {
    h = abs(z_to - z_from);
    zmin = min(z_from, z_to);
    for (wp = world_holes(pos, local_pts, rot_z)) {
        translate([wp[0], wp[1], zmin - 0.5])
            cylinder(h = h + 1, r = hole_r, $fn = 24);
    }
}

// Angled PCB standoffs.
module standoffs(pos, local_pts, rot_z, r, hole_r, z_from, z_to) {
    difference() {
        standoff_pegs(pos, local_pts, rot_z, r, z_from, z_to);
        standoff_holes(pos, local_pts, rot_z, hole_r, z_from, z_to);
    }
}

module new_spine(show, col, alpha) {
    if (show) {
        mb_bottom = MB_POS[2] - MB_SIZE[2]/2;
        hdd_top   = HDD_POS[2] + HDD_SIZE[2]/2;
        gan_top   = GAN_PSU_POS[2] + GAN_PSU_SIZE[2]/2;
        // SPINE_PLATE_MARGIN_X insets plate_w symmetrically - plate_x doesn't move.
        plate_x   = SPINE_PLATE_POS[0];
        plate_y   = SPINE_PLATE_POS[1];
        plate_z   = SPINE_PLATE_POS[2];
        plate_w   = SPINE_PLATE_SIZE[0] - 2*SPINE_PLATE_MARGIN_X;
        plate_d   = SPINE_PLATE_SIZE[1];
        plate_t   = SPINE_PLATE_SIZE[2];
        plate_top = plate_z + plate_t/2;
        plate_bot = plate_z - plate_t/2;
        spine_plate_taper_warnings();
        plate_outline = spine_plate_outline();

        color(col, alpha) {
            // divider plate, with HDD/GaN screw access holes drilled through. See README.
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
                }
                // Lightening/vent pattern - see SPINE_LIGHTENING_* above, README.
                lightening_px_limit = (ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2) - SPINE_LIGHTENING_MARGIN_PX;
                lightening_nx_limit = SPINE_PLATE_NX_X + SPINE_LIGHTENING_MARGIN_NX;
                lightening_py_limit = (plate_y + plate_d/2) - SPINE_LIGHTENING_MARGIN_PY;
                lightening_ny_limit = (plate_y - plate_d/2) + SPINE_LIGHTENING_MARGIN_NY;
                // sized to the box, not plate_w/plate_d - margins can go negative
                lightening_box_w = lightening_px_limit - lightening_nx_limit;
                lightening_box_d = lightening_py_limit - lightening_ny_limit;
                // PX/NX/NY clip follow their real taper edges - each closed into
                // a big region on the "allowed" side. See README.
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
                // see standoff_lightening_protect() above
                mb_lightening_protect = standoff_lightening_protect(MB_POS, MB_HOLES, MB_ROT[2], STANDOFF_R, plate_top, mb_bottom,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                hdd_lightening_protect = standoff_lightening_protect(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                gan_lightening_protect = standoff_lightening_protect(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_R, plate_bot, gan_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                lightening_protect_pts = concat(mb_lightening_protect[0], hdd_lightening_protect[0], gan_lightening_protect[0]);
                lightening_protect_rects = concat(mb_lightening_protect[1], hdd_lightening_protect[1], gan_lightening_protect[1]);
                translate([0, 0, plate_bot - 0.5])
                    linear_extrude(height = plate_t + 1)
                        intersection() {
                            translate(lightening_box_center)
                                square([lightening_box_w, lightening_box_d], center = true);
                            polygon(lightening_px_region);
                            polygon(lightening_nx_region);
                            polygon(lightening_ny_region);
                            // centered on the box, not plate_x/plate_y - asymmetric
                            // margins can shift the box's own center off-plate
                            if (SPINE_LIGHTENING_MODE == "diamond") {
                                // oversized (diagonal), rotated 45deg, clipped by the box intersection above
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

            // MB standoffs
            standoffs(MB_POS, MB_HOLES, MB_ROT[2], STANDOFF_R, STANDOFF_HOLE_R, plate_top, mb_bottom);

            // HDD + GaN standoffs, all flat-face (no O-ring pocket).
            // Heights adjusted for O-ring standard compression.
            // Built as one combined union-then-difference to avoid ramp crossover clipping.
            difference() {
                union() {
                    standoff_pegs(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd_top + HDD_ORING_POCKET_DEPTH);
                    
                        standoff_pegs(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_R, plate_bot, gan_top + GAN_ORING_POCKET_DEPTH);
                }
                standoff_holes(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_HOLE_R, plate_bot, hdd_top + HDD_ORING_POCKET_DEPTH);
                
                    standoff_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_HOLE_R, plate_bot, gan_top + GAN_ORING_POCKET_DEPTH);
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

/* ================= assembly ================= */


/* ---------- C14 Socket ---------- */
if (SHOW_C14_SOCKET) {
    color("LawnGreen") // Vibrant new leaves green!
    translate(C14_POS)
        rotate(C14_ROT)
            import(C14_STL_FILE);
}

spine_ref(SHOW_SPINE, [80, 0, 0], [0, -90, 0], SPINE_ALPHA);
new_spine(SHOW_NEW_SPINE, "Orange", 1);

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

// Reports the cooler / fan-intake / panel stack-up and flags anything that would
// silently eat the intake clearance. See README "Fan intake clearance".
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
    // The MB box is an envelope, not the board - if it is shorter than the real
    // cooler, every clearance read off the render is optimistic.
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

// Reports the consequences of the SC Shift 180 adaptor pair, and flags the
// assumptions that are not yet confirmed against real hardware. See README.
module gan_adaptor_report() {
    if (SHOW_GAN_BLOCKS) {
        plate_rear_y = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2;
        // rearmost extent of the PSU-side adaptor body
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
        // The junction must clear the plate, or the cable has nowhere to pass.
        if (adaptor_rear_y > plate_rear_y) {
            echo(str("WARNING: the adaptor junction at Y = ", SC_JUNCTION_Y,
                     " still overlaps the spine plate (rear edge ", plate_rear_y,
                     ") - the plate needs a notch here, or the PSU must shift -Y."));
        }
    }
}
