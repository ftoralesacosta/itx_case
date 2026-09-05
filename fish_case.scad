// Fish Case - ITX layout study. See README.md for context/conventions.

/* ---------- global toggles ---------- */
SHOW_SPINE      = false;          // original reference STL
SHOW_ENCLOSURE  = false;
SHOW_ODD        = false;


used_components = false;

SHOW_MB         = used_components;
SHOW_HDD        = used_components;
SHOW_GAN_PSU    = used_components;


SHOW_NEW_SPINE  = true;
SHOW_FRONT_PANEL = true;   // upper (MB-side) portion of the spine's front I/O panel, copied from the STL
SHOW_FRONT_PANEL_LOWER = true; // lower (HDD/GaN PSU-side) portion - simple flat plate, PSU cable opening + mount screws

SPINE_ALPHA     = 0.9;
ENCLOSURE_ALPHA = 0.55;

/* ---------- enclosure (outer volume budget) ---------- */
ENCLOSURE_SIZE = [176, 178, 85];   // [W, D, H]
ENCLOSURE_POS  = [5, -90, 18];
ENCLOSURE_ROT  = [0, 0, 0];
ENCLOSURE_EDGE_R = 1.0;

/* ---------- motherboard ---------- */
MB_SIZE = [170, 170, 38];
MB_POS  = [3, -90, 34.6];
MB_ROT  = [0, 0, 0];

/* ---------- HDD (replaces GPU) ---------- */
HDD_SIZE = [101.6, 146.99, 26.11]; // 3.5" HDD envelope [W, D, H]
HDD_POS  = [35, -78.5, -9.98];
HDD_ROT  = [0, 0, 0];

/* ---------- ODD (unused placeholder, see README) ---------- */
ODD_SIZE = [128, 129, 12.7];
ODD_POS  = [30, -70, -50];
ODD_ROT  = [0, 0, 0];

/* ---------- GaN PSU (HDPLEX 250W GaN AIO ATX) ---------- */
GAN_PSU_SIZE = [170, 55, 25]; // [D, W, H]
GAN_PSU_POS  = [-48, -90, -10];
GAN_PSU_ROT  = [0, 0, 90];

/* ---------- new spine (see README for design background) ---------- */
// Standoffs (MB/HDD/GaN) are tethered to their own part's POS. The plate's
// own footprint is separate: SPINE_PLATE_POS/SIZE, plain numbers, not a
// formula. SPINE_PLATE_MARGIN_X insets it symmetrically on top of that.
SPINE_PLATE_POS  = [2.31, -90, 8.1]; // [x, y, z]
SPINE_PLATE_SIZE = [170.6, 174, 3]; // [w, d, t]
SPINE_PLATE_MARGIN_X = 0; // X-only inset applied on top of POS/SIZE, each side

// 3 trapezoidal edge tapers (+X, -Y, -X), copied from the reference STL's
// own outline shape. Each: flat for *_BEFORE, then tapers over *_RUN to
// *_DEPTH in from the full edge, mirrored front/back. See README.
SPINE_PLATE_TAPER_PX_BEFORE = 15;
SPINE_PLATE_TAPER_PX_RUN = 6.665;
SPINE_PLATE_TAPER_PX_DEPTH = 5.35; // flush-with-HDD-standoffs target; new_spine() warns on drift

SPINE_PLATE_TAPER_NY_BEFORE = 20;
SPINE_PLATE_TAPER_NY_RUN = 5;
SPINE_PLATE_TAPER_NY_DEPTH = 10.5; // flush-with-GaN-standoffs target; new_spine() warns on drift

SPINE_PLATE_TAPER_NX_BEFORE = 25;
SPINE_PLATE_TAPER_NX_RUN = 30;
SPINE_PLATE_TAPER_NX_DEPTH = 30; // free - no real hardware to flush against; new_spine() warns if it cuts an MB standoff loose

// 4 reinforcement wedges, front panel to plate, one per corner. PX/NX =
// which plate edge; UPPER/LOWER = Z. X is auto-anchored to the plate's
// real edge (see spine_plate_px_edge()/nx_edge() below) + X_OFFSET. See
// README for why X isn't just a plain number here.
WEDGE_PX_UPPER_Y1 = -5; WEDGE_PX_UPPER_Z1 = 24.6; WEDGE_PX_UPPER_Y2 = -17; WEDGE_PX_UPPER_Z2 = 9.6; WEDGE_PX_UPPER_THICKNESS = 0.7; WEDGE_PX_UPPER_X_OFFSET = -1.0;
WEDGE_PX_LOWER_Y1 = -5; WEDGE_PX_LOWER_Z1 = -6.0; WEDGE_PX_LOWER_Y2 = -17; WEDGE_PX_LOWER_Z2 = 6.6; WEDGE_PX_LOWER_THICKNESS = 1; WEDGE_PX_LOWER_X_OFFSET = -1.0;
WEDGE_NX_UPPER_Y1 = -5; WEDGE_NX_UPPER_Z1 = 24.6; WEDGE_NX_UPPER_Y2 = -5; WEDGE_NX_UPPER_Z2 = 9.6; WEDGE_NX_UPPER_THICKNESS = 2; WEDGE_NX_UPPER_X_OFFSET = 0;
WEDGE_NX_LOWER_Y1 = -5; WEDGE_NX_LOWER_Z1 = -10.0; WEDGE_NX_LOWER_Y2 = -20; WEDGE_NX_LOWER_Z2 = 6.6; WEDGE_NX_LOWER_THICKNESS = 2; WEDGE_NX_LOWER_X_OFFSET = 2;

STANDOFF_R      = 3.5;  // mounting standoff outer radius
STANDOFF_HOLE_R = 1.9;  // M3 clearance radius
STANDOFF_MARGIN = 8;    // fallback corner inset where no real hole spec is known
STANDOFF_RAMP_RUN_FACTOR = 1.0; // ramp horizontal run = peg height x this (1.0 = 45 degree self-supporting slope)

// Real screw-hole patterns, [x,y] offsets from each part's own center
// before its own Z rotation. See README for sourcing (MB: measured off the
// reference STL; HDD: WD SFF-8301 whitepaper; GaN: HDPLEX's own STEP file).
MB_HOLES = [
    [-79.16,  75.47],
    [ 78.14,  52.57],
    [-79.13, -79.13],
    [ 78.14, -79.13],
];

HDD_HOLE_X_INSET  = 3.18;   // SFF-8301 A5
HDD_HOLE_Y_FRONT  = 41.28;  // SFF-8301 A7
HDD_HOLE_Y_REAR   = 76.20;  // SFF-8301 A13
HDD_HOLES = let(
        hx = HDD_SIZE[0]/2 - HDD_HOLE_X_INSET,
        y1 = -HDD_SIZE[1]/2 + HDD_HOLE_Y_FRONT,
        y2 = -HDD_SIZE[1]/2 + HDD_HOLE_Y_REAR
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
GAN_STANDOFF_HOLE_R = 1.9; // M3 clearance
GAN_STANDOFF_CS_DIA   = 6.4;
GAN_STANDOFF_CS_ANGLE = 90;

/* ---------- front panel ---------- */
FRONT_PANEL_TOP_Z    = 68.28; // measured off the reference STL
FRONT_PANEL_THICKNESS = 5; // Y depth, front face at Y=0

// MB rear-IO rectangle, stored as an offset from MB_POS/mb_bottom so it
// (and the retention groove, and the standoffs) move with the board. See
// README for how this was measured.
FRONT_PANEL_IO_OFFSET = [-72.01, 86.99, -2.83, 41.67]; // [x_min, x_max, z_min, z_max]

// IO shield retention groove - real, measured geometry (collar + widened
// snap pocket, see README). Widen is independent per side; PX is reduced
// from the real 3.25mm to clear the front panel's own edge.
FRONT_PANEL_IO_COLLAR_DEPTH = 1.51;
FRONT_PANEL_IO_GROOVE_WIDEN_NX = 3.25;
FRONT_PANEL_IO_GROOVE_WIDEN_PX = 1.25;
FRONT_PANEL_IO_GROOVE_WIDEN_NZ = 3.25;
FRONT_PANEL_IO_GROOVE_WIDEN_PZ = 3.25;

// Top corner screws (M3 + countersink) and their shell-mating tab slots.
FRONT_PANEL_SCREW_X_INSET = 3.0;
FRONT_PANEL_SCREW_Z_INSET = 3.0;
FRONT_PANEL_SCREW_R       = 1.5;
FRONT_PANEL_SCREW_CS_DIA   = 6.4;
FRONT_PANEL_SCREW_CS_ANGLE = 90;

// Tab slot cut into the panel's inside face at each corner screw - the
// eventual shell's own tab slides in here, same screw clamps both. See README.
FRONT_PANEL_TAB_SLOT_W     = 7.;
FRONT_PANEL_TAB_SLOT_H     = 7;
FRONT_PANEL_TAB_SLOT_DEPTH = 3;

// Clearance shaft + front-face countersink through the front panel's Y
// thickness, plus an optional shell-mating tab slot on the inside face
// (tab_w = 0 skips it) - see FRONT_PANEL_TAB_SLOT_* for the slot's role.
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

// Divider plate lightening/vent pattern, cut through the plate's own Z
// thickness. SPINE_LIGHTENING_MODE = "honeycomb" or "diamond" - see README
// for the tradeoffs. (A plain axis-aligned "grid" mode was tried and
// dropped - needed print supports in this part's real print orientation.)
SPINE_LIGHTENING_MODE = "diamond";
// Where the pattern stops, independent per side (PX/NX/NY = taper edges,
// PY = the plain +Y edge) - real limits, no shared floor, can go to 0 or
// negative. A plain axis-aligned box, not an outline offset() - see README
// ("Divider plate lightening pattern") for why that distinction matters.
SPINE_LIGHTENING_MARGIN_PX = 8;
SPINE_LIGHTENING_MARGIN_NX = 3;
SPINE_LIGHTENING_MARGIN_PY = 0;
SPINE_LIGHTENING_MARGIN_NY = 14;
// 16, 16, 18, 22

// Every MB/HDD/GaN standoff + print-support ramp gets its own real
// footprint tested per-cell (see standoff_lightening_protect()), left
// un-cut (solid) if a cell overlaps it - not a blanket keepout circle. This
// tolerance shifts that test: 0 = protect a cell as soon as it could touch
// the footprint at all; positive tolerates that many mm of encroachment
// first (e.g. a fraction-of-a-mm sliver you don't care about); negative
// protects even on near-misses. See README ("Divider plate lightening
// pattern").
SPINE_LIGHTENING_STANDOFF_PROTECT_FUDGE = 0.3;
SPINE_HONEYCOMB_HEX_R  = 4;
SPINE_HONEYCOMB_WALL   = 1.4;
// "diamond" mode's own cell size - a square grid (grid_2d()) rotated 45deg
SPINE_GRID_SLOT_W = 8;
SPINE_GRID_SLOT_H = 8;
SPINE_GRID_WALL   = 2.5;

// HDD ventilation grill (front panel), honeycomb sized around the HDD's own
// footprint with 4 independent margins. See README.
HDD_GRILL_MARGIN_LEFT   = 4;
HDD_GRILL_MARGIN_RIGHT  = 5.2;
HDD_GRILL_MARGIN_TOP    = 6;
HDD_GRILL_MARGIN_BOTTOM = 0;
HDD_GRILL_HEX_R  = 4;
HDD_GRILL_WALL   = 1.2;

// Guard wedge cut out of the HDD grill pattern near the +X/-Z corner screw
// so it keeps solid material regardless of where the hex tiling lands.
FRONT_PANEL_CORNER_INFILL_X = 13;
FRONT_PANEL_CORNER_INFILL_Z = 13;

// Distance from world point wp to the nearest edge of a protected-footprint
// set - circles as [x,y,r], axis-aligned rects as [x_min,y_min,x_max,y_max]
// - 0 if wp is inside one of them. Used by grid_2d()/honeycomb_2d() below to
// decide, per cell, whether that cell overlaps something that must stay
// solid (e.g. a standoff + its print-support ramp) - see README.
function lightening_protect_dist(wp, protect_pts, protect_rects) =
    min(concat(
        [for (c = protect_pts) max(norm([wp[0] - c[0], wp[1] - c[1]]) - c[2], 0)],
        [for (r = protect_rects)
            norm([max(r[0] - wp[0], wp[0] - r[2], 0), max(r[1] - wp[1], wp[1] - r[3], 0)])],
        [1e9]
    ));

// One part's standoffs + print-support ramps, as world-space footprints for
// the per-cell test above - [protect_pts, protect_rects], ready to concat
// across parts. Drops any standoff whose whole footprint already falls
// outside the margin box (nx/px/ny_limit) on one side - already guaranteed
// solid by the flat margin there, so the per-cell test doesn't need it too.
// See README ("Divider plate lightening pattern").
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

// A field of regular hexagons (2D, centered at the origin) tiling a [w,h]
// rectangle, clipped to a clean straight border. Wall thickness between
// cells comes out uniform by tiling on an enlarged "virtual" hex radius
// (r_tile) and cutting the smaller real hex (hex_r) inside each tile: for
// two hexagons sharing a tiling edge, shrinking each one's apothem by half
// the wall thickness opens a gap of exactly `wall` between them everywhere,
// not just along one axis.
// protect_pts/protect_rects (world-space, see lightening_protect_dist()
// above) mark cells to leave un-cut (solid) instead of generated - only
// meaningful together with world_rot/world_translate, this shape's own
// placement transform, needed to map each cell's local center into the
// same world space the protect data is given in. protect_fudge shifts the
// overlap threshold: 0 = protect as soon as a cell's guaranteed-solid
// interior (its apothem) could touch the footprint; positive tolerates
// that much encroachment before bothering to protect; negative protects
// even on near-misses. Defaults leave this exactly as a plain tiling.
module honeycomb_2d(w, h, hex_r, wall, protect_pts=[], protect_rects=[], protect_fudge=0, world_rot=0, world_translate=[0,0]) {
    r_tile = hex_r + wall / sqrt(3);
    pitch_x = 1.5 * r_tile;      // column spacing
    pitch_y = sqrt(3) * r_tile;  // row spacing
    n_cols = ceil(w / pitch_x) + 2;
    n_rows = ceil(h / pitch_y) + 2;
    apothem = hex_r * cos(30);
    intersection() {
        union() {
            // circle($fn=6) at angle 0 gives a flat-top/bottom hex (pointy
            // left/right) - that orientation tiles with alternating COLUMNS
            // offset vertically by half a row, not alternating rows offset
            // horizontally (which is the other hex orientation's tiling).
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

// A plain rectangular grid of square cells (2D, centered at the origin)
// tiling a [w,h] rectangle, clipped to a clean straight border - used
// rotated 45deg for the "diamond" SPINE_LIGHTENING_MODE. Same
// clipped-tiling structure as honeycomb_2d() above, just square cells on a
// square pitch instead of hexagons, and no r_tile trick needed since a
// square grid's wall thickness is already uniform on a plain
// (slot_w+wall) pitch.
// protect_pts/protect_rects/protect_fudge/world_rot/world_translate - see
// honeycomb_2d() above, same meaning.
module grid_2d(w, h, slot_w, slot_h, wall, protect_pts=[], protect_rects=[], protect_fudge=0, world_rot=0, world_translate=[0,0]) {
    pitch_x = slot_w + wall;
    pitch_y = slot_h + wall;
    n_cols = ceil(w / pitch_x) + 1;
    n_rows = ceil(h / pitch_y) + 1;
    apothem = min(slot_w, slot_h) / 2;
    intersection() {
        union() {
            for (i = [-n_cols : n_cols]) {
                for (j = [-n_rows : n_rows]) {
                    x = i * pitch_x;
                    y = j * pitch_y;
                    wp = [cos(world_rot)*x - sin(world_rot)*y, sin(world_rot)*x + cos(world_rot)*y] + world_translate;
                    if (lightening_protect_dist(wp, protect_pts, protect_rects) >= apothem - protect_fudge) {
                        translate([x, y])
                            square([slot_w, slot_h], center = true);
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

        // lower corner case-mounting screws, same treatment as the upper panel's
        corner_screw_xs = [x_min + FRONT_PANEL_SCREW_X_INSET, x_max - FRONT_PANEL_SCREW_X_INSET];
        corner_screw_z = z_min + FRONT_PANEL_SCREW_Z_INSET;

        grill_x_min = HDD_POS[0] - HDD_SIZE[0]/2 - HDD_GRILL_MARGIN_LEFT;
        grill_x_max = HDD_POS[0] + HDD_SIZE[0]/2 + HDD_GRILL_MARGIN_RIGHT;
        grill_z_min = HDD_POS[2] - HDD_SIZE[2]/2 - HDD_GRILL_MARGIN_BOTTOM;
        grill_z_max = HDD_POS[2] + HDD_SIZE[2]/2 + HDD_GRILL_MARGIN_TOP;
        grill_w = grill_x_max - grill_x_min;
        grill_h = grill_z_max - grill_z_min;
        grill_x = (grill_x_min + grill_x_max) / 2;
        grill_z = (grill_z_min + grill_z_max) / 2;

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, z_min])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, plate_top - z_min]);
                // GaN PSU power cable opening
                translate([cable_x - cable_w/2, -FRONT_PANEL_THICKNESS - 1, cable_z - cable_h/2])
                    cube([cable_w, FRONT_PANEL_THICKNESS + 2, cable_h]);
                // GaN PSU front-mounting screws
                for (p = mount_pts) {
                    panel_screw_hole(p[0], p[1], GAN_FRONT_MOUNT_R,
                        GAN_FRONT_MOUNT_CS_DIA, GAN_FRONT_MOUNT_CS_ANGLE);
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
                                honeycomb_2d(grill_w, grill_h, HDD_GRILL_HEX_R, HDD_GRILL_WALL);
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

// Wireframe cage (12 edge rods, no faces) - can't occlude anything in Preview
// or Render, sidestepping OpenSCAD's transparency-through-boolean limitation.
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

// Local [x,y] hole points (e.g. MB_HOLES/HDD_HOLES/GAN_PSU_HOLES), rotated
// by rot_z and offset by pos - the recurring "world coordinate of a part's
// own hole spec" computation used throughout standoffs()/new_spine().
function world_holes(pos, local_pts, rot_z) =
    [for (p = local_pts) let(wc = rot2d(p, rot_z)) [pos[0] + wc[0], pos[1] + wc[1]]];

function countersink_depth(r, cs_dia, cs_angle) = (cs_dia/2 - r) / tan(cs_angle/2);

// Real (taper-aware) plate edge X at a given world Y - keep in sync with
// plate_outline in new_spine(). Used to anchor the wedges. See README.
function spine_plate_px_edge(y) =
    let(
        full  = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2,
        narrow = full - SPINE_PLATE_TAPER_PX_DEPTH,
        y_max = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2,
        y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_PX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_PX_RUN,
        bbe = y_min + SPINE_PLATE_TAPER_PX_BEFORE,
        bte = bbe + SPINE_PLATE_TAPER_PX_RUN
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
        y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_NX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_NX_RUN,
        bbe = y_min + SPINE_PLATE_TAPER_NX_BEFORE,
        bte = bbe + SPINE_PLATE_TAPER_NX_RUN
    )
    (y > fbe) ? full :
    (y > fte) ? full + (narrow - full) * (fbe - y) / SPINE_PLATE_TAPER_NX_RUN :
    (y > bte) ? narrow :
    (y > bbe) ? full + (narrow - full) * (y - bbe) / SPINE_PLATE_TAPER_NX_RUN :
    full;

// spine_plate_nx_edge() above, shifted by `margin` into an explicit
// polyline following the taper's real shape (not a flat line) - see
// README. y_pad extends past the plate's real Y extent so callers can
// safely intersect this against a taller/shorter box.
function spine_plate_nx_edge_points(margin, y_pad = 50) =
    let(
        y_max = SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2,
        y_min = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
        fbe = y_max - SPINE_PLATE_TAPER_NX_BEFORE,
        fte = fbe - SPINE_PLATE_TAPER_NX_RUN,
        bbe = y_min + SPINE_PLATE_TAPER_NX_BEFORE,
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

// The plate's real (taper-aware) outline polygon, in new_spine()'s own
// point order - kept in sync with spine_plate_px_edge()/nx_edge() above.
// Pulled out of new_spine() so the outline shape can be read on its own.
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
        back_taper_start_y = plate_y_min + SPINE_PLATE_TAPER_PX_BEFORE,
        back_taper_end_y   = back_taper_start_y + SPINE_PLATE_TAPER_PX_RUN,
        ny_narrow_y = plate_y_min + SPINE_PLATE_TAPER_NY_DEPTH,
        ny_taper_left_start_x  = plate_x_min + SPINE_PLATE_TAPER_NY_BEFORE,
        ny_taper_left_end_x    = ny_taper_left_start_x + SPINE_PLATE_TAPER_NY_RUN,
        ny_taper_right_start_x = front_x_max - SPINE_PLATE_TAPER_NY_BEFORE,
        ny_taper_right_end_x   = ny_taper_right_start_x - SPINE_PLATE_TAPER_NY_RUN,
        nx_inset_x = plate_x_min + SPINE_PLATE_TAPER_NX_DEPTH,
        nx_taper_front_start_y = plate_y_max - SPINE_PLATE_TAPER_NX_BEFORE,
        nx_taper_front_end_y   = nx_taper_front_start_y - SPINE_PLATE_TAPER_NX_RUN,
        nx_taper_back_start_y  = plate_y_min + SPINE_PLATE_TAPER_NX_BEFORE,
        nx_taper_back_end_y    = nx_taper_back_start_y + SPINE_PLATE_TAPER_NX_RUN
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

// Drift/connectivity self-checks for the taper DEPTHs above - see README
// ("Divider plate position, size, and taper shape") for what each guards
// against. Kept separate from spine_plate_outline() so the shape and its
// warnings can be read independently.
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
    gan_world_ys  = [for (wp = world_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2])) wp[1]];
    gan_y_min_edge = min(gan_world_ys) - STANDOFF_R;
    ny_narrow_y = plate_y_min + SPINE_PLATE_TAPER_NY_DEPTH;
    if (abs(ny_narrow_y - gan_y_min_edge) > 0.01) {
        echo(str("WARNING: SPINE_PLATE_TAPER_NY_DEPTH (", SPINE_PLATE_TAPER_NY_DEPTH,
            ") no longer matches the flush-with-GaN-standoffs depth (gan_y_min_edge = ", gan_y_min_edge,
            ", would need NY_DEPTH = ", gan_y_min_edge - plate_y_min,
            ") - the -Y taper's waist is no longer flush with the GaN PSU standoffs."));
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

// Clamps an upper wedge's Z1 below the IO groove's real Z-range, only if
// the wedge's X-range overlaps the groove's. Returns z2 (degenerate/zero
// height) if there's no room left - caller skips building it in that case.
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

// 45deg print-support ramp fused to a standoff's +Y side, see README (Print
// orientation). hull() blends the round peg into a flat, constant-width
// (2r) bar, then a 2nd hull tapers that bar's height down to flush with the
// plate over `run`. Sharp corners throughout.
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

// Standoffs at [x,y] local hole points, each with a drilled through-hole
// and a +Y ramp. z_from is always the plate-contact end.
module standoffs(pos, local_pts, rot_z, r, hole_r, z_from, z_to) {
    h = abs(z_to - z_from);
    run = h * STANDOFF_RAMP_RUN_FACTOR;
    zmin = min(z_from, z_to);
    for (wp = world_holes(pos, local_pts, rot_z)) {
        wx = wp[0];
        wy = wp[1];
        difference() {
            union() {
                translate([wx, wy, zmin])
                    cylinder(h = h, r = r, $fn = 24);
                standoff_ramp(wx, wy, r, z_from, z_to, z_from, run);
            }
            translate([wx, wy, zmin - 0.5])
                cylinder(h = h + 1, r = hole_r, $fn = 24);
        }
    }
}

module new_spine(show, col, alpha) {
    if (show) {
        mb_bottom = MB_POS[2] - MB_SIZE[2]/2;
        hdd_top   = HDD_POS[2] + HDD_SIZE[2]/2;
        gan_top   = GAN_PSU_POS[2] + GAN_PSU_SIZE[2]/2;
        // SPINE_PLATE_MARGIN_X insets plate_w symmetrically from the plain
        // SPINE_PLATE_SIZE[0] (flush) value - plate_x doesn't need to move
        // to compensate, since a symmetric inset never shifts the center.
        plate_x   = SPINE_PLATE_POS[0];
        plate_y   = SPINE_PLATE_POS[1];
        plate_z   = SPINE_PLATE_POS[2];
        plate_w   = SPINE_PLATE_SIZE[0] - 2*SPINE_PLATE_MARGIN_X;
        plate_d   = SPINE_PLATE_SIZE[1];
        plate_t   = SPINE_PLATE_SIZE[2];
        plate_top = plate_z + plate_t/2;
        plate_bot = plate_z - plate_t/2;
        // 3 edge tapers - see README for the shape/DEPTH-warning rationale.
        // Outline shape lives in spine_plate_outline() (kept in sync with
        // spine_plate_px_edge()/nx_edge() above); drift/connectivity checks
        // live in spine_plate_taper_warnings() - see both for the rationale.
        spine_plate_taper_warnings();
        plate_outline = spine_plate_outline();

        color(col, alpha) {
            // divider plate, with HDD/GaN screw access holes drilled through
            // (screws go in from the MB side, down through the standoff bore -
            // see README) at the same positions/rotations as their standoffs.
            gan_cs_depth = countersink_depth(GAN_STANDOFF_HOLE_R, GAN_STANDOFF_CS_DIA, GAN_STANDOFF_CS_ANGLE);
            difference() {
                translate([0, 0, plate_z])
                    linear_extrude(height = plate_t, center = true)
                        polygon(plate_outline);
                for (wp = world_holes(HDD_POS, HDD_HOLES, HDD_ROT[2])) {
                    wx = wp[0];
                    wy = wp[1];
                    translate([wx, wy, plate_bot - 0.5])
                        cylinder(h = plate_t + 1, r = HDD_STANDOFF_HOLE_R, $fn = 24);
                    // O-ring pocket for the screw head, MB side
                    translate([wx, wy, plate_top - HDD_ORING_POCKET_DEPTH])
                        cylinder(h = HDD_ORING_POCKET_DEPTH + 0.5, r = HDD_ORING_POCKET_DIA/2, $fn = 48);
                }
                for (wp = world_holes(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2])) {
                    wx = wp[0];
                    wy = wp[1];
                    translate([wx, wy, plate_bot - 0.5])
                        cylinder(h = plate_t + 1, r = GAN_STANDOFF_HOLE_R, $fn = 24);
                    translate([wx, wy, (plate_top + 0.5) - gan_cs_depth])
                        cylinder(h = gan_cs_depth, r1 = GAN_STANDOFF_HOLE_R, r2 = GAN_STANDOFF_CS_DIA/2, $fn = 48);
                }
                // Lightening/vent pattern - see SPINE_LIGHTENING_* above and
                // README ("Divider plate lightening pattern"). Axis-aligned
                // box per side (PX/PY/NY flat, NX taper-following below);
                // every MB/HDD/GaN standoff + ramp kept solid via the
                // per-cell test in grid_2d()/honeycomb_2d() below.
                lightening_px_limit = (ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2) - SPINE_LIGHTENING_MARGIN_PX;
                lightening_nx_limit = (plate_x - plate_w/2) + SPINE_LIGHTENING_MARGIN_NX;
                lightening_py_limit = (plate_y + plate_d/2) - SPINE_LIGHTENING_MARGIN_PY;
                lightening_ny_limit = (plate_y - plate_d/2) + SPINE_LIGHTENING_MARGIN_NY;
                // tiling oversized to the box's own size (not plate_w/plate_d) -
                // margins can go negative, so the box is the only reliable bound
                lightening_box_w = lightening_px_limit - lightening_nx_limit;
                lightening_box_d = lightening_py_limit - lightening_ny_limit;
                // NX clip follows the real taper edge instead - see README
                lightening_nx_edge_pts = spine_plate_nx_edge_points(SPINE_LIGHTENING_MARGIN_NX);
                lightening_nx_region = concat(
                    lightening_nx_edge_pts,
                    [[100000, lightening_nx_edge_pts[len(lightening_nx_edge_pts) - 1][1]],
                     [100000, lightening_nx_edge_pts[0][1]]]
                );
                lightening_box_center = [(lightening_nx_limit + lightening_px_limit)/2, (lightening_ny_limit + lightening_py_limit)/2];
                // see standoff_lightening_protect() above
                mb_lightening_protect = standoff_lightening_protect(MB_POS, MB_HOLES, MB_ROT[2], STANDOFF_R, plate_top, mb_bottom,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                hdd_lightening_protect = standoff_lightening_protect(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, plate_bot, hdd_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                gan_lightening_protect = standoff_lightening_protect(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], STANDOFF_R, plate_bot, gan_top,
                    lightening_nx_limit, lightening_px_limit, lightening_ny_limit, lightening_py_limit);
                lightening_protect_pts = concat(mb_lightening_protect[0], hdd_lightening_protect[0], gan_lightening_protect[0]);
                lightening_protect_rects = concat(mb_lightening_protect[1], hdd_lightening_protect[1], gan_lightening_protect[1]);
                translate([0, 0, plate_bot - 0.5])
                    linear_extrude(height = plate_t + 1)
                        intersection() {
                            translate(lightening_box_center)
                                square([lightening_box_w, lightening_box_d], center = true);
                            polygon(lightening_nx_region);
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
                                            45, lightening_box_center);
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

            // HDD standoffs, plus the 2nd O-ring pocket (standoff-to-HDD side)
            difference() {
                standoffs(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, HDD_STANDOFF_HOLE_R, plate_bot, hdd_top);
                for (wp = world_holes(HDD_POS, HDD_HOLES, HDD_ROT[2])) {
                    wx = wp[0];
                    wy = wp[1];
                    translate([wx, wy, hdd_top - 0.5])
                        cylinder(h = HDD_ORING_POCKET_DEPTH + 0.5, r = HDD_ORING_POCKET_DIA/2, $fn = 48);
                }
            }

            // GaN PSU standoffs
            standoffs(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], STANDOFF_R, GAN_STANDOFF_HOLE_R, plate_bot, gan_top);

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
labeled_box(ODD_SIZE, ODD_POS, ODD_ROT, SHOW_ODD, "Cyan");
labeled_box(GAN_PSU_SIZE, GAN_PSU_POS, GAN_PSU_ROT, SHOW_GAN_PSU, "Black");
