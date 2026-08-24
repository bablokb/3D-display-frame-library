// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Stand: mask for Inky-Impression 4
//                      (First generation ACEP version)
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-stand
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

MAX_Z = 40;   // full height to force mask to create cutouts

// display dimensions (move to ii4_acep_dims.scad)

ii4_acep_display = [97, 69.3, 3.2];

// --- mask-helper   ---------------------------------------------------------
// This internal version is viewed from the backside with origin at FRONT+LEFT+BOTTOM

module _ii4_acep_mask() {
  // Pi connector including threads for top screws
  move([24.7, ii4_acep_display.y-6.95, 0])
     cuboid([65.6, 10, MAX_Z], anchor=BOTTOM+LEFT+CENTER);
  // bottom screws
  ymove(12.25) {
    xmove(28.35) cyl(d=7, h=MAX_Z, anchor=BOTTOM+CENTER);
    xmove(ii4_acep_display.x-10.35) cyl(d=7, h=MAX_Z, anchor=BOTTOM+CENTER);
  }
  // central block with FPC cable
  move([34.5, -0.5, 0])
    cuboid([28, 44.5, 2.5], anchor=FRONT+LEFT+BOTTOM);
  // additional pin connectors
  move([64.7, -MAX_Z, 0])
    cuboid([15, 18+MAX_Z, 4.4], anchor=FRONT+LEFT+BOTTOM);
  // SMDs below Pi connector
  move([58.3, 49.5, 0])
    cuboid([16, 8, 2.0], anchor=FRONT+LEFT+BOTTOM);
  // buttons
  xmove(ii4_acep_display.x-4.5) {
    ymove(11.7) cuboid([4.5+MAX_Z, 10, 3.8], anchor=FRONT+LEFT+BOTTOM);
    ymove(25) cuboid([4.5+MAX_Z, 10, 3.8], anchor=FRONT+LEFT+BOTTOM);
    ymove(38.5) cuboid([4.5+MAX_Z, 10, 3.8], anchor=FRONT+LEFT+BOTTOM);
    ymove(52.3) cuboid([4.5+MAX_Z, 10, 3.8], anchor=FRONT+LEFT+BOTTOM);
  }
}

// --- mask for extrusions   -------------------------------------------------

module ii4_acep_mask() {
  move([ii4_acep_display.x/2, -ii4_acep_display.y/2,0])
    yrot(180) _ii4_acep_mask();
}

// --- test view   ------------------------------------------------------------

module ii4_acep_mask_test(border=10, h=10) {
  difference() {
    cuboid([ii4_acep_display.x+border, ii4_acep_display.y+border, h], anchor=BOTTOM+CENTER);
    zmove(h-ii4_acep_display.z+FUZZ) {
      cuboid(size=[ii4_acep_display.x+GAP,ii4_acep_display.y+GAP,ii4_acep_display.z],
           anchor=BOTTOM+CENTER);
      zmove(FUZZ) ii4_acep_mask();
    }
  }
}

//ii4_acep_mask_test(3,h=4);
//_ii4_acep_mask();
//color("lightgray") cuboid(size=ii4_acep_display, anchor=FRONT+LEFT+TOP);

