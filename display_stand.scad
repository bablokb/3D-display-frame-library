// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Stand: part library.
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
