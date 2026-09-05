// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Frame Library: helper modules for
//                      the photo frame.
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-frame-library
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

// --- strut (one side) of a frame   -----------------------------------------

module _strut(size=[0,0,0],    // basic size
              wall=0,          // width of wall
              front_z=0,       // frame height of display_front()
              back_z=0) {      // frame height of display_back()

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
      cuboid([x, wall, z], anchor=BOTTOM+FRONT+CENTER);  // outer wall
      zmove(z-(z_f+z_b+z_i))                             // inner chamfer
        color("magenta") cuboid([x, y_b, z_i], chamfer=z_i-FUZZ, edges=BOTTOM+BACK,
               anchor=BOTTOM+FRONT+CENTER);
      color("aqua") zmove(z-(z_f+z_b-FUZZ))                            // display_back level
        cuboid([x, y_b, z_b], anchor=BOTTOM+FRONT+CENTER);
      zmove(z-z_f-FUZZ)                                  // display_front level
        color("blue") cuboid([x, y, z_f], chamfer=z_f-FUZZ, edges=BOTTOM+BACK,
               anchor=BOTTOM+FRONT+CENTER);
      color("red") move([0,d/2,z-FUZZ]) difference() {
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
  
// --- tests   ---------------------------------------------------------------

//x = 100; y = 10; z = 40;
//yflip_copy() ymove(-x/2) _strut(size=[x, y, z], wall=4, front_z=2, back_z=5);
//xflip_copy()
//  move([-x/2, 0, 0]) zrot(-90) _strut(size=[x, y, z], wall=4, front_z=2, back_z=5);
