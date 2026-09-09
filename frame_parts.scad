// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Frame Library: helper modules for
//                      the photo frame.
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-frame-library
// ---------------------------------------------------------------------------

include <joiners.scad>

// --- strut (one side) of a frame   -----------------------------------------

module _frame_strut(size=[0,0,0],    // basic size
              wall=0,                // width of wall
              front_z=0,             // frame height of display_front()
              back_z=0) {           // frame height of display_back()

  // calculated dimensions
  d   = size.y;
  x   = size.x;
  y   = size.y;
  z   = size.z;
  z_f = front_z;
  y_b = y - z_f;
  z_b = back_z;
  z_i = y_b;
  y_i = size.y - wall;

  // build everything from bottom to top
  difference() {
    union() {
      // outer wall
      cuboid([x, wall, z], anchor=BOTTOM+FRONT+CENTER);
      // chamfer outer wall -> size of display_back()
      color("magenta") zmove(z-(z_f+z_b+z_i))
          cuboid([x, y_b, z_i], chamfer=z_i-FUZZ, edges=BOTTOM+BACK,
                 anchor=BOTTOM+FRONT+CENTER);
      // inner wall sized to display_back()
      color("aqua") zmove(z-(z_f+z_b-FUZZ))
        cuboid([x, y_b, z_b], anchor=BOTTOM+FRONT+CENTER);
      // chamfer up to size.y. display_front() must be chamfered as well
      color("blue") zmove(z-z_f-FUZZ)
        cuboid([x, y, z_f], chamfer=z_f-FUZZ, edges=BOTTOM+BACK,
               anchor=BOTTOM+FRONT+CENTER);
      // top rounding of frame (half of a cylinder)
      color("red") move([0,d/2,z-FUZZ])
        difference() {
          xcyl(d=d, h=size.x, anchor=CENTER);
          cuboid([x+FUZZ,d,d], anchor=TOP+CENTER);
        }
    }
    // minus everything below zero
    cuboid([x+FUZZ,y,z], anchor=TOP+CENTER);
    // minus chamfering on left and right
    xflip_copy() xmove(-x/2)
      zrot(-45) cuboid([y,4*y,y+z+FUZZ], anchor=RIGHT+BOTTOM+CENTER);
  }
}
