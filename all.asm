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

; Variable definitions
    temp0 = $20
    temp1 = $21
    temp2 = $22
    temp3 = $23
    temp4 = $24
    temp5 = $25

    param0 = $10
    param1 = $11
    param2 = $12
    param3 = $13


; Output file
    !to "all.bin", plain

; Start of code
    *= $600
    jmp main

; Used in "gira" and "circ"

    gira_pos = $30
    gira_scr = $200
    circ_pos = $30
    circ_scr = $210
    show_pos = $31
    show_source = $a000
    show_dest = $500
    text_state = $40
    text_scr = $a000
;    text_scr = $480
    moire_buf = $a000
    moire_scr = $200
    moire_temp = $20

; Include routines and macros
    !source "fillRect.asm"
    !source "gira.asm"
    !source "circ.asm"
    !source "mapcopy.asm"
    !source "text.asm"
    !source "moireSmooth.asm"

; Main loop

main

    +giraInit
    +textInit1
    lda #63
    sta gira_pos

    ; Start show-pos from middle of screen
    lda #128
    sta show_pos

    ; First color is 3
    lda #3
    sta text_base_color

    ; Clear old text image
    lda #0
    tax
-
    sta text_scr,x
    inx
    bne -

loop
    +gira
    +circ
    +show
    +text

    lda text_pixel
    eor #$1f
    bne notChangeTextColor
    lda text_base_color
    clc
    adc #2
    and #3
    adc #3
    sta text_base_color

notChangeTextColor

    lda show_pos
    bne loop

    lda show_dest_addr+1
    eor #1
    sta show_dest_addr+1

    lda text_endFlag
    beq loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End of first text, do moire!
    jsr clearScr
    +moire

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End of moire, do ending text
    +textInit2 $300
    jsr clearScr

; loop text output
-
    +text

    lda text_pixel
    eor #$1f
    bne -
    lda text_dest_addr+1
    eor #7
    sta text_dest_addr+1

    lda text_endFlag
    beq -

    jmp main

clearScr
    ; Clear screen
    lda #0
    tax
-
    sta $200,x
    sta $300,x
    sta $400,x
    sta $500,x
    inx
    bne -
    rts

