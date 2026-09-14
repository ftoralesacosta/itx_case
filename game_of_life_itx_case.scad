// Game of Life ITX Case - ITX layout study. See README.md for context/conventions.

/* ---------- global toggles ---------- */
SHOW_SPINE      = false;          // original reference STL
SHOW_ENCLOSURE  = false;
SHOW_ODD        = false;


used_components = false;

SHOW_MB         = used_components;
SHOW_HDD        = used_components;
SHOW_HDD2       = used_components;
SHOW_GAN_PSU    = used_components;
SHOW_GAN_STANDOFFS = false; // the real mounting pegs, not the GAN_PSU_POS reference box above
// Front-panel cutout for the (old, spine-mounted) GaN PSU: the AC inlet through-hole +
// mounting pocket/screws, and the small vertical-bar MB<->GaN airflow grill above it.
// Off by default now that the GaN PSU mounts to a different part - see README.
SHOW_GAN_CABLE = false;


SHOW_NEW_SPINE  = true;
SHOW_FRONT_PANEL = true;   // upper (MB-side) I/O panel
SHOW_FRONT_PANEL_LOWER = true; // lower (HDD/GaN) panel

SPINE_ALPHA     = 0.9;
ENCLOSURE_ALPHA = 0.55;

/* ---------- enclosure (outer volume budget) ---------- */
// W grown from 176 to 178.5 specifically to give the IO shield groove's +X side full
// clearance for the real measured widen (3.25mm, matching the other 3 sides) instead of
// the previous 2.5mm compromise - see FRONT_PANEL_IO_GROOVE_WIDEN_PX and README ("IO
// shield retention groove"). IO shield fit takes priority over keeping this at 176.
ENCLOSURE_SIZE = [178.5, 220, 85];   // [W, D, H]
ENCLOSURE_POS  = [5, -90, 18];
ENCLOSURE_ROT  = [0, 0, 0];
ENCLOSURE_EDGE_R = 1.0;

/* ---------- motherboard ---------- */
MB_SIZE = [170, 170, 38];
// Y validated against the official Mini-ITX Addendum v2.0 (to the microATX spec) +
// the ATX spec's own Fig.5 connector-placement rule, not guessed: mounting hole "C" sits
// 10.16mm in from the board's rear/IO edge, and the spec's rear-IO connector face sits
// 11.30mm from that same hole reference - i.e. the connector face is 1.14mm BEYOND the
// board's physical edge. The old Y (-90) put that connector face 2.35mm behind the front
// panel's IO collar registration plane (FRONT_PANEL_IO_COLLAR_DEPTH) - real print/assembly
// testing confirmed the board sat too recessed from the IO shield by about that much.
// Moved 2.35mm toward the front panel (was -90) so the connector face lands on the collar
// plane instead. See README.
MB_POS  = [3, -87.65, 34.6];
MB_ROT  = [0, 0, 0];

/* ---------- HDD (replaces GPU) ---------- */
HDD_SIZE = [101.6, 146.99, 26.11]; // 3.5" HDD envelope [W, D, H]
HDD_POS  = [-5, -56.5, -9.98];
HDD_ROT  = [0, 0, 90];
// 2nd drive, same model/hardware (HDD_SIZE/HOLES/ROT/standoffs all shared) - just offset
// in Y, stacked behind HDD1 away from the front panel. 5mm gap from HDD1's far edge:
// HDD1's -Y face is at HDD_POS.y - HDD_SIZE[0]/2 = -107.8; HDD2's +Y face needs to land
// 5mm behind that, so HDD2_POS.y = -107.8 - 5 - HDD_SIZE[0]/2 = -163.6.
// NOTE: at the current ENCLOSURE_SIZE[1] (198mm) this pushes HDD2's far edge ~25mm past
// the enclosure's back wall (Y=-189) - the enclosure needs to grow further in Y (or HDD2
// needs to move) before this is print-ready. See README.
HDD2_POS = [HDD_POS[0], -159, HDD_POS[2]];

/* ---------- ODD (unused placeholder, see README) ---------- */
ODD_SIZE = [128, 129, 12.7];
ODD_POS  = [30, -70, -50];
ODD_ROT  = [0, 0, 0];

/* ---------- GaN PSU (HDPLEX 250W GaN AIO ATX) ---------- */
GAN_PSU_SIZE = [170, 55, 25]; // [D, W, H]
GAN_PSU_POS  = [3, -186, 38];
GAN_PSU_ROT  = [90, 0, 00];

// Dummy fit-check block, not used elsewhere - HDPLEX 500W GaN AIO ATX (hdplex.com),
// same POS/ROT slot as the 250W above for a direct size comparison.
SHOW_GAN_PSU_500W = false;
GAN_PSU_500W_SIZE = [200.2, 55, 40]; // [D, W, H]

/* ---------- new spine (see README for design background) ---------- */
// Plate footprint is separate from standoff POS - see README.
SPINE_PLATE_POS  = [2.31, -109, 8.1]; // [x, y, z]
SPINE_PLATE_SIZE = [170.6, 212, 3]; // [w, d, t]
SPINE_PLATE_MARGIN_X = 0; // X-only inset applied on top of POS/SIZE, each side

// 3 trapezoidal edge tapers (+X, -Y, -X), copied from the reference STL. See README.
SPINE_PLATE_TAPER_PX_BEFORE = 10;
SPINE_PLATE_TAPER_PX_RUN = 30;
SPINE_PLATE_TAPER_PX_AFTER = 100; // narrow flat run in the middle, measured from the front taper's end - see README
SPINE_PLATE_TAPER_PX_DEPTH = 30; // flush-with-HDD-standoffs target; new_spine() warns on drift

SPINE_PLATE_TAPER_NY_BEFORE = 10;
SPINE_PLATE_TAPER_NY_RUN = 1;
SPINE_PLATE_TAPER_NY_DEPTH = 3; // flush-with-GaN-standoffs target; new_spine() warns on drift

SPINE_PLATE_TAPER_NX_BEFORE = 10;
SPINE_PLATE_TAPER_NX_RUN = 30;
SPINE_PLATE_TAPER_NX_AFTER = 85; // narrow flat run in the middle, measured from the front taper's end - see README
SPINE_PLATE_TAPER_NX_DEPTH = 30; // free - no real hardware to flush against; new_spine() warns if it cuts an MB standoff loose

// 4 reinforcement wedges, front panel to plate, one per corner. X is
// auto-anchored to the plate's real edge + X_OFFSET - see README.
WEDGE_PX_UPPER_Y1 = -5; WEDGE_PX_UPPER_Z1 = 36; WEDGE_PX_UPPER_Y2 = -17; WEDGE_PX_UPPER_Z2 = 9.6; WEDGE_PX_UPPER_THICKNESS = 0.7; WEDGE_PX_UPPER_X_OFFSET = -1.06;
WEDGE_PX_LOWER_Y1 = -5; WEDGE_PX_LOWER_Z1 = -6.0; WEDGE_PX_LOWER_Y2 = -17; WEDGE_PX_LOWER_Z2 = 6.6; WEDGE_PX_LOWER_THICKNESS = 1; WEDGE_PX_LOWER_X_OFFSET = -1.0;
WEDGE_NX_UPPER_Y1 = -5; WEDGE_NX_UPPER_Z1 = 24.6; WEDGE_NX_UPPER_Y2 = -5; WEDGE_NX_UPPER_Z2 = 9.6; WEDGE_NX_UPPER_THICKNESS = 2; WEDGE_NX_UPPER_X_OFFSET = 0;
WEDGE_NX_LOWER_Y1 = -5; WEDGE_NX_LOWER_Z1 = -10.0; WEDGE_NX_LOWER_Y2 = -20; WEDGE_NX_LOWER_Z2 = 6.6; WEDGE_NX_LOWER_THICKNESS = 2; WEDGE_NX_LOWER_X_OFFSET = 2;

STANDOFF_R      = 3.5;  // mounting standoff outer radius
STANDOFF_HOLE_R = 1.9;  // M3 clearance radius
STANDOFF_MARGIN = 8;    // fallback corner inset where no real hole spec is known
STANDOFF_RAMP_RUN_FACTOR = 1.0; // ramp horizontal run = peg height x this (1.0 = 45 degree self-supporting slope)

// Real screw-hole patterns, local [x,y] offsets. See README for sourcing.
// Spec-derived (official Mini-ITX Addendum v2.0, Fig. 3/Table 3), re-derived from scratch
// and triple-checked directly against the primary-source dimensioned drawing (not just a
// summary) - datum at hole C = 6.35mm/10.16mm from the board's rear-left corner, others
// follow from the drawing's own dimensioned spans (C-F = 152.40mm/6.00in exactly, etc).
// A prior version reverted to a different, real-board-measured set after a print reportedly
// screwed together fine - but that fit turned out to require force and warped the spine
// slightly, i.e. it wasn't actually a clean fit either. Back on the spec values now; these
// have NOT yet been print-tested at this exact revision, so re-check fit on the next print.
// See README.
MB_HOLES = [
    [-78.65,  74.84], // hole C - spec datum, 6.35mm/10.16mm from the rear-left corner
    [ 73.75,  62.14], // hole F
    [-78.65, -80.10], // hole H
    [ 73.75, -80.10], // hole J
];

// Re-verified directly against the Seagate Exos X20 SATA Product Manual (Rev. B),
// Figure 4 bottom-mounting-hole drawing. The first read of this drawing (which produced
// the old 41.28/76.20-from-one-edge numbers below) mis-chained the dimensions; the manual
// actually gives hole-to-hole SPACING (A13) plus a hole-to-EDGE offset (A7), not two
// offsets from the same edge. Re-deriving from the drawing's actual chain matches the
// user's own tape-measure numbers (~1"/~1.5") almost exactly. See README.
HDD_HOLE_X_INSET       = 3.18;  // SFF-8301 A5 - 0.125in from the side edge, unchanged
HDD_HOLE_Y_SPACING      = 76.20; // SFF-8301 A13 - "2X 3.000in" hole-to-hole spacing (front row to rear row)
HDD_HOLE_Y_SATA_OFFSET  = 41.28; // SFF-8301 A7  - "2X 1.625in" from the connector-end edge to the near hole row
// Which world direction the SATA/power-connector end faces. true = -X, false = +X.
// (This assumes the current HDD_ROT = [0,0,90]; if that rotation changes, re-check the
// sign against rot2d() before trusting this toggle.)
HDD_SATA_FACING_NEG_X = true;
HDD_HOLES = let(
        hx = HDD_SIZE[0]/2 - HDD_HOLE_X_INSET,
        // rot2d(p, 90) maps local Y to world X as: world_x = HDD_POS.x - local_y.
        // So a *positive* local Y is what lands on the world -X side.
        sata_sign = HDD_SATA_FACING_NEG_X ? 1 : -1,
        sata_y    = sata_sign * (HDD_SIZE[1]/2 - HDD_HOLE_Y_SATA_OFFSET),
        nonsata_y = sata_y - sata_sign * HDD_HOLE_Y_SPACING
    ) [[hx,sata_y], [hx,nonsata_y], [-hx,sata_y], [-hx,nonsata_y]];
// 6-32 UNC, not M3 - see README hardware table + vibration-isolation notes.
HDD_STANDOFF_HOLE_R = 2.3;
HDD_STANDOFF_R = 5;
HDD_ORING_OD = 7.24; // AS568-007
HDD_ORING_CS = 1.78;
// No locating pocket - flat faces on both sides. An earlier version cut a recessed pocket
// (first 1.56mm, later 0.35mm) but even a shallow pocket eats into the O-ring's own
// compressible height for no real benefit: radial location doesn't need a depth cut at
// all, since the O-ring gets threaded onto the screw shaft like a washer during assembly
// (the shaft itself centers it). A pocket's only upside was keeping the ring from
// wandering before the screw goes in, and that's not worth trading compressible height
// for. See README ("HDD vibration isolation - install notes").

GAN_PSU_HOLES = [
    [ 71,  16.65],
    [-73,  16.65],
    [ 71, -16.65],
    [-73, -16.65],
];
GAN_STANDOFF_HOLE_R = 1.9; // M3 clearance
// Widened from the shared STANDOFF_R (like HDD_STANDOFF_R) so the O-rings (OD 7.14mm)
// have a full flat face to rest on at both ends, with a real wall margin around them -
// not just enough for the screw clearance hole.
GAN_STANDOFF_R = 5;
// O-ring at both standoff faces (PSU side + screw-head/plate side) as a thermal
// break from the GaN PSU's aluminum body - see README.
GAN_ORING_OD = 7.14; // 9/32"
GAN_ORING_CS = 1.59; // 1/16"
// No locating pocket - same reasoning as HDD_ORING_OD/CS above. See README ("GaN PSU
// thermal isolation - install notes").

/* ---------- front panel ---------- */
FRONT_PANEL_TOP_Z    = 68.28; // measured off the reference STL
FRONT_PANEL_THICKNESS = 5; // Y depth, front face at Y=0

// MB rear-IO rectangle, offset from MB_POS/mb_bottom so it moves with the board.
// Width/height validated against the official ATX Specification 2.01 Sec 3.3.5: nominal
// I/O cutout is 158.75 x 44.45mm (6.25in x 1.75in, +-0.20mm) - NOT 160.0 x 44.45mm as an
// earlier pass here guessed. This rectangle's own 159.00 x 44.50mm is already within a
// hair of that spec (slightly larger, which is the right direction for clearance), so it
// was left as-is - the real fit problem turned out to be the groove widen below, not this.
FRONT_PANEL_IO_OFFSET = [-72.01, 86.99, -2.83, 41.67]; // [x_min, x_max, z_min, z_max]

// IO shield retention groove - real measured geometry. See README.
FRONT_PANEL_IO_COLLAR_DEPTH = 1.51;
FRONT_PANEL_IO_GROOVE_WIDEN_NX = 3.25;
// Real print/assembly testing showed the shield doesn't fully seat on this side - the
// prior 1.25mm value (cut down from the real measured 3.25mm solely to avoid breaching
// the panel's own +X edge) was leaving too shallow a bite for the shield's folded lip.
// Rather than compromise the IO shield fit, ENCLOSURE_SIZE[0] was grown (176 -> 178.5,
// see above) specifically to give this side room for the FULL real measured value -
// matching the other 3 sides now, with a safe ~1mm wall to the panel's own edge. Re-check
// this margin if ENCLOSURE_SIZE/MB_POS/FRONT_PANEL_IO_OFFSET change.
FRONT_PANEL_IO_GROOVE_WIDEN_PX = 3.25;
FRONT_PANEL_IO_GROOVE_WIDEN_NZ = 3.25;
FRONT_PANEL_IO_GROOVE_WIDEN_PZ = 3.25;

// Top corner screws (M3 + countersink) and their shell-mating tab slots.
FRONT_PANEL_SCREW_X_INSET = 3.0;
FRONT_PANEL_SCREW_Z_INSET = 3.0;
FRONT_PANEL_SCREW_R       = 1.5;
FRONT_PANEL_SCREW_CS_DIA   = 6.4;
FRONT_PANEL_SCREW_CS_ANGLE = 90;

// Tab slot for the eventual shell's own mating tab - same screw clamps both.
FRONT_PANEL_TAB_SLOT_W     = 7.;
FRONT_PANEL_TAB_SLOT_H     = 7;
FRONT_PANEL_TAB_SLOT_DEPTH = 3;

// 2D rounded rectangle (hull of 4 corner circles), centered on the origin.
module rounded_rect_2d(w, h, r) {
    hull()
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * (w/2 - r), sy * (h/2 - r)])
                circle(r = r, $fn = 32);
}

// Clearance shaft + countersink through the panel, optional tab slot (tab_w=0 skips it).
module panel_screw_hole(x, z, r, cs_dia, cs_angle, tab_w=0, tab_h=0, tab_depth=0) {
    cs_r = cs_dia / 2;
    cs_depth = countersink_depth(r, cs_dia, cs_angle);
    translate([x, -FRONT_PANEL_THICKNESS - 1, z])
        rotate([-90, 0, 0])
            cylinder(h = FRONT_PANEL_THICKNESS + 2, r = r, $fn = 24);
    translate([x, 0.5 - cs_depth, z])
        rotate([-90, 0, 0])
            cylinder(h = cs_depth, r1 = r, r2 = cs_r, $fn = 48);
    if (tab_w > 0)
        translate([x - tab_w/2, -FRONT_PANEL_THICKNESS - 0.5, z - tab_h/2])
            cube([tab_w, tab_depth + 0.5, tab_h]);
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

        screw_xs = [x_min + FRONT_PANEL_SCREW_X_INSET, x_max - FRONT_PANEL_SCREW_X_INSET];
        screw_z = FRONT_PANEL_TOP_Z - FRONT_PANEL_SCREW_Z_INSET;

        groove_x0 = io[0] - FRONT_PANEL_IO_GROOVE_WIDEN_NX;
        groove_x1 = io[1] + FRONT_PANEL_IO_GROOVE_WIDEN_PX;
        groove_z0 = io[2] - FRONT_PANEL_IO_GROOVE_WIDEN_NZ;
        groove_z1 = io[3] + FRONT_PANEL_IO_GROOVE_WIDEN_PZ;

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, plate_bot])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, FRONT_PANEL_TOP_Z - plate_bot]);
                // collar: shield's flat face registers here
                translate([io[0], -FRONT_PANEL_IO_COLLAR_DEPTH, io[2]])
                    cube([io[1] - io[0], FRONT_PANEL_IO_COLLAR_DEPTH + 0.5, io[3] - io[2]]);
                // groove: widened pocket, shield's retention lip snaps in
                translate([groove_x0, -FRONT_PANEL_THICKNESS - 1, groove_z0])
                    cube([groove_x1 - groove_x0, FRONT_PANEL_THICKNESS + 1 - FRONT_PANEL_IO_COLLAR_DEPTH + 0.5, groove_z1 - groove_z0]);
                for (screw_x = screw_xs) {
                    panel_screw_hole(screw_x, screw_z, FRONT_PANEL_SCREW_R,
                        FRONT_PANEL_SCREW_CS_DIA, FRONT_PANEL_SCREW_CS_ANGLE,
                        FRONT_PANEL_TAB_SLOT_W, FRONT_PANEL_TAB_SLOT_H, FRONT_PANEL_TAB_SLOT_DEPTH);
                }
            }
    }
}

/* ---------- front panel, lower portion (HDD/GaN PSU side) ---------- */
// GaN PSU AC inlet (the real 3-pin IEC C14 power-cord socket, not the DC output side).
// Real physical part (see photo): a 2-screw, no-fuse C14 flange inlet - closely matches
// the Bulgin PX0580/28 "Flange Mount Inlet" family (EN60320-1 Sheet C14 Class I), whose
// datasheet (Bulgin/Farnell "IEC Connectors" catalog, doc 311707, p.51/PDF p.7) gives an
// actual dimensioned drawing: the flange is a plain 40.0 x 19.8mm rounded rectangle
// (R5.0 corners), NOT the elongated hexagon guessed from the photo alone - the 2x Ø3.4
// screw holes sit exactly at the two ends (40mm apart, matching the flange's full length).
// The plug-face opening itself isn't dimensioned on this sheet, so that still uses the
// separately-corroborated IEC 60320-2-2 figure (~27-28 x 19-20mm, agreeing across two
// independent listings). Fixed on the front face, independent of GAN_PSU_POS - see README.
GAN_CABLE_POS = [-55, -10]; // [x, z]
GAN_CABLE_CUTOUT_W = 29;   // front through-hole, flush with the panel face - plug face
GAN_CABLE_CUTOUT_H = 21;   // is ~27-28 x 19-20mm (IEC 60320-2-2) + print clearance
GAN_CABLE_CUTOUT_R = 3;    // front hole corner rounding - the real plug face is rounded too
// Rear pocket for the flange - a real rounded rectangle now (Bulgin PX0580/28: 40.0 x
// 19.8mm, R5.0), not the oversized hexagon-hull guess from before. Sized with ~1-1.5mm
// clearance per side over the real flange so it seats without a fight.
GAN_CABLE_POCKET_W = 42;      // flange 40.0mm + clearance
GAN_CABLE_POCKET_H = 22;      // flange 19.8mm + clearance
GAN_CABLE_POCKET_R  = 5.5;    // flange corner R5.0 + clearance
// Recessed so the plug face sits flush with the panel front despite FRONT_PANEL_THICKNESS
// being thicker than the connector's own front boss. Depth = panel thickness minus your
// own ~1.5mm (middle of the 1-2mm range you estimated) boss-height guess - the Bulgin sheet
// doesn't give this either (only overall depth "A" by termination type, not boss height
// specifically), so this part is still your estimate, not a datasheet figure.
GAN_CABLE_POCKET_DEPTH = FRONT_PANEL_THICKNESS - 1.5;
GAN_CABLE_SCREW_SPACING = 40; // 2x M3 (Ø3.4 clearance per Bulgin PX0580/28), 40mm apart
GAN_CABLE_SCREW_R = 1.75;     // M3 clearance

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
SPINE_GRID_WALL   = 2.5;
// Diamonds along the -Y margin get subdivided to this scale (0 disables). See README.
SPINE_LIGHTENING_NY_INLAY_SCALE = 0.3;

// Game of Life-inspired shapes for GOL_Grill_*_SHAPE below - [di,dj] live-cell
// offsets on a square lattice. See README ("HDD ventilation grill").
LIFE_BLOCK   = [[0,0],[1,0], [0,1],[1,1]]; // solid 2x2 - already fully edge-connected
LIFE_BEEHIVE = [[1,0],[2,0], [0,1],[3,1], [1,2],[2,2], [0,0],[3,0],[0,2],[3,2]];
LIFE_POND    = [[1,0],[2,0], [0,1],[3,1], [0,2],[3,2], [1,3],[2,3]]; // ring / "0"
LIFE_HEX_RING = [[1,0],[2,0], [0,1],[3,1], [1,2],[2,2]]; // hex "0", unbridged

// Not still lifes - plain ">"/"<" chevrons, two straight lines sharing a corner
// cell (the grid's own 45deg rotation makes them diagonal). _2/_3 = arm length.
ARROW_GT_2 = [[0,0], [0,1], [-1,0]];
ARROW_GT_3 = [[0,0], [0,1],[0,2], [-1,0],[-2,0]];
ARROW_LT_2 = [[0,0], [1,0], [0,-1]];
ARROW_LT_3 = [[0,0], [1,0],[2,0], [0,-1],[0,-2]];
GOL_OFF = []; // set a GOL_Grill_*_SHAPE to this to turn that slot off

// HDD ventilation grill (front panel). Untethered from HDD_POS/HDD_SIZE - move/resize
// freely. Defaults below reproduce the old HDD-tethered footprint (margins L4/R5.2/T6/B0
// around the drive envelope at its old position) so this change doesn't shift anything.
HDD_GRILL_MODE = "diamond"; // "honeycomb" or "diamond"
// Left edge pulled in to -15 (from -39.2) to clear the GaN cable pocket's right tip
// (-26 at the current GAN_CABLE_POS/SCREW_SPACING/POCKET_END_R) with an 11mm margin -
// right edge unchanged. Re-check this gap if either position moves again.
HDD_GRILL_POS  = [10, -6.5];   // [x, z] center, front panel local coords
HDD_GRILL_SIZE = [160, 32.0];  // [w, h]

HDD_GRILL_HEX_R  = 4;
HDD_GRILL_WALL   = 1.25; // shared by both modes
HDD_GRILL_DIAMOND_SLOT_W = 4;
HDD_GRILL_DIAMOND_SLOT_H = 4;

// "diamond" mode only: up to 4 [SHAPE, ANCHOR] slots kept solid on the grill.
// ANCHOR is a grid_2d index [i0,j0], lattice step = SLOT+WALL. See README.
GOL_Grill_1_SHAPE  = LIFE_HEX_RING; // "0" ring, +X side
GOL_Grill_1_ANCHOR = [4, -6];
GOL_Grill_2_SHAPE  = GOL_OFF;
GOL_Grill_2_ANCHOR = [0, -2];
GOL_Grill_3_SHAPE  = GOL_OFF;
GOL_Grill_3_ANCHOR = [-6, 6];
GOL_Grill_4_SHAPE  = GOL_OFF;
GOL_Grill_4_ANCHOR = [-3, 3];

// Guard wedge cut out of the HDD grill pattern near the +X/-Z corner screw
// so it keeps solid material regardless of where the hex tiling lands.
FRONT_PANEL_CORNER_INFILL_X = 13;
FRONT_PANEL_CORNER_INFILL_Z = 13;

// Distance from wp to nearest protected footprint (circles [x,y,r], rects
// [x_min,y_min,x_max,y_max]); 0 if inside. See README.
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

// World-space protect_pts for a [di,dj] shape anchored at grid_2d index [i0,j0];
// pitch_x/y and world_rot must match the grid_2d() call this feeds. See README.
function life_pattern_protect_pts(cells, anchor, pitch_x, pitch_y, world_rot) =
    [for (c = cells)
        let(x = (anchor[0] + c[0]) * pitch_x, y = (anchor[1] + c[1]) * pitch_y)
        [cos(world_rot)*x - sin(world_rot)*y, sin(world_rot)*x + cos(world_rot)*y, 0]];

// One part's standoff+ramp footprints as world-space [protect_pts, protect_rects].
// Drops standoffs already covered by the flat margin box. See README.
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

// Hex field tiling [w,h], clipped to a straight border. protect_* keep cells
// over a footprint solid instead of generated. See README ("Hex/grid tiling helpers").
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

// Square grid, used rotated 45deg for "diamond" mode. Same params as honeycomb_2d()
// above, plus inlay_edge_pts/inlay_scale (subdivide cells near an edge). See README.
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

        cable_x = GAN_CABLE_POS[0];
        cable_z = GAN_CABLE_POS[1];

        // lower corner case-mounting screws, same treatment as the upper panel's
        corner_screw_xs = [x_min + FRONT_PANEL_SCREW_X_INSET, x_max - FRONT_PANEL_SCREW_X_INSET];
        corner_screw_z = z_min + FRONT_PANEL_SCREW_Z_INSET;

        grill_w = HDD_GRILL_SIZE[0];
        grill_h = HDD_GRILL_SIZE[1];
        grill_x = HDD_GRILL_POS[0];
        grill_z = HDD_GRILL_POS[1];

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, z_min])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, plate_top - z_min]);
                // GaN PSU AC inlet cutout (through-hole + pocket + screws) and the small
                // vertical-bar MB<->GaN airflow grill above it - one toggle for all 3,
                // since they're only meaningful together (see SHOW_GAN_CABLE above/README).
                if (SHOW_GAN_CABLE) {
                    // front through-hole for the connector body/plug face, rounded rect
                    // (real plug face has rounded corners too)
                    translate([cable_x, -FRONT_PANEL_THICKNESS - 1, cable_z])
                        rotate([-90, 0, 0])
                            linear_extrude(height = FRONT_PANEL_THICKNESS + 2)
                                rounded_rect_2d(GAN_CABLE_CUTOUT_W, GAN_CABLE_CUTOUT_H, GAN_CABLE_CUTOUT_R);
                    // ...plus a recessed rear pocket for the mounting flange, so the plug
                    // face lands flush with the panel front - see GAN_CABLE_POCKET_DEPTH above.
                    // Real flange shape (Bulgin PX0580/28): a plain rounded rectangle.
                    translate([cable_x, -FRONT_PANEL_THICKNESS - 1, cable_z])
                        rotate([-90, 0, 0])
                            linear_extrude(height = GAN_CABLE_POCKET_DEPTH + 1)
                                rounded_rect_2d(GAN_CABLE_POCKET_W, GAN_CABLE_POCKET_H, GAN_CABLE_POCKET_R);
                    // AC inlet mounting screws (2x M3, 40mm apart - not 4)
                    for (sx = [cable_x - GAN_CABLE_SCREW_SPACING/2, cable_x + GAN_CABLE_SCREW_SPACING/2]) {
                        translate([sx, -FRONT_PANEL_THICKNESS - 1, cable_z])
                            rotate([-90, 0, 0])
                                cylinder(h = FRONT_PANEL_THICKNESS + 2, r = GAN_CABLE_SCREW_R, $fn = 24);
                    }
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
                    }
                }
                // lower corner case-mounting screws
                for (screw_x = corner_screw_xs) {
                    panel_screw_hole(screw_x, corner_screw_z, FRONT_PANEL_SCREW_R,
                        FRONT_PANEL_SCREW_CS_DIA, FRONT_PANEL_SCREW_CS_ANGLE,
                        FRONT_PANEL_TAB_SLOT_W, FRONT_PANEL_TAB_SLOT_H, FRONT_PANEL_TAB_SLOT_DEPTH);
                }
                // HDD grill, with a guard wedge cut out near the corner screw.
                // honeycomb_2d()'s local frame is centered on (grill_x, grill_z);
                // rotate([-90,0,0]) negates local_y relative to world Z.
                corner_guard = [
                    [x_max - grill_x, grill_z - z_min],
                    [x_max - FRONT_PANEL_CORNER_INFILL_X - grill_x, grill_z - z_min],
                    [x_max - grill_x, grill_z - (z_min + FRONT_PANEL_CORNER_INFILL_Z)],
                ];
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
                                                grill_life_protect, [], 0, 45);
                                        square([grill_w, grill_h], center = true);
                                    }
                                } else {
                                    honeycomb_2d(grill_w, grill_h, HDD_GRILL_HEX_R, HDD_GRILL_WALL);
                                }
                                polygon(corner_guard);
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

// Wireframe cage (12 edge rods, no faces) - can't occlude anything, sidestepping
// OpenSCAD's transparency-through-boolean limitation.
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
        full  = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2,
        narrow = full - SPINE_PLATE_TAPER_PX_DEPTH,
        y_max = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_PX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_PX_RUN,
        bte = fte - SPINE_PLATE_TAPER_PX_AFTER,
        bbe = bte - SPINE_PLATE_TAPER_PX_RUN
    )
    (y > fbe) ? full :
    (y > fte) ? full - (full - narrow) * (fbe - y) / SPINE_PLATE_TAPER_PX_RUN :
    (y > bte) ? narrow :
    (y > bbe) ? full - (full - narrow) * (y - bbe) / SPINE_PLATE_TAPER_PX_RUN :
    full;

function spine_plate_nx_edge(y) =
    let(
        full  = SPINE_PLATE_POS[0] - SPINE_PLATE_SIZE[0]/2,
        narrow = full + SPINE_PLATE_TAPER_NX_DEPTH,
        y_max = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_NX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_NX_RUN,
        bte = fte - SPINE_PLATE_TAPER_NX_AFTER,
        bbe = bte - SPINE_PLATE_TAPER_NX_RUN
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
        x_min = SPINE_PLATE_POS[0] - (SPINE_PLATE_SIZE[0] - 2*SPINE_PLATE_MARGIN_X)/2,
        x_max = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2,
        lbe = x_min + SPINE_PLATE_TAPER_NY_BEFORE,
        lte = lbe + SPINE_PLATE_TAPER_NY_RUN,
        rbe = x_max - SPINE_PLATE_TAPER_NY_BEFORE,
        rte = rbe - SPINE_PLATE_TAPER_NY_RUN
    )
    (x < lbe) ? full :
    (x < lte) ? full + (narrow - full) * (x - lbe) / SPINE_PLATE_TAPER_NY_RUN :
    (x < rte) ? narrow :
    (x < rbe) ? full + (narrow - full) * (rbe - x) / SPINE_PLATE_TAPER_NY_RUN :
    full;

// *_edge() above, shifted by margin, as a polyline following the real taper.
// pad extends past the plate so callers can intersect against a taller/shorter box.
function spine_plate_px_edge_points(margin, y_pad = 50) =
    let(
        y_max = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2,
        y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_PX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_PX_RUN,
        bte = fte - SPINE_PLATE_TAPER_PX_AFTER,
        bbe = bte - SPINE_PLATE_TAPER_PX_RUN
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
        bte = fte - SPINE_PLATE_TAPER_NX_AFTER,
        bbe = bte - SPINE_PLATE_TAPER_NX_RUN
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
        x_min = SPINE_PLATE_POS[0] - (SPINE_PLATE_SIZE[0] - 2*SPINE_PLATE_MARGIN_X)/2,
        x_max = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2,
        lbe = x_min + SPINE_PLATE_TAPER_NY_BEFORE,
        lte = lbe + SPINE_PLATE_TAPER_NY_RUN,
        rbe = x_max - SPINE_PLATE_TAPER_NY_BEFORE,
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

// The plate's real (taper-aware) outline polygon - keep in sync with
// spine_plate_px_edge()/nx_edge()/ny_edge() above.
function spine_plate_outline() =
    let(
        plate_x = SPINE_PLATE_POS[0],
        plate_y = SPINE_PLATE_POS[1],
        plate_w = SPINE_PLATE_SIZE[0] - 2*SPINE_PLATE_MARGIN_X,
        plate_d = SPINE_PLATE_SIZE[1],
        plate_x_min = plate_x - plate_w/2,
        plate_x_max = plate_x + plate_w/2,
        plate_y_min = plate_y - plate_d/2,
        plate_y_max = plate_y + plate_d/2,
        front_x_max = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2,
        px_narrow_x = front_x_max - SPINE_PLATE_TAPER_PX_DEPTH,
        taper_start_y = plate_y_max - SPINE_PLATE_TAPER_PX_BEFORE,
        taper_end_y   = taper_start_y - SPINE_PLATE_TAPER_PX_RUN,
        back_taper_end_y   = taper_end_y - SPINE_PLATE_TAPER_PX_AFTER,
        back_taper_start_y = back_taper_end_y - SPINE_PLATE_TAPER_PX_RUN,
        ny_narrow_y = plate_y_min + SPINE_PLATE_TAPER_NY_DEPTH,
        ny_taper_left_start_x  = plate_x_min + SPINE_PLATE_TAPER_NY_BEFORE,
        ny_taper_left_end_x    = ny_taper_left_start_x + SPINE_PLATE_TAPER_NY_RUN,
        ny_taper_right_start_x = front_x_max - SPINE_PLATE_TAPER_NY_BEFORE,
        ny_taper_right_end_x   = ny_taper_right_start_x - SPINE_PLATE_TAPER_NY_RUN,
        nx_inset_x = plate_x_min + SPINE_PLATE_TAPER_NX_DEPTH,
        nx_taper_front_start_y = plate_y_max - SPINE_PLATE_TAPER_NX_BEFORE,
        nx_taper_front_end_y   = nx_taper_front_start_y - SPINE_PLATE_TAPER_NX_RUN,
        nx_taper_back_end_y    = nx_taper_front_end_y - SPINE_PLATE_TAPER_NX_AFTER,
        nx_taper_back_start_y  = nx_taper_back_end_y - SPINE_PLATE_TAPER_NX_RUN
    )
    [
        [plate_x_min, plate_y_min],
        [ny_taper_left_start_x, plate_y_min],
        [ny_taper_left_end_x, ny_narrow_y],
        [ny_taper_right_end_x, ny_narrow_y],
        [ny_taper_right_start_x, plate_y_min],
        [front_x_max, plate_y_min],
        [front_x_max, back_taper_start_y],
        [px_narrow_x, back_taper_end_y],
        [px_narrow_x, taper_end_y],
        [front_x_max, taper_start_y],
        [front_x_max, plate_y_max],
        [plate_x_min, plate_y_max],
        [plate_x_min, nx_taper_front_start_y],
        [nx_inset_x, nx_taper_front_end_y],
        [nx_inset_x, nx_taper_back_end_y],
        [plate_x_min, nx_taper_back_start_y],
    ];

// Drift/connectivity self-checks for the taper DEPTHs above. See README.
module spine_plate_taper_warnings() {
    plate_x_max = SPINE_PLATE_POS[0] + (SPINE_PLATE_SIZE[0] - 2*SPINE_PLATE_MARGIN_X)/2;
    plate_y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2;
    front_x_max = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2;
    px_narrow_x = front_x_max - SPINE_PLATE_TAPER_PX_DEPTH;
    if (abs(px_narrow_x - plate_x_max) > 0.01) {
        echo(str("WARNING: SPINE_PLATE_TAPER_PX_DEPTH (", SPINE_PLATE_TAPER_PX_DEPTH,
            ") no longer matches the flush-with-HDD-standoffs width (plate_x_max = ", plate_x_max,
            ", would need PX_DEPTH = ", front_x_max - plate_x_max,
            ") - the +X taper's waist is no longer flush with the HDD standoffs."));
    }
    // Gated on SHOW_GAN_STANDOFFS - with the GaN PSU mounting to a different part
    // entirely (see README), this plate's -Y taper has nothing GaN-related to stay
    // flush with, so the drift check is meaningless noise until that changes.
    if (SHOW_GAN_STANDOFFS) {
        gan_world_ys  = [for (wp = world_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2])) wp[1]];
        gan_y_min_edge = min(gan_world_ys) - GAN_STANDOFF_R;
        ny_narrow_y = plate_y_min + SPINE_PLATE_TAPER_NY_DEPTH;
        if (abs(ny_narrow_y - gan_y_min_edge) > 0.01) {
            echo(str("WARNING: SPINE_PLATE_TAPER_NY_DEPTH (", SPINE_PLATE_TAPER_NY_DEPTH,
                ") no longer matches the flush-with-GaN-standoffs depth (gan_y_min_edge = ", gan_y_min_edge,
                ", would need NY_DEPTH = ", gan_y_min_edge - plate_y_min,
                ") - the -Y taper's waist is no longer flush with the GaN PSU standoffs."));
        }
    }
    // warn if the -X taper cuts an MB standoff loose from the plate
    for (wp = world_holes(MB_POS, MB_HOLES, MB_ROT[2])) {
        mb_wx = wp[0];
        mb_wy = wp[1];
        nx_edge_here = spine_plate_nx_edge(mb_wy);
        if (mb_wx - STANDOFF_R < nx_edge_here) {
            echo(str("WARNING: SPINE_PLATE_TAPER_NX_DEPTH (", SPINE_PLATE_TAPER_NX_DEPTH,
                ") cuts past an MB standoff at [", mb_wx, ",", mb_wy, "] - standoff -X edge = ",
                mb_wx - STANDOFF_R, ", plate -X edge there = ", nx_edge_here,
                " - this standoff may be disconnected from the plate."));
        }
    }
}

// Real (MB_POS-aware) IO groove footprint [x_min,x_max,z_min,z_max] -
// mirrors front_panel_upper()'s own cut. Keeps the upper wedges clear of it.
function io_groove_bounds() =
    let(
        mb_bottom = MB_POS[2] - MB_SIZE[2]/2,
        x0 = MB_POS[0] + FRONT_PANEL_IO_OFFSET[0],
        x1 = MB_POS[0] + FRONT_PANEL_IO_OFFSET[1],
        z0 = mb_bottom + FRONT_PANEL_IO_OFFSET[2],
        z1 = mb_bottom + FRONT_PANEL_IO_OFFSET[3]
    )
    [x0 - FRONT_PANEL_IO_GROOVE_WIDEN_NX, x1 + FRONT_PANEL_IO_GROOVE_WIDEN_PX,
     z0 - FRONT_PANEL_IO_GROOVE_WIDEN_NZ, z1 + FRONT_PANEL_IO_GROOVE_WIDEN_PZ];

// Clamps an upper wedge's Z1 below the IO groove's real Z-range (if X-ranges
// overlap). Returns z2 (degenerate) if there's no room - caller skips building it.
function wedge_upper_z1_clamped(z1, z2, x_lo, x_hi) =
    let(
        gb = io_groove_bounds(),
        x_overlaps = (x_hi > gb[0]) && (x_lo < gb[1]),
        limit = gb[2] - 0.5 // small safety margin below the groove's real floor
    )
    (x_overlaps && limit < z1) ? max(z2, limit) : z1;

// Right-triangle gusset in the Y-Z plane, extruded by `thickness` in X from
// world X = x0. dir=+1 extrudes toward +X, dir=-1 toward -X. Right angle at (y1, z2).
module reinforcement_wedge(y1, z1, y2, z2, x0, thickness, dir) {
    x_min = dir > 0 ? x0 : x0 - thickness;
    x_max = dir > 0 ? x0 + thickness : x0;
    polyhedron(
        points = [
            [x_min, y1, z1],
            [x_min, y2, z2],
            [x_min, y1, z2],
            [x_max, y1, z1],
            [x_max, y2, z2],
            [x_max, y1, z2],
        ],
        faces = [
            [0, 2, 1],
            [3, 4, 5],
            [0, 1, 4, 3],
            [1, 2, 5, 4],
            [2, 0, 3, 5],
        ]
    );
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

// Standoffs at [x,y] local hole points, each with a drilled through-hole
// and a +Y ramp. z_from is always the plate-contact end.
// NOTE: when standoffs from two different components sit close together (e.g. two HDDs
// a few mm apart), don't call this per-component - a ramp from one can reach far enough
// in +Y to bury an adjacent component's hole, since this cuts holes only against its own
// pegs. Instead union() all the standoff_pegs() calls together first, then subtract every
// component's standoff_holes() in one combined difference() - see the HDD/HDD2/GaN group
// in new_spine() for the pattern.
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
        hdd2_top  = HDD2_POS[2] + HDD_SIZE[2]/2;
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
                for (wp = world_holes(HDD2_POS, HDD_HOLES, HDD_ROT[2])) {
                    wx = wp[0];
                    wy = wp[1];
                    translate([wx, wy, plate_bot - 0.5])
                        cylinder(h = plate_t + 1, r = HDD_STANDOFF_HOLE_R, $fn = 24);
                }
                // Gated like the pegs/lightening-protect below - with SHOW_GAN_STANDOFFS
                // off, the GaN PSU isn't mounting to this plate at all (see README), so no
                // clearance hole should appear here either.
                if (SHOW_GAN_STANDOFFS)
                    for (wp = world_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2])) {
                        wx = wp[0];
                        wy = wp[1];
                        translate([wx, wy, plate_bot - 0.5])
                            cylinder(h = plate_t + 1, r = GAN_STANDOFF_HOLE_R, $fn = 24);
                    }
                // Lightening/vent pattern - see SPINE_LIGHTENING_* above, README.
                lightening_px_limit = (ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2) - SPINE_LIGHTENING_MARGIN_PX;
                lightening_nx_limit = (plate_x - plate_w/2) + SPINE_LIGHTENING_MARGIN_NX;
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
                hdd2_lightening_protect = standoff_lightening_protect(HDD2_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd2_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                // No standoffs there means no material needs protecting - let the
                // lightening pattern cut straight through instead of leaving solid cells.
                gan_lightening_protect = SHOW_GAN_STANDOFFS
                    ? standoff_lightening_protect(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_R, plate_bot, gan_top,
                        lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit)
                    : [[], []];
                lightening_protect_pts = concat(mb_lightening_protect[0], hdd_lightening_protect[0], hdd2_lightening_protect[0], gan_lightening_protect[0]);
                lightening_protect_rects = concat(mb_lightening_protect[1], hdd_lightening_protect[1], hdd2_lightening_protect[1], gan_lightening_protect[1]);
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

            // HDD + 2nd HDD + GaN standoffs, all flat-face (no O-ring pocket - see README).
            // Built as one combined union-then-difference, not 3 separate standoffs()
            // calls: HDD/HDD2 sit close enough together that one standoff's +Y print
            // ramp can reach into the next one's hole position - cutting each hole only
            // against its own peg (like standoffs() does standalone) can leave that
            // ramp material plugging a neighboring standoff's hole. Doing every hole as
            // one difference() against the whole unioned peg group avoids that regardless
            // of how close two standoffs end up.
            difference() {
                union() {
                    standoff_pegs(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd_top);
                    standoff_pegs(HDD2_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd2_top);
                    if (SHOW_GAN_STANDOFFS)
                        standoff_pegs(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_R, plate_bot, gan_top);
                }
                standoff_holes(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_HOLE_R, plate_bot, hdd_top);
                standoff_holes(HDD2_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_HOLE_R, plate_bot, hdd2_top);
                if (SHOW_GAN_STANDOFFS)
                    standoff_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], GAN_STANDOFF_HOLE_R, plate_bot, gan_top);
            }

            front_panel_upper(SHOW_FRONT_PANEL, plate_bot, col, alpha);
            front_panel_lower(SHOW_FRONT_PANEL_LOWER, plate_top, col, alpha);

            // reinforcement wedges - see WEDGE_* above. UPPER wedges get Z1
            // clamped below the IO groove; skipped entirely if no room is left.
            px_upper_edge = spine_plate_px_edge(WEDGE_PX_UPPER_Y2) + WEDGE_PX_UPPER_X_OFFSET;
            px_upper_z1 = wedge_upper_z1_clamped(WEDGE_PX_UPPER_Z1, WEDGE_PX_UPPER_Z2,
                px_upper_edge - WEDGE_PX_UPPER_THICKNESS, px_upper_edge);
            if (px_upper_z1 > WEDGE_PX_UPPER_Z2) {
                reinforcement_wedge(WEDGE_PX_UPPER_Y1, px_upper_z1, WEDGE_PX_UPPER_Y2, WEDGE_PX_UPPER_Z2,
                    px_upper_edge, WEDGE_PX_UPPER_THICKNESS, -1);
            } else {
                echo("WARNING: WEDGE_PX_UPPER skipped - no clearance from the IO groove at the current MB_POS");
            }
            reinforcement_wedge(WEDGE_PX_LOWER_Y1, WEDGE_PX_LOWER_Z1, WEDGE_PX_LOWER_Y2, WEDGE_PX_LOWER_Z2,
                spine_plate_px_edge(WEDGE_PX_LOWER_Y2) + WEDGE_PX_LOWER_X_OFFSET, WEDGE_PX_LOWER_THICKNESS, -1);
            nx_upper_edge = spine_plate_nx_edge(WEDGE_NX_UPPER_Y2) + WEDGE_NX_UPPER_X_OFFSET;
            nx_upper_z1 = wedge_upper_z1_clamped(WEDGE_NX_UPPER_Z1, WEDGE_NX_UPPER_Z2,
                nx_upper_edge, nx_upper_edge + WEDGE_NX_UPPER_THICKNESS);
            if (nx_upper_z1 > WEDGE_NX_UPPER_Z2) {
                reinforcement_wedge(WEDGE_NX_UPPER_Y1, nx_upper_z1, WEDGE_NX_UPPER_Y2, WEDGE_NX_UPPER_Z2,
                    nx_upper_edge, WEDGE_NX_UPPER_THICKNESS, 1);
            } else {
                echo("WARNING: WEDGE_NX_UPPER skipped - no clearance from the IO groove at the current MB_POS");
            }
            reinforcement_wedge(WEDGE_NX_LOWER_Y1, WEDGE_NX_LOWER_Z1, WEDGE_NX_LOWER_Y2, WEDGE_NX_LOWER_Z2,
                spine_plate_nx_edge(WEDGE_NX_LOWER_Y2) + WEDGE_NX_LOWER_X_OFFSET, WEDGE_NX_LOWER_THICKNESS, 1);
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

spine_ref(SHOW_SPINE, [80, 0, 0], [0, -90, 0], SPINE_ALPHA);
new_spine(SHOW_NEW_SPINE, "Orange", 1);

enclosure_ref(ENCLOSURE_SIZE, ENCLOSURE_POS, ENCLOSURE_ROT, SHOW_ENCLOSURE, "Gray", ENCLOSURE_ALPHA, ENCLOSURE_EDGE_R);

labeled_box(MB_SIZE,  MB_POS,  MB_ROT,  SHOW_MB,  "Blue");
labeled_box(HDD_SIZE, HDD_POS, HDD_ROT, SHOW_HDD, "Red");
labeled_box(HDD_SIZE, HDD2_POS, HDD_ROT, SHOW_HDD2, "Red");
labeled_box(ODD_SIZE, ODD_POS, ODD_ROT, SHOW_ODD, "Cyan");
labeled_box(GAN_PSU_SIZE, GAN_PSU_POS, GAN_PSU_ROT, SHOW_GAN_PSU, "Black");
labeled_box(GAN_PSU_500W_SIZE, GAN_PSU_POS, GAN_PSU_ROT, SHOW_GAN_PSU_500W, "Purple", 0.5);
