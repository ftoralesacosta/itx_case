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
| `4.7-Fish_-_spine.stl` | Original spine reference geometry (source: printables.com link above). Only its front I/O opening dimensions and mounting-hole layout were used; the new spine is otherwise built from scratch. |
| `4.7-Fish_-_case.stl` | Original outer shell reference geometry — not yet used in the model. |
| `4.7-fish-step.step` | Original design in STEP format. |

## What's modeled

- **Divider plate** sized to a ~180×180mm enclosure, with standoffs for the
  motherboard (top face), HDD, and GaN PSU (both hanging from the underside).
- **Front I/O panel**, upper portion: the motherboard's rear-IO cutout, sized
  from the reference spine STL, plus two M3 corner mounting screws.
- **Front I/O panel**, lower portion: a GaN PSU power-cable opening, the
  PSU's own front-mounting screws, an HDD honeycomb ventilation grill, and
  two more M3 corner mounting screws (matching the upper panel).
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
| Front panel → case shell (top+bottom corners) | 4 | M3 | TBD | flat/countersunk, 90° | Attaches the spine assembly to the outer case shell. Length depends on the shell's own screw boss depth, which hasn't been designed yet. |
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

- Outer case shell not yet modeled.
- Lower front panel's GaN PSU mount screws are a simplified stand-in, not
  the PSU's real mounting rail (see table above).
- Front-panel-to-shell screw length depends on a shell design that doesn't
  exist yet.
