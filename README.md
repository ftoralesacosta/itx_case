# Game of Life ITX Case — ITX Layout Study

![Render of the divider plate/spine, showing the diamond lightening pattern and HDD grill](render.png)

A parametric OpenSCAD model built around the ["4.7L Mini ITX case, easily
printable (2 major pieces)"](https://www.printables.com/model/143897-47l-mini-itx-case-easily-printable-2-major-pieces)
design. The original pairs a fish-shaped **spine** (structural divider +
motherboard standoffs) with an outer **shell**. This project keeps the
spine's "sandwich" concept — a divider plate between a motherboard
compartment and a lower compartment — but redesigns the lower compartment
around different hardware:

- **GPU → 3.5" HDD**, vibration-isolated on O-rings
- **ATX/FlexATX PSU → HDPLEX 250W GaN AIO ATX PSU**, thermally isolated on O-rings
- Board: **ASRock B860I** (Mini-ITX)

The outer shell has not been redesigned yet — this is a layout and mounting
study for the spine only.

## `dual_HDD` branch

This branch is `main`'s model (last merged at `316c6c5`) with the lower
compartment re-planned for **two 3.5" drives and no PSU**. Everything after
this section is `main`'s text, kept verbatim so future merges stay easy —
where it describes the GaN PSU, the SC adaptors, the PSU cable gap, or
`main`'s plate/enclosure/taper numbers, **this section wins**. The renders
in this README show `main`'s layout.

**What's different from `main`:**

- **GaN PSU removed** — the PSU, its 24-pin/SC adaptor blocks, the 500W
  fit-check block, its standoffs, plate holes and countersinks,
  `gan_adaptor_report()`, `FRONT_PANEL_PSU_CABLE_GAP`, the unused
  `GAN_CABLE_*` / `GAN_FRONT_MOUNT_*` / `FRONT_VENT_*` parameters, and every
  other `GAN_*`/`SC_*` parameter. The face bottom stays at `main`'s -31.33,
  which leaves ~8.3 mm of cable room under the drives.
- **HDD rotated 90°** (`HDD_ROT = [0,0,90]`): the 146.99 mm length runs
  along X, so the 101.6 mm width is the drive's Y depth. HDD1 sits
  `HDD_PANEL_GAP` (1.7 mm, free) behind the panel's back face
  (`HDD_POS = [-5, -55, -9.98]`, X -78.5 .. 68.5). Keep the gap ≥ ~1.29, or
  HDD1's front standoff ramps poke out through the front face.
- **Second drive** (`HDD2_POS`, derived; `SHOW_HDD2`, driven by
  `used_components` in place of `SHOW_GAN_PSU`): same model, holes and
  standoffs, directly behind HDD1 with `HDD_STACK_GAP` (0.9 mm, free) of
  air. HDD1's rear and HDD2's front standoffs are only 7.26 mm apart and
  merge into shared pads, so all 8 are built in one union-then-drill group
  in `new_spine()`.
- **Connector end** (`HDD_SATA_FACING_NEG_X`, default `true` = SATA/power at
  -X; only valid for this rotation). `false` moves every HDD standoff
  11.77 mm toward -X; the -X/-Y tapers then cut into them (warned) and need
  a re-tune.
- **C14 inlet kept but off** (`C14_ENABLE = false`; `SHOW_C14_SOCKET` also
  needs it). There's no PSU to feed, and HDD1's front face is only 1.7 mm
  behind the panel: the straight-pin socket body reaches Y -28.6, ~24 mm
  into the drive, and `main`'s planned right-angle-pin socket still has a
  body far deeper than 1.7 mm. `true` restores all three cuts (socket,
  screws, flange pocket), narrows the HDD grill back to `main`'s, and warns
  while the socket hits HDD1. `c14_tool.scad`/`c14_socket.stl` aren't
  tracked (same as on `main`); with the C14 off, a missing `c14_tool.scad`
  only causes a harmless "Can't find include file" warning.
- **HDD grill** spans the whole lower face with the C14 off
  (`HDD_GRILL_W` 166.5 @ `HDD_GRILL_POS_X` 2.75, 2 mm edge margins;
  `main`: 108 @ 32). The Game of Life shapes keep `main`'s anchors, which
  are relative to the grill centre.
- **Deeper spine**: plate rear -177 → **-213.5** (`SPINE_PLATE_POS` /
  `SIZE` = `[2.31, -107.75, 8.1]` / `[170.6, 211.5, 3]`, 3.38 mm past HDD2's
  rear standoffs) and enclosure depth 178 → **214.5** (`ENCLOSURE_POS[1]`
  -108.25; the front stays at -1).
- **Tapers** — `AFTER` is measured from the rear edge, which moved 36.5 mm
  (BEFORE / RUN / AFTER / DEPTH):

  | Taper | `dual_HDD` | `main` | Why |
  |---|---|---|---|
  | PX | 41 / 20 / **56.5** / 30 | 41 / 20 / 20 / 30 | rear taper-back at Y -157, clear of the MB rear standoff ramps (-157.13) |
  | NX | 53 / 28 / **56.5** / 28 | 53 / 28 / 55 / 28 | same Y -157; `main`'s 45° RUN/DEPTH kept |
  | NY | **50 / 25 / 54 / 25** | 7 / 38 / 44.4 / 38 | notch X -30 .. 32, floor Y -188.5, ~2 mm clear of HDD2's rear standoffs (`main`'s would cut through them) |
  | NY2 | **off** | on: 110 / 3 / 10 / 7 | at X 30 .. 76 its floor (Y -206.5) cuts ~3.6 mm into HDD2's +X rear standoff |

  The HDD standoffs sit ~9.8 mm (NX) / 12 mm (PX) inside the waists.
- **Self-checks** — added: `HDD1 front face is … not HDD_PANEL_GAP`,
  `HDD standoff ramp … past the front face`, and `C14_ENABLE is on, but the
  socket body reaches …`. The cut-loose checks cover MB / HDD / HDD2, and
  the -Y one also samples the edge's breakpoints under each standoff, so a
  narrow notch between the three standard samples is still caught. Removed
  with the PSU: the PSU cable-gap, `NY_DEPTH`-flush-with-GaN, GaN peg and SC
  adaptor warnings. Currently firing: only the MB envelope discrepancy.
- **Hardware**: HDD → standoffs is **8** screws and **16** O-rings (two
  drives); the GaN rows don't apply.

**Open items (`dual_HDD`):**

- **SATA plug room:** with the connector ends at -X the drives end only
  4 mm inside the enclosure's -X face (X -78.5 vs -82.5) — far less than a
  straight SATA plug needs. Check real right-angle plugs, or flip to +X
  (19.5 mm there) and re-tune the -X/-Y tapers.
- **Print height:** 213.5 mm with the front face on the bed — inside the
  MK4S's 220 mm max Z with only 6.5 mm to spare — and the wall is ~211 mm
  tall instead of ~175, so the [print guide](#print-guide)'s anti-wobble
  steps matter more.
- **Drive spacing:** 0.9 mm between the drives, and the facing rows'
  O-rings end up ~0.02 mm apart. Fine on paper; check the real drives'
  width (101.6 mm nominal) before printing.
- **MB mounting** uses `main`'s test-fit `MB_HOLES_RAW` / `MB_POS` (this
  branch's older spec-derived set was dropped in the first merge). Re-check
  the board's fit on the first `dual_HDD` print.
- **Power:** there's no PSU in the model; whatever powers the board isn't
  modeled yet.

## Contents

1. [Files](#files)
2. [Using the model](#using-the-model)
3. [Conventions](#conventions)
4. [Design reference](#design-reference)
   - [Enclosure and front face](#enclosure-and-front-face)
   - [Divider plate](#divider-plate)
   - [Standoffs](#standoffs)
   - [Front panel — upper (rear I/O)](#front-panel--upper-rear-io)
   - [Front panel — lower (HDD / PSU side)](#front-panel--lower-hdd--psu-side)
   - [Front panel mounting screws](#front-panel-mounting-screws)
   - [CPU cooler and fan intake clearance](#cpu-cooler-and-fan-intake-clearance)
   - [PSU 24-pin routing (SC Shift adaptors)](#psu-24-pin-routing-sc-shift-adaptors)
5. [Printing](#printing)
6. [Hardware and assembly](#hardware-and-assembly)
7. [Self-checks (console warnings)](#self-checks-console-warnings)
8. [Known open items](#known-open-items)

## Files

| File | Purpose |
|---|---|
| `game_of_life_itx_case.scad` | The working model — everything below. |
| `c14_tool.scad` | Included by the main file. Cutting tools for the C14 inlet (flange lip + body), with per-axis fit trims. Profiles auto-generated from `c14_socket.stl`. |
| `asrock_b860i_io_shield.scad` | Caliper-measured rear-I/O port layout for the ASRock B860I. Exported to `asrock_b860i_io_shield.stl`, which the main file imports and cuts into the front panel. |
| `c14_socket.stl` / `c14_snap-fit_socket.stl` | C14 inlet models (screw-mount / snap-in), selected by `USE_SNAP_IN_C14`. |
| `4.7-Fish_-_spine.stl` | Original spine reference. Front I/O opening, mounting holes, and taper shape were measured from it. |
| `4.7-Fish_-_case.stl`, `4.7-fish-step.step` | Original shell / STEP reference — not used in the model yet. |
| `asrock_b760m_itx_io_shield.scad`/`.stl`, `basic_layout.scad` | Legacy: the previous board's shield model and an early layout snapshot. Not used. |

## Using the model

- Requires OpenSCAD **≥ 2021.01** (function literals are used for the -Y
  taper breakpoints). The manifold backend (`--backend=manifold`) is much faster.
- `used_components` toggles `SHOW_MB` / `SHOW_HDD` / `SHOW_GAN_PSU` /
  `SHOW_C14_SOCKET` together — translucent reference bodies for clearance
  checks. **Set it `false` before exporting.**
- `SHOW_SPINE` imports the *original* reference STL in a comparison pose;
  most "real" measurements were taken against it. Not part of the print.
- `SHOW_ODD` / `ODD_*` is a leftover slim-optical-drive placeholder, unused.
- `SHOW_GAN_BLOCKS` shows the SC Shift adaptor bodies and enables their
  report (see [PSU 24-pin routing](#psu-24-pin-routing-sc-shift-adaptors)).
- **Export:** `SHOW_NEW_SPINE = true`, everything else (`SHOW_SPINE`,
  `SHOW_ENCLOSURE`, `SHOW_ODD`, `used_components`) `false`, then a full
  **Render (F6)** — the lightening pattern is slow and can be wrong in
  Preview. CLI: `openscad --backend=manifold -D used_components=false -o game_of_life_itx_case.stl game_of_life_itx_case.scad`.
- After any change, **read the console for `WARNING:` lines** (see
  [Self-checks](#self-checks-console-warnings)).

## Conventions

- **Real vs free numbers.** Most dimensions come from a verifiable source
  (datasheet, spec, manufacturer STEP, caliper, or the reference STL).
  Others are free design choices. This README records which is which (the
  code keeps only terse inline notes). When a free parameter is *meant* to
  track a real value, the model computes that value each render and echoes a
  `WARNING:` on drift instead of silently overriding you.
- **Literals that can't be derived.** OpenSCAD evaluates top-level
  assignments in order, so a few positions are literals that depend on
  things defined later (`MB_POS[1]`, `GAN_PSU_POS[2]`, `ENCLOSURE_*` Z). Each
  has a drift warning that prints the value to set.
- **Manifold ≠ connected.** A watertight union can still contain disjoint
  bodies. Verify connectivity with STL-intersection probes:
  `intersection() { import("model.stl"); translate([x,y,z]) cube(s); }` —
  empty output where there should be material means something is loose.
- **Naming.** `PX`/`NX`/`PY`/`NY`/`PZ`/`NZ` = +X/-X/+Y/-Y/+Z/-Z edge or side.
  `UPPER`/`LOWER` = Z (MB side / HDD-PSU side).
- **Axes.** Front face at Y = 0, the case extends toward -Y. +Z is the MB
  side of the plate, -Z the HDD/PSU side.
- **Print orientation matters** — see [Printing](#printing) before assuming
  a design choice is arbitrary.

## Design reference

<img src="render_with_component_blocks.png" alt="Render with MB (blue), GaN PSU (black), and HDD (red) placeholder blocks shown" width="500">

### Enclosure and front face

`ENCLOSURE_SIZE = [170.5, 178, 91.83]` @ `ENCLOSURE_POS = [2.75, -90, 14.585]`
is the outer volume budget and defines the front face's X and Z extent.

- **X: -82.5 .. 88.** +X is flush with the MB PCB. The Sep 25 test print
  (170 wide @ X 3) had the board flush on +X but ~1 mm past the face on -X,
  so the face grew 0.5 mm on -X only (free, from the test fit).
- **Z: -31.33 .. 60.5** (the panel itself tops out at `FRONT_PANEL_TOP_Z` =
  59.2, see [fan clearance](#cpu-cooler-and-fan-intake-clearance)). The
  bottom sits `FRONT_PANEL_PSU_CABLE_GAP` = **10.5 mm** below the PSU's bottom
  face (-20.83) — bend room for the 24-pin cable (free). History: 85 → 94
  (+9 on -Z for cable room) → 91.83 (trimmed to the 10.5 mm target).
  `front_panel_lower()` warns if the gap drifts.
- When the bottom moved, the HDD grill's bottom margin and the C14 moved
  with it (see [lower panel](#front-panel--lower-hdd--psu-side)); the lower
  mount screws follow the edge automatically.

### Divider plate

#### Position and extent

`SPINE_PLATE_POS = [2.31, -89.5, 8.1]`, `SPINE_PLATE_SIZE = [170.6, 175, 3]`:
plate Z 6.6 .. 9.6, Y -2.0 .. -177.

- **The front edge (Y -2.0) must overlap the panel** (back face at
  -`FRONT_PANEL_THICKNESS` = -2.5). It once stopped at -3.0; in the print
  orientation (front face on the bed) the whole spine then started mid-air.
- **X extent** comes from `SPINE_PLATE_NX_X` / `SPINE_PLATE_PX_X` (derived:
  2 mm inside each MB edge, 166 mm wide), superseding `POS`/`SIZE` X and
  `SPINE_PLATE_MARGIN_X`.

#### Edge tapers

The outline copies the reference STL's trapezoidal notches on the three
non-I/O edges, plus an optional second -Y notch:

| | `*_BEFORE` | `*_RUN` | `*_AFTER` | `*_DEPTH` |
|---|---|---|---|---|
| **+X** `SPINE_PLATE_TAPER_PX_*` | flat run from the front | Y-run of each slope | flat run from the back | X-depth into the plate |
| **-Y** `SPINE_PLATE_TAPER_NY_*` | flat run from the -X end | X-run of each slope | flat run from the +X end | Y-depth into the plate |
| **-Y #2** `SPINE_PLATE_TAPER_NY2_*` | same as -Y | same | same | same |
| **-X** `SPINE_PLATE_TAPER_NX_*` | flat run from the front | Y-run of each slope | flat run from the back | X-depth into the plate |

- `RUN` values were measured from the reference STL; `BEFORE`/`AFTER`/
  `DEPTH` are free.
- `PX_DEPTH` defaults to flush with the HDD standoffs, `NY_DEPTH` to flush
  with the GaN standoffs' -Y edge; `NY_DEPTH` warns when it no longer is.
- **NY2** is an independent second notch on the back edge
  (`SPINE_PLATE_TAPER_NY2_ENABLE`). The -Y edge is the *deeper* of the two
  cuts at every X, so the notches may sit apart, touch, or overlap. The
  edge is traced through the breakpoints of both tapers plus any point where
  their slopes cross (`spine_plate_ny_breaks()`); the outline and the
  lightening boundary share that list, so they always agree. With NY2
  disabled the geometry is identical to the single-taper version.
- **Checks:** `BEFORE + 2·RUN + AFTER` must fit the edge (else the outline
  self-intersects); every taper warns if it cuts past any MB/HDD/GaN
  standoff (the -Y check samples the edge across the standoff's whole width,
  so a slope under it is caught).
- Keep every taper that faces -Y at **RUN ≥ DEPTH** (≤ 45°) — with -Y up in
  the print, steeper tapers overhang.

#### Lightening pattern

`SPINE_LIGHTENING_MODE` (`"diamond"` default, or `"honeycomb"`) cuts a
pattern through the plate.

| Mode | Cell params | Notes |
|---|---|---|
| `"diamond"` | `SPINE_GRID_SLOT_W/H`, `SPINE_GRID_WALL` | Square grid rotated 45° — every wall is a short diagonal, no supports needed. Fewer, larger cells. **Default.** |
| `"honeycomb"` | `SPINE_HONEYCOMB_HEX_R`, `SPINE_HONEYCOMB_WALL` | Best open area per wall; slowest to print. |

A plain axis-aligned grid was removed: with -Y up, any wall running purely
along X becomes a full-width unsupported bridge.

- **Where it stops:** `SPINE_LIGHTENING_MARGIN_PX/NX/PY/NY`, independent,
  may be 0 or negative. PX/NX/NY follow their taper's real edge
  (`spine_plate_*_edge_points()`); PY is a flat line.
- **Applied as an axis-aligned box, not an `offset()` of the outline.** An
  outline `offset()` once left razor-thin through-slivers at the notches'
  reflex corners (a numerical artefact). If you reintroduce one, re-verify
  all notch corners with a full render and probes.
- **Standoff protection:** each standoff's peg *and* its print ramp stay
  solid. Cells aren't clipped by CSG; `grid_2d()`/`honeycomb_2d()` compute
  each cell's world position and skip any whose centre comes within
  `apothem − SPINE_LIGHTENING_STANDOFF_PROTECT_FUDGE` (0.3) of a footprint,
  so protected cells stay whole. `standoff_lightening_protect()` builds the
  footprints and drops standoffs already inside the solid margin (otherwise
  they leave a jog in the margin edge).
- **-Y inlay:** in diamond mode, cut cells whose circumradius reaches the
  -Y boundary are subdivided at `SPINE_LIGHTENING_NY_INLAY_SCALE` (0.4; 0 =
  off), so the clip halves small diamonds instead of big ones.

#### Tiling helpers

`honeycomb_2d()` / `grid_2d()` tile an oversized field and intersect it with
a `[w, h]` rectangle. `honeycomb_2d()` tiles on `r_tile = hex_r + wall/√3`
so the gap between neighbours is exactly `wall` in every direction;
flat-top hexes (`$fn = 6`) tile in columns offset by half a row.
`world_rot`/`world_translate` map cell centres into the frame the protect
data was computed in. `grid_2d()` also takes `inlay_edge_pts`/`inlay_scale`
and recurses once to subdivide a cell near that polyline.

### Standoffs

All standoffs are built along Z, which is **horizontal** as printed. Each
gets a 45° `standoff_ramp()` on its +Y side (`STANDOFF_RAMP_RUN_FACTOR`, 1.0
= 45°) so it grows out of the plate without supports.

#### Motherboard (M3, heat-set inserts)

- **Holes** (`MB_HOLES_RAW`): standard mITX pattern. Edge insets are 5.84 mm
  (-X) / 6.86 mm (+X). `MB_HOLES_X_SHIFT` moves only the standoff pattern
  (and so the board), not the panel; it is 0 = the Sep 25 print, where +X
  sat flush. The ~1 mm -X overhang was fixed by widening the face instead
  (1.02 was never printed and would push +X ~1 mm proud).
- **Height:** plate top 9.6 → PCB underside 15.6 (6 mm).
  `MB_POS[1]` = -`FRONT_PANEL_THICKNESS` - `MB_PANEL_GAP` - 85 = -87.8
  (PCB edge 0.3 mm behind the panel; was -90 / 2.5 mm).
- **Heat-set inserts** (`MB_HEAT_INSERT = true`, default): a blind bore of
  `MB_INSERT_HOLE_DIA` (4.0) × `MB_INSERT_LEN + MB_INSERT_DEPTH_EXTRA`
  (5.7 + 1.0) from the standoff top, for a common M3×5.7 insert (Ruthex /
  CNC Kitchen style, knurl OD ~4.6). The M3 clearance bore
  (`STANDOFF_HOLE_R` 1.9) continues below it. The bore is deeper than the
  6 mm peg, so it is also cut into the plate (bottom Z 8.9).
- **Wall:** `MB_STANDOFF_R = max(STANDOFF_R, hole/2 + MB_INSERT_MIN_WALL)` =
  max(3.5, 2.0 + 1.8) = **3.8 mm** (7.6 OD; still inside the ~10 mm ITX
  mounting-hole keep-out). 1.8 rather than the usual ~1.5 because the
  insert's radial push acts across layer lines in this orientation. 2.0
  would put the two -X standoffs 0.16 mm past the plate edge (the edge is
  2 mm inside the MB, the holes 5.84 mm in). With inserts off, the
  standoffs revert to 3.5 mm with a plain clearance bore.

#### HDD (6-32 UNC, O-ring isolated)

- **Holes** (SFF-8301 Rev 1.9, Fig 3-1 / Table 3-1): A5 = 3.18 in from each
  long side (95.25 across); A7 = 41.28 from the connector end (-Y) to the
  first pair; A13 = 76.20 from *that pair* to the far pair (A6 = 44.45 for
  drives with only the middle pair). Seagate Exos uses A7 + A13 → a
  95.25 × 76.20 rectangle. (A13 was once wrongly measured from the drive
  end, putting the second pair only 34.92 mm behind the first.)
- `HDD_STANDOFF_R` 5, bore `HDD_STANDOFF_HOLE_R` 2.3, O-ring pocket
  `HDD_ORING_POCKET_DEPTH` 1.56 (~12.5% compression of AS568-007).
- **Pass-through access:** screws go in from the MB side, through the
  plate and standoff, into the drive's own threads.

#### GaN PSU (M3 nylon flat heads, O-ring thermal break)

- **Holes** (`GAN_PSU_HOLES`) from HDPLEX's STEP ("same as HDPLEX 200W /
  400W ACDC"). Screw sites (world) X 39.85 / 73.15, Y -18 / -162 — all under
  the MB.
- **Stack:** plate underside 6.6 → peg `GAN_STANDOFF_H` **1.0** (free; was
  2.67, shortened to lift the PSU) → O-ring gap `GAN_ORING_POCKET_DEPTH`
  1.43 → PSU top. So `GAN_PSU_POS[2]` = 6.6 − 1.0 − 1.43 − 12.5 = **-8.33**
  (a literal; `new_spine()` warns if it drifts from `GAN_STANDOFF_H`). The
  O-rings, not the peg, are the thermal break, so the short peg only trades
  air gap above the PSU.
- **Countersink:** `GAN_SCREW_CS_DIA` 6.4 × `GAN_SCREW_CS_ANGLE` 90° in the
  plate's top face, full diameter exactly at the surface so the head sits
  flush (a DIN 965 M3 head is 5.5–6.0, so it lands flush to ~0.45 mm under).
  It prints as a horizontal 45° cone. Bore `GAN_STANDOFF_HOLE_R` 1.9; the
  countersink centres the screw.
- **PSU DC outputs:** all four headers (24-pin Molex 46207-1024, 8-pin EPS,
  8-pin PCIe, 4-pin SATA) are on one 170×55 face within ~30 mm of one end.
  Here that face is -Z and the cluster is at the rear (-Y); the AC pigtail
  exits the front toward the C14.

### Front panel — upper (rear I/O)

`FRONT_PANEL_THICKNESS` = 2.5 (front face Y = 0). Spans the plate bottom
to `FRONT_PANEL_TOP_Z`.

#### Port cutout

The panel is the I/O shield: the port holes come straight from
`asrock_b860i_io_shield.stl`, flattened with `projection()` and extruded
through the full panel thickness (the STL's own 0.25 mm depth isn't
trusted).

- The projection is solid *with* holes, so the cut is its complement inside
  a square inset by `IO_SHIELD_EDGE_INSET` (1.0) — the inset keeps the
  shield outline itself from cutting a slot; it must stay smaller than the
  nearest port's distance to the shield edge.
- `IO_SHIELD_STL_SIZE = [155.0, 40.5]` must equal the STL's bounding box.
  (It was [154.75, 40.75]; the extra 0.25 mm cut a hairline slot across the
  panel at Z ≈ 55.3, hidden until the panel grew above 55.)
- It is centred in the ATX-derived I/O rectangle `FRONT_PANEL_IO_OFFSET`
  (`[x_min, x_max, z_min, z_max]` relative to `MB_POS[0]` / board bottom).
  Shield-local y = 0 is the HDMI/DP end, which maps to world Z under
  `rotate([90,0,0])` (verified: DP renders above HDMI).
- `IO_SHIELD_Z_SHIFT = 2.0` is a test-fit correction: the first print had
  the ports ~2.0 mm (-X end) / ~1.5 mm (+X end) above their cutouts. 2.0 is
  taken from the -X end, which has a standoff 9.5 mm from the I/O edge;
  the +X end's nearest standoff is ~32 mm back, so it can sag. Moves only
  the cutouts.

#### Port pocket

A recess in the panel's back face under the port cluster, so connectors
that stick out past the PCB can nest into the panel and plugs pass through
less wall.

| Parameter | Value | Real / free |
|---|---|---|
| `MB_PANEL_GAP` | 0.3 | free — PCB edge to panel back face |
| `IO_PORT_OVERHANG` | 1.0 | **real** — calipered (furthest housing) |
| `IO_PORT_CLEARANCE` | 0.5 | free — connectors get 1.0 + 0.5 = 1.5 mm of room |
| `IO_POCKET_DEPTH` | 1.2 | free — 0.3 + 1.2 = 1.5 mm; leaves a **1.3 mm** skin over the ports |
| `IO_POCKET_MARGIN` | 2.0 | free — housing size beyond its hole, per side |
| `IO_POCKET_EXTRA_NX` | 2.5 | free — extra on -X only (below) |
| `IO_POCKET_EXTRA_PZ` | 3.0 | free — extra on +Z only (below) |
| `IO_POCKET_SCREW_WALL` | 1.0 | free — solid ring kept around each top-edge countersink |

- **One rectangle**: the hull of per-column bands from the PCB top (the
  housings sit on the board) to the highest opening, grown by the margin.
  One big pocket gives more room for error than per-stack pockets, at the
  cost of the ribs between stacks. (An earlier hull-of-holes version cut
  ~2 mm into the video and audio stacks' boxes.)
- **Audio housing:** the audio stack (-X-most column, jacks at X
  -56.61..-48.61) has a metal housing reaching 2 mm past its holes on -X —
  exactly the margin, i.e. zero air. `IO_POCKET_EXTRA_NX` stretches the
  pocket 2.5 mm further on -X (4.5 mm past the jacks). The nearest feature
  is the -X corner screw's keep-out, ~12 mm away.
- **Wi-Fi housing:** the metal housing around the antenna connectors hit
  the panel above the pocket in a test fit, so `IO_POCKET_EXTRA_PZ` raises
  the pocket's top by 3 mm (54.23 → 57.23), leaving a 1.97 mm full-thickness
  strip below the panel's top edge (59.2). The top-edge screw keep-outs are
  still subtracted.
- Pocket extent: X -61.12 .. 83.75, Z 15.20 .. 57.23. It's on the back face
  (the top as printed), so no supports.
- `front_panel_upper()` warns if the overhang plus clearance doesn't fit, or
  if `MB_POS[1]` drifts from `MB_PANEL_GAP`.

#### USB-C overmold relief

USB Type-C leaves almost no room for a panel in front of the receptacle
(USB Type-C Cable and Connector Spec R2.0): the plug's exposed shell is
**≥ 6.51 mm** (Fig 3-3), the receptacle's effective shell length is
**6.20 ± 0.20 mm** (Fig 3-1, note 7), and the overmold should clear the
exterior surface by **≥ 0.05 mm** when seated (Fig 3-80). That allows
6.51 − 6.20 − 0.05 ≈ **0.26 mm** between the receptacle front and the outside
of the case nominally, and ~0.06 mm worst case — effectively flush. Here
the receptacle front sits ~1.8 mm behind the face (PCB edge Y -2.8 + ~1 mm
port overhang), so only cables with extra-long plugs seat. Shaving 0.3 mm
off the skin would leave 1.5 mm — still far outside the spec.

Instead, `USB_C_RELIEF` cuts an overmold-sized pill (`USB_C_RELIEF_SIZE`
13 × 7, free) through the panel around the USB-C port, so the overmold
passes the face into the pocket and the plug seats regardless of panel
thickness. `USB_C_RELIEF_CENTER` is the port centre in shield-STL
coordinates ([116.14, 5.25], from `asrock_b860i_io_shield.scad`: mirrored
stack-1 X plus `usbc_x_offset`). World extent X 42.63..55.63, Z 18.52..25.52,
leaving 2.25 mm of wall below the USB-A above it. Caliper your cable's
overmold and resize if it is larger (thick braided cables can be).

### Front panel — lower (HDD / PSU side)

#### HDD grill

`HDD_GRILL_MODE` (`"diamond"` / `"honeycomb"`) around the drive's front
face, with independent `HDD_GRILL_MARGIN_*`. `HDD_GRILL_MARGIN_BOTTOM` =
6.83 extends it down into the grown face while keeping a ~1.46 mm solid
border above the bottom edge (9 when the face was 94 tall, −2.17 with the
trim). `HDD_GRILL_WALL` applies to both modes; diamond cells use their own
`HDD_GRILL_DIAMOND_SLOT_W/H`.

- Any cell within `FRONT_PANEL_SCREW_GRILL_WALL` (1.2) of a mount-screw
  countersink stays solid. In grill-local coordinates x = X − grill_x,
  y = −(Z − grill_z); the protect test is centre-vs-apothem, so the rotated
  cell's circumradius is added.
- `FRONT_PANEL_CORNER_INFILL_X/Z` cuts a guard wedge out of the pattern at
  the +X/−Z corner screw.

#### Game of Life shapes (diamond mode)

Up to four `[SHAPE, ANCHOR]` slots (`GOL_Grill_N_SHAPE` / `_ANCHOR`) leave
cells solid in a pattern. `SHAPE = GOL_OFF` disables a slot. Currently slots
1 and 3 use `LIFE_HEX_RING`; 2 and 4 are off.

- `LIFE_BLOCK` (2×2), `LIFE_BEEHIVE`, `LIFE_POND` are still-life
  silhouettes. BEEHIVE/POND get a bridge cell at each diagonal-only joint so
  every cell shares a full edge (no longer Life-stable, but prints as one
  shape). `LIFE_HEX_RING` is BEEHIVE's outline deliberately *without*
  bridges.
- `ARROW_GT_2/3`, `ARROW_LT_2/3` are plain chevrons: two straight index-space
  lines sharing a corner cell; the grid's 45° rotation renders them
  diagonal.
- `ANCHOR` is a `grid_2d()` index `[i0, j0]` in the *pre-rotation* lattice
  (step = slot + wall); `diamond_anchor(x, y)` converts intuitive steps.
  Check the whole shape lands on the grill, not just the anchor — cells past
  the grill edge silently do nothing. `life_pattern_protect_pts()` turns a
  shape into zero-radius protect points, reusing the standoff-protection
  mechanism.

#### C14 inlet

- **Current socket:** the HDPLEX-supplied screw-mount C14, switching to a
  variant with **right-angle pins**, which removes the earlier clash between
  the socket's rear body/terminals and the HDD (the straight socket reached
  Y -28.6 vs the drive front at -22.5). The model still uses
  `c14_socket.stl` for the cutout — confirm the right-angle socket's front
  lip and flange match it.
- `C14_POS = [-52.5, -2, -9.83]` (X free; Z free — lowered 4 mm when the
  face grew, then raised 2.17 with the bottom trim). `C14_ROT = [270, 180, 0]`.
- **Mounting:** socket from inside, eared flange against the back face;
  M3×10 90° countersunk from outside → panel → flange → **M3 nyloc nut**
  (the flange holes are plain 3.2 mm clearance). `C14_SCREW_PITCH` 42 runs
  along world X for this `C14_ROT` (re-check if the rotation changes);
  countersinks match the front-panel screws (6.4 × 90°).
- **Datum:** the socket's front face is flush with Y = 0.
  `c14_solid_tool()` pockets the 2 mm front lip and cuts the body; the
  eared flange spans Y -5..-2 against a back face at -2.5, so
  `c14_flange_pocket()` cuts the flange outline into the back face (sliced
  from the STL mid-flange at local z -1.5, screw holes closed, +0.3 mm
  clearance). Screw-mount only.
- **Fit trims** (`c14_tool.scad`, total mm, negative grows; local X → world
  X, local Y → world Z): test fit had the lip pocket ~1.0 mm too tall and
  ~0.25 mm too wide, so 31.6 × 22.6 → 31.35 × 21.6
  (`C14_FLANGE_TRIM_X/Z` = 0.25 / 1.0). `c14_trim_2d()` keeps corner radii
  and is valid while each straight side is longer than the trim. Base fit
  clearance 0.3 mm.
- `USE_SNAP_IN_C14` switches to the snap-in model (cutout
  `C14_SNAP_CUTOUT_W/H` 28 × 20.5).

#### Disabled features

The GaN power-cable opening, the PSU front-mount screws, and the small
MB↔PSU vent-bar grill are **not cut** (their code was disabled, and has
been removed from the file; it's in git history). `GAN_CABLE_CUTOUT_*`,
`GAN_FRONT_MOUNT_*` and `FRONT_VENT_*` remain as unused parameters. The
front-mount spacing was never verified — the real PSU uses a length-wise
rail (177 × 35 mm, M3).

### Front panel mounting screws

Six M3 × 90° countersunk holes, heads flush at Y = 0: the four outer
corners plus mid-X on the top and bottom edges.

- Insets `FRONT_PANEL_SCREW_X/Z_INSET` = 5 to the hole centre, so the
  countersink edge is 5 − 3.2 = **1.8 mm** from the panel edge (was
  3.5/4.0 → 0.3/0.8 mm).
- `FRONT_PANEL_SCREW_R` 1.7 (3.4 mm clearance; was 1.5, a thread-forming
  fit). Cone reaches full diameter exactly at the face (it used to leave
  heads 0.5 mm proud).
- X positions derive from the enclosure X extent (outer corners 5 mm in,
  mid at the face centre X 2.75); Z from each panel's outer edge.
  `FRONT_PANEL_MOUNT_OFFSET_UPPER/LOWER` add per-hole `[dx, dz]` nudges (all
  0 now); the grill keep-out follows.
- The lower +X corner used to be skipped for the GaN PSU; since the face
  grew it sits well below the PSU.

### CPU cooler and fan intake clearance

The cooler is a downdraft unit: the fan sits on the fin stack and fires
**−Z**, so the panel above faces the fan's **intake**. `FAN_PANEL_GAP` =
**5 mm** from the intake face to the panel's inner face (free; don't go
below ~4).

#### Why 5 mm

Vent cell size must be ≤ the gap (or the blades see jets), and honeycomb
open area is `(c/(c+t))²` with a printable web `t` ≈ 1.0 mm — so a smaller
gap forces smaller cells and less open area. Thick-orifice model
(`K = (1/(Cd·σ))² − 1`, `Cd ≈ 0.88` chamfered), 92 mm fan at ~40 CFM
(3.5 m/s, 7.4 Pa dynamic head):

| Gap | Max cell | Open area | ΔP sharp | ΔP chamfered |
|----:|---------:|----------:|---------:|-------------:|
| 2 mm | 2 mm | 44% | 90 Pa | 41 Pa |
| 3 mm | 3 mm | 56% | 53 Pa | 23 Pa |
| 4 mm | 4 mm | 64% | 39 Pa | 16 Pa |
| **5 mm** | **5 mm** | **69%** | 32 Pa | **12 Pa** |
| 8 mm | 8 mm | 79% | 23 Pa | 8 Pa |
| 15 mm | 15 mm | 88% | 17 Pa | 5 Pa |

A low-profile 92 mm fan makes ~15–25 Pa. Below ~4 mm the vent eats a large
share of that; above ~6 mm the curve flattens. **5 mm is the knee.** A
*solid* panel vented only at the perimeter would need ~19 mm instead.

Vent rules that go with it: cells ≤ 5 mm with ~1.0 mm webs (hex, not round
punch — punch patterns are only 35–40% open); **chamfer the intake side**
(Cd 0.6 → 0.88, roughly halving the loss); perforate out to ~112 mm square
over the fan and no further.

#### Stack-up

```
MB_PCB_TOP_Z      17.2   = MB_POS[2] − MB_SIZE[2]/2 + MB_PCB_THICK
CPU_COOLER_HEIGHT 37.0   real, Thermalright low-profile, PCB top → fan top
CPU_COOLER_TOP_Z  54.2
FAN_PANEL_GAP      5.0
FAN_PANEL_INNER_Z 59.2   = FRONT_PANEL_TOP_Z   (was a hard-coded 55 from the reference STL)
```

The cooler block uses `MB_PCB_TOP_Z`, so it must stay below the MB block in
the file. `cooler_clearance_report()` echoes this every render and warns if
the gap drops below 4 mm, the panel overshoots the enclosure top (60.5), or
`MB_SIZE[2]` understates the cooler.

> **Assumption:** `CPU_COOLER_FAN_D = 92` (AXP90 class) — verify. The table's
> percentages are portable; the Pascals are a first-order Idelchik model,
> ±40%.

> **Known discrepancy:** `MB_SIZE[2] = 38` puts the MB envelope top at 53.6,
> 0.6 mm below the cooler. Don't fix it by editing `MB_SIZE[2]` alone —
> `FRONT_PANEL_IO_OFFSET` hangs off the board bottom, so also move
> `MB_POS[2]` by half the change.

### PSU 24-pin routing (SC Shift adaptors)

Enabled with `SHOW_GAN_BLOCKS`. Plan: Singularity Computers "Shift
Motherboard 24pin 180 Degree Adaptor Short" (SC-A-180-24-S, rigid dual-layer
PCB), one on each header, turning the two sockets to face each other.

- `SC_ADAPTOR_SIZE = [52, 32, 22]` (real). The 32 is the **lateral offset**
  between its two connectors, not a length; it runs along world -Y here.
  (The non-Short variant is 42 × 52 × 22: 52 mm offset.)
- PSU side: mates onto the down-facing 24-pin (`GAN_24PIN_*`: Mini-Fit Jr
  12×2 @ 4.2 mm, 51 × 10, header 11 mm — real; inset 8 mm from the rear end
  — free), turns it up, offset -Y so the socket clears the plate's rear
  edge. MB side: mates onto the up-facing MB 24-pin and turns it down,
  landing above the PSU adaptor's socket.
- **Unconfirmed:** assumes the MB 24-pin sits at `MB_24PIN_IMPLIED`; not yet
  checked against the real B860I.
- 24-pin cables are specified connector face to face, so
  `SC_CABLE_FREE_SPAN` (board top − PSU bottom) *is* the cable length to
  order. Practical floors: `SC_MIN_SPAN_FLAT` 45 mm (flat/ribbon custom),
  `SC_MIN_SPAN_ROUND` 70 mm (round bundle; the HDPLEX in-box short cable is
  ~70). `gan_adaptor_report()` echoes the span, the implied MB header
  position, the rear chase depth, and warns if the span is too short or the
  junction still overlaps the plate.
- `SHOW_GAN_PSU_500W` shows a fit-check box for the HDPLEX 500W GaN
  (200.2 × 55 × 40) in the same slot.

## Printing

### Orientation

Print with the spine's **+Y face (the front panel) down**, build direction
+Y → −Y. Consequences:

- **Standoffs** lie horizontal, so each has a 45° ramp on its +Y side. The
  ramp is two `hull()`s: peg → constant-width bar, then the bar tapering
  flush to the plate over `run`.
- **Standoff and plate bores** (3.8–7.64 mm) are horizontal but small enough
  to bridge; the 7.64 mm HDD O-ring pocket is the one to test first. MB
  insert bores (4.0 mm) may print slightly oval — heat inserts tolerate it.
- **Front-panel holes** are vertical in this orientation — no concern.
- **The I/O pocket and C14 flange pocket** are on the panel's back face, the
  top as printed.
- **No lightening wall may run purely along X** (see
  [Lightening pattern](#lightening-pattern)).
- **-Y-facing tapers ≤ 45°** (RUN ≥ DEPTH).

### Print guide

Tested on a Prusa MK4S, PETG, 0.4 nozzle, 0.25 mm profile (~4.5 h). The spine
is a 3 mm wall ~175 mm tall anchored only at the front panel, so the top
half tends to wobble. In order of cost:

1. **Orient on the bed (free).** The MK4S bed moves in Y. Put the front
   panel's 170 mm edge front-to-back so bed motion runs along the plate's
   stiff in-plane direction.
2. **Minimum layer time 8–10 s** (Filament → Cooling). ~No added time.
3. **Slow the top ~75 mm** (above ~100 mm), +45–90 min. Either live
   (**Tune → Speed → 60–70%** at ~100 mm) or baked in via a custom G-code at
   ~100 mm on the layer slider:
   ```
   M220 S65          ; 65% speed from here up
   M201 X1000 Y1000  ; cap acceleration (verify your firmware honours it)
   ```
   A height-range modifier changes speeds but not accelerations — weakest.
4. **Still wobbling?** `SPINE_GRID_WALL` toward 2.0–2.5, a larger
   `SPINE_LIGHTENING_MARGIN_NY`, or breakaway braces from the front panel.

## Hardware and assembly

Two thread standards: **M3** everywhere except the HDD's **6-32 UNC**.

| Joint | Qty | Thread | Length | Head | Notes |
|---|---|---|---|---|---|
| Motherboard → standoffs | 4 | M3 | 6 mm (8 max) | pan / socket | Into **M3×5.7 heat-set inserts** (4). M3×6 through the 1.6 mm PCB engages ~4.4 mm; M3×8 still bottoms clear. With `MB_HEAT_INSERT = false`: M3 thread-forming screws into a 3.8 mm bore. |
| HDD → standoffs (from MB side) | 4 | **6-32 UNC** | 3/8" (9.53 mm)† | pan / button | Into the drive's bottom holes. The screw touches only the two O-rings and the drive threads. **Not** countersunk — the O-ring needs a flat face. |
| HDD isolation O-rings | 8 | — | AS568-007 (ID 3.68, OD 7.24, CS 1.78 mm) | silicone 70A | Two per standoff: under the head and between standoff and drive. |
| GaN PSU → standoffs (from MB side) | 4 | M3 | **10 or 12 mm**‡ | **nylon, 90° flat head** (DIN 965 / ISO 7046) | Into the PSU's tapped holes. Head flush in the plate top, so nothing stands proud under the MB's solder pins. |
| GaN isolation O-rings | 4 | — | 5/32" ID × 9/32" OD × 1/16" CS (3.97 / 7.14 / 1.59 mm) | silicone 70A | **One** per screw, between standoff face and PSU body. Thermal break. |
| Front panel → shell | 6 | M3 | TBD | 90° flat head | All four corners + top/bottom mid. Length depends on the unbuilt shell. |
| C14 inlet → panel | 2 | M3 | 10 mm | 90° flat head | From outside, with **M3 nyloc nuts** behind the flange. |

† Plate 3 mm + standoff gap + ≥3 mm engagement (SFF-8301 minimum) was made
to land on 3/8" by adjusting `HDD_POS[2]`. 5/16" leaves only 0.38 mm of wall
around the O-ring pocket; 7/16" pushes the drive past the enclosure floor.

‡ Flat-head length includes the head: plate 3 + peg 1.0 + O-ring gap 1.43 =
5.43 mm before the PSU body. M3×10 leaves ~4.6 mm of thread in the PSU,
M3×12 ~6.6 mm. Nylon threads are weak, so **use M3×12 if the PSU's holes are
≥ 7 mm deep**, otherwise M3×10. The depth isn't in the STEP — probe it.

### GaN PSU thermal isolation

A stress-tested HDPLEX 250W GaN measured up to 58 °C at the case surface —
close to PETG's heat-deflection point for a joint under constant load. One
silicone O-ring per screw keeps the aluminium off the plastic; compression is
deliberately light.

Why nylon flat heads (replacing steel pan heads on a second O-ring):

- **Heat:** nylon conducts ~100× less than steel, so the screw no longer
  bridges heat past the O-ring — the head-side O-ring was dropped.
- **Board clearance:** the screws sit 6 mm under the PCB. A pan head on an
  O-ring stood ~4 mm proud (~2 mm from the solder pins); the countersunk head
  is flush, and nylon can't short anything.
- **Strength:** an M3 nylon 6/6 screw holds ~200 N+; the PSU is well under
  1 kg across four screws.

Install:

- **Target ~5–10% compression.** Thread in until the O-ring just touches
  both faces, then **1/6–1/3 turn** more (0.5 mm pitch → 0.08–0.17 mm of the
  1.59 mm cross-section). One O-ring means each turn compresses twice as
  much as the old two-O-ring stack.
- The seated head is a stop for the head only — further turning keeps
  squeezing the O-ring. **Don't torque nylon:** M3 strips at ~0.3 N·m.
- `GAN_ORING_POCKET_DEPTH` (1.43) is the nominal gap (~10%); the turn count
  is the real reference.
- Nylon creeps when warm; re-snug ~1/8 turn if the PSU ever rattles.

### HDD vibration isolation

Two O-rings per standoff carry the whole clamp load; there is **no hard
stop**, so "snug it down" is wrong here.

- **Target 10–15% compression.** Thread until resistance is first felt, then
  **1/2–2/3 turn** more (6-32 advances 0.79 mm/turn; the two O-rings in
  series halve the compression per turn).
- `HDD_ORING_POCKET_DEPTH` targets 12.5% assuming a nominal 1.78 mm
  cross-section; the turn count is the real reference.

### Motherboard heat-set inserts

Press the M3×5.7 inserts in with a soldering-iron tip at PETG temperature,
straight down the standoff axis. The 1 mm of extra bore depth takes the
displaced plastic. If you use a different insert, set `MB_INSERT_HOLE_DIA`
/ `MB_INSERT_LEN` to its spec — the standoff radius and bore depth follow,
and warnings fire if the wall drops below `MB_INSERT_MIN_WALL` or the bore
leaves < 1 mm of plate.

## Self-checks (console warnings)

| Warning | Fires when |
|---|---|
| `PCB front edge is … not MB_PANEL_GAP` | `MB_POS[1]` drifts from the gap |
| `IO connectors stick out …` | overhang + clearance > gap + pocket depth |
| `panel bottom is … below the PSU` | face bottom drifts from `FRONT_PANEL_PSU_CABLE_GAP` |
| `SPINE_PLATE_TAPER_* BEFORE + 2*RUN + AFTER …` | a taper doesn't fit its edge |
| `SPINE_PLATE_TAPER_NY_DEPTH … no longer matches` | NY waist not flush with the GaN standoffs |
| `… cuts past a MB/HDD/GaN standoff` | a PX, NX, or NY/NY2 taper eats into a standoff |
| `MB insert wall is …` / `MB insert bore bottom …` | insert wall too thin / bore too deep |
| `GaN standoff pegs are …` | `GAN_PSU_POS[2]` drifts from `GAN_STANDOFF_H` |
| `FAN_PANEL_GAP …`, `MB envelope top …`, `panel top …` | cooler clearance report |
| `span …`, `the adaptor junction …` | SC adaptor report (`SHOW_GAN_BLOCKS`) |

Currently firing: `SPINE_PLATE_TAPER_NY_DEPTH` (NY_DEPTH 38 vs a flush value
of 10 — set it or accept the mismatch) and the MB envelope
discrepancy above.

## Known open items

- Outer shell not modeled; front-panel-to-shell screw length is TBD.
- The C14 cutout still uses the straight-pin `c14_socket.stl`; confirm the
  right-angle socket's lip/flange match.
- The GaN power-cable opening, PSU front mounts, and MB↔PSU vent grill are
  disabled (see [Disabled features](#disabled-features)).
- Lightening pattern and grills are sized for printability, not validated
  thermally.
- MB 24-pin position for the SC adaptor plan is unconfirmed.
- MB envelope is 0.6 mm shorter than the cooler (see
  [fan clearance](#cpu-cooler-and-fan-intake-clearance)).
