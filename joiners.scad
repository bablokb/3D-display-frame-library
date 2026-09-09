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

// --- helper module: joiner   -------------------------------------------------

module joiner(gender,       // needs to be provided
              height,       // height (needs to be provided),
              size=[8,5],   // width, slide (x, y)
              slope=3,      // the slope
              $slop=0.1) {  // the slop
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

// --- wall-lock: join components using wall-locks   ---------------------------

module wall_lock(size=[0,0], count=3, d=W2, l=3, space=0, mask=false) {
  // size  : (outer) dimensions of walls
  // count : number of locks. Can be a scalar of vector.
  // d     : diameter of lock. Should be 2xwall-width
  // l     : length of lock
  // space: space between locks (default: evenly spaced). Can be a scalar of vector.

  d_lock  = mask ? d+GAP : d;
  l_lock  = mask ? l+GAP : l;
  counts  = is_list(count)  ? count  : [count,count,count,count];
  spaces = is_list(space) ? space : [space,space,space,space];

  // back (north)
  ymove(size.y/2) xcopies(spaces[0] == 0 ? size.x/(counts[0]+1):spaces[0],
                     counts[0]) xcyl(l=l_lock,d=d_lock);
  // right (east)
  xmove(size.x/2) ycopies(spaces[1] == 0 ? size.x/(counts[1]+1):spaces[1],
                     counts[1]) ycyl(l=l_lock,d=d_lock);
  // front (south)
  ymove(-size.y/2) xcopies(spaces[2] == 0 ? size.x/(counts[2]+1):spaces[2],
                      counts[2]) xcyl(l=l_lock,d=d_lock);
  // left (west)
  xmove(-size.x/2) ycopies(spaces[3] == 0 ? size.x/(counts[3]+1):spaces[3],
                      counts[3]) ycyl(l=l_lock,d=d_lock);
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
