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
; define "gira_pos" and "gira_scr" before including
;
    .pos = gira_pos
    .scr00 = gira_scr
    .scr01 = gira_scr + $8
    .scr10 = gira_scr + $100
    .scr11 = gira_scr + $108

; gira:
    !macro gira {
        jsr  gira_code
    }

; init code:
    !macro giraInit {
        +fillRect gira_scr-1, 1
        +fillRect gira_scr+7, 2
        +fillRect gira_scr+$107, 3
    }

gira_code:

    inc  .pos
    lda  .pos
    and  #63
    sta  .pos
    tax

    lda  .tabla,x
    tax
    lda  .scr11,x
    adc  #1
    and  #3

    sta  .scr11,x
    txa
    eor  #$E7
    tax
    lda  .scr00,x
    adc  #1
    and  #3
    sta  .scr00,x

    lda  .pos
    eor #63
    tax
    lda  .tabla,x
    eor  #$E0
    tax
    lda  .scr01,x
    adc  #1
    and  #3
    sta  .scr01,x

    txa
    eor  #$E7
    tax
    lda  .scr10,x
    adc  #1
    and  #3
    sta  .scr10,x

    rts

.tabla
    !byte 224, 192, 160, 128,  96, 225,  64, 193, 161, 226, 129,  32, 194,  97, 162, 227
    !byte 195, 130, 228,  65, 163, 196,  98, 229, 131, 164, 197, 230, 231, 132, 165, 198
    !byte  99,  66,  33,   0, 199, 166, 133, 100, 167,  67, 134, 101, 135,  34,  68, 102
    !byte 103,  69,  35,  70,  71,  36,   1,  37,  38,  39,   2,   3,   4,   5,   6,   7

}

