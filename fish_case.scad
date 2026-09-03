// Fish Case - ITX layout study
// Reference geometry (import only, not part of the solid model yet):
//   4.7-Fish_-_spine.stl  bbox: X 109.3 x Y 198.0 x Z 222.7 mm
// All part boxes share the STL's native coordinate system, so pos/rot
// below are offsets from that origin - dial them in against the spine.

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
// ~200 x 200 mm footprint, height TBD as the build develops.
ENCLOSURE_SIZE = [176, 178, 85];   // [W, D, H] - H is the free variable
// Accounts for wall thickness of outer case, which will be 2mm in each dimension. There is an open face to the case, in +Y direction, hence only a single 2mm allowance.
ENCLOSURE_POS  = [5, -90, 18];
ENCLOSURE_ROT  = [0, 0, 0];
ENCLOSURE_EDGE_R = 1.0;             // wireframe rod radius

/* ---------- motherboard ---------- */
MB_SIZE = [170, 170, 38];           // existing screw holes assumed on this footprint
//MB_POS  = [2, -90, 38.66];
MB_POS  = [2, -90, 34.6];
MB_ROT  = [0, 0, 0];

/* ---------- HDD (replaces GPU) ---------- */
// Standard 3.5" HDD envelope (damping/grommet screw mount): 101.6 x 146.99 x 26.11 mm
HDD_SIZE = [101.6, 146.99, 26.11]; // [W, D, H]
HDD_POS  = [35, -75, -9.98]; // Z lowered 0.98mm from -9 to lengthen the HDD standoff gap to fit a standard 6-32 x 3/8" screw - see HDD_ORING_POCKET_DEPTH comment
HDD_ROT  = [0, 0, 0];

/* ---------- ODD (slim internal Blu-ray drive) ---------- */
// Slim slot-load internal BD writer envelope (e.g. Panasonic UJ-265): 128 x 129 x 12.7 mm
ODD_SIZE = [128, 129, 12.7];        // [W, D, H]
ODD_POS  = [30, -70, -50];
ODD_ROT  = [0, 0, 0];

/* ---------- GaN PSU (HDPLEX 250W GaN AIO ATX) ---------- */
// HDPLEX-listed envelope: 170 (D) x 55 (W) x 25 (H) mm
GAN_PSU_SIZE = [170, 55, 25];       // [D, W, H]
GAN_PSU_POS  = [-53+5, -88, -10];
GAN_PSU_ROT  = [0, 0, 90];

/* ---------- new spine (sandwich-layout divider, per the printables.com design) ---------- */
// Source design: "4.7L Mini ITX case, easily printable (2 major pieces)"
// https://www.printables.com/model/143897 - a spine + outer shell, MB standoffs
// on one face, GPU/PSU mounting on the other. Here the spine is a horizontal
// divider plate sitting in the gap between the MB (above) and the HDD + GaN
// PSU (below): standoffs rise to the MB, and hang down to the HDD/PSU.
// X/Y position and rotation are NOT independent params like the other parts -
// the plate footprint and its standoffs' X/Y positions are derived from
// MB_POS/HDD_POS/GAN_PSU_POS above so they stay keyed to whatever those are
// set to. Assumes those parts are only rotated about Z (true for the
// current layout). Z height is the one exception: SPINE_PLATE_Z below is a
// fixed, independent value rather than derived from the parts' Z positions,
// so raising/lowering the HDD or GaN PSU only shortens/lengthens their own
// standoffs instead of dragging the whole plate (and MB standoffs) with
// them. Move the plate itself by editing SPINE_PLATE_Z directly.
SPINE_PLATE_Z   = 8.1; // fixed plate mid-height - matches the layout's original derived position (see history)
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
// flip HDD_ROT by 180 about Z if that's backwards for your orientation.
HDD_HOLE_X_INSET  = 3.18;   // SFF-8301 A5
HDD_HOLE_Y_FRONT  = 41.28;  // SFF-8301 A7 (required)
HDD_HOLE_Y_REAR   = 76.20;  // SFF-8301 A13 (alternate 2nd row)
HDD_HOLES = let(
        hx = HDD_SIZE[0]/2 - HDD_HOLE_X_INSET,
        y1 = -HDD_SIZE[1]/2 + HDD_HOLE_Y_FRONT,
        y2 = -HDD_SIZE[1]/2 + HDD_HOLE_Y_REAR
    ) [[hx,y1], [hx,y2], [-hx,y1], [-hx,y2]];
// Native HDD threads are 6-32 UNC (major dia 3.51mm) - NOT metric M3 (3mm) -
// this is a genuinely different screw from everything else in this build, now
// that a real screw actually passes through here (was just a generic
// placeholder clearance before this hole became a real pass-through).
//
// Vibration isolation: the screw is meant to touch NOTHING rigid except the
// HDD's own threads - not the plate, not the standoff. Two silicone O-rings
// (AS568-007: ID 3.68mm, OD 7.24mm, cross-section 1.78mm, 70A - real,
// catalog part, not guessed) take up the entire clamping load instead: one
// under the pan-head screw's flat underside (in a pocket cut into the
// plate's MB-side face), one under the standoff's own bottom face (in a
// matching pocket, between the standoff and the HDD's mounting boss). A
// pan/button head is required here, not a flat/countersunk one - there's no
// flat underside on a countersunk head to compress an O-ring evenly against.
// -007 was chosen over the next size up (-008) specifically because its OD
// (7.24mm) is almost fully covered by a #6 pan head's ~6.86mm (0.270") max
// diameter, so the clamping force compresses it evenly across the whole
// ring - -008's wider OD would leave ~15% of the ring's cross-section
// outside the head's reach, compressing unevenly for the part's whole
// service life. The tradeoff: -007's 3.68mm ID only just clears the screw's
// 3.51mm major diameter (0.09mm margin per side) - it has to be threaded on
// gently, not dropped on loose.
HDD_STANDOFF_HOLE_R = 2.3; // shank clearance through the plate + standoff bore - bigger than the O-ring's own ID (3.68mm/2), so the O-ring is the only thing that ever touches the screw
HDD_STANDOFF_R = 5; // wider than the shared STANDOFF_R - needs to comfortably contain the O-ring pocket (see HDD_ORING_POCKET_DIA) plus a real wall around it
HDD_ORING_OD = 7.24; // AS568-007, measured (real part, see catalog: ID 0.145in/3.68mm, OD 0.285in/7.24mm, CS 0.070in/1.78mm)
HDD_ORING_CS = 1.78;  // AS568-007 cross-section (the O-ring's own "thickness" when sitting uncompressed)
HDD_ORING_POCKET_CLEARANCE = 0.4; // extra pocket diameter beyond the O-ring's OD, for an easy (not interference) fit
HDD_ORING_POCKET_DIA   = HDD_ORING_OD + HDD_ORING_POCKET_CLEARANCE;
HDD_ORING_POCKET_DEPTH = 1.56; // ~12.5% compression of HDD_ORING_CS (target range: 10-15%, softer compression damps vibration better) - re-tune once you have the real part in hand
// Screw: 6-32 x 3/8" (9.53mm), pan/button head, ~3mm thread engagement into
// the HDD - real stack-up math, not a guess: plate (3mm) + standoff gap
// (HDD's own standoff height, see HDD_POS[2]) + engagement (3mm, WD
// SFF-8301's own minimum) = 9.53mm needed. Because the pocket depth above is
// set to exactly match the target compressed O-ring height, the screw head
// ends up flush with the plate and the peg rim never bottoms out against the
// HDD - and the compression % cancels out of this equation entirely, so 3/8"
// holds across the whole 10-15% target range, not just at 12.5% exactly.
// 3/8" was picked over the next standard sizes up/down: 5/16" leaves only
// 0.38mm of peg wall around the pocket (too thin to print reliably); 7/16"
// and larger need enough extra standoff length that the HDD gets pushed
// past the enclosure's own bottom (z_min) - see HDD_POS[2] below, which was
// lowered 0.98mm from its previous value specifically to hit this length.

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
// This entry is one of two real mounting-hole patterns tapped directly into
// the PSU's own flat body - HDPLEX documents both as compatible alternates
// (for cross-compatibility with sibling PSU models), not a better/worse
// choice:
//   - 122.3 x 43.3mm spacing, r=1.025mm (2.05mm dia, M2.5 tap drill) -
//     "same as HDPLEX 400W DCATX". NOT used here.
//   - 144 x 33.3mm spacing, r=1.25mm (2.5mm dia, M3 tap drill) - "same as
//     HDPLEX 200W ACDC and HDPLEX 400W ACDC". USED here, for hardware
//     consistency with the M3 screws used everywhere else in this build.
// This group's center sits almost exactly on the PSU body's own geometric
// center (within 1mm - the M2.5 group was off by 4mm), so the 4 positions
// below are close to a plain symmetric rectangle. Standoffs hang from the
// plate's underside down to the PSU's top face, same as MB/HDD standoffs, so
// the PSU is supported along its length instead of cantilevered off the
// front panel alone.
GAN_PSU_HOLES = [
    [ 71,  16.65],
    [-73,  16.65],
    [ 71, -16.65],
    [-73, -16.65],
];
GAN_STANDOFF_HOLE_R = 1.9; // M3 clearance (3.8mm dia) - matches STANDOFF_HOLE_R now that this is an M3 hole too
GAN_STANDOFF_CS_DIA   = 6.4; // M3 flat-head countersink diameter, same value used everywhere else in this build
GAN_STANDOFF_CS_ANGLE = 90;  // M3 flat-head countersink angle (ISO 7046)

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
//   - MB I/O rectangle (at the MB_POS/MB_SIZE in place when measured):
//     X [-67.01, 91.99], Z [16.83, 61.33] - now stored as FRONT_PANEL_IO_OFFSET,
//     an offset from the MB rather than this fixed rectangle - see there.
//
// Removed corner mounting holes - coordinates kept here in case they're
// wanted again later, as [X, Z, hole_r]:
//   [-79.41, 65.18, 1.5]  -X +Z corner - real, was copied from the STL
//   [ 89.41, 65.18, 1.5]  +X +Z corner - synthetic, mirrored (not from the STL)
// (They previously also had a 1mm reinforcement boss and an M3 countersink -
// 6.4mm dia / 90deg - removed along with the holes.)
FRONT_PANEL_TOP_Z    = 68.28;
FRONT_PANEL_THICKNESS = 5; // Y depth of the plate, front face at Y=0, back overlaps the divider plate for a clean union

// MB I/O rectangle - stored as an OFFSET from the motherboard, not a fixed
// world rectangle, so it (and the snap groove built from it, and the
// standoffs which already do this) all move together if MB_POS/MB_SIZE
// change. X is offset from MB_POS[0]; Z is offset from mb_bottom (the
// board's underside, MB_POS[2]-MB_SIZE[2]/2) rather than MB_POS[2] itself,
// since that's the real reference point the IO shield's position is tied to
// on an actual board (confirmed by measurement: the reference STL's own
// standoff top - i.e. real mb_bottom - sits within ~0.3mm of this build's
// mb_bottom, and the IO rectangle was extracted from that same STL). These
// 4 numbers are exactly [-67.01, 91.99, 16.83, 61.33] (the originally
// measured absolute rectangle) minus [MB_POS[0], MB_POS[0], mb_bottom,
// mb_bottom] at the values in place when that alignment was confirmed
// (MB_POS=[5,-90,38.66], MB_SIZE=[170,170,38] -> mb_bottom=19.66) - so
// moving MB_POS/MB_SIZE now reproduces the exact same real-world rectangle
// as before until you actually change them.
FRONT_PANEL_IO_OFFSET = [-72.01, 86.99, -2.83, 41.67]; // [x_min, x_max, z_min, z_max], relative to MB_POS[0] and mb_bottom

// IO shield retention groove - real geometry, measured (not guessed) from
// the reference spine STL. Stock ATX IO shields are stamped steel with a
// perimeter lip folded backward from the shield's flat face; the shield
// registers flush against a snug "collar" at the front of the opening, and
// that folded lip snaps into a wider pocket recessed just behind it - the
// narrower collar is what keeps the shield located and gives the snap its
// grip, same mechanism as a picture frame's rabbet.
// Measured by cross-sectioning the reference STL (projection(cut=true) at
// several fixed X and Z planes through the opening's 4 walls, using the
// same translate/rotate as spine_ref) rather than guessed: all 4 walls
// (left, right, top, bottom) show the identical two-depth step, to the
// hundredth of a mm - a flush collar for the first ~1.5mm of depth (exactly
// the nominal io[] rectangle size, see FRONT_PANEL_IO_OFFSET), then the opening widens by ~3.25mm on all 4
// sides for the remaining depth. That 3.25mm widen is a real measured value
// on 3 of 4 walls checked (the 4th read 2.75mm - most likely just a slightly
// off cut plane on that pass, not a real asymmetry - 3.25mm is used
// everywhere here for a consistent groove).
FRONT_PANEL_IO_COLLAR_DEPTH = 1.51; // Y depth of the flush collar, front face inward
FRONT_PANEL_IO_GROOVE_WIDEN = 3.25; // how much wider the pocket gets beyond the collar, per side

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

// Shell-mating tab slots - cut into the panel's INSIDE face (opposite the
// countersinks, i.e. the MB-facing back side), centered on each of the 4
// corner screw holes above. The eventual outer shell (next session) gets a
// matching tab + screw hole at each of these 4 spots, so the spine seats
// into the shell and the same screw that holds the panel together also
// clamps the shell tab in place. FRONT_PANEL_TAB_SLOT_H is deliberately
// taller than FRONT_PANEL_SCREW_Z_INSET (8mm half-height vs. a 3.5mm inset)
// so the slot always overshoots past the panel's real top/bottom edge and
// opens straight through it, rather than falling short and leaving a
// pocket with a floor - the shell's tab needs to slide in from that edge.
FRONT_PANEL_TAB_SLOT_W     = 7.1; // X width, centered on the screw hole
FRONT_PANEL_TAB_SLOT_H     = 8; // Z height, centered on the screw hole - reaches past the panel's edge on purpose
FRONT_PANEL_TAB_SLOT_DEPTH = 3; // Y depth, cut in from the inside face

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
        cs_r = FRONT_PANEL_SCREW_CS_DIA / 2;
        cs_depth = (cs_r - FRONT_PANEL_SCREW_R) / tan(FRONT_PANEL_SCREW_CS_ANGLE / 2);

        w = FRONT_PANEL_IO_GROOVE_WIDEN;

        color(col, alpha)
            difference() {
                translate([x_min, -FRONT_PANEL_THICKNESS, plate_bot])
                    cube([x_max - x_min, FRONT_PANEL_THICKNESS, FRONT_PANEL_TOP_Z - plate_bot]);
                // Collar: flush with the front face, exact nominal IO_RECT
                // size - the shield's flat face registers/seats against this.
                translate([io[0], -FRONT_PANEL_IO_COLLAR_DEPTH, io[2]])
                    cube([io[1] - io[0], FRONT_PANEL_IO_COLLAR_DEPTH + 0.5, io[3] - io[2]]);
                // Groove: beyond the collar, the pocket widens on all 4 sides
                // to receive the shield's folded retention flange - this is
                // the snap-fit groove itself. See FRONT_PANEL_IO_GROOVE_WIDEN.
                translate([io[0] - w, -FRONT_PANEL_THICKNESS - 1, io[2] - w])
                    cube([io[1] - io[0] + 2*w, FRONT_PANEL_THICKNESS + 1 - FRONT_PANEL_IO_COLLAR_DEPTH + 0.5, io[3] - io[2] + 2*w]);
                for (screw_x = screw_xs) {
                    // M3 clearance shaft, straight through
                    translate([screw_x, -FRONT_PANEL_THICKNESS - 1, screw_z])
                        rotate([-90, 0, 0])
                            cylinder(h = FRONT_PANEL_THICKNESS + 2, r = FRONT_PANEL_SCREW_R, $fn = 24);
                    // countersink at the front face
                    translate([screw_x, 0.5 - cs_depth, screw_z])
                        rotate([-90, 0, 0])
                            cylinder(h = cs_depth, r1 = FRONT_PANEL_SCREW_R, r2 = cs_r, $fn = 48);
                    // shell-mating tab slot, inside face - see FRONT_PANEL_TAB_SLOT_*
                    translate([screw_x - FRONT_PANEL_TAB_SLOT_W/2, -FRONT_PANEL_THICKNESS - 0.5, screw_z - FRONT_PANEL_TAB_SLOT_H/2])
                        cube([FRONT_PANEL_TAB_SLOT_W, FRONT_PANEL_TAB_SLOT_DEPTH + 0.5, FRONT_PANEL_TAB_SLOT_H]);
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

// HDD ventilation grill - a honeycomb of hex cutouts sized around the HDD's
// own front-face footprint (its width x height cross-section facing this
// panel: HDD_SIZE[0] x HDD_SIZE[2], unaffected by HDD_ROT since that's
// currently [0,0,0]). Each of the 4 edges is an independent margin measured
// outward from the HDD's own raw bounding box - not a single shared margin -
// so the grill boundary can be pushed around freely on any one side (e.g.
// TOP bigger than BOTTOM lets air in along more of the drive's length
// instead of just its middle).
HDD_GRILL_MARGIN_LEFT   = 4; // extra space beyond the HDD's -X edge
HDD_GRILL_MARGIN_RIGHT  = 4; // extra space beyond the HDD's +X edge
HDD_GRILL_MARGIN_TOP    = 6; // extra space beyond the HDD's +Z edge
HDD_GRILL_MARGIN_BOTTOM = 1; // extra space beyond the HDD's -Z edge
HDD_GRILL_HEX_R  = 4;   // hexagon circumradius (cell size)
HDD_GRILL_WALL   = 1.2; // wall thickness left between adjacent hex cells

// The +X -Z corner mounting screw (see corner_screw_xs/corner_screw_z
// below) sits close enough to the honeycomb grill that individual hex
// cells can land right up against its countersink/tab slot, leaving only
// a sliver of material there. This cuts a triangular wedge OUT of the
// honeycomb pattern itself (not the panel) in that corner, guaranteeing
// solid, unbroken material around the screw regardless of exactly where
// the hex tiling's cell walls happen to fall - anchored at the panel's
// real +X,-Z corner and sized comfortably larger than the screw's own tab
// slot + countersink footprint (checked: that footprint's nearest corner
// sits about 27% inside this triangle's hypotenuse, not right on the
// edge). The screw hole/countersink/tab slot are still cut in normally
// afterward, so this only ever adds material, never blocks the screw.
FRONT_PANEL_CORNER_INFILL_X = 15; // wedge reach inward from the panel's +X edge
FRONT_PANEL_CORNER_INFILL_Z = 15; // wedge reach inward from the panel's -Z edge

// A field of regular hexagons (2D, centered at the origin) tiling a [w,h]
// rectangle, clipped to a clean straight border. Wall thickness between
// cells comes out uniform by tiling on an enlarged "virtual" hex radius
// (r_tile) and cutting the smaller real hex (hex_r) inside each tile: for
// two hexagons sharing a tiling edge, shrinking each one's apothem by half
// the wall thickness opens a gap of exactly `wall` between them everywhere,
// not just along one axis.
module honeycomb_2d(w, h, hex_r, wall) {
    r_tile = hex_r + wall / sqrt(3);
    pitch_x = 1.5 * r_tile;      // column spacing
    pitch_y = sqrt(3) * r_tile;  // row spacing
    n_cols = ceil(w / pitch_x) + 2;
    n_rows = ceil(h / pitch_y) + 2;
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
                    translate([x, y])
                        circle(r = hex_r, $fn = 6);
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

        cs_r = GAN_FRONT_MOUNT_CS_DIA / 2;
        cs_depth = (cs_r - GAN_FRONT_MOUNT_R) / tan(GAN_FRONT_MOUNT_CS_ANGLE / 2);

        // Lower corner case-mounting screws (-X -Z and +X -Z) - same M3
        // clearance + countersink treatment as the upper panel's top corner
        // screws, reusing the exact same FRONT_PANEL_SCREW_* parameters (just
        // measured up from the bottom edge here instead of down from the top).
        corner_screw_xs = [x_min + FRONT_PANEL_SCREW_X_INSET, x_max - FRONT_PANEL_SCREW_X_INSET];
        corner_screw_z = z_min + FRONT_PANEL_SCREW_Z_INSET;
        corner_cs_r = FRONT_PANEL_SCREW_CS_DIA / 2;
        corner_cs_depth = (corner_cs_r - FRONT_PANEL_SCREW_R) / tan(FRONT_PANEL_SCREW_CS_ANGLE / 2);

        // HDD ventilation grill placement - 4 independent edges, each offset
        // outward from the HDD's own raw bounding box
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
                    // M3 clearance shaft, straight through
                    translate([p[0], -FRONT_PANEL_THICKNESS - 1, p[1]])
                        rotate([-90, 0, 0])
                            cylinder(h = FRONT_PANEL_THICKNESS + 2, r = GAN_FRONT_MOUNT_R, $fn = 24);
                    // countersink at the front face
                    translate([p[0], 0.5 - cs_depth, p[1]])
                        rotate([-90, 0, 0])
                            cylinder(h = cs_depth, r1 = GAN_FRONT_MOUNT_R, r2 = cs_r, $fn = 48);
                }
                // lower corner case-mounting screws
                for (screw_x = corner_screw_xs) {
                    // M3 clearance shaft, straight through
                    translate([screw_x, -FRONT_PANEL_THICKNESS - 1, corner_screw_z])
                        rotate([-90, 0, 0])
                            cylinder(h = FRONT_PANEL_THICKNESS + 2, r = FRONT_PANEL_SCREW_R, $fn = 24);
                    // countersink at the front face
                    translate([screw_x, 0.5 - corner_cs_depth, corner_screw_z])
                        rotate([-90, 0, 0])
                            cylinder(h = corner_cs_depth, r1 = FRONT_PANEL_SCREW_R, r2 = corner_cs_r, $fn = 48);
                    // shell-mating tab slot, inside face - see FRONT_PANEL_TAB_SLOT_*
                    translate([screw_x - FRONT_PANEL_TAB_SLOT_W/2, -FRONT_PANEL_THICKNESS - 0.5, corner_screw_z - FRONT_PANEL_TAB_SLOT_H/2])
                        cube([FRONT_PANEL_TAB_SLOT_W, FRONT_PANEL_TAB_SLOT_DEPTH + 0.5, FRONT_PANEL_TAB_SLOT_H]);
                }
                // HDD ventilation grill, with a solid wedge guarded out of it
                // in the +X -Z corner (see FRONT_PANEL_CORNER_INFILL_*) so the
                // nearby corner screw always has real material around it.
                // honeycomb_2d() is in its own local 2D frame, centered on
                // (grill_x, grill_z); the rotate([-90,0,0]) below flips that
                // frame's Y axis relative to world Z, so local_x = world_X -
                // grill_x but local_y = grill_z - world_Z (negated).
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

// Support ramp fused to a standoff's +Y side, like the real spine's own
// standoff bosses: full peg height right at the peg, tapering down to flush
// with the plate at world_y + r + run. Printed with the spine's +Y face down
// on the bed (build direction +Y -> -Y), this means the ramp's material
// builds up gradually layer by layer ahead of the peg's own full-height mass
// arriving, instead of the peg overhanging off the thin plate with no lead-in
// - it also just beefs up the standoff around the screw. plate_z is whichever
// end of the peg sits flush against the plate (matches the z_from arg below).
//
// Two stages, unioned:
//  1. A round-to-square BLEND right at the peg - hull() of the peg's own
//     cylinder (radius r, so it's flush with the round standoff with zero
//     gap and zero mismatch) and a square cross-section of the same "size"
//     (side = 2r, same as the peg's diameter) sitting at the peg's own +Y
//     tangent line. Because the two shapes are offset from each other along
//     Y, hull() actually blends between round and square here instead of
//     the square just swallowing the circle outright.
//  2. The flat square ramp itself, from that same square cross-section down
//     to the foot, flush with the plate further +Y - unchanged in spirit
//     from before: flat/uncurved sides, no taper in the X-Z plane.
// The hole is NOT cut here; standoffs() drills it through the peg+ramp union
// as one step, since a hole cut only in the peg would just get plugged by
// this solid ramp material where the two overlap.
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
        plate_z   = SPINE_PLATE_Z;
        plate_w   = ENCLOSURE_SIZE[0] - 2*SPINE_INSET;
        plate_d   = ENCLOSURE_SIZE[1] - 2*SPINE_INSET;
        plate_top = plate_z + SPINE_PLATE_T/2;
        plate_bot = plate_z - SPINE_PLATE_T/2;

        color(col, alpha) {
            // divider plate - the sandwich core between the MB compartment and the HDD/PSU compartment.
            // HDD/GaN standoffs hang BELOW the plate, unreachable by a screwdriver
            // once the drive/PSU are installed underneath - so unlike the MB
            // standoffs (screwed from the MB side straight down into the standoff,
            // no plate access needed), these get screwed from the MB side of the
            // plate instead: the screw passes through this plate access hole, down
            // through the standoff's own bore, and threads directly into the
            // HDD's/PSU's own tapped hole below. Drilled here (through the plate
            // only) using the exact same positions/rotations as the standoffs
            // below, so the two bores line up and form one continuous channel.
            // Countersinks are cut on the MB side (plate_top). GaN PSU keeps
            // its M3/90deg flat-head countersink (GAN_STANDOFF_CS_*). HDD is
            // different: a pan-head screw + silicone O-ring instead of a
            // flat-head + countersink (see HDD_ORING_* above for why) - so
            // instead of a cone, it gets a straight cylindrical pocket sized
            // to seat that O-ring, with the screw's flat underside pressing
            // straight down on it.
            gan_cs_depth = (GAN_STANDOFF_CS_DIA/2 - GAN_STANDOFF_HOLE_R) / tan(GAN_STANDOFF_CS_ANGLE / 2);
            difference() {
                translate([ENCLOSURE_POS[0], ENCLOSURE_POS[1], plate_z])
                    cube([plate_w, plate_d, SPINE_PLATE_T], center = true);
                for (p = HDD_HOLES) {
                    wc = rot2d(p, HDD_ROT[2]);
                    wx = HDD_POS[0] + wc[0];
                    wy = HDD_POS[1] + wc[1];
                    translate([wx, wy, plate_bot - 0.5])
                        cylinder(h = SPINE_PLATE_T + 1, r = HDD_STANDOFF_HOLE_R, $fn = 24);
                    // O-ring pocket for the screw head, MB side
                    translate([wx, wy, plate_top - HDD_ORING_POCKET_DEPTH])
                        cylinder(h = HDD_ORING_POCKET_DEPTH + 0.5, r = HDD_ORING_POCKET_DIA/2, $fn = 48);
                }
                for (p = GAN_PSU_HOLES) {
                    wc = rot2d(p, GAN_PSU_ROT[2]);
                    wx = GAN_PSU_POS[0] + wc[0];
                    wy = GAN_PSU_POS[1] + wc[1];
                    translate([wx, wy, plate_bot - 0.5])
                        cylinder(h = SPINE_PLATE_T + 1, r = GAN_STANDOFF_HOLE_R, $fn = 24);
                    translate([wx, wy, (plate_top + 0.5) - gan_cs_depth])
                        cylinder(h = gan_cs_depth, r1 = GAN_STANDOFF_HOLE_R, r2 = GAN_STANDOFF_CS_DIA/2, $fn = 48);
                }
            }

            // motherboard standoffs - rise from the plate's top face up to the MB
            standoffs(MB_POS, MB_HOLES, MB_ROT[2], STANDOFF_R, STANDOFF_HOLE_R, plate_top, mb_bottom);

            // HDD standoffs - hang from the plate's underside down to the HDD.
            // Wrapped in an extra difference() here (not inside standoffs()
            // itself, which is shared with MB/GaN) to cut a matching O-ring
            // pocket into each standoff's own bottom face - the second of
            // the two isolation points, between the standoff and the HDD's
            // mounting boss. HDD_STANDOFF_R (not the shared STANDOFF_R) is
            // used here since the peg needs to be wide enough to actually
            // contain that pocket plus a real wall around it.
            difference() {
                standoffs(HDD_POS, HDD_HOLES, HDD_ROT[2], HDD_STANDOFF_R, HDD_STANDOFF_HOLE_R, plate_bot, hdd_top);
                for (p = HDD_HOLES) {
                    wc = rot2d(p, HDD_ROT[2]);
                    wx = HDD_POS[0] + wc[0];
                    wy = HDD_POS[1] + wc[1];
                    translate([wx, wy, hdd_top - 0.5])
                        cylinder(h = HDD_ORING_POCKET_DEPTH + 0.5, r = HDD_ORING_POCKET_DIA/2, $fn = 48);
                }
            }

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
labeled_box(ODD_SIZE, ODD_POS, ODD_ROT, SHOW_ODD, "Cyan");
labeled_box(GAN_PSU_SIZE, GAN_PSU_POS, GAN_PSU_ROT, SHOW_GAN_PSU, "Black");
