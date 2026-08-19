// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Stand
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-stand
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

// --- back of the stand (display-holder)   ----------------------------------

module display_back(
  frame=[0,0,0],
  display=[0,0,0],
  offset=[0,0,0],
  rounding=3,
  edges=[BACK+LEFT, BACK+RIGHT]) {

  difference() {
    // base of the back
    cuboid(size=frame, rounding=rounding, edges=edges, anchor=BOTTOM+CENTER);
    // cutout for display
    zmove(FUZZ) move(offset) cuboid(size=display, anchor=BOTTOM+CENTER);
  }
}

// --- front of the stand (panel)   -----------------------------------------

module display_front(
  frame=[0,0,0],
  cutout=[0,0,0],
  offset=[0,0,0],
  rounding=[3, 3, 0, 0]) {
  difference() {
    // panel
    ymove(offset.y/2) prismoid(size1=[frame.x, frame.y-offset.y],
                             size2=[cutout.x, cutout.y], h=frame.z,
                             shift=[offset.x, 0],
                             rounding=rounding, anchor=BOTTOM+CENTER);
    // cutout for display
    zmove(-FUZZ) move(offset) cuboid(size=cutout, anchor=BOTTOM+CENTER);
  }
}
 
// --- test-modules   --------------------------------------------------------

module test_simple() {
  border_i = 2;
  border_o = 10;
  border_add = 10;
  front_z    =  1.8;

  display = [100, 75, 4];
  frame   = [display.x+2*border_o, display.y+2*border_o+border_add, display.z+BT];
  cutout  = [display.x-2*border_i, display.y-2*border_i, front_z+2*FUZZ];

  display_back(frame, display, offset=[0, border_add/2, frame.z-display.z]);

  color("blue") zmove(frame.z)
     display_front([frame.x, frame.y, front_z], cutout, offset=[0, border_add/2,0]);
}

// --- tests   ----------------------------------------------------------------

test_simple();
