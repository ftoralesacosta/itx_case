// Outer shell: a tube closed at the front (the face opposite the I/O), printed front face down.
// The I/O plate sits inside the open end and screws into bosses here. Shared model and outline: case_common.scad.
// The rear USB-C (ADT-Link UT8T board) mounts on bosses behind the closed face; the power button is on the I/O plate.
// Export: -D used_components=false -D SHOW_ASSEMBLY=false (add -D FOR_PRINT=true to lay it on the bed).
include <case_common.scad>

ASSEMBLY_PREVIEW = false;
SHELL_DRAW       = true;    // files that include this one set it false

// ---------- view ----------
SHOW_ASSEMBLY    = false;    // live spine + I/O plate (orange)
SHOW_COOLER      = true;    // CPU cooler block (drives the top grill)
SHOW_FRONT_PARTS = true;    // rear USB-C board (on SHELL_USBC_WALL) + the I/O plate's power button
SHELL_COLOR      = "SteelBlue";
SHELL_ALPHA      = 0.9;
SHELL_CUTAWAY    = "none";  // "none", "x" (drop X > SHELL_CUTAWAY_AT), "z" (drop Z > SHELL_CUTAWAY_AT)
SHELL_CUTAWAY_AT = 0;
FOR_PRINT        = false;   // front face down on the bed at z = 0

// ---------- body ----------
SHELL_FRONT_THICK          = 2.5;
SHELL_SPINE_REAR_GAP       = 0.5;  // spine rear edge -> front inner face
SHELL_FRONT_CHAMFER        = 1.0;  // 45deg on the bed edge (prints cleanly, hides elephant foot)
SHELL_OPEN_CHAMFER         = 0.5;  // outer edge at the open (I/O) end
SHELL_OPEN_INNER_CHAMFER   = 0.6;  // lead-in for the I/O plate

SHELL_OPEN_Y      = 0;  // flush with the I/O plate's outer face
SHELL_FRONT_IN_Y  = SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2 - SHELL_SPINE_REAR_GAP;
SHELL_FRONT_OUT_Y = SHELL_FRONT_IN_Y - SHELL_FRONT_THICK;
IB = shell_inner_box();  // [x0, x1, z0, z1]
OB = [IB[0] - SHELL_WALL, IB[1] + SHELL_WALL, IB[2] - SHELL_WALL, IB[3] + SHELL_WALL];
SHELL_CORNER_EXTENT = (1 + SHELL_CORNER_SMOOTHING) * SHELL_CORNER_R;  // straight walls start this far from each outer corner

// ---------- I/O plate screw bosses (same M3 x 4 x 4 insert and M3 x 10 flat head as the spine joints) ----------
SHELL_BOSS_ENABLE_UPPER = FRONT_PANEL_MOUNT_ENABLE_UPPER;  // one boss per I/O plate mount hole (case_common.scad)
SHELL_BOSS_ENABLE_LOWER = FRONT_PANEL_MOUNT_ENABLE_LOWER;
SHELL_BOSS_WALL_UPPER   = SPINE_PANEL_INSERT_WALL;
SHELL_BOSS_WALL_LOWER   = 1.4;   // thinner so the lower bosses clear the HDD as the assembly slides in
SHELL_BOSS_LEN          = SPINE_PANEL_BOSS_LEN;  // from the I/O plate's back face
SHELL_INSERT_MIN_CLEARANCE = 0.5;  // boss silhouette -> anything that slides past it

// ---------- I/O plate stop tab (top middle, where the plate has no screw) ----------
// A ledge on the inner +Z wall, flush with the boss faces: the plate's back face rests on it, so pushing on the
// top edge (plugging cables) can't bow it inward. It hangs only to SHELL_INSERT_MIN_CLEARANCE above the cooler.
SHELL_TAB_ENABLE = !FRONT_PANEL_MOUNT_ENABLE_UPPER[1];
SHELL_TAB_X      = front_panel_mount_x()[1];  // centred where the screw was
SHELL_TAB_W      = 24;    // along X
SHELL_TAB_LAND   = 1.5;   // flat contact depth (Y) before the 45deg underside runs back to the wall
SHELL_TAB_BOT_Z  = CPU_COOLER_TOP_Z + SHELL_INSERT_MIN_CLEARANCE;

// ---------- motherboard rail (-X wall): a channel the PCB edge slides along ----------
SHELL_MB_RAIL_ENABLE    = true;
SHELL_MB_RAIL_DEPTH     = 2.0;   // protrusion from the wall (+X), into the MB volume - intended
SHELL_MB_RAIL_THICK     = SPINE_RIB_THICK;
SHELL_MB_RAIL_CLEARANCE = 0.2;   // per side, PCB -> rib
SHELL_MB_RAIL_LEAD_IN   = 1.0;   // channel widens by this at the open end
SHELL_MB_RAIL_START_GAP = 0.5;   // behind the I/O plate's back face

// ---------- motherboard rail (+X wall): rear only, with a funnel ----------
// The fan headers run along the PCB's +X edge, so this rail only covers the header-free rear SHELL_MB_RAIL_PX_REACH
// of it. The front SHELL_MB_RAIL_PX_FUNNEL_LEN of that is a funnel: the channel opens by SHELL_MB_RAIL_PX_FUNNEL in Z
// each way at the mouth and narrows to the tight channel behind it, so the board's rear corner gets caught even
// when the back of the assembly is several mm high or low.
SHELL_MB_RAIL_PX_ENABLE       = true;
SHELL_MB_RAIL_PX_REACH        = 30;    // from the PCB's rear edge towards the I/O plate (measured on the board)
SHELL_MB_RAIL_PX_FUNNEL_LEN   = 15;    // front part of the reach; the rest is the tight channel
SHELL_MB_RAIL_PX_FUNNEL       = 8;     // Z opening per side at the mouth (28deg flanks at 15 long)
SHELL_MB_RAIL_PX_DEPTH        = 1.5;   // rib protrusion: ~1.3 over the PCB (edge 0.2 off the wall), 0.7 off the spine's edge

// ---------- spine nub sockets (front inner face) ----------
// A tight part at the back holds the nubs; in front of it a funnel opens by FUNNEL_Z above / below the plate and
// FUNNEL_XY round the nub outline, so the nubs find their sockets from a few mm off.
SHELL_SOCKET_DEPTH      = 4.0;   // tight part, from the front inner face (the spine's rear edge is 0.5 in front of it)
SHELL_SOCKET_FUNNEL_LEN = 5.0;   // flared mouth in front of the tight part; the mouth stays 0.5 behind the PSU's rear
SHELL_SOCKET_FUNNEL_Z   = 3.0;   // extra opening above and below the plate at the mouth
SHELL_SOCKET_FUNNEL_XY  = 1.5;   // extra opening round the nub outline at the mouth (X play is only ~0.9 total)
SHELL_SOCKET_CLEARANCE  = 0.2;   // per side
SHELL_SOCKET_WALL       = 2.0;
SHELL_SOCKET_REACH      = 15;    // X window around each nub, inboard

// ---------- feet (-X side = bottom in use) ----------
SHELL_FOOT_ENABLE    = true;
SHELL_FOOT_H         = 4.0;    // how far the foot stands off the wall
SHELL_FOOT_LEN_BASE  = 22;     // along Y, at the wall
SHELL_FOOT_LEN_TIP   = 12;     // along Y, at the tip; (BASE - TIP)/2 >= H keeps the underside >= 45deg from the bed
SHELL_FOOT_T_BASE    = 14;     // along Z, at the wall
SHELL_FOOT_T_TIP     = 10;     // along Z, at the tip
SHELL_FOOT_END_INSET = 25;     // foot centre from each end (Y)
SHELL_FOOT_Z_INSET   = 22;     // foot centre from the outer Z faces
SHELL_FOOT_Y = [SHELL_OPEN_Y - SHELL_FOOT_END_INSET, SHELL_FRONT_OUT_Y + SHELL_FOOT_END_INSET];
SHELL_FOOT_Z = [OB[2] + SHELL_FOOT_Z_INSET, OB[3] - SHELL_FOOT_Z_INSET];

// ---------- grills (diamond cells: 45deg roofs in the print orientation) ----------
SHELL_GRILL_MARGIN     = 2.0;   // solid band around keep-outs and the rounded corners
SHELL_GRILL_END_MARGIN = 4.0;   // solid band at both ends of each wall
SHELL_GRILL_BLIND_SKIN = 0.8;   // cells over the +X rail stay as blind recesses with this much wall left inside
SHELL_GRILL_FRAME      = SHELL_CORNER_EXTENT + SHELL_GRILL_MARGIN;  // solid frame round every grill: where the walls go flat
// CPU cooler: roughly centred in Y in the case (confirmed at test fit), matching the manual's layout drawing
// (MB_CPU_SOCKET_XY). The top grill covers the whole flat face, so it covers the fan here with margin.
SHELL_COOLER_POS = MB_CPU_SOCKET_XY;  // XY centre
// Full-face grill on `wall`: the flat area inset by SHELL_GRILL_FRAME on the sides; `ends` = [closed end, open end]
// insets from the outer faces along Y (ignored on "front"). Returns [enable, centre [u, v], size [u, v], cell, web, outer chamfer].
function grill_full(wall, ends, cell, web, chamfer) =
    let(f = SHELL_GRILL_FRAME,
        x = [OB[0] + f, OB[1] - f], z = [OB[2] + f, OB[3] - f],
        y = [SHELL_FRONT_OUT_Y + ends[0], SHELL_OPEN_Y - ends[1]],
        uv = wall == "front" ? [x, z] : (wall == "pz" || wall == "nz") ? [x, y] : [y, z])
    [true, [(uv[0][0] + uv[0][1])/2, (uv[1][0] + uv[1][1])/2], [uv[0][1] - uv[0][0], uv[1][1] - uv[1][0]], cell, web, chamfer];
// u/v = X/Y on the Z walls, Y/Z on the X walls, X/Z on "front". Same frame everywhere so the five faces read as one design.
// Fan face: 5 mm cells (<= FAN_PANEL_GAP). Elsewhere 8 mm cells / 1.6 webs: fewer hole contours per layer, so the
// full-face grills print in ~13.4 h / 201 g vs 15.2 h / 194 g with 5 mm cells everywhere (old small grills: 12.9 h / 247 g).
SHELL_GRILL_CELL  = 8;
SHELL_GRILL_WEB   = 1.6;
SHELL_GRILL_PZ    = grill_full("pz", [SHELL_GRILL_FRAME, SHELL_GRILL_FRAME], FAN_PANEL_GAP, 1.2, 0.4);  // fan intake: cell <= fan gap, chamfered
SHELL_GRILL_NZ    = grill_full("nz", [SHELL_GRILL_FRAME, SHELL_GRILL_FRAME], SHELL_GRILL_CELL, SHELL_GRILL_WEB, 0);
SHELL_GRILL_PX    = grill_full("px", [SHELL_GRILL_FRAME, SHELL_GRILL_FRAME], SHELL_GRILL_CELL, SHELL_GRILL_WEB, 0);
SHELL_GRILL_NX    = grill_full("nx", [SHELL_GRILL_FRAME, SHELL_GRILL_FRAME], SHELL_GRILL_CELL, SHELL_GRILL_WEB, 0);
SHELL_GRILL_FRONT = grill_full("front", [0, 0], SHELL_GRILL_CELL, SHELL_GRILL_WEB, 0);  // the closed face (the back in use); the bed face as printed

// ---------- rear USB-C: ADT-Link UTF3-FM-20P (UT8T Type-C female board -> flat ribbon -> UF6A Type-E male) ----------
// The power switch is on the I/O plate now (IO_BUTTON_* in case_common.scad).
// Wall: "front" (the closed face, opposite the I/O plate), "px", "nx", "pz" or "nz". u, v = X, Z on "front"; Y, Z on the X walls; X, Y on the Z walls.
SHELL_USBC_ENABLE       = true;
SHELL_USBC_WALL         = "front";
SHELL_USBC_POS          = [80, 47];    // [u, v] receptacle centre: towards the top (+X), above the 24-pin cable loop
SHELL_USBC_ROT          = 90;          // board on the wall: 0 = ribbon leaves towards +v; 90 = towards -u (-X here, portrait slot)
SHELL_USBC_RECESS       = 0.5;         // receptacle front behind the outer face (inside the overmold relief)
SHELL_USBC_OPENING      = [10.4, 4.2, 1.0];  // through-hole [x, y, corner r] around the receptacle (9.14 x 3.36 + a 0.43 tab at one corner)
SHELL_USBC_RELIEF       = [13, 7];     // overmold pill on the outside, same size as the I/O plate's USB-C relief
SHELL_USBC_RELIEF_DEPTH = 1.0;         // plugs still seat if the receptacle ends up to ~0.7 mm deeper than modelled
SHELL_USBC_SCREW_PITCH  = 20.0;        // the slots allow 16.5..21.5; 20 keeps the bosses 0.4 off the receptacle flange
SHELL_USBC_BOSS_D       = SPINE_PANEL_INSERT_DIA + 2*SPINE_PANEL_INSERT_WALL;  // M3 x 4 insert, same as the rest of the build
SHELL_USBC_BORE_LEN     = SPINE_PANEL_INSERT_LEN + SPINE_PANEL_INSERT_EXTRA;

// UT8T board, from ADT-Link's STEP (UT8T-UF6A). Board frame: origin = receptacle centre on the component face,
// x across the ear bar (screw slots), y along the neck (the ribbon leaves +y), z = mating side (towards the wall).
UT8T_EAR      = [27.28, 9.6];      // ear bar [x, y]
UT8T_EAR_Y0   = -3.04;             // ear bar spans y -3.04 .. +6.56
UT8T_NECK     = [13.6, 6.0];       // neck past the ear bar; the ribbon (14 wide, 1.4 thick) leaves its end
UT8T_THICK    = 1.0;
UT8T_RECEPT   = [9.14, 3.36];      // receptacle shell (plus a 0.43 side tab)
UT8T_RECEPT_H = 10.0;              // receptacle front above the component face
UT8T_FLANGE   = [12.0, 5.21];      // mid-mount flange, 0.5..2 mm above the component face
UT8T_SLOT     = [6.0, 3.5, 19.0];  // screw slots [length along x, width, centre pitch]
UT8T_BACK     = 2.6;               // receptacle tail, parts and ribbon joint behind the component face

// ===================================================================================

function _rect_gap(a, b) =  // a, b = [x0, x1, z0, z1]; negative = overlap
    let(dx = max(b[0] - a[1], a[0] - b[1]), dz = max(b[2] - a[3], a[2] - b[3]))
    (dx < 0 && dz < 0) ? max(dx, dz) : norm([max(dx, 0), max(dz, 0)]);

// ---------- bosses ----------
function shell_bosses() =  // [[x, z], r, is_upper, i]
    let(up = front_panel_mount_holes_upper(), lo = front_panel_mount_holes_lower())
    concat([for (i = [0:2]) if (SHELL_BOSS_ENABLE_UPPER[i]) [up[i], SPINE_PANEL_INSERT_DIA/2 + SHELL_BOSS_WALL_UPPER, true, i]],
           [for (i = [0:2]) if (SHELL_BOSS_ENABLE_LOWER[i]) [lo[i], SPINE_PANEL_INSERT_DIA/2 + SHELL_BOSS_WALL_LOWER, false, i]]);

// Silhouette [x0, x1, z0, z1]: the boss reaches its Z wall, and the X wall too when that is within 10 mm.
function shell_boss_box(b) =
    let(p = b[0], r = b[1],
        wz = b[2] ? IB[3] : IB[2],
        near_nx = p[0] - IB[0] < 10, near_px = IB[1] - p[0] < 10)
    [near_nx ? IB[0] : p[0] - r, near_px ? IB[1] : p[0] + r,
     b[2] ? p[1] - r : wz, b[2] ? wz : p[1] + r];

module shell_boss_2d(b) {
    p = b[0]; r = b[1]; bx = shell_boss_box(b);
    zs = b[2] ? [p[1], bx[3]] : [bx[2], p[1]];
    intersection() {
        hull() {
            translate(p) circle(r = r, $fn = 48);
            translate([bx[0], zs[0]]) square([bx[1] - bx[0], zs[1] - zs[0]]);
        }
        offset(r = SHELL_WALL/2) shell_inner_2d();
    }
}

module shell_bosses_solid() {
    y1 = -FRONT_PANEL_THICKNESS;
    y0 = y1 - SHELL_BOSS_LEN;
    for (b = shell_bosses()) {
        bx = shell_boss_box(b);
        reach = bx[3] - bx[2];
        wz = b[2] ? IB[3] : IB[2];
        xz_extrude(y0, y1) shell_boss_2d(b);
        // 45deg support under the boss in the print orientation (the open end is up)
        hull() {
            xz_extrude(y0 - 0.01, y0) shell_boss_2d(b);
            xz_extrude(y0 - reach - 0.01, y0 - reach)
                translate([bx[0], b[2] ? wz - 0.01 : wz - SHELL_WALL/2]) square([bx[1] - bx[0], SHELL_WALL/2 + 0.01]);
        }
    }
}

module shell_boss_bores() {
    y1 = -FRONT_PANEL_THICKNESS;
    for (b = shell_bosses()) {
        p = b[0];
        translate([p[0], y1 + 0.01, p[1]]) rotate([90, 0, 0]) {
            cylinder(d = SPINE_PANEL_INSERT_DIA, h = SPINE_PANEL_INSERT_LEN + SPINE_PANEL_INSERT_EXTRA, $fn = 32);
            cylinder(r = FRONT_PANEL_SCREW_R, h = SPINE_PANEL_BORE_LEN, $fn = 24);
        }
    }
}

// ---------- I/O plate stop tab ----------
// YZ profile: flat contact face at the plate's back face, a SHELL_TAB_LAND bottom, then 45deg back into the wall
// (the open end is up as printed, so the underside is a 45deg roof). Embedded 0.5 into the wall.
function shell_tab_profile() =
    let(y0 = -FRONT_PANEL_THICKNESS, zb = SHELL_TAB_BOT_Z, zt = IB[3] + 0.5, h = zt - zb)
    [[y0, zb], [y0, zt], [y0 - SHELL_TAB_LAND - h, zt], [y0 - SHELL_TAB_LAND, zb]];
function shell_tab_box() = [SHELL_TAB_X - SHELL_TAB_W/2, SHELL_TAB_X + SHELL_TAB_W/2, SHELL_TAB_BOT_Z, IB[3]];  // XZ silhouette

module shell_tab() {
    if (SHELL_TAB_ENABLE)
        translate([SHELL_TAB_X - SHELL_TAB_W/2, 0, 0]) rotate([90, 0, 90])
            linear_extrude(height = SHELL_TAB_W) polygon(shell_tab_profile());
}

// ---------- MB rail ----------
function shell_rail_z() = let(pcb_bot = MB_PCB_TOP_Z - MB_PCB_THICK)
    [[pcb_bot - SHELL_MB_RAIL_CLEARANCE - SHELL_MB_RAIL_THICK, pcb_bot - SHELL_MB_RAIL_CLEARANCE],
     [MB_PCB_TOP_Z + SHELL_MB_RAIL_CLEARANCE, MB_PCB_TOP_Z + SHELL_MB_RAIL_CLEARANCE + SHELL_MB_RAIL_THICK]];

module shell_mb_rails() {
    if (SHELL_MB_RAIL_ENABLE) {
        y_end = -(FRONT_PANEL_THICKNESS + SHELL_MB_RAIL_START_GAP);
        L = SHELL_MB_RAIL_LEAD_IN;
        x0 = IB[0] - SHELL_WALL/2;
        w = SHELL_MB_RAIL_DEPTH + SHELL_WALL/2;
        rz = shell_rail_z();
        for (k = [0, 1]) {
            z0 = rz[k][0]; z1 = rz[k][1];
            xz_extrude(SHELL_FRONT_IN_Y - 0.5, y_end - L) translate([x0, z0]) square([w, z1 - z0]);
            hull() {  // lead-in: the channel side steps back by L at the open end
                xz_extrude(y_end - L - 0.01, y_end - L) translate([x0, z0]) square([w, z1 - z0]);
                xz_extrude(y_end - 0.01, y_end) translate([x0, k == 0 ? z0 : z0 + L]) square([w, z1 - z0 - L]);
            }
        }
    }
    shell_mb_rail_px();
}

// +X rail Y stations: [back (into the front face), funnel start = end of the tight channel, mouth].
function shell_rail_px_y() = let(mouth = MB_POS[1] - MB_SIZE[1]/2 + SHELL_MB_RAIL_PX_REACH)
    [SHELL_FRONT_IN_Y - 0.5, mouth - SHELL_MB_RAIL_PX_FUNNEL_LEN, mouth];

// Rib k (0 = below the PCB, 1 = above) at Y = y: [z0, z1]. Tight behind the funnel start, then opening linearly.
function shell_rail_px_z(k, y) =
    let(ry = shell_rail_px_y(), rz = shell_rail_z()[k],
        t = min(max((y - ry[1]) / (ry[2] - ry[1]), 0), 1), dz = (k == 0 ? -1 : 1) * t * SHELL_MB_RAIL_PX_FUNNEL)
    [rz[0] + dz, rz[1] + dz];

// XZ silhouettes [y0, y1, z0, z1] of the +X rail, the funnel split into slabs (grill keep-outs, checks).
function shell_rail_px_boxes(n = 5) =
    let(ry = shell_rail_px_y(), rz = shell_rail_z())
    SHELL_MB_RAIL_PX_ENABLE ? concat(
        [for (k = [0, 1]) [ry[0], ry[1], rz[k][0], rz[k][1]]],
        [for (k = [0, 1], i = [0 : n - 1])
            let(ya = ry[1] + (ry[2] - ry[1]) * i / n, yb = ry[1] + (ry[2] - ry[1]) * (i + 1) / n,
                za = shell_rail_px_z(k, ya), zb = shell_rail_px_z(k, yb))
            [ya, yb, min(za[0], zb[0]), max(za[1], zb[1])]]) : [];

module shell_mb_rail_px() {
    if (SHELL_MB_RAIL_PX_ENABLE) {
        ry = shell_rail_px_y();
        x0 = IB[1] - SHELL_MB_RAIL_PX_DEPTH;
        w = SHELL_MB_RAIL_PX_DEPTH + SHELL_WALL/2;
        for (k = [0, 1]) {
            zt = shell_rail_px_z(k, ry[1]);
            zm = shell_rail_px_z(k, ry[2]);
            xz_extrude(ry[0], ry[1]) translate([x0, zt[0]]) square([w, zt[1] - zt[0]]);
            hull() {  // funnel flank
                xz_extrude(ry[1] - 0.01, ry[1]) translate([x0, zt[0]]) square([w, zt[1] - zt[0]]);
                xz_extrude(ry[2] - 0.01, ry[2]) translate([x0, zm[0]]) square([w, zm[1] - zm[0]]);
            }
        }
    }
}

// ---------- spine nub sockets ----------
function shell_nub_windows() = [
    [IB[0] - SHELL_WALL/2, SPINE_PLATE_NX_X + SPINE_PLATE_TAPER_NY_BEFORE + SHELL_SOCKET_REACH],
    [SPINE_PLATE_PX_X - (SPINE_PLATE_TAPER_NY2_ENABLE ? SPINE_PLATE_TAPER_NY2_AFTER : SPINE_PLATE_TAPER_NY_AFTER)
        - SHELL_SOCKET_REACH, IB[1] + SHELL_WALL/2]];

// [front inner face, end of the tight part, mouth]
function shell_socket_y() = [SHELL_FRONT_IN_Y, SHELL_FRONT_IN_Y + SHELL_SOCKET_DEPTH,
                             SHELL_FRONT_IN_Y + SHELL_SOCKET_DEPTH + SHELL_SOCKET_FUNNEL_LEN];
// Socket block Z: the funnel's mouth plus a wall above and below.
function shell_socket_z() = [SPINE_PANEL_PLATE_BOT_Z - SHELL_SOCKET_CLEARANCE - SHELL_SOCKET_FUNNEL_Z - SHELL_SOCKET_WALL,
                             SPINE_PANEL_PLATE_TOP_Z + SHELL_SOCKET_CLEARANCE + SHELL_SOCKET_FUNNEL_Z + SHELL_SOCKET_WALL];

// Thin slice of the nub slot at Y = y inside window w, grown by g (XY) and gz (Z). Convex (one interval per window),
// so a hull of two slices is the funnel between them.
module shell_socket_slice(w, y, g, gz) {
    c = SHELL_SOCKET_CLEARANCE;
    translate([0, 0, SPINE_PANEL_PLATE_BOT_Z - c - gz])
        linear_extrude(height = SPINE_PANEL_PLATE_TOP_Z - SPINE_PANEL_PLATE_BOT_Z + 2*(c + gz))
            intersection() {
                offset(delta = c + g) polygon(spine_plate_outline());
                translate([w[0], y - 0.005]) square([w[1] - w[0], 0.01]);
            }
}

module shell_sockets() {
    sy = shell_socket_y();
    sz = shell_socket_z();
    y0 = sy[0] - 0.5;
    ym = sy[2];
    c = SHELL_SOCKET_CLEARANCE;
    ring = c + SHELL_SOCKET_FUNNEL_XY + SHELL_SOCKET_WALL;
    pz0 = SPINE_PANEL_PLATE_BOT_Z - c;
    pz1 = SPINE_PANEL_PLATE_TOP_Z + c;
    for (w = shell_nub_windows())
        difference() {
            intersection() {
                translate([0, 0, sz[0]]) linear_extrude(height = sz[1] - sz[0]) union() {
                    offset(r = ring) polygon(spine_plate_outline());
                    translate([w[0] < 0 ? w[0] : SPINE_PLATE_PX_X - 1, y0])
                        square([w[0] < 0 ? SPINE_PLATE_NX_X + 1 - w[0] : w[1] - SPINE_PLATE_PX_X + 1, ym - y0]);
                }
                translate([w[0], y0, sz[0] - 1]) cube([w[1] - w[0], ym - y0, sz[1] - sz[0] + 2]);
            }
            translate([0, 0, pz0]) linear_extrude(height = pz1 - pz0) offset(delta = c) polygon(spine_plate_outline());
            hull() {  // funnel: tight slot at the end of the tight part -> mouth grown by FUNNEL_XY / FUNNEL_Z
                shell_socket_slice(w, sy[1], 0, 0);
                shell_socket_slice(w, ym + 0.01, SHELL_SOCKET_FUNNEL_XY, SHELL_SOCKET_FUNNEL_Z);
            }
        }
}

// ---------- feet ----------
module shell_feet() {
    if (SHELL_FOOT_ENABLE)
        for (y = SHELL_FOOT_Y, z = SHELL_FOOT_Z)
            hull() {
                translate([OB[0] - 0.01, y - SHELL_FOOT_LEN_BASE/2, z - SHELL_FOOT_T_BASE/2])
                    cube([SHELL_WALL/2 + 0.01, SHELL_FOOT_LEN_BASE, SHELL_FOOT_T_BASE]);
                translate([OB[0] - SHELL_FOOT_H, y - SHELL_FOOT_LEN_TIP/2, z - SHELL_FOOT_T_TIP/2])
                    cube([0.01, SHELL_FOOT_LEN_TIP, SHELL_FOOT_T_TIP]);
            }
}

// ---------- wall frames ----------
// Local frame: u, v on the wall, w = depth from the outer face inward.
function wall_matrix(wall) =
    wall == "pz"    ? [[1,0,0,0], [0,1,0,0], [0,0,-1,OB[3]]] :
    wall == "nz"    ? [[1,0,0,0], [0,1,0,0], [0,0,1,OB[2]]] :
    wall == "px"    ? [[0,0,-1,OB[1]], [1,0,0,0], [0,1,0,0]] :
    wall == "front" ? [[1,0,0,0], [0,0,1,SHELL_FRONT_OUT_Y], [0,1,0,0]] :
                      [[0,0,1,OB[0]], [1,0,0,0], [0,1,0,0]];
module wall_frame(wall) { multmatrix(wall_matrix(wall)) children(); }
function wall_t(wall) = wall == "front" ? SHELL_FRONT_THICK : SHELL_WALL;

function _grow(r, m) = [r[0] - m, r[1] + m, r[2] - m, r[3] + m];

// Allowed area [u0, u1, v0, v1] on a wall: the flat part, minus the end bands.
function wall_flat(wall) =
    let(e = SHELL_CORNER_EXTENT + SHELL_GRILL_MARGIN,
        y0 = SHELL_FRONT_OUT_Y + SHELL_FRONT_THICK + SHELL_GRILL_END_MARGIN,
        y1 = SHELL_OPEN_Y - SHELL_GRILL_END_MARGIN)
    wall == "front" ? [OB[0] + e, OB[1] - e, OB[2] + e, OB[3] - e] :
    (wall == "pz" || wall == "nz") ? [OB[0] + e, OB[1] - e, y0, y1] : [y0, y1, OB[2] + e, OB[3] - e];

// ---------- rear USB-C geometry (wall frame: u, v on the wall, w = depth from the outer face) ----------
function usbc_xf(p) = SHELL_USBC_POS + rot2d(p, SHELL_USBC_ROT);  // board (x, y) -> wall (u, v)
function usbc_w_board() = SHELL_USBC_RECESS + UT8T_RECEPT_H;      // component face = boss tops
function _rect_pts(x0, x1, y0, y1) = [[x0, y0], [x1, y0], [x1, y1], [x0, y1]];
function _pts_rect(pts) = [min([for (p = pts) p[0]]), max([for (p = pts) p[0]]),
                           min([for (p = pts) p[1]]), max([for (p = pts) p[1]])];
function usbc_board_pts() = let(e0 = UT8T_EAR_Y0, e1 = e0 + UT8T_EAR[1])
    [for (p = concat(_rect_pts(-UT8T_EAR[0]/2, UT8T_EAR[0]/2, e0, e1),
                     _rect_pts(-UT8T_NECK[0]/2, UT8T_NECK[0]/2, e1, e1 + UT8T_NECK[1]))) usbc_xf(p)];
function usbc_relief_pts() = [for (p = _rect_pts(-SHELL_USBC_RELIEF[0]/2, SHELL_USBC_RELIEF[0]/2,
                                                  -SHELL_USBC_RELIEF[1]/2, SHELL_USBC_RELIEF[1]/2)) usbc_xf(p)];
function usbc_boss_pts() = [for (s = [-1, 1]) usbc_xf([s * SHELL_USBC_SCREW_PITCH/2, 0])];
// Footprint [u0, u1, v0, v1] on SHELL_USBC_WALL: board, bosses and overmold relief.
function io_usbc_rect() = let(r = SHELL_USBC_BOSS_D/2)
    _pts_rect(concat(usbc_board_pts(), usbc_relief_pts(), [for (c = usbc_boss_pts(), d = [[-r, -r], [r, r]]) c + d]));
function _in_convex(pts, q) = let(n = len(pts),
        c = [for (i = [0 : n - 1]) let(a = pts[i], b = pts[(i + 1) % n]) (b[0] - a[0])*(q[1] - a[1]) - (b[1] - a[1])*(q[0] - a[0])])
    min(c) >= 0 || max(c) <= 0;

function wall_keepouts(wall) =
    let(m = SHELL_GRILL_MARGIN,
        boss_y1 = -FRONT_PANEL_THICKNESS + 1,
        bosses = [for (b = shell_bosses())
                    let(bx = shell_boss_box(b), y0 = -FRONT_PANEL_THICKNESS - SHELL_BOSS_LEN - (bx[3] - bx[2]))
                    if ((wall == "pz" && b[2]) || (wall == "nz" && !b[2]))
                        _grow([bx[0], bx[1], y0, boss_y1], m)
                    else if ((wall == "nx" && bx[0] <= IB[0]) || (wall == "px" && bx[1] >= IB[1]))
                        _grow([y0, boss_y1, bx[2], bx[3]], m)],
        rz = shell_rail_z(),
        rails = (wall == "nx" && SHELL_MB_RAIL_ENABLE)
                ? [_grow([SHELL_FRONT_IN_Y - 1, 1, rz[0][0], rz[1][1]], m)] : [],
        sz = shell_socket_z(),
        sy = shell_socket_y(),
        sockets = (wall == "nx" || wall == "px")
                ? [_grow([SHELL_FRONT_IN_Y - 1, sy[2], sz[0], sz[1]], m)]
                : wall == "front" ? [for (w = shell_nub_windows()) _grow([w[0], w[1], sz[0], sz[1]], m)] : [],
        feet = (wall == "nx" && SHELL_FOOT_ENABLE)
                ? [for (y = SHELL_FOOT_Y, z = SHELL_FOOT_Z)
                     _grow([y - SHELL_FOOT_LEN_BASE/2, y + SHELL_FOOT_LEN_BASE/2, z - SHELL_FOOT_T_BASE/2, z + SHELL_FOOT_T_BASE/2], m)]
                : [],
        io = (wall == SHELL_USBC_WALL && SHELL_USBC_ENABLE) ? [_grow(io_usbc_rect(), m)] : [])
    concat(bosses, rails, sockets, feet, io);

// Zones where cells are cut blind (from outside, SHELL_GRILL_BLIND_SKIN left) instead of dropped, so the pattern
// reads the same from outside while the +X rail and funnel ribs keep a solid wall to grow from.
function wall_blind_zones(wall) = wall == "px" ? [for (b = shell_rail_px_boxes()) _grow(b, 1.0)] : [];

function _box_overlap(a, b) = a[0] < b[1] && b[0] < a[1] && a[2] < b[3] && b[2] < a[3];

// Diamond lattice centred on the grill; whole cells only. blind = false: through cells; true: the blind ones.
function grill_cells(g, wall, blind = false) =
    let(c = g[1], s = g[2], cell = g[3], web = g[4],
        h = cell / sqrt(2),
        q = (cell + web) / sqrt(2),
        f = wall_flat(wall),
        area = [max(c[0] - s[0]/2, f[0]), min(c[0] + s[0]/2, f[1]), max(c[1] - s[1]/2, f[2]), min(c[1] + s[1]/2, f[3])],
        n = ceil(max(s[0], s[1]) / q) + 2,
        ko = wall_keepouts(wall),
        bz = wall_blind_zones(wall))
    [for (i = [-n : n], j = [-n : n])
        let(u = c[0] + (i + j) * q, v = c[1] + (j - i) * q, bb = [u - h, u + h, v - h, v + h])
        if (bb[0] >= area[0] && bb[1] <= area[1] && bb[2] >= area[2] && bb[3] <= area[3]
            && len([for (k = ko) if (_box_overlap(bb, k)) 1]) == 0
            && (len([for (k = bz) if (_box_overlap(bb, k)) 1]) > 0) == blind)
            [u, v]];

module diamond_2d(cell) { rotate(45) square(cell, center = true); }

module shell_grill(g, wall) {
    if (g[0]) {
        cells = grill_cells(g, wall);
        blind = grill_cells(g, wall, true);
        echo(str("Shell grill ", wall, ": ", len(cells), " cells", len(blind) > 0 ? str(" + ", len(blind), " blind") : "",
                 " (", g[3], " mm, ", g[4], " mm webs)."));
        wall_frame(wall) {
            for (p = cells) translate([p[0], p[1], 0]) grill_cell_cut(g, wall_t(wall) + 1);
            for (p = blind) translate([p[0], p[1], 0]) grill_cell_cut(g, wall_t(wall) - SHELL_GRILL_BLIND_SKIN + 0.5);
        }
    }
}

// One cell in the wall frame: from 0.5 outside the outer face, depth d; plus the optional outer chamfer.
module grill_cell_cut(g, d) {
    translate([0, 0, -0.5]) linear_extrude(height = d) diamond_2d(g[3]);
    if (g[5] > 0)
        translate([0, 0, -0.01]) linear_extrude(height = g[5] + 0.01, scale = g[3] / (g[3] + 2*g[5]))
            diamond_2d(g[3] + 2*g[5]);
}

// ---------- rear USB-C (on SHELL_USBC_WALL) ----------
module pill_2d(s) { hull() for (k = [-1, 1]) translate([k * (s[0] - s[1])/2, 0]) circle(d = s[1], $fn = 32); }

// Bosses from the wall's inner face to the board's component face; M3 x 5 pan heads through the slots into inserts.
module usbc_bosses() {
    t = wall_t(SHELL_USBC_WALL);
    if (SHELL_USBC_ENABLE) wall_frame(SHELL_USBC_WALL)
        for (p = usbc_boss_pts()) translate([p[0], p[1], t - 0.01])
            cylinder(d = SHELL_USBC_BOSS_D, h = usbc_w_board() - t + 0.01, $fn = 48);
}

module usbc_holes() {
    t = wall_t(SHELL_USBC_WALL);
    if (SHELL_USBC_ENABLE) wall_frame(SHELL_USBC_WALL) {
        translate([SHELL_USBC_POS[0], SHELL_USBC_POS[1], 0]) rotate(SHELL_USBC_ROT) {
            translate([0, 0, -1]) linear_extrude(height = t + 2)
                offset(r = SHELL_USBC_OPENING[2], $fn = 32) square([SHELL_USBC_OPENING[0], SHELL_USBC_OPENING[1]] - 2*[1, 1]*SHELL_USBC_OPENING[2], center = true);
            translate([0, 0, -0.01]) linear_extrude(height = SHELL_USBC_RELIEF_DEPTH + 0.01) pill_2d(SHELL_USBC_RELIEF);
        }
        for (p = usbc_boss_pts()) translate([p[0], p[1], usbc_w_board() - SHELL_USBC_BORE_LEN])
            cylinder(d = SPINE_PANEL_INSERT_DIA, h = SHELL_USBC_BORE_LEN + 1, $fn = 32);
    }
}

module io_parts_preview() {
    if (SHOW_FRONT_PARTS) {
        if (SHELL_USBC_ENABLE) wall_frame(SHELL_USBC_WALL)
            translate([SHELL_USBC_POS[0], SHELL_USBC_POS[1], 0]) rotate(SHELL_USBC_ROT) {
                wb = usbc_w_board();
                e0 = UT8T_EAR_Y0;
                e1 = e0 + UT8T_EAR[1];
                color("DarkGreen") translate([0, 0, wb]) linear_extrude(height = UT8T_THICK) difference() {
                    union() {
                        translate([-UT8T_EAR[0]/2, e0]) square(UT8T_EAR);
                        translate([-UT8T_NECK[0]/2, e1 - 0.01]) square(UT8T_NECK + [0, 0.01]);
                    }
                    for (s = [-1, 1]) translate([s * UT8T_SLOT[2]/2, 0]) pill_2d([UT8T_SLOT[0], UT8T_SLOT[1]]);
                }
                color("Silver") {
                    translate([0, 0, SHELL_USBC_RECESS]) linear_extrude(height = UT8T_RECEPT_H + UT8T_THICK + 0.8) pill_2d(UT8T_RECEPT);
                    translate([0, 0, wb - 2]) linear_extrude(height = 1.5) square(UT8T_FLANGE, center = true);
                }
                color("Orange") translate([-7, e1 + UT8T_NECK[1] - 2, wb + UT8T_THICK]) cube([14, 30, 1.4]);  // ribbon stub
            }
        if (IO_BUTTON_ENABLE) {
            p = io_button_pos();
            color("Silver") {
                translate([p[0], 0, p[1]]) rotate([-90, 0, 0]) cylinder(d = IO_BUTTON_HEAD_D, h = 2, $fn = 48);
                translate([p[0], -FRONT_PANEL_THICKNESS, p[1]]) rotate([90, 0, 0]) {
                    cylinder(d = IO_BUTTON_NUT_D, h = 3, $fn = 6);
                    cylinder(d = IO_BUTTON_BODY_D, h = IO_BUTTON_BODY_LEN, $fn = 48);
                }
            }
        }
    }
}

module cooler_preview() {
    if (SHOW_COOLER)
        color("Silver", 0.6) translate([SHELL_COOLER_POS[0] - CPU_COOLER_FAN_D/2, SHELL_COOLER_POS[1] - CPU_COOLER_FAN_D/2, MB_PCB_TOP_Z])
            cube([CPU_COOLER_FAN_D, CPU_COOLER_FAN_D, CPU_COOLER_TOP_Z - MB_PCB_TOP_Z]);
}

// ---------- checks ----------
function _cooler_box_xz() = [SHELL_COOLER_POS[0] - CPU_COOLER_FAN_D/2, SHELL_COOLER_POS[0] + CPU_COOLER_FAN_D/2, MB_PCB_TOP_Z, CPU_COOLER_TOP_Z];
function _box_xz(pos, size, rot90) = let(sx = rot90 ? size[1] : size[0])
    [pos[0] - sx/2, pos[0] + sx/2, pos[2] - size[2]/2, pos[2] + size[2]/2];

module shell_checks() {
    // Everything behind the I/O plate slides past the bosses, so compare XZ silhouettes.
    comps = [["HDD", _box_xz(HDD_POS, HDD_SIZE, false)],
             ["GaN PSU", _box_xz(GAN_PSU_POS, GAN_PSU_SIZE, true)],
             ["CPU cooler", _cooler_box_xz()],
             ["C14 body", [C14_POS[0] - C14_BODY_HALF_W, C14_POS[0] + C14_BODY_HALF_W,
                           C14_POS[2] - C14_BODY_TOP_DZ, C14_POS[2] + C14_BODY_TOP_DZ]]];
    for (b = shell_bosses(), k = comps) {
        g = _rect_gap(shell_boss_box(b), k[1]);
        if (g < 2) echo(str("Shell boss ", b[2] ? "upper " : "lower ", b[3], " at [", b[0][0], ",", b[0][1], "]: ", g, "mm from the ", k[0], " silhouette."));
        if (g < SHELL_INSERT_MIN_CLEARANCE)
            echo(str("WARNING: shell boss at [", b[0][0], ",", b[0][1], "] would block the ", k[0],
                     " as the assembly slides in (gap ", g, " < ", SHELL_INSERT_MIN_CLEARANCE, "). Disable it in SHELL_BOSS_ENABLE_*."));
    }
    if (SHELL_TAB_ENABLE) {
        tb = shell_tab_box();
        for (k = comps) {
            g = _rect_gap(tb, k[1]);
            if (g < 2) echo(str("Shell I/O plate tab: ", g, "mm from the ", k[0], " silhouette."));
            if (g < SHELL_INSERT_MIN_CLEARANCE - 0.001)
                echo(str("WARNING: the I/O plate tab would block the ", k[0], " as the assembly slides in (gap ", g, ")."));
        }
        if (SHELL_TAB_BOT_Z < FAN_PANEL_INNER_Z - FAN_PANEL_GAP + SHELL_INSERT_MIN_CLEARANCE - 0.001 || SHELL_TAB_BOT_Z > IB[3] - 1)
            echo(str("WARNING: I/O plate tab bottom Z ", SHELL_TAB_BOT_Z, " - check it against the cooler top / shell wall."));
    }

    // Feet
    run = (SHELL_FOOT_LEN_BASE - SHELL_FOOT_LEN_TIP) / 2;
    ang = atan2(run, SHELL_FOOT_H);
    echo(str("Shell feet: underside ", ang, "deg from the bed in the print orientation."));
    if (SHELL_FOOT_ENABLE && run < SHELL_FOOT_H)
        echo(str("WARNING: feet underside is ", ang, "deg from the bed (< 45) - grow SHELL_FOOT_LEN_BASE or shrink SHELL_FOOT_LEN_TIP / H."));
    for (z = SHELL_FOOT_Z)
        if (SHELL_FOOT_ENABLE && (z - SHELL_FOOT_T_BASE/2 < OB[2] + SHELL_CORNER_EXTENT || z + SHELL_FOOT_T_BASE/2 > OB[3] - SHELL_CORNER_EXTENT))
            echo(str("WARNING: foot at Z ", z, " runs onto the rounded corner - raise SHELL_FOOT_Z_INSET."));

    // Rail vs MB edge
    mb_x0 = MB_POS[0] - MB_SIZE[0]/2;
    if (SHELL_MB_RAIL_ENABLE)
        echo(str("Shell MB rail: PCB edge X ", mb_x0, " sits ", mb_x0 - IB[0], "mm off the -X wall; channel ", SHELL_MB_RAIL_DEPTH, "mm deep."));

    // +X rail: overlap with the PCB, clearance to the spine's +X edge (it passes the rail first), and what the
    // funnel's flanks reach above / below the PCB in the final position.
    if (SHELL_MB_RAIL_PX_ENABLE) {
        ry = shell_rail_px_y();
        mb_x1 = MB_POS[0] + MB_SIZE[0]/2;
        rib_x = IB[1] - SHELL_MB_RAIL_PX_DEPTH;
        spine_x = max([for (y = [ry[0] : 1 : ry[2]]) spine_plate_px_edge(y)]);
        lo = shell_rail_px_z(0, ry[2]); hi = shell_rail_px_z(1, ry[2]);
        echo(str("Shell +X MB rail: Y ", SHELL_FRONT_IN_Y, "..", ry[2], " (tight to ", ry[1], ", funnel ", ry[1], "..", ry[2],
                 "); ribs overlap the PCB by ", mb_x1 - rib_x, "mm, ", rib_x - spine_x, "mm off the spine's +X edge; funnel mouth catches Z ",
                 lo[1], "..", hi[0], " (PCB ", MB_PCB_TOP_Z - MB_PCB_THICK, "..", MB_PCB_TOP_Z, "), flanks reach Z ", lo[0], "..", hi[1], "."));
        echo(str("NOTE: keep fan headers / parts off X > ", rib_x, " for Y < ", ry[2], " (", SHELL_MB_RAIL_PX_REACH,
                 "mm from the PCB's rear edge) - the +X rail and its funnel sit there."));
        if (mb_x1 - rib_x < 0.8)
            echo(str("WARNING: the +X rail only overlaps the PCB by ", mb_x1 - rib_x, "mm - deepen SHELL_MB_RAIL_PX_DEPTH."));
        if (rib_x - spine_x < 0.3)
            echo(str("WARNING: the +X rail ribs are ", rib_x - spine_x, "mm from the spine's +X edge - it may catch them on insertion."));
        if (ry[1] - ry[0] < 5)
            echo(str("WARNING: the +X rail's tight channel is only ", ry[1] - ry[0], "mm long - shorten SHELL_MB_RAIL_PX_FUNNEL_LEN."));
        if (ry[1] < MB_POS[1] - MB_SIZE[1]/2 + 3)
            echo("WARNING: the +X rail's tight channel barely reaches the PCB - shorten SHELL_MB_RAIL_PX_FUNNEL_LEN.");
    }

    // Socket funnels: they stand in front of the face, behind the boards - keep them off the PSU, HDD and PCB.
    {
        fy = shell_socket_y(); fz = shell_socket_z();
        echo(str("Shell nub sockets: tight Y ", fy[0], "..", fy[1], " (", fy[1] - (SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2),
                 "mm engagement), funnel to ", fy[2], "; mouth catches +-", SHELL_SOCKET_CLEARANCE + SHELL_SOCKET_FUNNEL_Z,
                 "mm in Z, +-", SHELL_SOCKET_CLEARANCE + SHELL_SOCKET_FUNNEL_XY, "mm round the nubs; block Z ", fz[0], "..", fz[1], "."));
        if (fy[1] - (SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2) < 2)
            echo("WARNING: the nubs engage the sockets' tight part by less than 2 mm - raise SHELL_SOCKET_DEPTH.");
        pcb = [MB_POS[0] - MB_SIZE[0]/2, MB_POS[0] + MB_SIZE[0]/2, MB_POS[1] - MB_SIZE[1]/2, MB_POS[1] + MB_SIZE[1]/2,
              MB_PCB_TOP_Z - MB_PCB_THICK, MB_POS[2] + MB_SIZE[2]/2];
        for (w = shell_nub_windows(), o = [["GaN PSU", _box3(GAN_PSU_POS, [GAN_PSU_SIZE[1], GAN_PSU_SIZE[0], GAN_PSU_SIZE[2]])],
                                           ["HDD", _box3(HDD_POS, HDD_SIZE)], ["MB", pcb]]) {
            b = [w[0], w[1], fy[0], fy[2] + 0.3, fz[0], fz[1]];
            if (_box3_overlap(b, o[1]))
                echo(str("WARNING: the nub socket funnel at X ", w[0], "..", w[1], " comes within 0.3 mm of the ", o[0],
                         " - shorten SHELL_SOCKET_FUNNEL_LEN or shrink SHELL_SOCKET_FUNNEL_Z."));
        }
    }

    // Top grill vs the fan footprint
    g = SHELL_GRILL_PZ;
    if (g[0]) {
        cells = grill_cells(g, "pz");
        us = [for (p = cells) p[0]]; vs = [for (p = cells) p[1]];
        h = g[3] / sqrt(2);
        if (len(cells) > 0) {
            span = [min(us) - h, max(us) + h, min(vs) - h, max(vs) + h];
            echo(str("Top grill spans X ", span[0], "..", span[1], ", Y ", span[2], "..", span[3], "."));
            for (fc = [["assumed SHELL_COOLER_POS", SHELL_COOLER_POS], ["manual MB_CPU_SOCKET_XY", MB_CPU_SOCKET_XY]]) {
                need = [fc[1][0] - CPU_COOLER_FAN_D/2, fc[1][0] + CPU_COOLER_FAN_D/2,
                        fc[1][1] - CPU_COOLER_FAN_D/2, fc[1][1] + CPU_COOLER_FAN_D/2];
                echo(str("  fan at the ", fc[0], ": X ", need[0], "..", need[1], ", Y ", need[2], "..", need[3],
                         " - margin ", min(need[0] - span[0], span[1] - need[1], need[2] - span[2], span[3] - need[3]), "mm."));
                if (span[0] > need[0] || span[1] < need[1] || span[2] > need[2] || span[3] < need[3])
                    echo(str("WARNING: the top grill doesn't cover the whole fan at the ", fc[0], " - resize SHELL_GRILL_PZ or check keep-outs."));
            }
        }
        if (g[3] > FAN_PANEL_GAP) echo(str("WARNING: top grill cell ", g[3], " > FAN_PANEL_GAP ", FAN_PANEL_GAP, " - the blades will see jets."));
    }

    // Internals the rear USB-C board and the power button body must clear (world AABBs).
    mb = [MB_POS[0] - MB_SIZE[0]/2, MB_POS[0] + MB_SIZE[0]/2, MB_POS[1] - MB_SIZE[1]/2, MB_POS[1] + MB_SIZE[1]/2];
    sz = shell_socket_z();
    obstacles = [
        ["MB PCB", [mb[0], mb[1], mb[2], mb[3], MB_PCB_TOP_Z - MB_PCB_THICK, MB_PCB_TOP_Z]],
        ["spine plate", [SPINE_PLATE_NX_X, SPINE_PLATE_PX_X, SPINE_PLATE_POS[1] - SPINE_PLATE_SIZE[1]/2,
                         SPINE_PLATE_POS[1] + SPINE_PLATE_SIZE[1]/2, SPINE_PANEL_PLATE_BOT_Z, SPINE_PANEL_PLATE_TOP_Z]],
        ["GaN PSU", _box3(GAN_PSU_POS, [GAN_PSU_SIZE[1], GAN_PSU_SIZE[0], GAN_PSU_SIZE[2]])],
        ["HDD", _box3(HDD_POS, HDD_SIZE)],
        ["CPU cooler", [SHELL_COOLER_POS[0] - CPU_COOLER_FAN_D/2, SHELL_COOLER_POS[0] + CPU_COOLER_FAN_D/2,
                        SHELL_COOLER_POS[1] - CPU_COOLER_FAN_D/2, SHELL_COOLER_POS[1] + CPU_COOLER_FAN_D/2,
                        MB_PCB_TOP_Z, CPU_COOLER_TOP_Z]],
        ["24-pin plug (mated, est.)", [MB_ATXPWR_RECT[0], MB_ATXPWR_RECT[1], MB_ATXPWR_RECT[2] - 1.7, MB_ATXPWR_RECT[3],
                                       MB_PCB_TOP_Z, MB_PCB_TOP_Z + MB_ATXPWR_PLUG_H]],
        for (w = shell_nub_windows())
            ["spine nub socket", [w[0], w[1], SHELL_FRONT_IN_Y, shell_socket_y()[2], sz[0], sz[1]]]];

    // Power button (on the I/O plate): its nut slides past the shell's upper bosses; its body sits behind the panel.
    if (IO_BUTTON_ENABLE) {
        p = io_button_pos();
        for (b = shell_bosses()) {
            bx = shell_boss_box(b);
            g = norm([max(bx[0] - p[0], p[0] - bx[1], 0), max(bx[2] - p[1], p[1] - bx[3], 0)]) - IO_BUTTON_NUT_D/2;
            if (g < 2) echo(str("Shell boss ", b[2] ? "upper " : "lower ", b[3], ": ", g, "mm from the power button nut."));
            if (g < SHELL_INSERT_MIN_CLEARANCE)
                echo(str("WARNING: the power button nut would hit the shell boss at [", b[0][0], ",", b[0][1],
                         "] as the assembly slides in (gap ", g, ") - move IO_BUTTON_OFFSET."));
        }
        rb = max(IO_BUTTON_NUT_D, IO_BUTTON_BODY_D)/2;
        bb = [p[0] - rb, p[0] + rb, -FRONT_PANEL_THICKNESS - IO_BUTTON_BODY_LEN, -FRONT_PANEL_THICKNESS, p[1] - rb, p[1] + rb];
        for (o = obstacles) if (_box3_overlap(bb, o[1]))
            echo(str("WARNING: the power button body hits the ", o[0], " - move IO_BUTTON_OFFSET or shorten the body."));
    }

    // Rear USB-C: footprint on the wall, bosses vs the receptacle, board stack clear of the internals.
    if (SHELL_USBC_ENABLE) {
        t = wall_t(SHELL_USBC_WALL);
        wb = usbc_w_board();
        if (wb - t < 1)
            echo(str("WARNING: USB-C bosses are only ", wb - t, "mm tall - the receptacle is too short for this wall / SHELL_USBC_RECESS."));
        if (abs(SHELL_USBC_SCREW_PITCH - UT8T_SLOT[2]) > (UT8T_SLOT[0] - UT8T_SLOT[1])/2)
            echo(str("WARNING: SHELL_USBC_SCREW_PITCH ", SHELL_USBC_SCREW_PITCH, " is outside the board's slots (",
                     UT8T_SLOT[2] - (UT8T_SLOT[0] - UT8T_SLOT[1])/2, "..", UT8T_SLOT[2] + (UT8T_SLOT[0] - UT8T_SLOT[1])/2, ")."));
        fl_gap = SHELL_USBC_SCREW_PITCH/2 - SHELL_USBC_BOSS_D/2 - UT8T_FLANGE[0]/2;
        if (fl_gap < 0.2)
            echo(str("WARNING: USB-C bosses are ", fl_gap, "mm from the receptacle flange - widen SHELL_USBC_SCREW_PITCH."));
        if (SHELL_USBC_WALL == "front") {
            m_in = 0.5;
            m_out = SHELL_FRONT_CHAMFER + 1.0;
            inner = smooth_rect_pts(IB[0] + m_in, IB[1] - m_in, IB[2] + m_in, IB[3] - m_in,
                                    SHELL_CORNER_R - SHELL_WALL - m_in, SHELL_CORNER_SMOOTHING, SHELL_CORNER_STEPS);
            outer = smooth_rect_pts(OB[0] + m_out, OB[1] - m_out, OB[2] + m_out, OB[3] - m_out,
                                    SHELL_CORNER_R - m_out, SHELL_CORNER_SMOOTHING, SHELL_CORNER_STEPS);
            inside = concat(usbc_board_pts(), [for (c = usbc_boss_pts(), a = [0 : 30 : 330]) c + SHELL_USBC_BOSS_D/2 * [cos(a), sin(a)]]);
            if (len([for (q = inside) if (!_in_convex(inner, q)) 1]) > 0)
                echo(str("WARNING: the USB-C board / bosses come within ", m_in, "mm of the shell's inner wall - move SHELL_USBC_POS."));
            if (len([for (q = usbc_relief_pts()) if (!_in_convex(outer, q)) 1]) > 0)
                echo("WARNING: the USB-C relief runs onto the front face's chamfer / rounded corner - move SHELL_USBC_POS.");
        } else {
            flat = wall_flat(SHELL_USBC_WALL);
            r = io_usbc_rect();
            if (r[0] < flat[0] || r[1] > flat[1] || r[2] < flat[2] || r[3] > flat[3])
                echo(str("WARNING: the USB-C on ", SHELL_USBC_WALL, " [", r, "] leaves the flat wall area [", flat,
                         "] - move it off the rounded corner / end band."));
        }
        b = _wall_box_world(SHELL_USBC_WALL, _pts_rect(usbc_board_pts()), SHELL_USBC_RECESS, wb + UT8T_BACK);
        echo(str("Shell USB-C board stack: X ", b[0], "..", b[1], ", Y ", b[2], "..", b[3], ", Z ", b[4], "..", b[5],
                 "; bosses ", wb - t, "mm tall."));
        for (o = obstacles) if (_box3_overlap(b, o[1]))
            echo(str("WARNING: the USB-C board hits the ", o[0], " - move SHELL_USBC_POS."));
        if (SHELL_USBC_WALL == "front")
            echo(str("Shell USB-C: board stack ends ", (MB_POS[1] - MB_SIZE[1]/2) - b[3], "mm short of the MB's rear edge (Y ",
                     MB_POS[1] - MB_SIZE[1]/2, "), ", b[4] - MB_PCB_TOP_Z, "mm above the PCB top."));
    }
}

function _box3(pos, size) = [pos[0] - size[0]/2, pos[0] + size[0]/2, pos[1] - size[1]/2, pos[1] + size[1]/2,
                             pos[2] - size[2]/2, pos[2] + size[2]/2];
function _box3_overlap(a, b) = a[0] < b[1] && b[0] < a[1] && a[2] < b[3] && b[2] < a[3] && a[4] < b[5] && b[4] < a[5];
function _xf(m, p) = [for (r = m) r * [p[0], p[1], p[2], 1]];
function _wall_box_world(wall, r, w0, w1) =
    let(m = wall_matrix(wall),
        pts = [for (u = [r[0], r[1]], v = [r[2], r[3]], w = [w0, w1]) _xf(m, [u, v, w])])
    [min([for (p = pts) p[0]]), max([for (p = pts) p[0]]), min([for (p = pts) p[1]]), max([for (p = pts) p[1]]),
     min([for (p = pts) p[2]]), max([for (p = pts) p[2]])];

// ---------- assembly ----------
module shell_body() {
    fc = SHELL_FRONT_CHAMFER;
    oc = SHELL_OPEN_CHAMFER;
    ic = SHELL_OPEN_INNER_CHAMFER;
    difference() {
        union() {
            hull() {
                xz_extrude(SHELL_FRONT_OUT_Y, SHELL_FRONT_OUT_Y + 0.01) offset(r = -fc) shell_outer_2d();
                xz_extrude(SHELL_FRONT_OUT_Y + fc, SHELL_FRONT_OUT_Y + fc + 0.01) shell_outer_2d();
            }
            xz_extrude(SHELL_FRONT_OUT_Y + fc, SHELL_OPEN_Y - oc) shell_outer_2d();
            hull() {
                xz_extrude(SHELL_OPEN_Y - oc - 0.01, SHELL_OPEN_Y - oc) shell_outer_2d();
                xz_extrude(SHELL_OPEN_Y - 0.01, SHELL_OPEN_Y) offset(r = -oc) shell_outer_2d();
            }
        }
        xz_extrude(SHELL_FRONT_IN_Y, SHELL_OPEN_Y + 1) shell_inner_2d();
        hull() {
            xz_extrude(SHELL_OPEN_Y - ic - 0.01, SHELL_OPEN_Y - ic) shell_inner_2d();
            xz_extrude(SHELL_OPEN_Y, SHELL_OPEN_Y + 0.01) offset(r = ic) shell_inner_2d();
        }
    }
}

module shell() {
    difference() {
        union() {
            shell_body();
            shell_bosses_solid();
            shell_mb_rails();
            shell_sockets();
            shell_feet();
            usbc_bosses();
            shell_tab();
        }
        shell_boss_bores();
        shell_grill(SHELL_GRILL_PZ, "pz");
        shell_grill(SHELL_GRILL_NZ, "nz");
        shell_grill(SHELL_GRILL_PX, "px");
        shell_grill(SHELL_GRILL_NX, "nx");
        shell_grill(SHELL_GRILL_FRONT, "front");
        usbc_holes();
        if (SHELL_CUTAWAY == "x") translate([SHELL_CUTAWAY_AT, -500, -500]) cube(1000);
        if (SHELL_CUTAWAY == "z") translate([-500, -500, SHELL_CUTAWAY_AT]) cube(1000);
    }
}

if (SHELL_DRAW) {
    shell_checks();
    if (FOR_PRINT) {
        translate([0, 0, -SHELL_FRONT_OUT_Y]) rotate([90, 0, 0]) shell();
    } else {
        color(SHELL_COLOR, SHELL_ALPHA) shell();
        if (SHOW_ASSEMBLY) {
            new_spine(true, "Orange", 1);
            io_plate(true, "Orange", 1);
        }
        cooler_preview();
        io_parts_preview();
        render_references();
    }
}
