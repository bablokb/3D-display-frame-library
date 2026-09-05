// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Frame Library: Tests.
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-frame-library
// ---------------------------------------------------------------------------

include <display_parts.scad>

border_i = 2;
border_o = 15;
border_add = 10;
front_z    = 2;

display = [100, 75, 4];
frame_back  = [display.x+2*border_o, display.y+2*border_o+border_add, display.z+BT];
frame_front = [display.x+2*border_o, display.y+2*border_o+border_add, front_z];
cutout  = [display.x-2*border_i, display.y-2*border_i];

// --- test-modules   --------------------------------------------------------

module test_wall() {
  display_back(frame_back, display, offset=[0, border_add/2, frame_back.z-display.z],
               lock=false);
  zmove(frame_back.z+frame_front.z+15)
   display_front(frame_front,
                 cutout=cutout,
                 offset=[0, border_add/2,0],
                 wall=W4, wall_h=frame_back.z+frame_front.z);
}

module test_conn() {
  display_back(frame_back, display, offset=[0, border_add/2, frame_back.z-display.z]);
  zmove(frame_back.z+frame_front.z+15)
  display_front(frame_front,
                cutout=cutout,
                offset=[0, border_add/2,0], joiner_z=frame_back.z);
}

module test_chamfer() {
  display_back(frame_back, display, offset=[0, border_add/2, frame_back.z-display.z],
               rounding=0);
  zmove(frame_back.z+frame_front.z+15)
  display_front(frame_front,
                cutout=cutout,
                chamfer=true,
                offset=[0, border_add/2,0], joiner_z=frame_back.z);
}


// --- tests   ----------------------------------------------------------------

test_wall();
ymove(frame_back.y+20)  test_conn();
ymove(-frame_back.y-20) test_chamfer();

xmove(-frame_back.x-20)
  display_base([frame_front.x,40], z=5, h=frame_front.z+frame_back.z+GAP, size_feet=[10,70]);
