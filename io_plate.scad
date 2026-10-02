// I/O plate: the whole front plane (rear I/O, HDD grill, C14) with countersinks for the spine joints. Prints front face down.
// Shared model in case_common.scad; export with SHOW_OTHER_PART = false and used_components = false.
include <case_common.scad>

SHOW_OTHER_PART = false;
ASSEMBLY_PREVIEW = false;

io_plate(true, "Orange", 1);
other_part("spine.stl", SHOW_OTHER_PART);
render_references();
