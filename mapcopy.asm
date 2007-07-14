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
; define "show_pos" and "show_scr" before including
;
    .pos = show_pos
    .source = show_source
    .dest = show_dest

; show:
    !macro show {
        jsr  show_code
    }

show_code
    ldx .pos
    lda .tabla,x
    tax
.source_label
    lda .source,x
.dest_label
    sta .dest,x
    inc .pos
    rts

    show_source_addr = .source_label + 1
    show_dest_addr = .dest_label + 1

.tabla
    !byte 195, 227, 194, 162, 228,  97, 226, 128, 129, 130, 225,  64, 161, 163, 224,  96
    !byte 160, 193, 196,  32,  98, 192,  65,   0, 131, 229, 164,  33,  99, 197,  66, 132
    !byte   1, 230,  34, 165,  67, 100, 198,   2,   3,  68,   6,  35, 133, 166,   5, 101
    !byte   4, 199,   7,  36, 231,  69, 134, 167,  37,  38, 102, 135,  70, 232,  71,  39
    !byte 103, 136, 200, 168,   8,  11,  10, 169, 233, 104,   9,  12, 137, 201,  13,  40
    !byte  44,  72,  43, 170,  42,  45,  41, 105,  73, 202,  14, 138, 234,  74,  75, 106
    !byte 203,  76, 171,  46,  77, 235, 107, 139,  15, 108, 172, 174, 140, 173, 141, 142
    !byte 204, 109, 206, 207, 205,  78, 175,  47, 236, 239, 143, 237, 238, 110, 240, 241
    !byte 111, 208,  16,  79, 176, 209, 242,  48, 144, 243,  80, 177, 244, 112, 210,  17
    !byte  49, 178, 179,  52,  53, 147,  18,  81, 211, 145,  19, 146,  51,  85, 180,  20
    !byte  54, 113, 148,  22,  50,  84, 212,  21,  55, 115, 245,  83, 114, 116,  23,  82
    !byte  86,  88,  89,  87, 118, 117, 119, 149, 213,  56,  57, 181, 214,  90, 121, 122
    !byte 150, 151, 182, 183, 215, 246,  58, 120, 247,  24, 153, 184, 152, 216,  25,  26
    !byte  59,  91, 248, 123, 185,  27,  60, 217, 154,  28,  92, 249,  29, 155, 186,  61
    !byte 218,  93, 124, 250, 187,  30, 251,  62, 156,  94, 125, 219, 188,  31, 252, 254
    !byte 220, 253,  63, 126, 255, 157, 221,  95, 159, 191, 222, 127, 189, 223, 158, 190

}

