// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Frame Library: mask for Inky-Impression 7.3
//                      (second generation Spectra6 version, side-mounted buttons)
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

module _ii73_spectra6_mask(size=[0,0,0]) {
  // Pi connector including threads for top screws
  move([22.5, 47+49, 0])
     cuboid([65.6, 10, MAX_Z], anchor=BOTTOM+LEFT+CENTER);
  // bottom screws
  ymove(47) {
    xmove(26.7) cyl(d=7, h=MAX_Z, anchor=BOTTOM+CENTER);
    xmove(26.7+58) cyl(d=7, h=MAX_Z, anchor=BOTTOM+CENTER);
  }
  // central block with FPC cable
  move([70, 4.3, 0])
    cuboid([46, 55, 2.5], anchor=FRONT+LEFT+BOTTOM);
  // top central element (LED??)
  move([87, size.y-5, 0])
    cyl(d=3.5, h=1, anchor=BOTTOM+CENTER);
  // additional pin connectors (left edge)
  move([-MAX_Z, 11.5, 0])
    cuboid([17+MAX_Z, 29.5, 4], anchor=FRONT+LEFT+BOTTOM);
  // SMDs next to Pi connector
  move([96, 91.5, 0])
    cuboid([20, 10, 2.0], anchor=FRONT+LEFT+BOTTOM);
  // 2x Stemma/Qt connector
  move([131, 97, 0])
    cuboid([9, 20, MAX_Z], anchor=CENTER+BOTTOM);
  move([131+19, 97, 0])
    cuboid([9, 20, MAX_Z], anchor=CENTER+BOTTOM);
  // buttons
  xmove(size.x-8.5) {
    ymove( 28.5) cuboid([8.5+MAX_Z, 10, 4], anchor=LEFT+BOTTOM+CENTER);
    ymove( 52.5) cuboid([8.5+MAX_Z, 10, 4], anchor=LEFT+BOTTOM+CENTER);
    ymove( 76.5) cuboid([8.5+MAX_Z, 10, 4], anchor=LEFT+BOTTOM+CENTER);
    ymove(100.5) cuboid([8.5+MAX_Z, 10, 4], anchor=LEFT+BOTTOM+CENTER);
  }
}

// --- mask for extrusions   -------------------------------------------------

module ii73_spectra6_mask(size=[0,0,0]) {
  move([size.x/2, -size.y/2,0])
    yrot(180) _ii73_spectra6_mask(size=size);
}

// --- test view   ------------------------------------------------------------

module ii73_spectra6_mask_test(display, border=10, h=10) {
  difference() {
    // "display_back()"
    cuboid([display.x+2*border, display.y+2*border, h], anchor=BOTTOM+CENTER);
    // minus "display"
    zmove(h-display.z+FUZZ) {
      cuboid(size=[display.x+GAP,display.y+GAP,display.z],
           anchor=BOTTOM+CENTER);
    // minus mask
    zmove(FUZZ) ii73_spectra6_mask(size=display);
    }
  }
}

//ii73_spectra6_mask_test(display=[174.20, 123.20, 3.0], border=3, h=4);
