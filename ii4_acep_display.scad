// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Frame Library: build for Inky-Impression 4
//                      (First generation ACEP version)
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-frame-library
// ---------------------------------------------------------------------------

include <display_parts.scad>
include <ii4_acep_mask.scad>

// --- dimensions of the display   -------------------------------------------

display = [97, 69.3, 3.2];
border_i = [4, 4, 4, 9];    // inner border: right, back, left, front
border_o = 15;              // outer (frame) border
border_add = 0;
front_z    = 2;

base_angle = 30;            // display angle within base from vertical
feet_x     = 10;

// --- calculated dimensions   -----------------------------------------------

frame_back    = [display.x+2*border_o,
                 display.y+2*border_o+border_add,
                 display.z+BT
                ];
offset_back   = [0, 0, BT+FUZZ];

frame_front   = [display.x+2*border_o,
                 display.y+2*border_o+border_add,
                 front_z
                ];
cutout_front  = [display.x-border_i[0]-border_i[2],
                 display.y-border_i[1]-border_i[3]
                ];
offset_front = [0, (border_i[3]-border_i[1])/2, 0];

base_x = frame_back.x;
//base_x = feet_x;                      // generates a single foot
base_d = 4*(display.z+BT+front_z);
base_h = frame_front.z+frame_back.z+GAP/2;
base_z = 4;
feet_y = cos(90-base_angle)*frame_back.y;

// --- modules for the parts   ----------------------------------------------

module back() {
  difference() {
    display_back(frame=frame_back,
                 display=[display.x+GAP, display.y+GAP, display.z],
                 offset=offset_back, lock=true);
    zmove(frame_back.z-display.z+2*FUZZ) ii4_acep_mask(size=display);
  }
}

module front() {
  display_front(frame=frame_front,
                cutout=cutout_front,
                offset=offset_front,
                joiner_z=frame_back.z);
}

module base() {
  display_base([base_x, base_d],
                z=base_z,
                h=base_h,
                alpha=base_angle,
                size_feet=[feet_x, feet_y]);
}

// --- create objects   -----------------------------------------------------

back();
xmove(frame_front.x + 20)
  front();
xmove(-frame_front.x - 20)
  base();
