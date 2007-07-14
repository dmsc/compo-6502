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

; Parameters (consts)
    .scr = moire_scr
    .buf = moire_buf
; Variables
    .p1 = moire_temp
    .o1 = moire_temp + 2
    .o2 = moire_temp + 4
    .o3 = moire_temp + 6
    .o4 = moire_temp + 8
    .iter = moire_temp + 10
    .valStartX = moire_temp + 11
    .deltaX = moire_temp + 12
    .deltaY = moire_temp + 13
    .yPos = moire_temp + 14

; moire!:
    !macro moire {
        jsr  moire_code
    }

    !macro add16 .var, .value {
        lda .var
        clc
        adc #<.value
        sta .var
        lda .var+1
        adc #>.value
        sta .var+1
    }

    !macro sto16 .var, .value {
        lda #<.value
        sta .var
        lda #>.value
        sta .var+1
    }

moire_code:

    lda #0
    sta .iter

.loop:

    lda #1
    sta .deltaX
    sta .deltaY

    +sto16 .p1, .buf

    lda .iter
    sta .valStartX

    ldx #15
--
    ldy #15
-
    sta (.p1),y
    clc
    adc .deltaX
    inc .deltaX
    dey
    bpl -

    +add16 .p1, $0020

    lda #1
    sta .deltaX

    lda .valStartX
    clc
    adc .deltaY
    sta .valStartX
    inc .deltaY

    dex
    bpl --


; update screen
    +sto16 .p1, .buf
    +sto16 .o1, .scr + $01E0
    +sto16 .o2, .scr + $0200
    +sto16 .o3, .scr + $01F0
    +sto16 .o4, .scr + $0210

    lda #15
    sta .yPos
--
    ldy #15
-
    lda (.p1),y
    lsr
    lsr
    lsr
    lsr
    tax
    lda .tabCol,x

    cmp (.o1),y
    beq .noCopy
    sta (.o1),y
    sta (.o2),y
    tax
    tya
    eor #15
    tay
    txa
    sta (.o3),y
    sta (.o4),y
    tya
    eor #15
    tay
.noCopy:
    dey
    bpl -

    +add16 .p1, $0020
    +add16 .o1, $FFE0
    +add16 .o2, $0020
    +add16 .o3, $FFE0
    +add16 .o4, $0020

    dec .yPos
    bpl --

    inc .iter
    lda .iter
    and #$3f
    beq +
    jmp .loop
+
    rts

.tabCol
    !byte 0,11,12,15,1,15,12,11
    !byte 0,11,12,15,1,15,12,11
    !byte 0,11,12,15,1,15,12,11
    !byte 0,11,12,15,1,15,12,11

}
