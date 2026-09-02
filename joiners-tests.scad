// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Dovetail tests
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-frame-library
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <BOSL2/joiners.scad>
include <dimensions.scad>

DOVE   = [8, 5];    // width, slide (x, y)
DOVE_S = 3;
SIZE_B = [20, 30, 5];
SIZE_F = [20, 30, 2];

// --- simulated back-module   -------------------------------------------------

module back() {
  difference() {
    ymove(-5) cuboid(SIZE_B, anchor=BOTTOM+CENTER);
    zmove(SIZE_B.z+FUZZ) 
      dovetail("female", slide=DOVE.y, width=DOVE.x, , $slop=0.05,
                height=SIZE_B.z+2*FUZZ,
                slope=DOVE_S, entry_slot_length=DOVE.y+2, anchor=BOTTOM+FRONT);
  }
}

// --- simulated front-module   ------------------------------------------------

module front() {
  ymove(-5) cuboid(SIZE_F, anchor=BOTTOM+CENTER);
  zmove(SIZE_F.z-FUZZ) 
    dovetail("male", slide=DOVE.y, width=DOVE.x, , $slop=0.05,
              height=SIZE_B.z+2*FUZZ,
              slope=DOVE_S, entry_slot_length=DOVE.y+2, anchor=BOTTOM+FRONT);
}

// --- test outputs   ----------------------------------------------------------

PRINT = true;

back();
if (!PRINT) {
  // visual inspection
  color("blue")
    zmove(SIZE_B.z+SIZE_F.z)
      yrot(180)
       front();
} else {
  // print orientation
  color("blue")
    xmove(2*SIZE_B.x)
      front();
}
