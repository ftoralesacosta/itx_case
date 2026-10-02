// Spine: divider plate, HDD/GaN standoffs, I/O-plate joint bosses. Prints MB face down.
// Shared model in case_common.scad; export with SHOW_OTHER_PART = false and used_components = false.
include <case_common.scad>

SHOW_OTHER_PART = true;
ASSEMBLY_PREVIEW = false;

new_spine(true, "Orange", 1);
other_part("io_plate.stl", SHOW_OTHER_PART);
render_references();
