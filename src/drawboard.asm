*=$C000                ; Start of upper RAM area

    color    = $02
    colorram = $fb
    pos      = $fd
    counters = $61

    lda #$00           ; Initialize pos to 1024
    sta pos
    lda #$04
    sta pos + 1

    lda #$03           ; Initialize color to 3 (cyan)
    sta color

    ldx #$01           ; Start of rows draw loop

rowsloop

    stx counters       ; Start lines draw loop
    ldx #$01

linesloop

    stx counters + 1   ; Start squares draw loop
    ldx #$01

    ldy #$00           ; Index into screen/color RAM of current line

    clc
    lda pos            ; Calculate color RAM address for current line
    sta colorram
    lda pos + 1
    adc #$d4
    sta colorram + 1

squaresloop

    stx counters + 2   ; Start square draw loop
    ldx #$01

squareloop

    lda #$a0           ; Write space to screen
    sta (pos),y
    lda color          ; Setting color
    sta (colorram),y
    iny;

    inx                ; End of square draw loop
    cpx #$05
    bne squareloop
    ldx counters + 2

    lda color          ; Switch square color
    eor #$03
    sta color

    inx                ; End of squares draw loop
    cpx #$09
    bne squaresloop
    ldx counters + 1

    clc                ; Increments value of pos by 40
    lda pos            ; Adding 40 to low byte
    adc #$28
    sta pos
    lda pos + 1        ; Adding carry to high byte
    adc #$00
    sta pos + 1

    inx                ; End of lines draw loop
    cpx #$04
    bne linesloop
    ldx counters

    lda color          ; Switch square color
    eor #$03
    sta color

    inx                ; End of rows draw loop
    cpx #$09
    bne rowsloop

    rts