*=$c000                ; Start of upper RAM area

!addr start = $fb      ; Inclusive start address of memory to clear, also current page
!addr end   = $fd      ; Inclusive end address of memory to clear

    lda #$00
    ldy start          ; Store start index of first page to clear in Y
    sta start          ; Clear low byte of start address

clearpage

    ldx start + 1      ; If current page is end page go to clearfinalpage
    cpx end + 1
    beq clearfinalpage

clearbytes

    sta (start),Y      ; Clear current byte
    cpy #$ff           ; If last byte of page was cleared go to nextpage
    beq nextpage
    iny                ; Prepare next loop iteration
    jmp clearbytes

nextpage

    ldy #$00           ; Reset page offset
    inc start + 1      ; and increment page
    jmp clearpage

clearfinalpage

    sta (start),Y      ; Clear current byte
    cpy end            ; If last byte of last page was cleared return
    beq return
    iny                ; Prepare next loop interation
    jmp clearfinalpage

return

    rts