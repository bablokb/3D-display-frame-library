// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Stand: part library.
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-stand
// ---------------------------------------------------------------------------

include <joiners.scad>

// --- back of the stand (display-holder)   ----------------------------------

module display_back(
  frame=[0,0,0],                     // outer frame
  display=[0,0,0],                   // physical display size
  offset=[0,0,0],                    // offset of display within frame
  rounding=3,                        // rounding of edges
  edges=[BACK+LEFT, BACK+RIGHT],     // edges (default: back)
  lock=true) {                       // add locks (dovetail-joiners)

  difference() {
    // base of the back
    cuboid(size=frame, rounding=rounding, edges=edges, anchor=BOTTOM+CENTER);
    // cutout for display
    zmove(FUZZ) move(offset) cuboid(size=display, anchor=BOTTOM+CENTER);
    // cutout for joiners
    if (lock) {
      joiner_mask(size=frame);
    }
  }
}

// --- front of the stand (panel)   -----------------------------------------

module display_front(frame=[0,0,0],                  // outer frame
                     cutout=[0,0],                   // cutout display
                     offset=[0,0,0],                 // offset of display within frame
                     rounding=3,                     // rounding of edges
                     edges=[BACK+LEFT, BACK+RIGHT],  // edges (default: back)
                     wall=0,                         // width of additional wall
                     wall_h=0,                       // height of additional wall
                     wall_r=[3,3,0,0],               // roundings of wall
                     joiner_z=0) {                   // z of joiners
  // with a wall, slightly increase the size to have a small gap
  fx = wall ? (frame.x+GAP)/frame.x: 1.0;
  fy = wall ? (frame.y+GAP)/frame.y: 1.0;
  // simple front
  scale([fx,fy,1.0]) difference() {
    color("green") cuboid(size=frame, rounding=rounding, edges=edges,
                          anchor=BOTTOM+CENTER);
    // cutout for display
    zmove(-FUZZ) move(offset) cuboid(size=[cutout.x, cutout.y, frame.z+2*FUZZ],
                                     chamfer=frame.z, edges=[TOP],
                                     anchor=BOTTOM+CENTER);
  }
  // optional wall
  if (wall) {
    echo("wall=",wall);
    echo("wall_h=", wall_h);
    rect_tube(isize=[fx*frame.x-FUZZ,fy*frame.y-FUZZ], wall=wall, h=wall_h,
                rounding=wall_r, irounding=wall_r, anchor=BOTTOM+CENTER);
  } else if (joiner_z) {
    joiner(size=frame, height=joiner_z);
  }
}

// --- feet   ----------------------------------------------------------------

module display_feet(size=[0,0], d=0) {
  angle = atan(d/2/size.y);
  top_half(s=2*max(size.x, size.y)+d)
     zrot(-90) yrot(-90)
        teardrop(r=d/2, h=size.x, ang=angle);
}

// --- base   ----------------------------------------------------------------

module display_base(size=[0,0], z=0, h=0, alpha=30, feet=true, size_feet=[0,0]) {
  // base is a cylinder with a cutout of height h, offset z and angled at alpha
  difference() {
    union() {
      top_half(s=2*size.x) xcyl(l=size.x, d=size.y, anchor=CENTER);
      if (feet) {
        xmove(-size.x/2+size_feet.x/2)
            display_feet(size=size_feet, d=size.y);
        xmove(+size.x/2-size_feet.x/2)
            display_feet(size=size_feet, d=size.y);
      }
    }
    xrot(-alpha) zmove(z) cuboid([size.x+FUZZ, h, size.y], anchor=BOTTOM+BACK);
  }
}
