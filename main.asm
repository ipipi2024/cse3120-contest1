.386
.model flat,stdcall
.stack 4096
INCLUDE Irvine32.inc
ExitProcess proto, dwExitCode:dword

.data
deckCounts DWORD 13 DUP(4)   ; 13 card ranks, each starts with count of 4
totalCardsDrawn DWORD 0       ; total cards drawn from deck

.code

;------------------------------------------
; InitializeDeck PROC
; Description: Resets the deck to initial state (4 of each rank)
; Input: None
; Output: None
; Modifies: deckCounts array, totalCardsDrawn
;------------------------------------------
InitializeDeck PROC
    push ecx
    push edi
    push eax

    ; Reset all counts to 4
    mov ecx, 13
    mov edi, OFFSET deckCounts
    mov eax, 4

resetLoop:
    mov [edi], eax
    add edi, 4
    loop resetLoop

    ; Reset total cards drawn
    mov totalCardsDrawn, 0

    pop eax
    pop edi
    pop ecx
    ret
InitializeDeck ENDP

;------------------------------------------
; DrawCard PROC
; Description: Draws a random card from the deck (1-13)
;              Automatically regenerates if selected card is exhausted
; Input: None
; Output: EAX = card rank (1-13)
; Modifies: EAX, deckCounts array
;------------------------------------------
DrawCard PROC
    push ecx
    push edi

tryAgain:
    ; Generate random number 1-13
    mov eax, 13
    call RandomRange      ; EAX = 0-12
    inc eax               ; shift to 1-13

    ; Check if this rank is available (count > 0)
    mov ecx, eax          ; save card rank
    dec ecx               ; convert to 0-based index
    mov edi, OFFSET deckCounts
    mov eax, [edi + ecx*4] ; get deckCounts[rank-1]
    cmp eax, 0
    je tryAgain           ; if count = 0, try another card

    ; Decrement the count for this rank
    dec eax
    mov [edi + ecx*4], eax

    ; Restore card rank to EAX for return
    mov eax, ecx
    inc eax               ; convert back to 1-13

    pop edi
    pop ecx
    ret
DrawCard ENDP

;------------------------------------------
; main PROC
; Description: Test harness - draws all 52 cards and displays them
;------------------------------------------
main PROC
    call Randomize        ; Seed the random number generator
    call InitializeDeck   ; Initialize deck to 4 of each rank

drawLoop:
    call DrawCard         ; Draw a card (result in EAX)
    call WriteDec         ; Display the card rank
    call Crlf

    ; Increment and check total cards drawn
    inc totalCardsDrawn
    mov eax, totalCardsDrawn
    cmp eax, 52           ; Have we drawn all 52 cards?
    jb drawLoop           ; if < 52, continue drawing

    invoke ExitProcess, 0
main ENDP
END main
