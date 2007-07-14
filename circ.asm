;
; 6502 Assembler Demo.
; Copyright (C) 2007  Daniel Serpell <daniel.serpell@gmail.com>
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along
; with this program; if not, write to the Free Software Foundation, Inc.,
; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
;

    !zone {
;
; define "circ_pos" before including
;

    .pos = circ_pos
    .scr00 = circ_scr
    .scr01 = circ_scr + $8
    .scr10 = circ_scr + $100
    .scr11 = circ_scr + $108

; circ:
    !macro circ {
        jsr  circ_code
    }

circ_code:

	ldx	.pos
    lda .tabla,x
    tax
	inc	.scr11,x
    eor #07
    tax
	inc	.scr10,x
    eor #$e7
    tax
	inc	.scr01,x
    eor #07
    tax
	inc	.scr00,x

    rts

.tabla
	!byte   0,  32,   1,  33,  64,   2,  65,  34,  96,  66,   3,  97,  35,  98,  67, 128
	!byte   4, 129,  36,  99, 130,  68, 160,   5, 161, 131, 100,  37, 162,  69, 132, 192
	!byte 163, 101,   6, 193,  38, 194,  70, 164, 133, 195, 102, 224,   7, 225,  39, 165
	!byte 226, 196, 134,  71, 227, 103, 197, 166, 228, 135, 198, 229, 167, 230, 199, 231

}

