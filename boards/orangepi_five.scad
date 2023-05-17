// Copyright (c) 2017 Clément Bœsch <u pkh.me>
//
// Permission to use, copy, modify, and distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

include <../globals.scad>

use <../case.scad>
use <../utils.scad>
use <../electronics/hdmi.scad>
use <../electronics/header.scad>
use <../electronics/jack.scad>
use <../electronics/misc.scad>
use <../electronics/network.scad>
use <../electronics/sd.scad>
use <../electronics/usb.scad>


board_dim = [100, 61.5, 1.25];

m2_screw_x_inset = 26;
m2_screw_y_inset = 12;


/* Plate holes */
hole_d = 3;
hole_orig = [board_dim[0], board_dim[1]] * -.5;
ring_off = 6.2 - hole_d;
hole_pad = 3.5;

holes_pos = [
    /* Corners */
    hole_orig + [0, 0]                       + hole_pad *  [ 1, 1],
    hole_orig + [0, board_dim[1]]            + hole_pad *  [ 1,-1],
    hole_orig + [board_dim[0], 0]            + hole_pad *  [ -1, 1],
    hole_orig + [board_dim[0], board_dim[1]] + hole_pad *  [ -1,-1],

    /* m2 */
    hole_orig + [board_dim[0] - m2_screw_x_inset, board_dim[1]] + hole_pad *  [ -1,-1],
    hole_orig + [board_dim[0] - m2_screw_x_inset, board_dim[1] -m2_screw_y_inset] + hole_pad *  [ -1,-1],
];

/* Components bounding box dimensions */
ethernet_dim    = [   21, 16, 14.5];
hdmi_dim        = [ 11.5, 15,  6.5];
jack_dim        = [ 14.5,  7,    6];
microsdcard_dim = [   15, 11,    1];
microsdslot_dim = [ 11.5, 12, 1.25];
usb_c_dim    =    [10,  10,    4.5];
gpio_dim        = [   32,  5,  8.5];
debug_dim        =[   6,  5,  8.5];
serialcon_dim   = [  2.5, 22,  5.5];
usbx1_dim       = [15, 5, 16.5];
usbx2_dim       = [17.25, 15, 16.5];

ethusb_dim      = [17.25, 3.25, 13.5]; // cleanup box
usbusb_dim      = [17.25,    3, 16.5]; // cleanup box


module orangepi_five_plate_2d() {
    plate_2d(board_dim[0], board_dim[1], 3);
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */

    [ethernet_info(),       ethernet_dim,    [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [   2,   24,   0]],
    [hdmi_info(),           hdmi_dim,        [ 1, 0,-1], [0,0,3], [-1,-1, 1], [  36,   -1,   0]],
    [jack_info(),           jack_dim,        [ 1, 0,-1], [0,0,3], [-1,-1, 1], [  21,   -2,   0]],
    [microsdcard_info(),    microsdslot_dim, [ 1, 0,-1], [0,0,2], [-1, 1, 1], [   0,  -14,   0]],
    [microsdslot_info(),    microsdslot_dim, [ 1, 0,-1], [0,0,2], [-1, 1, 1], [   0,  -14,   0]],
    [usb_c_info(),       usb_c_dim,       [ 1, 0,-1], [0,0,3], [-1,-1, 1], [   12,   -2,   0]],
    [pin_header_info(),     gpio_dim,        [ 0, 0,-1], [0,0,0], [-1, 1, 1], [25, -3,0]],
    [pin_header_info(),  debug_dim,          [ 0, 0,-1], [0,0,0], [-1, 1, 1], [   47, -2,0]], // camera
    [usb_info(),          usbx1_dim,         [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [    2,  10,0]],
    [usbx2_info(),          usbx2_dim,       [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [    2,  45,-1]],
    /*
    [usbx2_info(),          usbx2_dim,       [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [    2,  47,0]],

    [unknown_info(),        ethusb_dim,      [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [    2,19.875,0]],
    [unknown_info(),        usbusb_dim,      [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [    2,    38,0]],
    */
];

module orangepi_five() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off, clr=c_green_pcb, clr_ring=c_yellow)
       orangepi_five_plate_2d();

    set_components(board_dim, comp_info) {
        ethernet(dim=ethernet_dim, swap_led=true);
        hdmi(dim=hdmi_dim);
        jack(dim=jack_dim);
        microsdcard(dim=microsdcard_dim);
        microsdslot(dim=microsdslot_dim);
        usb_c(dim=usb_c_dim);
        pin_header_pitch254(dim=gpio_dim, n=13, m=2);
        pin_header_pitch254(dim=debug_dim, n=3, m=1);
        usb(dim=usbx1_dim);
        usbx2(dim=usbx2_dim);
        /*
        usbx2(dim=usbx2_dim);

        %cube(ethusb_dim, center=true);
        %cube(usbusb_dim, center=true);
        */
    }
}

function orangepi_five_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];


demo_board(board_dim) {
    orangepi_five();
    *#bounding_box(board_dim, comp_info);
}
