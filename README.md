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
| HDD → standoffs (from MB side) | 4 | **6-32 UNC** | 1/2" (12.7mm)† | flat/countersunk, 82° | Threads directly into the drive's own tapped bottom-mount holes (real metal thread, no insert needed). Screw travels from the plate's MB-side face, through the plate and standoff, into the drive. |
| GaN PSU → standoffs (from MB side) | 4 | M3 | 16mm‡ | flat/countersunk, 90° | Threads directly into the PSU's own tapped mounting holes (verified from HDPLEX's STEP file, "same as HDPLEX 200W ACDC / 400W ACDC" pattern). Same access-from-above arrangement as the HDD. |
| Front panel → case shell (top+bottom corners) | 4 | M3 | TBD | flat/countersunk, 90° | Attaches the spine assembly to the outer case shell. Length depends on the shell's own screw boss depth, which hasn't been designed yet. |
| GaN PSU → front panel (cable-side mounts) | 4 | M3 | TBD | flat/countersunk, 90° | **Placeholder, not verified real hardware** — the GaN PSU's actual front-mounting bracket is a length-wise rail (177×35mm hole spacing, confirmed M3) rather than a small end-cap plate like this cutout assumes. Keep these for now, but don't treat the spacing as matching the real PSU rail. |

† Based on WD's SFF-8301 bottom-mount spec: engagement depth requirements
vary by drive family (1–3 disk vs. 4-disk vs. >5-disk) enough that no single
length is ideal for every drive. 1/2" targets ~3mm engagement, a safe
default across families. If you know your drive is a modern high-capacity
(4+ platter) model, **5/8" (15.88mm)** gives ~6.4mm engagement instead,
matching that family's spec more closely.

‡ Assumes ~4.5mm of M3 thread engagement into the PSU's aluminum body (a
general engineering guideline — the PSU's tapped-hole *depth* wasn't
extracted from the STEP file, only hole position and diameter). If 16mm
screws bottom out, drop to 14mm.

## Known open items

- Outer case shell not yet modeled.
- Lower front panel's GaN PSU mount screws are a simplified stand-in, not
  the PSU's real mounting rail (see table above).
- Front-panel-to-shell screw length depends on a shell design that doesn't
  exist yet.
