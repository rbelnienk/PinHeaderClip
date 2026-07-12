// PinHeaderClip v4 - "clipsingle"
// Reverse-engineered from clipsingle.3mf.
//
// The part is a little BRIDGE / staple:
//   * a thin top slab spanning the full length and width, and
//   * a foot at each end that drops down to the base, with a
//     semicircular arch tunnel through it (the pin channel).
// Between the two feet the underside is open - only the top slab spans.
//
// Coordinates are kept identical to the source model so this file is a
// drop-in match (X = width, Y = height, Z = length).

$fn = 96;

// ---- parameters (mm) --------------------------------------------------
half_w    = 1.27;     // half of the 2.54 mm (0.1") width
y_slab    =  0.15;    // underside of the top slab
y_top     =  0.60;    // top surface (flat over the whole length)

slot_r    =  0.75;    // radius of the arch / pin channel
slot_cy   = -1.27;    // centre height of the arch semicircle

foot_len  =  1.50;    // length of each end foot
span      = 17.80;    // clear length between the two feet (the measured gap)
z_start   = -19.10;   // keeps the original coordinate origin
z_end     = z_start + span + 2 * foot_len;   // = 1.70 at span = 17.80

// ---- options ----------------------------------------------------------
close_foot    = "start";   // close one foot into a stop: "start", "end" or "none"
cap_thickness = 0.40;      // thickness of that closing wall

count = 1;                 // number of clips side-by-side. They share walls
                           // at the 2.54 mm pitch so the long side faces
                           // touch -> one solid multi-way header clip.

equal_end_tines = true;    // pad the two outer tines so they are as wide as
                           // the (doubled) shared tines in the middle.

rows      = 1;             // pin-header rows to grip: 2 makes the tines twice
                           // as deep (longer fork) for a stacked two-row header.
tine_len  = slot_cy - (-2.54);            // straight tine/slot depth for one row (1.27)
y_bottom  = slot_cy - rows * tine_len;    // open mouth of the slot; deeper for more rows

pitch   = 2 * half_w;      // 2.54 mm  (channel pitch)
wall    = half_w - slot_r; // one channel side-wall = half a middle tine (0.52)
strip_w = count * pitch;   // pitch-defined width (channels stay on 2.54 grid)
total_w = strip_w + (equal_end_tines ? 2 * wall : 0);   // padded overall width

// ---- 2D cross sections (whole strip, count cells wide) ----------------
// One pin channel (bottom-open, round-topped slot).
module slot_2d() {
    union() {
        translate([-slot_r, y_bottom])
            square([2 * slot_r, slot_cy - y_bottom]);   // straight walls
        translate([0, slot_cy])
            circle(r = slot_r);                         // round top
    }
}

// All channels across the strip.
module slots_2d() {
    for (i = [0 : count - 1])
        translate([(i - (count - 1) / 2) * pitch, 0])
            slot_2d();
}

// Foot: full strip rectangle with every channel removed.
module arch_profile() {
    difference() {
        translate([-total_w / 2, y_bottom])
            square([total_w, y_top - y_bottom]);
        slots_2d();
    }
}

// Middle: only the thin top slab.
module slab_profile() {
    translate([-total_w / 2, y_slab])
        square([total_w, y_top - y_slab]);
}

// Full solid cross section (used to close a foot).
module body_profile() {
    translate([-total_w / 2, y_bottom])
        square([total_w, y_top - y_bottom]);
}

// Thin floor that bridges the fork tines, closing the mouth of each channel.
module mouth_fill_2d() {
    for (i = [0 : count - 1])
        translate([(i - (count - 1) / 2) * pitch, 0])
            translate([-slot_r, y_bottom])
                square([2 * slot_r, cap_thickness]);
}

// ---- assembly (profiles extruded along Z = length) --------------------
module pin_header_clip() {
    // top slab, full length
    translate([0, 0, z_start])
        linear_extrude(height = z_end - z_start) slab_profile();

    // foot at each end
    translate([0, 0, z_start])
        linear_extrude(height = foot_len) arch_profile();
    translate([0, 0, z_end - foot_len])
        linear_extrude(height = foot_len) arch_profile();

    // close one foot: bridge the fork tines by flooring the mouth of each
    // channel (a thin surface across the slot opening, thickness cap_thickness).
    // The arch shape and the end faces stay untouched.
    if (close_foot == "start")
        translate([0, 0, z_start])
            linear_extrude(height = foot_len) mouth_fill_2d();
    else if (close_foot == "end")
        translate([0, 0, z_end - foot_len])
            linear_extrude(height = foot_len) mouth_fill_2d();
}

pin_header_clip();
