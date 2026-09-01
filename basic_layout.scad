// Fish Case - ITX layout study
// Reference geometry (import only, not part of the solid model yet):
//   4.7-Fish_-_spine.stl  bbox: X 109.3 x Y 198.0 x Z 222.7 mm
// All part boxes share the STL's native coordinate system, so pos/rot
// below are offsets from that origin - dial them in against the spine.

/* ---------- global toggles ---------- */
SHOW_SPINE      = true;
SHOW_ENCLOSURE  = true;
SHOW_MB         = true;
SHOW_HDD        = true;
SHOW_PSU        = false;
SHOW_ODD        = false;
SHOW_GAN_PSU    = true;

SPINE_ALPHA     = 0.25;
ENCLOSURE_ALPHA = 0.55;

/* ---------- enclosure (outer volume budget) ---------- */
// ~200 x 200 mm footprint, height TBD as the build develops.
ENCLOSURE_SIZE = [178, 176, 85];   // [W, D, H] - H is the free variable
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

enclosure_ref(ENCLOSURE_SIZE, ENCLOSURE_POS, ENCLOSURE_ROT, SHOW_ENCLOSURE, "Gray", ENCLOSURE_ALPHA, ENCLOSURE_EDGE_R);

labeled_box(MB_SIZE,  MB_POS,  MB_ROT,  SHOW_MB,  "Blue");
labeled_box(HDD_SIZE, HDD_POS, HDD_ROT, SHOW_HDD, "Red");
labeled_box(PSU_SIZE, PSU_POS, PSU_ROT, SHOW_PSU, "Green");
labeled_box(ODD_SIZE, ODD_POS, ODD_ROT, SHOW_ODD, "Cyan");
labeled_box(GAN_PSU_SIZE, GAN_PSU_POS, GAN_PSU_ROT, SHOW_GAN_PSU, "Black");
