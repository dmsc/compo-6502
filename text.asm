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
; define:
;  "text_state": 8 bytes of internal state
;  "text_scr"  : output screen address
;  "text_data" : text character data
;
    text_char  = text_state + 0
    .fps = text_state + 1
    text_pixel = text_state + 2
    text_skip  = text_state + 3
    .cb  = text_state + 4
    .fsz = text_state + 5
    text_endFlag = text_state + 6
    .scr = text_scr
    .data = text_data

    ; abbreviations
    .pos = text_char
    .cxy = text_pixel
    .skp = text_skip

; "pos" pointer to the next character
; "cxy" screen position
; "fps" position in font data of current character
; "fsz" remaining bytes of current character
; "skp" skip data, used in spaces, begining and ending
; "cb"  current output byte (8 bits, one column)

; text:
    !macro text {
        jsr  text_code
    }

    !macro textInit1 {
        lda #$1f
        sta text_pixel
        lda #0
        sta text_endFlag
        sta text_skip
        sta text_char
        lda #1
        sta text_base_color
        lda #<text_scr
        sta text_dest_addr
        lda #>text_scr
        sta text_dest_addr+1
    }

    !macro textInit2 .scrOut {
        lda #$1f
        sta text_pixel
        lda #0
        sta text_endFlag
        sta text_skip
        sta text_base_color
        lda #<.scrOut
        sta text_dest_addr
        lda #>.scrOut
        sta text_dest_addr+1
    }


text_code

    lda .cxy
    and #$e0
    bne .putpixel     ; If we have more pixels, put them

    ; To next x coord
    lda .cxy
    clc
    adc #1
    and #$1f
    sta .cxy

    ; If we are in "skip" mode, skip :-)
    lda .skp
    beq .noskip

.doSkip
    ; skip this step (filling with blanks)
    dec .skp

.storeColumn0
    lda #0
    jmp .storeColumn

.noskip
    ; Continue font data
    dec .fsz

    ; Skip just one column if just at the end of character
    beq .storeColumn0

    bpl .nextcolumn ; More columns

    ; Get next character
    ldx .pos
    inc .pos
    lda .data, x
    bpl .fontdata

    ; A > 128, skip "A-128" characters
    and #$7F
    sta .skp

    ; If skip == 127 (value=255), signal the end of text data
    eor #$7F
    bne .storeColumn0

    lda #1
    sta text_endFlag
    jmp .storeColumn0

.fontdata
    tax
	lda .font_size,x
	sta .fsz
	dec .fsz

	lda .font_pos,x
	sta .fps

.nextcolumn
    ldx .fps
    inc .fps
    lda .font_data, x

.storeColumn
    sta .cb
    ; skip over to putpixel

.putpixel
    lda .cxy
    clc
    adc #$e0
	sta .cxy
    ldx .cxy
.base_color
	lda #1
	ror .cb
	rol
.dest_label
	sta .scr,x
	rts

    text_base_color = .base_color + 1
    text_dest_addr  = .dest_label + 1

; font
.font_size:
	!byte 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 2, 3, 3, 3, 3, 3, 1, 2, 3, 1
	!byte 5, 3, 3, 3, 3, 3, 2, 2, 3, 3, 5, 4, 3, 3, 5, 4, 4, 4, 3, 3, 4, 4
	!byte 1, 3, 4, 3, 5, 5, 5, 4, 5, 4, 4, 3, 4, 4, 7, 4, 4, 4, 2, 1
.font_pos:
	!byte   0,   3,   6,   9,  12,  15,  18,  21,  24,  27,  30,  32,  35
	!byte  35,  38,  40,  43,  46,  49,  50,  52,   4,  55,  55,  60,  63
	!byte  65,  68,  71,  73,  75,  78,  78,  33,  83,  86,  89,  94,  98
	!byte 102, 106, 109, 112, 116,  94, 120, 123, 127, 130, 134, 139, 144
	!byte 148, 153, 157, 161, 164, 167, 171, 178, 171, 182, 186,   5
.font_data:
	!byte  56, 68, 56, 36,124,  4, 76, 84, 36, 68, 84, 40, 24, 40,124,100
	!byte  84, 88, 56, 84, 72, 76, 80, 96, 40, 84, 40, 36, 84, 56, 44, 28
	!byte 124, 36, 24, 24, 36,124, 24, 52, 16, 60, 80, 24, 37, 30,124, 32
 	!byte  28,188,  1,190,124, 24, 36, 60, 32, 28, 32, 28, 24, 36, 24, 63
 	!byte  36, 24, 36, 63, 60, 16, 32, 52, 44,120, 36, 56,  4, 60, 56,  4
 	!byte  56,  4, 56, 57,  6, 56, 44, 52, 36, 12, 48,208, 48, 12,252,164
 	!byte 164, 88,120,132,132, 72,252,132,132,120,252,164,132,252,160,128
 	!byte 120,132,164, 56,252, 32, 32,252,  8,  4,248,252, 48, 80,140,252
 	!byte   4, 4, 252, 64, 60, 64,252, 64, 48,  8,252,120,132,132,132,120
 	!byte 252,144,144, 96,120,132,134,133,120,252,144,144,108, 68,164,164
 	!byte 152,128,252,128,248,  4,  4,248,  4,  8,240,224, 28, 16,224, 28
 	!byte  16,224,204, 48, 48,204,140,148,164,196,  0,  0


text_data
    !source "textdata.asm"

}

