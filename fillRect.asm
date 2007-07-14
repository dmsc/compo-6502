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

; Uses the following:
;  params: param0, param1
;  temps: temp0


; Locals
    .color = temp0

; Params
    fillRect_buffer = param0
    .buf = fillRect_buffer

; fillRect:
;   Fill a rectangle of 8x8 pixels with a color.
; input: A  = color index
;        .buffer = output buffer (address)
    !macro fillRect .buffer {
        ldx  #<.buffer
        stx  fillRect_buffer
        ldx  #>.buffer
        stx  fillRect_buffer+1
        jsr  fillRect_code
    }

; fillRect:
;   Fill a rectangle of 8x8 pixels with a color.
; input: .color  = color index
;        .buffer = output buffer (address)
    !macro fillRect .buffer, .color {
        lda  #.color
        +fillRect .buffer
    }

fillRect_code:
	sta	.color
	ldx	#8
--
	ldy	#8
-
	sta	(.buf),y
	dey
	bne	-

	lda	.buf
	clc
	adc	#32
	sta	.buf
    lda .buf+1
    adc #0
    sta .buf+1
	lda	.color
	dex
	bne	--

	rts

}

