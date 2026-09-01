// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Dovetail tests
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-stand
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <BOSL2/joiners.scad>
include <dimensions.scad>

// --- helper module: joiner   -------------------------------------------------

module joiner(gender,       // needs to be provided
              height,       // height (needs to be provided),
              size=[8,5],   // width, slide (x, y)
              slope=3,      // the slope
              $slop=0.05) { // the slop
  dovetail(gender, slide=size.y, width=size.x, $slop=$slop,
            height=height,
            slope=slope, entry_slot_length=size.y+2, anchor=BOTTOM+FRONT);
}

// --- joiners_mask: female dovetails in a grid   ------------------------------

module joiners_mask(size=[0,0,0],     // size of the grid
                   offset=[10,10],   // offset of the joiners from the corners
                   height=0) {       // joiner height  
  h = height == 0 ? min(5, size.z) : height;
  xflip_copy()
    move([size.x/2-offset.x, size.y/2-offset.y, size.z+FUZZ])
      joiner("female",h);
  xflip_copy()
    move([size.x/2-offset.x, -size.y/2+offset.y, size.z+FUZZ])
      joiner("female",h);
}

// --- joiners: male dovetails in a grid   -------------------------------------

module joiners(size=[0,0,0],     // size of the grid
               offset=[10,10],   // offset of the joiners from the corners
               height=0) {       // joiner height
  h = height==0 ? 5 : height;
  xflip_copy()
    move([size.x/2-offset.x, size.y/2-offset.y, size.z-FUZZ])
      joiner("male",h);
  xflip_copy()
    move([size.x/2-offset.x, -size.y/2+offset.y, size.z-FUZZ])
      joiner("male",h);
}

// --- test outputs   ----------------------------------------------------------

module _joiners_test() {
  difference() {
    cuboid(size=[140, 110, 10], anchor=BOTTOM+CENTER);
    joiners_mask(size=[140, 110, 10], height=5);
  }
  
   color("blue") zmove(25) yrot(180) union() {
    cuboid(size=[140, 110, 2], anchor=BOTTOM+CENTER);
    joiners(size=[140, 110, 2], height=5);
  }
}
//_joiners_test();
