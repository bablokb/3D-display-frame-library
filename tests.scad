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
front_z    = 2;

display = [100, 75, 4];
frame_back  = [display.x+2*border_o, display.y+2*border_o+border_add, display.z+BT];
frame_front = [display.x+2*border_o, display.y+2*border_o+border_add, front_z];
cutout  = [display.x-2*border_i, display.y-2*border_i];

// --- test-modules   --------------------------------------------------------

module test_simple() {
  display_back(frame_back, display, offset=[0, border_add/2, frame_back.z-display.z]);
  zmove(frame_back.z+5)
     display_front(frame_front,
                   cutout=cutout,
                   offset=[0, border_add/2,0]);
}

// --- tests   ----------------------------------------------------------------

test_simple();
xmove(-frame_back.x-20) {
  display_base([frame_front.x,40], z=5, h=frame_front.z+frame_back.z+GAP, size_feet=[10,70]);
}
