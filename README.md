# Fish Case — ITX Layout Study

A parametric OpenSCAD model built around the ["4.7L Mini ITX case, easily
printable (2 major pieces)"](https://www.printables.com/model/143897-47l-mini-itx-case-easily-printable-2-major-pieces)
design. The original case pairs a fish-shaped **spine** (structural divider +
motherboard standoffs) with an outer **shell**. This project keeps the
spine's general "sandwich" concept — a divider plate between a motherboard
compartment and a GPU/PSU compartment — but redesigns the lower compartment
around a different hardware set:

- **GPU → 3.5" HDD**, mounted via damping/grommet screws
- **Standard ATX/FlexATX PSU → HDPLEX 250W GaN AIO ATX PSU**

The outer shell itself has not been redesigned yet — this file is a layout
and mounting study for the spine only.

## Files

| File | Purpose |
|---|---|
| `fish_case.scad` | The working model — everything described below. |
| `basic_layout.scad` | An early snapshot, kept for reference. |
| `4.7-Fish_-_spine.stl` | Original spine reference geometry (source: printables.com link above). Its front I/O opening dimensions, retention-groove geometry, mounting-hole layout, and outer-edge taper shape were all measured from this file; the new spine is otherwise built from scratch. |
| `4.7-Fish_-_case.stl` | Original outer shell reference geometry — not yet used in the model. |
| `4.7-fish-step.step` | Original design in STEP format. |

## Using this file

- Requires OpenSCAD **≥ 2019.05** (uses `offset()`, needed for the divider
  plate's lightening pattern).
- `used_components = false` near the top of `fish_case.scad` toggles
  `SHOW_MB`/`SHOW_HDD`/`SHOW_GAN_PSU` together — flip it to `true` to show
  translucent reference boxes for the actual hardware footprints alongside
  the printed geometry, useful when checking clearances. Leave it `false`
  for a clean export.
- `SHOW_SPINE` / `spine_ref()` imports the *original* reference STL
  (translated/rotated to a comparison pose) — this is how nearly every
  "real" measurement in this file was taken (DXF projections and
  cross-sections through it; see the Conventions section below). It's not
  part of the printed model and should stay `false` unless you're
  re-measuring something against the reference.
- `SHOW_ODD` / `ODD_SIZE` / `ODD_POS` is a leftover placeholder for a slim
  optical drive that was considered early on and never integrated — it's
  not wired into `new_spine()` at all, just a floating reference box. Safe
  to ignore or delete; it doesn't affect the real model.
- To export a printable STL: set `SHOW_NEW_SPINE = true`, everything else
  (`SHOW_SPINE`, `SHOW_ENCLOSURE`, `SHOW_ODD`, `used_components`) `false`,
  then **F6 (Render)** before exporting — not F5 (Preview). The divider
  plate's honeycomb/diamond lightening pattern in particular is slow
  and can render incorrectly in Preview; always confirm on a full Render.
- After changing any parameter, **check the console output for `WARNING:`
  lines** before trusting the result — see Conventions below.

## Conventions

Ground rules this project has settled on, worth knowing before changing
anything:

- **Real hardware numbers and free/adjustable numbers are both allowed,
  but always labeled which is which.** Most dimensions here come from a
  verifiable source (a datasheet, a spec whitepaper, a manufacturer's own
  STEP file, or direct measurement off the reference STL) — comments say
  exactly where each one came from and how confident it is. Some
  parameters (taper `DEPTH`s, wedge geometry, lightening-pattern cell
  size) have no real-world reference and are intentionally free — those
  say so explicitly too. When a parameter defaults to a real-hardware
  value but is still meant to be freely adjustable (e.g. the taper
  `DEPTH`s), the model computes the real value at render time and
  **echoes a `WARNING:`** if your number has drifted from it, rather than
  silently accepting a mismatch or silently overriding your choice.
- **A manifold render does not mean the parts are actually connected.**
  OpenSCAD's `--render` "Top level object is a 3D object (manifold)"
  check only proves the *union* is watertight — a union of two
  individually-valid but spatially-disjoint solids still reports as
  manifold. This bit twice during development (a taper cutting a standoff
  loose from the plate; a wedge left floating past a panel edge) before
  the STL-intersection-probe method below became standard practice.
- **Verify real connectivity with STL-intersection probes, not just a
  render.** Export the model to STL, then `intersection()` it against a
  small probe cube at a specific coordinate in a throwaway scratch file:
  `openscad --render -o probe.stl probe.scad` where `probe.scad` is
  `intersection() { import("model.stl"); translate([x,y,z]) cube([s,s,s]); }`.
  `Current top level object is empty` at a point that should have
  material (or real vertex/facet output at a point that should be open
  air) means something is actually wrong, even if the full-model render
  reported no error. This is how every taper, wedge, and lightening-mode
  change in this file has been checked.
- **After changing any parameter, check the console for `WARNING:`
  echoes.** The file has several deliberate self-checks built in (taper
  `DEPTH` mismatches, MB-standoff disconnection risk from the -X taper,
  wedges skipped for lack of IO-groove clearance) — they only help if
  someone actually reads the console output after a render.
- **Naming convention**: `PX`/`NX`/`NY`/`PZ`/`NZ` prefixes/suffixes mean
  "which edge/side", not an arbitrary label — `PX` = +X edge, `NX` = -X
  edge, `NY` = -Y edge, and so on, used consistently across the plate
  tapers, the reinforcement wedges, and the IO groove widen parameters.
  `UPPER`/`LOWER` on the wedges means Z (toward the MB compartment or the
  HDD/GaN side), not X.
- **This part has a specific intended print orientation** (+Y face down,
  -Y "up") that isn't just a slicer setting — several design choices
  (standoff ramps, the lightening-pattern mode default) exist because of
  it. See "Print orientation" below before assuming a parameter choice is
  arbitrary.

## What's modeled

- **Divider plate**, shaped to match the reference STL's own outline (not a
  plain rectangle) — trapezoidal taper cuts on all 3 non-I/O edges, flush
  with the HDD standoffs on one side and the GaN PSU standoffs on another.
  Standoffs for the motherboard rise from the top face; HDD and GaN PSU
  standoffs hang from the underside.
- **Front panel reinforcement wedges** — 4 triangular gussets tying the
  (vertical) front panel to the (horizontal) divider plate at each of its
  4 corners, auto-anchored to the plate's real edge so they can't be left
  floating in open air if the taper parameters change later.
- **Front I/O panel, upper portion**: the motherboard's rear-IO cutout
  (real ATX-spec size, measured from the reference STL), plus its real
  two-depth **retention groove** (a snug collar the shield's face seats
  against, then a wider recessed pocket the shield's folded lip snaps
  into), plus 2 M3 corner mounting screws with shell-mating tab slots.
- **Front I/O panel, lower portion**: a GaN PSU power-cable opening, the
  PSU's own front-mounting screws, an HDD honeycomb ventilation grill, a
  small vertical-bar ventilation grill between the GaN cable cutout and
  the MB compartment, and 2 more M3 corner mounting screws (matching the
  upper panel).
- **Divider plate lightening/ventilation pattern** — a honeycomb or
  45°-rotated "diamond" cutout pattern through the plate itself, switchable
  by a single parameter, with automatic clearance around every standoff and
  the plate's own tapered edges.
- **Standoff support ramps**: every standoff (MB/HDD/GaN) gets a 45°
  self-supporting print ramp fused to its +Y side, so the peg doesn't need
  print supports in this part's real print orientation (see below).
- **Pass-through screw access**: the HDD and GaN PSU standoffs hang below
  the plate where a screwdriver can't reach once the drive/PSU are
  installed. Screws for those two joints go in from the **motherboard side**
  instead — through an access hole in the plate, down through the standoff's
  bore, and directly into the HDD's/PSU's own tapped mounting hole.
- **HDD vibration isolation**: the HDD standoffs mount the drive through a
  pair of silicone O-rings per screw instead of a rigid plastic-to-metal
  clamp, so drive vibration doesn't couple straight into the plate (and
  from there, the rest of the case). See "HDD vibration isolation" under
  Hardware below for the real numbers and install instructions.

Most dimensions and hole patterns are pulled from real sources (datasheets,
official spec whitepapers, or — for the GaN PSU — the manufacturer's own
published STEP CAD file) rather than guessed. See the comments in
`fish_case.scad` for exactly where each number came from and how confident
it is; a few (the GaN PSU's front-panel cable/mount cutout, most notably)
are explicitly flagged as simplified placeholders, not verified hardware.

## Print orientation

This part is intended to print with the spine's **+Y face down on the
build plate**, build direction running **+Y → -Y** — i.e. **-Y is "up"**
from the bed's perspective, not the model's own Z axis. This isn't just a
slicer setting; several design decisions in the model exist *because* of
this orientation, and would need re-checking if you ever print it flat
(Z-up) instead:

- **Standoff bodies** (the MB/HDD/GaN pegs) are built along the model's Z
  axis, which is **horizontal** in this orientation — a bare peg would be
  a horizontal cantilever with nothing under it as it printed outward. The
  45° `standoff_ramp()` fused to each peg's +Y side solves this: material
  builds up gradually layer-by-layer *ahead* of the peg's own mass arriving,
  instead of the peg overhanging with no lead-in. `STANDOFF_RAMP_RUN_FACTOR`
  controls the ramp's slope (1.0 = 45°, self-supporting).
- **Standoff/plate screw holes** (MB + GaN M3 bores, HDD 6-32 bore, the HDD
  O-ring pockets) are likewise Z-axis, so also horizontal in this
  orientation — but all of them are small enough (3.8–7.64mm diameter) to
  self-bridge cleanly without dedicated supports; the O-ring pocket
  (7.64mm) is the largest and the one worth test-printing first.
- **Front panel screw holes** (corner mounts + GaN front-mount screws) are
  cut with `rotate([-90,0,0])`, putting their axis along Y — which is
  **vertical** in this orientation. These print as plain round holes with
  zero overhang concern regardless of size.
- **The divider plate's lightening pattern must avoid long straight walls
  aligned with X.** A layer at a given Y is an X-Z cross-section; any
  cutout-pattern wall that runs purely along X becomes a single print layer
  spanning the *entire plate width*, resting only on whatever narrow
  vertical struts happen to sit below it — a real, confirmed unsupported
  bridge. This is why `"honeycomb"` (zigzag walls) and `"diamond"`
  (45°-rotated grid, diagonal walls) are the only two lightening modes —
  neither has a wall segment running purely along X or Y. A plain
  axis-aligned grid was tried and dropped for exactly this reason: every
  row needed print supports in this orientation. See "Divider plate
  lightening pattern" below.

If you ever reorient this part to print flat (Z-up), none of the above
constraints apply.

## Technical reference

Parameter-level detail that's genuinely useful to have somewhere other than
inline comments — the comments in `fish_case.scad` are the authoritative
source for the *exact* current values and any edge-case caveats, but the
*why* behind each system is collected here so it isn't spread across
hundreds of scattered comment blocks.

### Divider plate position, size, and taper shape

`SPINE_PLATE_POS`/`SIZE` are plain, independent `[x,y,z]`/`[w,d,t]` numbers
— not live formulas — matching every other part's `POS`/`SIZE` in this
file. `SPINE_PLATE_MARGIN_X` applies an additional, separately-adjustable
X-only inset on top of those (shrinks the plate symmetrically, recentered);
`0` means the plate's real edges are exactly `POS`/`SIZE` as given. At the
current 0 margin, the plate's -X edge is flush with the front panel's own
-X edge, and its +X edge (before tapering) is flush with the HDD standoffs.

The plate's outline is **not a plain rectangle** — it copies the reference
STL's own trapezoidal taper on all 3 non-I/O edges (+X, -Y, -X), each
controlled by 3 independent parameters:

| | `*_BEFORE` | `*_RUN` | `*_DEPTH` |
|---|---|---|---|
| **+X** (`SPINE_PLATE_TAPER_PX_*`) | flat full-width run before the taper starts | Y-run of the taper itself | X-depth of the indent, measured in from the front panel edge |
| **-Y** (`SPINE_PLATE_TAPER_NY_*`) | flat full-depth run before the taper starts | X-run of the taper itself | Y-depth of the indent, measured in from the plate's full back edge |
| **-X** (`SPINE_PLATE_TAPER_NX_*`) | flat full-width run before the taper starts | Y-run of the taper itself | X-depth of the indent, into the plate from its -X edge |

`BEFORE` and `RUN` are mirrored from both ends of their edge (front/back or
left/right). All 3 `RUN` values were measured directly from the reference
STL's own outline (DXF projection); `BEFORE` values are free/adjustable
(no real reference — the reference STL doesn't have a "before" flat run at
all, it tapers immediately).

`DEPTH` is where the +X/-Y tapers differ from -X: the +X taper's depth
defaults to whatever keeps it flush with the **HDD standoffs**, and the -Y
taper's defaults to flush with the **GaN PSU standoffs** — both are still
plain, independently-adjustable numbers (not live formulas), but
`new_spine()` computes the real flush value each render and **echoes a
warning** if your `DEPTH` has drifted from it (e.g. after moving
`GAN_PSU_POS` or `HDD_POS`). The -X taper's `DEPTH` has no single real
value to flush against, so there's no mismatch warning for it — but it has
a different safety check instead: pushing it too far can cut the plate's
-X edge back past an **MB standoff's own position**, disconnecting it from
the plate (this happened once during development). `new_spine()` checks
every MB standoff's own -X extent against the taper's real edge at that
standoff's Y and echoes a warning if the taper has eaten into it.

### Front panel reinforcement wedges

4 triangular gussets (right-triangle cross-section in the Y-Z plane,
extruded in X) tying the front panel to the divider plate at its 4
corners: `WEDGE_PX_UPPER`, `WEDGE_PX_LOWER`, `WEDGE_NX_UPPER`,
`WEDGE_NX_LOWER`. Naming: `PX`/`NX` = which plate edge it anchors to (+X
near the HDD standoffs, -X on the opposite side — same convention as the
taper parameters above); `UPPER`/`LOWER` = Z, reaching up toward the MB
compartment or down toward the HDD/GaN side.

Each wedge has independent `Y1`/`Z1`/`Y2`/`Z2`/`THICKNESS` — the
right-angle corner sits at `(Y1, Z2)`, the real physical corner where the
panel meets the plate. **X position is auto-anchored, not fully free**:
each wedge sits flush with the plate's real edge at whatever X that edge
is *at the wedge's own `Y2`* (via `spine_plate_px_edge()`/
`spine_plate_nx_edge()`), so it stays correctly attached even if the taper
parameters above change later — a plain fixed X would risk leaving the
wedge disconnected from the plate if a taper ever moved past it. Each
wedge also has an `X_OFFSET`, layered on top of that auto-anchor (same
pattern as `SPINE_PLATE_MARGIN_X`): `0` reproduces the flush position,
positive shifts toward +X, negative toward -X — regardless of which edge
the wedge is on. Push it too far and it either buries into the plate
(harmless) or pulls away from the real edge into open air (disconnects it)
— worth a render + connectivity check after changing it.

The two `UPPER` wedges additionally get their `Z1` clamped below the IO
shield retention groove's real, `MB_POS`-aware footprint (`io_groove_
bounds()`), so a moved MB can't leave a wedge anchored to panel material
the groove has since hollowed out. If there's no clearance left at all,
the wedge is skipped rather than built broken — watch the console for a
`WEDGE_*_UPPER skipped` warning.

### IO shield retention groove

Real, measured geometry (cross-sectioned from the reference STL, not
guessed): stock ATX IO shields are stamped steel with a folded-back
perimeter lip. The shield's flat face registers against a snug **collar**
(`FRONT_PANEL_IO_COLLAR_DEPTH`, exactly the nominal IO rectangle size,
`FRONT_PANEL_IO_OFFSET`), and that folded lip snaps into a **wider pocket**
recessed just behind it — like a picture frame's rabbet. The widen amount
is independent **per side** (`FRONT_PANEL_IO_GROOVE_WIDEN_NX/PX/NZ/PZ`),
not one shared number: 3 sides are at the real measured value (3.25mm),
but `PX` is intentionally reduced (currently 1.25mm) to reclaim clearance
to the front panel's own outer edge — the real geometry there put the
groove within under 1mm of breaching straight through the panel face. That
gives the shield's lip a shallower bite on that one side only; still
expected to hold since a stamped shield doesn't need uniform grip around
its whole perimeter.

### Divider plate lightening pattern

`SPINE_LIGHTENING_MODE` (`"honeycomb"` or `"diamond"`) selects between 2
interchangeable cutout patterns through the plate's own Z thickness — same
idea as the HDD grill, but cut through the structural divider plate instead
of a thin panel. A plain axis-aligned `"grid"` mode existed early on and
was removed - see "Print orientation" above for why (every row would have
needed print supports in this part's real orientation).

**Where the pattern stops** is independent per side —
`SPINE_LIGHTENING_MARGIN_PX/NX/PY/NY` (PX/NX/NY = same edges as the taper
params; PY = the plate's plain, untapered +Y edge). Each is a real,
independent limit, not layered on a shared floor: any of the 4 can go down
to 0, or negative (letting the pattern reach past that edge, which the
plate's own real outline then naturally clips), with no minimum enforced.

That freedom is safe specifically because of *how* the margin is applied:
as a plain axis-aligned box, not an `offset()` of the plate's own outline.
That distinction matters for a real reason — an earlier version confined
the pattern with a uniform `offset()` of the taper-notched outline, and the
plate's 4 reflex (concave) taper-notch corners turned out to be numerically
touchy: a diamond/grid line running close to one of those corners could
leave a razor-thin sliver hole breaching all the way through the plate.
That turned out to be a numerical artifact of running OpenSCAD's `offset()`
against those specific corners — not a "needs N mm of clearance" issue —
so a plain box, which never calls `offset()` at all, sidesteps it entirely
(confirmed clean at all 4 corners even with every margin pushed down to 5).
**If you ever reintroduce an outline-following `offset()` here, re-verify
all 4 corners with a full render (F6), not just Preview** — a
STL-intersection probe at each corner is the most reliable check.

`SPINE_LIGHTENING_MARGIN_PX/NX/NY` each follow their own taper's real edge
(`spine_plate_px_edge_points()`/`nx_edge_points()`/`ny_edge_points()`)
instead of a flat line, staying a constant distance from that taper's
actual shape through its notch, and automatically re-tracking it if the
corresponding `SPINE_PLATE_TAPER_*` params are ever retuned. `PY` stays a
flat line — the plate's own +Y edge isn't tapered, so there's no real edge
shape for it to follow.

**Every MB/HDD/GaN standoff keeps the pattern off itself and its
print-support ramp** — not a plain keepout circle. This part prints **+Y
face down**, so each standoff's ramp (see "Print orientation") needs real
solid material to land on where it touches the plate, not just clearance
around the peg. Every pattern cell is tested against the standoff's real
footprint — the peg's own circle *and* its ramp's rectangular reach — and
left un-cut (solid) if it overlaps, rather than just trimmed at the edge.
OpenSCAD has no way to query "did this boolean produce empty geometry" as a
condition, so this isn't a CSG operation at all: `grid_2d()` and
`honeycomb_2d()` (`fish_case.scad`) compute each cell's position with plain
trigonometry (matching whatever rotation/translation the caller is about to
place the tiling with) *before* generating it, and skip cells whose center
comes within `apothem - SPINE_LIGHTENING_STANDOFF_PROTECT_FUDGE` of the
footprint — `apothem` being that cell's own guaranteed-solid inradius, so
the test only needs a plain point-to-shape distance, not real polygon
intersection. `standoff_lightening_protect()` builds one part's footprint
list; `new_spine()` calls it once per part (MB/HDD/GaN) and concatenates
the results.

That function also drops any standoff whose whole footprint already falls
outside the margin box on one side — already guaranteed solid by the flat
margin there, so the per-cell test doesn't need to touch it too. Without
this, a standoff sitting in (say) the `PX` rim could still trigger the
per-cell test right at the margin's own boundary, leaving a small stray jog
in what should be a clean straight edge — confirmed by a facet-count diff
between the two, not just eyeballing it, since the artifact was small
enough to miss in a tight crop.

`SPINE_LIGHTENING_STANDOFF_PROTECT_FUDGE` (default 0.3mm) tunes the
per-cell threshold: 0 protects a cell the moment it *could* touch the
footprint at all; positive tolerates that many mm of encroachment first
(e.g. to not bother filling in a cell over a fraction-of-a-mm sliver);
negative protects even on near-misses. This deliberately isn't efficient —
the whole cell gets kept solid, not just the overlapping sliver of it, so
the result reads as clean, full diamonds/hexes/squares around every
standoff rather than tiny fragments.

| Mode | Cell size params | Tradeoff |
|---|---|---|
| `"honeycomb"` | `SPINE_HONEYCOMB_HEX_R`, `SPINE_HONEYCOMB_WALL` | Best airflow/weight savings per unit wall thickness; slowest to print (many small islands = many perimeter loops + travel moves). Zigzag walls, no support issue in the real print orientation. |
| `"diamond"` (default) | `SPINE_GRID_SLOT_W/H`, `SPINE_GRID_WALL` | A plain square grid (`grid_2d()`), rotated 45° so no wall runs purely along X or Y (every one is a short diagonal) — no support needed in the real print orientation. Fewer, bigger cells than honeycomb at the same wall thickness. **Recommended default.** |

### HDD ventilation grill (front panel)

Honeycomb pattern (`HDD_GRILL_HEX_R`/`WALL`) sized around the HDD's own
front-face footprint, with 4 independent margins
(`HDD_GRILL_MARGIN_LEFT/RIGHT/TOP/BOTTOM`) rather than one shared value —
lets the boundary be pushed unevenly (e.g. more clearance along the top
than the bottom). `FRONT_PANEL_CORNER_INFILL_X/Z` cuts a guard wedge out
of the honeycomb pattern itself near the +X/-Z corner screw, guaranteeing
solid material around that screw regardless of where the hex tiling's
walls happen to land.

### Front panel ventilation grill (MB ↔ GaN PSU airflow)

A separate small row of vertical bars (`FRONT_VENT_POS/SIZE`,
`FRONT_VENT_SLOT_W`, `FRONT_VENT_WALL`) cut straight through the **front
panel's** Y thickness — not the divider plate — sitting in the one clear
strip of solid material between the GaN PSU's cable cutout and where the
upper panel piece begins. Placement is pinned to `GAN_PSU_POS` and the
plate's own Z position; re-check clearance if either moves.

## Hardware / screws needed

Two different thread standards are used in this build — **M3** everywhere
except the HDD, which uses the drive industry's standard **6-32 UNC**
(imperial, not metric). Don't mix them up when buying screws.

| Joint | Qty | Thread | Length | Head | Notes |
|---|---|---|---|---|---|
| Motherboard → standoffs | 4 | M3 | ~6mm | pan/socket | Standard mITX standoff screw length. The standoffs themselves are printed plastic with a plain clearance bore — they need **M3 heat-set threaded inserts**, or M3 thread-forming ("PT"/plastic) screws, since there's no metal thread to bite into. |
| HDD → standoffs (from MB side) | 4 | **6-32 UNC** | 3/8" (9.53mm)† | pan/button (flat underside) | Threads directly into the drive's own tapped bottom-mount holes. Vibration-isolated (see below) — the screw touches nothing but the two O-rings and the drive's threads the whole way through the plate and standoff. **Not** flat/countersunk — a countersunk head has no flat face to compress an O-ring evenly against. |
| HDD standoff isolation O-rings | 8 | — | AS568-007 (ID 0.145"/3.68mm, OD 0.285"/7.24mm, CS 0.070"/1.78mm) | silicone (VMQ), 70A | Two per standoff — one under the screw head, one between the standoff and the HDD's mounting boss. This is what actually isolates HDD vibration from the plate; the screw and standoff themselves never touch each other rigidly. See "HDD vibration isolation" below for install compression. |
| GaN PSU → standoffs (from MB side) | 4 | M3 | 16mm‡ | flat/countersunk, 90° | Threads directly into the PSU's own tapped mounting holes (verified from HDPLEX's STEP file, "same as HDPLEX 200W ACDC / 400W ACDC" pattern). Same access-from-above arrangement as the HDD. |
| Front panel → case shell (all 4 corners, upper + lower) | 4 | M3 | TBD | flat/countersunk, 90° | Attaches the spine assembly to the outer case shell. Each hole also has a shell-mating tab slot cut into the panel's inside face — the eventual shell gets a matching tab that this same screw clamps in place. Length depends on the shell's own screw boss depth, which hasn't been designed yet. |
| GaN PSU → front panel (cable-side mounts) | 4 | M3 | TBD | flat/countersunk, 90° | **Placeholder, not verified real hardware** — the GaN PSU's actual front-mounting bracket is a length-wise rail (177×35mm hole spacing, confirmed M3) rather than a small end-cap plate like this cutout assumes. Keep these for now, but don't treat the spacing as matching the real PSU rail. |

† A real stack-up calculation, not a rule of thumb: plate thickness (3mm) +
standoff gap + ~3mm thread engagement (WD SFF-8301's own minimum) needs to
land exactly on a standard screw length. The HDD's own Z position
(`HDD_POS[2]` in `fish_case.scad`) was adjusted specifically to make that
land on 3/8" - the next standard size down (5/16") leaves only 0.38mm of
printed wall around the O-ring pocket (too thin to print reliably), and the
next size up (7/16") pushes the drive past the enclosure's own floor. See
the `HDD_ORING_POCKET_DEPTH` comment in `fish_case.scad` for the full math.

‡ Assumes ~4.5mm of M3 thread engagement into the PSU's aluminum body (a
general engineering guideline — the PSU's tapped-hole *depth* wasn't
extracted from the STEP file, only hole position and diameter). If 16mm
screws bottom out, drop to 14mm.

### HDD vibration isolation - install notes

The HDD isn't rigidly bolted to the spine. Two silicone O-rings per
standoff (screw-head side and standoff-to-HDD side) carry the entire
clamping load - the screw never touches the plate or the standoff, only
the O-rings and the drive's threads. That only works if the O-rings end up
compressed to roughly the right amount, and this joint has **no hard
mechanical stop** - past the target, tightening further just keeps
compressing the O-rings, so "screw it down snug" is the wrong instinct
here.

- **Target: 10-15% compression** (soft enough to actually damp vibration,
  firm enough to hold the drive securely - see the design discussion for
  why softer beats a fully-torqued rigid joint here).
- Because each screw has **two** O-rings in series (not one), the
  compression splits between them - a given amount of screw travel only
  buys half the compression you'd get with a single isolator. Install by
  hand-threading until resistance is first felt (both O-rings just
  touching, zero compression), then turn an additional **1/2 to 2/3 turn**
  past that point - 6-32's 32 TPI thread advances 0.79mm per full turn, so
  that range covers 10-15% compression on both O-rings together. (A single
  O-ring reaching 15% alone would only take about 1/3 turn - it's the
  two-in-series setup that doubles it.)
- `HDD_ORING_POCKET_DEPTH` in `fish_case.scad` targets 12.5% (the middle of
  that range) assuming the O-ring's free height matches the AS568-007 spec
  exactly (1.78mm cross-section) - real parts vary a little from nominal,
  so treat the 1/2-2/3 turn instruction as the actual install reference,
  not the pocket depth number.

## Known open items

- Outer case shell not yet modeled — the shell-mating tab slots on the
  front panel and the front-panel-to-shell screw length both assume a
  shell design that doesn't exist yet.
- Lower front panel's GaN PSU mount screws are a simplified stand-in, not
  the PSU's real mounting rail (see hardware table above).
- Neither the divider-plate lightening pattern nor the front ventilation
  grill has been thermally validated — both are sized for print
  practicality and a reasonable-looking amount of open area, not against
  any actual airflow/thermal target.
