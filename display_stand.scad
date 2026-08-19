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

module display_front(frame=[0,0], base_height=3, bevel_height=1.8,
                     cutout=[0,0],  offset=[0,0,0],
                     rounding_base=3, rounding_bevel=[3, 3, 0, 0],
                     edges=[BACK+LEFT, BACK+RIGHT]) {
  cutout_z = base_height + bevel_height + 2*FUZZ;
  difference() {
    union() {
      // base
      color("green") cuboid([frame.x, frame.y, base_height], edges=edges,
                            rounding=rounding_base, anchor=BOTTOM+CENTER);
      // panel
      color("blue") move([0, offset.y/2, base_height-FUZZ])
        prismoid(size1=[frame.x, frame.y-offset.y],
                 size2=[cutout.x, cutout.y], h=bevel_height,
                 shift=[offset.x, 0],
                 rounding=rounding_bevel, anchor=BOTTOM+CENTER);
    }
    // cutout for display
    zmove(-FUZZ) move(offset) cuboid(size=[cutout.x, cutout.y, cutout_z],
                                     anchor=BOTTOM+CENTER);
  }
}

// --- base   ----------------------------------------------------------------

module display_base(size=[0,0], z=0, h=0, alpha=30) {
  // base is a cylinder with a cutout of height h, offset z and angled at alpha
  difference() {
    top_half(s=2*size.x) xcyl(l=size.x, d=size.y, anchor=CENTER);
    xrot(-alpha) zmove(z) cuboid([size.x+FUZZ, h, size.y], anchor=BOTTOM+BACK);
  }
}

// --- test-modules   --------------------------------------------------------

module test_simple() {
  border_i = 2;
  border_o = 10;
  border_add = 10;
  base_height  = 3;
  bevel_height = 1.8;

  display = [100, 75, 4];
  frame   = [display.x+2*border_o, display.y+2*border_o+border_add, display.z+BT];
  cutout  = [display.x-2*border_i, display.y-2*border_i];

  display_back(frame, display, offset=[0, border_add/2, frame.z-display.z]);

  zmove(frame.z+5)
     display_front([frame.x, frame.y],
                   base_height=base_height, bevel_height=bevel_height,
                   cutout=cutout,
                   offset=[0, border_add/2,0]);
}

// --- tests   ----------------------------------------------------------------

//test_simple();
//display_base([100,20], z=2, h=W4);
