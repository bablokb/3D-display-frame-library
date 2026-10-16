// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic Display Frame Library: build for
//                      Waveshare Pico-ResTouch-LCD-2.8"
//
// Author: Bernhard Bablok
// License: CC-BY-SA
//
// https://github.com/bablokb/3D-display-frame-library
// ---------------------------------------------------------------------------

include <../display_parts.scad>
include <ws28_mask.scad>

// --- dimensions of the display   -------------------------------------------

display     = [70.7, 52.7, 6.1];    // physical outer dimensions
display_off = [8.8, 3, 2.5, 4.5];   // inner display offsets: right, back, left, front
border_o    = 15;                   // outer (frame) border
front_z     = 2;                    // height of passpartout

cable_d     = 5;                    // diameter of cable

// --- calculated dimensions   -----------------------------------------------

frame_back    = [display.x+2*border_o,
                 display.y+2*border_o,
                 display.z+BT
                ];
// move display to center the display area
offset_back   = [(display_off[0]-display_off[2])/2,
                 (display_off[1]-display_off[3])/2, BT+FUZZ];

frame_front   = [display.x+2*border_o,
                 display.y+2*border_o,
                 front_z
                ];
cutout_front  = [display.x-display_off[0]-display_off[2],
                 display.y-display_off[1]-display_off[3]
                ];
// cutout offset is relative to offset-back: here we undo offset-back
// to have a centered offset
cutout_offset = [-offset_back.x, -offset_back.y, 0];

frame_z = frame_back.z + frame_front.z + 20;  // sockets+Pico: 15.3
frame_w = 4;                                  // default frame-wall thicknes
frame_d = 10;                                 // default frame-top diameter

// --- modules for the parts   ----------------------------------------------

module back() {
  difference() {
    display_back(frame=frame_back,
                 display=[display.x+GAP, display.y+GAP, display.z],
                 offset=offset_back, jlock=false, wall_lock=W2, rounding=0);
    zmove(frame_back.z-display.z+2*FUZZ) move(offset_back) ws28_mask(size=display);
  }
}

module front() {
  display_front(frame=frame_front,
                offset=[offset_back.x, offset_back.y, 0],
                cutout=cutout_front,
                coffset=cutout_offset,
                chamfer=true,
                joiner_z=0);
}

module frame() {
  difference() {
    display_frame(size=[frame_back.x,frame_back.y],      // basic size
                       d=frame_d,                        // diameter of rounded top
                       wall=frame_w,                     // wall thickness
                       wall_lock=W2,
                       total_z=frame_z,                  // complete height
                       front_z=frame_front.z,            // frame height of display_front()
                       back_z=frame_back.z);             // frame height of display_back()
    // add a cutout for a cable
    move([-frame_back.x/2-frame_w, -frame_back.y/2+cable_d, -FUZZ])
      cuboid([3*frame_w, cable_d, 1.5*cable_d], rounding=cable_d/2, edges=TOP,
             anchor=BOTTOM+CENTER);
  }
}

// --- create objects   -----------------------------------------------------

back();
xmove(frame_front.x + 20)
  front();
xmove(-frame_front.x - 20)
  frame();
