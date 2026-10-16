// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Frame Library: mask for Waveshare
//                      Pico-ResTouch-LCD-2.8.
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-frame-library
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <../dimensions.scad>

MAX_Z = 40;   // full height to force mask to create cutouts

// --- mask-helper   ---------------------------------------------------------
// This internal version is viewed from the backside with origin at FRONT+LEFT+BOTTOM

module _ws28_mask(size=[0,0,0]) {
  // screws
  move([4, 4.6, 0]) cyl(d=6.2, h=MAX_Z, anchor=BOTTOM+CENTER);
  move([4, size.y-4.6, 0]) cyl(d=6.2, h=MAX_Z, anchor=BOTTOM+CENTER);
  move([size.x-4, 4.6, 0]) cyl(d=6.2, h=MAX_Z, anchor=BOTTOM+CENTER);
  move([size.x-4, size.y-4.6, 0]) cyl(d=6.2, h=MAX_Z, anchor=BOTTOM+CENTER);
  // SD-card slot
  move([10, -MAX_Z, 0])
     cuboid([17, 18.5+MAX_Z, MAX_Z], anchor=FRONT+LEFT+BOTTOM);
  // Reset button
  move([27-FUZZ, -MAX_Z, 0])
     cuboid([9, 5+MAX_Z, 5], anchor=FRONT+LEFT+BOTTOM);
  // SMD block above SD-card slot and button
  cuboid([38.5, 33.5, 1.5], anchor=FRONT+LEFT+BOTTOM);
  // Pico sockets
  move([0, -1, -MAX_Z]) {
    // left Pico socket
    xmove(41.1)
      cuboid([8, size.y+1, 2*MAX_Z], anchor=FRONT+CENTER+BOTTOM);
    // right Pico socket
    xmove(59.0)
      cuboid([8, size.y+1, 2*MAX_Z], anchor=FRONT+CENTER+BOTTOM);
  }
}

// --- mask for extrusions   -------------------------------------------------

module ws28_mask(size=[0,0,0]) {
  move([size.x/2, -size.y/2,0])
    yrot(180) _ws28_mask(size=size);
}

// --- test view   ------------------------------------------------------------

module ws28_mask_test(display, border=10, h=10) {
  difference() {
    // "display_back()"
    cuboid([display.x+2*border, display.y+2*border, h], anchor=BOTTOM+CENTER);
    // minus "display"
    zmove(h-display.z+FUZZ) {
      cuboid(size=[display.x+GAP,display.y+GAP,display.z],
           anchor=BOTTOM+CENTER);
    // minus mask
    zmove(FUZZ) ws28_mask(size=display);
    }
  }
}

//_ws28_mask(size=[70.2, 52.2, 6.1]);
//ws28_mask_test(display=[70.7, 52.7, 6.1], border=2, h=8.4);
