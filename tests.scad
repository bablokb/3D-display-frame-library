// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Stand: Tests.
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-stand
// ---------------------------------------------------------------------------

include <display_stand.scad>

border_i = 2;
border_o = 10;
border_add = 10;
base_height  = 3;
bevel_height = 1.8;

display = [100, 75, 4];
frame   = [display.x+2*border_o, display.y+2*border_o+border_add, display.z+BT];
cutout  = [display.x-2*border_i, display.y-2*border_i];

// --- test-modules   --------------------------------------------------------

module test_simple() {
  display_back(frame, display, offset=[0, border_add/2, frame.z-display.z]);
  zmove(frame.z+5)
     display_front([frame.x, frame.y],
                   base_height=base_height, bevel_height=bevel_height,
                   cutout=cutout,
                   offset=[0, border_add/2,0]);
}

// --- tests   ----------------------------------------------------------------

test_simple();
xmove(-frame.x-20) {
  display_base([frame.x,40], z=5, h=frame.z+base_height+GAP, size_feet=[10,70]);
}
