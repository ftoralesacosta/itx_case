// Fish Case - ITX layout study
// Reference geometry (import only, not part of the solid model yet):
//   4.7-Fish_-_spine.stl  bbox: X 109.3 x Y 198.0 x Z 222.7 mm
// All part boxes share the STL's native coordinate system, so pos/rot
// below are offsets from that origin - dial them in against the spine.

/* ---------- global toggles ---------- */
SHOW_SPINE      = false;            // original reference STL
SHOW_ENCLOSURE  = false;
SHOW_PSU        = false;
SHOW_ODD        = false;

SHOW_MB         = true;
SHOW_HDD        = true;
SHOW_GAN_PSU    = true;


SHOW_NEW_SPINE  = true;
SHOW_FRONT_PANEL = true;   // upper (MB-side) portion of the spine's front I/O panel, copied from the STL
SHOW_FRONT_PANEL_LOWER = true; // lower (HDD/GaN PSU-side) portion - simple flat plate, PSU cable opening + mount screws

SPINE_ALPHA     = 0.25;
ENCLOSURE_ALPHA = 0.55;

/* ---------- enclosure (outer volume budget) ---------- */
// ~200 x 200 mm footprint, height TBD as the build develops.
ENCLOSURE_SIZE = [180, 180, 85];   // [W, D, H] - H is the free variable
ENCLOSURE_POS  = [5, -90, 18];
ENCLOSURE_ROT  = [0, 0, 0];
ENCLOSURE_EDGE_R = 1.0;             // wireframe rod radius

/* ---------- motherboard ---------- */
MB_SIZE = [170, 170, 38];           // existing screw holes assumed on this footprint
MB_POS  = [5, -90, 39];
MB_ROT  = [0, 0, 0];

/* ---------- HDD (replaces GPU) ---------- */
// Standard 3.5" HDD envelope (damping/grommet screw mount): 101.6 x 146.99 x 26.11 mm
HDD_SIZE = [101.6, 146.99, 26.11]; // [W, D, H]
HDD_POS  = [35, -75, -9];
HDD_ROT  = [0, 0, 0];

/* ---------- PSU (Flex ATX) ---------- */
// FlexATX standard envelope: 150 (L) x 81.5 (W) x 40.5 (H) mm
// Power inlet side faces where the GPU I/O slots currently sit.
PSU_SIZE = [150, 81.5, 40.5];       // [L, W, H]
PSU_POS  = [-59, -75, -35];
PSU_ROT  = [90, 0, 90];

/* ---------- ODD (slim internal Blu-ray drive) ---------- */
// Slim slot-load internal BD writer envelope (e.g. Panasonic UJ-265): 128 x 129 x 12.7 mm
ODD_SIZE = [128, 129, 12.7];        // [W, D, H]
ODD_POS  = [30, -70, -50];
ODD_ROT  = [0, 0, 0];

/* ---------- GaN PSU (HDPLEX 250W GaN AIO ATX) ---------- */
// HDPLEX-listed envelope: 170 (D) x 55 (W) x 25 (H) mm
GAN_PSU_SIZE = [170, 55, 25];       // [D, W, H]
GAN_PSU_POS  = [-53, -88, -10];
GAN_PSU_ROT  = [0, 0, 90];

/* ---------- new spine (sandwich-layout divider, per the printables.com design) ---------- */
// Source design: "4.7L Mini ITX case, easily printable (2 major pieces)"
// https://www.printables.com/model/143897 - a spine + outer shell, MB standoffs
// on one face, GPU/PSU mounting on the other. Here the spine is a horizontal
// divider plate sitting in the gap between the MB (above) and the HDD + GaN
// PSU (below): standoffs rise to the MB, and hang down to the HDD/PSU.
// Position/rotation are NOT independent pos/rot params like the other parts -
// the plate and its standoffs are derived from MB_POS/HDD_POS/GAN_PSU_POS
// above so it stays keyed to whatever those are set to. Assumes those parts
// are only rotated about Z (true for the current layout).
SPINE_PLATE_T   = 3;    // divider plate thickness - matches the real spine STL's own material thickness (measured)
SPINE_INSET     = 2;    // clearance from the enclosure walls so it can slide in
STANDOFF_R      = 3.5;  // mounting standoff outer radius (7mm OD, ~1.6mm wall around the hole)
STANDOFF_HOLE_R = 1.9;  // clearance hole radius - matches the 3.8mm dia modeled in the spine's own MB holes (fits M3 loosely)
STANDOFF_MARGIN = 8;    // fallback corner inset, used only where no real hole spec is known (GaN PSU)
STANDOFF_RAMP_RUN_FACTOR = 1.0; // ramp horizontal run = peg height x this (1.0 = 45 degree self-supporting slope)

// Real screw-hole patterns, as [x,y] offsets from each part's own center, before
// that part's Z rotation is applied (matches how MB_ROT/HDD_ROT/GAN_PSU_ROT work).
//
// MB: extracted directly from 4.7-Fish_-_spine.stl's own modeled mounting-hole
// geometry (the spine was designed around a real Mini-ITX board, holes and all).
// Method: projected the transformed spine to DXF (projection(cut=false), same
// translate/rotate as spine_ref below) and read exact vertex coordinates -
// found 4 finely-tessellated 3.8mm-dia circles, distinct from the diamond
// weight-reduction lattice and a separate small-hole pair elsewhere on the
// plate. 3 of the 4 sit on a clean 157.28mm grid; the 4th (the 2nd entry
// below) is pulled in ~22.9mm from where the symmetric pattern would put it -
// almost certainly CPU-socket-retention clearance. This is real, not a
// commonly-cited approximation. Offsets are relative to MB_POS.
MB_HOLES = [
    [-79.16,  75.47],
    [ 78.14,  52.57],
    [-79.13, -79.13],
    [ 78.14, -79.13],
];

// HDD: real numbers from WD's SFF-8301 bottom-mount whitepaper (verified source).
// A5=3.18mm side inset, A7=41.28mm (required row, from front/connector edge),
// A13=76.2mm (alternate 2nd row, from front edge) - non-symmetric front-to-back,
// which matches the actual spec. Assumes -Y is the drive's front/connector edge;
// flip HDD_ROT by 180 about Z if that's backwards for your orientation. Native
// HDD threads are 6-32 UNC, not metric - this hole is just bracket-side clearance
// for a grommet/screw shank, sized for M3 per your call.
HDD_HOLE_X_INSET  = 3.18;   // SFF-8301 A5
HDD_HOLE_Y_FRONT  = 41.28;  // SFF-8301 A7 (required)
HDD_HOLE_Y_REAR   = 76.20;  // SFF-8301 A13 (alternate 2nd row)
HDD_HOLES = let(
        hx = HDD_SIZE[0]/2 - HDD_HOLE_X_INSET,
        y1 = -HDD_SIZE[1]/2 + HDD_HOLE_Y_FRONT,
        y2 = -HDD_SIZE[1]/2 + HDD_HOLE_Y_REAR
    ) [[hx,y1], [hx,y2], [-hx,y1], [-hx,y2]];

// GaN PSU: REAL numbers, extracted directly from HDPLEX's own published STEP
// CAD file (hdplex.com product page -> "3D Engineer Drawing (STP) Download
// Here"), not a guess. Parsed the STEP file's CYLINDRICAL_SURFACE entities
// for hole-sized radii and traced each back to its AXIS2_PLACEMENT_3D/
// CARTESIAN_POINT for exact coordinates. That also settled two things we'd
// been guessing at:
//   - The PSU's "front mounting plate" screws are M3 (r=1.6mm / 3.2mm dia
//     clearance holes found) - confirms GAN_FRONT_MOUNT_R's choice.
//   - BUT that plate's 4 screws are spaced 177 x 35mm apart - nearly the
//     PSU's full 170mm length. It's a length-wise mounting rail, not a small
//     cap on the 55x25mm connector-end face like front_panel_lower() assumes.
//     The cable-opening cutout there is still valid; the 4 mount holes on
//     that panel are a simplified stand-in, not this real hardware.
// This entry is the OTHER pattern: real mounting holes tapped directly into
// the PSU's own flat body (M2.5, 2.05mm tap-drill holes, r=1.025mm found),
// spacing 122.3 x 43.3mm (one of two documented groups - HDPLEX calls this
// one "same as HDPLEX 400W DCATX"). Center of this hole group sits 4mm off
// the body's own geometric center along its length (real, not rounding -
// preserved rather than symmetrized). Standoffs hang from the plate's
// underside down to the PSU's top face, same as MB/HDD standoffs, so the PSU
// is supported along its length instead of cantilevered off the front panel
// alone.
GAN_PSU_HOLES = [
    [ 65.15, -21.77],
    [-57.15,  21.54],
    [ 65.15,  21.54],
    [-57.15, -21.77],
];
GAN_STANDOFF_HOLE_R = 1.4; // M2.5 clearance (2.9mm dia) - these are real M2.5 holes, unlike the shared M3 STANDOFF_HOLE_R

/* ---------- front panel (simple flat plate, MB I/O opening only) ---------- */
// Kept deliberately simple: a flat plate spanning the enclosure's X width,
// from the divider plate's bottom face up to the panel's real top edge, with
// just the MB rear-IO rectangle cut out. No corner holes, bosses, or
// countersinks right now - see the removed-features comment below if those
// need to come back.
//
// Both measured via DXF projection of the spine STL (X-Z plane, same method
// used for the MB holes):
//   - Panel top edge: Z = 68.28
//   - MB I/O rectangle: X [-67.01, 91.99], Z [16.83, 61.33]
//
// Removed corner mounting holes - coordinates kept here in case they're
// wanted again later, as [X, Z, hole_r]:
//   [-79.41, 65.18, 1.5]  -X +Z corner - real, was copied from the STL
//   [ 89.41, 65.18, 1.5]  +X +Z corner - synthetic, mirrored (not from the STL)
// (They previously also had a 1mm reinforcement boss and an M3 countersink -
// 6.4mm dia / 90deg - removed along with the holes.)
FRONT_PANEL_TOP_Z    = 68.28;
FRONT_PANEL_THICKNESS = 5; // Y depth of the plate, front face at Y=0, back overlaps the divider plate for a clean union
FRONT_PANEL_IO_RECT  = [-67.01, 91.99, 16.83, 61.33]; // [x_min, x_max, z_min, z_max]

// Top corner screw holes (-X +Z and +X +Z) - M3 clearance + countersink,
// both just plain difference() cuts (a straight cylinder for the shaft, a
// cone for the countersink), no reinforcement boss. Position is defined as
// an inset from the panel's own edges, so it's easy to retarget if the panel
// bounds change.
FRONT_PANEL_SCREW_X_INSET = 3.5;   // distance from the panel's -X/+X edges to each hole center
FRONT_PANEL_SCREW_Z_INSET = 3.5;   // distance from the panel's +Z (top) edge to each hole center
FRONT_PANEL_SCREW_R       = 1.5; // M3 clearance radius
FRONT_PANEL_SCREW_CS_DIA   = 6.4; // countersink head diameter, standard M3 flat-head value
FRONT_PANEL_SCREW_CS_ANGLE = 90;  // countersink included angle

module front_panel_upper(show, plate_bot, col, alpha) {
    if (show) {
        x_min = ENCLOSURE_POS[0] - ENCLOSURE_SIZE[0]/2;
        x_max = ENCLOSURE_POS[0] + ENCLOSURE_SIZE[0]/2;
        io = FRONT_PANEL_IO_RECT;

        screw_xs = [x_min + FRONT_PANEL_SCREW_X_INSET, x_max - FRONT_PANEL_SCREW_X_INSET];
        screw_z = FRONT_PANEL_TOP_Z - FRONT_PANEL_SCREW_Z_INSET;
        cs_r = FRONT_PANEL_SCREW_CS_DIA / 2;
        cs_depth = (cs_r - FRONT_PANEL_SCREW_R) / tan(FRONT_PANEL_SCREW_CS_ANGLE / 2);

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, plate_bot])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, FRONT_PANEL_TOP_Z - plate_bot]);
                translate([io[0], -FRONT_PANEL_THICKNESS - 1, io[2]])
                    cube([io[1] - io[0], FRONT_PANEL_THICKNESS + 2, io[3] - io[2]]);
                for (screw_x = screw_xs) {
                    // M3 clearance shaft, straight through
                    translate([screw_x, -FRONT_PANEL_THICKNESS - 1, screw_z])
                        rotate([-90, 0, 0])
                            cylinder(h = FRONT_PANEL_THICKNESS + 2, r = FRONT_PANEL_SCREW_R, $fn = 24);
                    // countersink at the front face
                    translate([screw_x, 0.5 - cs_depth, screw_z])
                        rotate([-90, 0, 0])
                            cylinder(h = cs_depth, r1 = FRONT_PANEL_SCREW_R, r2 = cs_r, $fn = 48);
                }
            }
    }
}

/* ---------- front panel, lower portion (HDD/GaN PSU side) ---------- */
// Simple flat plate, same construction as the upper panel - no STL copying
// here at all. Just a GaN PSU power-cable opening and its front-mounting
// screws; otherwise solid.
//
// The GaN PSU sits rotated 90deg about Z (GAN_PSU_ROT), so its local X (170mm,
// the PSU's own "depth") runs along world Y, and its local Y (55mm, "width")
// runs along world X - the face pointing at this panel (world +Y) is
// therefore 55mm (X) x 25mm (Z, GAN_PSU_SIZE[2], unaffected by a Z-rotation).
// Cable opening size is a placeholder (resize to the real connector).
// Mount screw positions use the same generic/unverified corner-inset
// approach as GAN_PSU_HOLES above (no verified drawing for the GaN PSU's
// "front mounting plate" either), sized to that 55x25 face instead of the
// PSU's top footprint, so both hole sets are built the same way and stay
// consistent if real numbers ever turn up.
GAN_CABLE_CUTOUT_W = 20; // power cable opening width (X)
GAN_CABLE_CUTOUT_H = 15; // power cable opening height (Z)
GAN_FRONT_MOUNT_MARGIN = 6; // corner inset for the PSU's front-mounting screws
GAN_FRONT_MOUNT_R = 1.5;    // M3 clearance - unverified size, see note below
// HDPLEX's page only documents M2.5 screws for mounting the PSU onto its own
// front plate (a different joint); no size is published for mounting that
// plate to the case, so this stays M3 for consistency with the rest of the
// build - switch to 1.25 (M2.5) here if you'd rather match the one number
// HDPLEX actually gives.
GAN_FRONT_MOUNT_CS_DIA   = 6.4; // countersink head diameter, same M3 flat-head value used elsewhere
GAN_FRONT_MOUNT_CS_ANGLE = 90;  // countersink included angle

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

        cs_r = GAN_FRONT_MOUNT_CS_DIA / 2;
        cs_depth = (cs_r - GAN_FRONT_MOUNT_R) / tan(GAN_FRONT_MOUNT_CS_ANGLE / 2);

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, z_min])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, plate_top - z_min]);
                // GaN PSU power cable opening
                translate([cable_x - cable_w/2, -FRONT_PANEL_THICKNESS - 1, cable_z - cable_h/2])
                    cube([cable_w, FRONT_PANEL_THICKNESS + 2, cable_h]);
                // GaN PSU front-mounting screws
                for (p = mount_pts) {
                    // M3 clearance shaft, straight through
                    translate([p[0], -FRONT_PANEL_THICKNESS - 1, p[1]])
                        rotate([-90, 0, 0])
                            cylinder(h = FRONT_PANEL_THICKNESS + 2, r = GAN_FRONT_MOUNT_R, $fn = 24);
                    // countersink at the front face
                    translate([p[0], 0.5 - cs_depth, p[1]])
                        rotate([-90, 0, 0])
                            cylinder(h = cs_depth, r1 = GAN_FRONT_MOUNT_R, r2 = cs_r, $fn = 48);
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

// Support ramp fused to a standoff's +Y side, like the real spine's own
// standoff bosses: full peg height right at the peg, tapering down to flush
// with the plate at world_y + r + run. Printed with the spine's +Y face down
// on the bed (build direction +Y -> -Y), this means the ramp's material
// builds up gradually layer by layer ahead of the peg's own full-height mass
// arriving, instead of the peg overhanging off the thin plate with no lead-in
// - it also just beefs up the standoff around the screw. plate_z is whichever
// end of the peg sits flush against the plate (matches the z_from arg below).
// The near end is a flat box (the peg's own bounding square, not a curved
// cylinder) so the ramp stays flat/uncurved in the X-Z plane while still
// fully overlapping the peg - no gap, no taper around the peg's curve. The
// hole is NOT cut here; standoffs() drills it through the peg+ramp union as
// one step, since a hole cut only in the peg would just get plugged by this
// solid ramp material where the two overlap.
module standoff_ramp(wx, wy, r, z_from, z_to, plate_z, run) {
    EPS = 0.02;
    h = abs(z_to - z_from);
    hull() {
        translate([wx - r, wy - r, min(z_from, z_to)])
            cube([2*r, 2*r, h]);
        translate([wx - r, wy + r + run, plate_z - EPS/2])
            cube([2*r, EPS, EPS]);
    }
}

// Standoffs at explicit [x,y] local hole points (see *_HOLES above), each
// drilled with a through-hole for the screw. rot_z handles parts placed with
// a Z-axis rotation. Spans z_from to z_to (z_from is always the plate-contact
// end - see the call sites below). Each peg gets a +Y support ramp too - peg
// and ramp are unioned first, then the hole is drilled through both at once
// so the ramp's material can't plug the hole back up.
module standoffs(pos, local_pts, rot_z, r, hole_r, z_from, z_to) {
    h = abs(z_to - z_from);
    run = h * STANDOFF_RAMP_RUN_FACTOR;
    zmin = min(z_from, z_to);
    for (p = local_pts) {
        wc = rot2d(p, rot_z);
        wx = pos[0] + wc[0];
        wy = pos[1] + wc[1];
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
        below_top = max(hdd_top, gan_top);
        plate_z   = (mb_bottom + below_top) / 2;
        plate_w   = ENCLOSURE_SIZE[0] - 2*SPINE_INSET;
        plate_d   = ENCLOSURE_SIZE[1] - 2*SPINE_INSET;
        plate_top = plate_z + SPINE_PLATE_T/2;
        plate_bot = plate_z - SPINE_PLATE_T/2;

        color(col, alpha) {
            // divider plate - the sandwich core between the MB compartment and the HDD/PSU compartment
            translate([ENCLOSURE_POS[0], ENCLOSURE_POS[1], plate_z])
                cube([plate_w, plate_d, SPINE_PLATE_T], center = true);

            // motherboard standoffs - rise from the plate's top face up to the MB
            standoffs(MB_POS, MB_HOLES, MB_ROT[2], STANDOFF_R, STANDOFF_HOLE_R, plate_top, mb_bottom);

            // HDD standoffs - hang from the plate's underside down to the HDD
            standoffs(HDD_POS, HDD_HOLES, HDD_ROT[2], STANDOFF_R, STANDOFF_HOLE_R, plate_bot, hdd_top);

            // GaN PSU standoffs - hang from the plate's underside down to the PSU, real hole pattern (see GAN_PSU_HOLES)
            standoffs(GAN_PSU_POS, GAN_PSU_HOLES, GAN_PSU_ROT[2], STANDOFF_R, GAN_STANDOFF_HOLE_R, plate_bot, gan_top);

            // front I/O panel, upper portion - copied from the spine STL, fused into the same solid
            front_panel_upper(SHOW_FRONT_PANEL, plate_bot, col, alpha);

            // front panel, lower portion - simple flat plate, GaN PSU cable + mount screws
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

spine_ref(SHOW_SPINE, [80, 0, 0], [0, -90, 0], SPINE_ALPHA);
new_spine(SHOW_NEW_SPINE, "Orange", 1);

enclosure_ref(ENCLOSURE_SIZE, ENCLOSURE_POS, ENCLOSURE_ROT, SHOW_ENCLOSURE, "Gray", ENCLOSURE_ALPHA, ENCLOSURE_EDGE_R);

labeled_box(MB_SIZE,  MB_POS,  MB_ROT,  SHOW_MB,  "Blue");
labeled_box(HDD_SIZE, HDD_POS, HDD_ROT, SHOW_HDD, "Red");
labeled_box(PSU_SIZE, PSU_POS, PSU_ROT, SHOW_PSU, "Green");
labeled_box(ODD_SIZE, ODD_POS, ODD_ROT, SHOW_ODD, "Cyan");
labeled_box(GAN_PSU_SIZE, GAN_PSU_POS, GAN_PSU_ROT, SHOW_GAN_PSU, "Black");
