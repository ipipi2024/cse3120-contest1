.386
.model flat,stdcall
.stack 4096
INCLUDE Irvine32.inc
ExitProcess proto, dwExitCode:dword

.data
deckCounts DWORD 13 DUP(4)   ; 13 card ranks, each starts with count of 4
totalCardsDrawn DWORD 0       ; total cards drawn from deck
msgRank BYTE "Rank: ", 0
msgValue BYTE " -> Value: ", 0
currentCard DWORD ?           ; temporary storage for current card

; Hand storage (max 11 cards possible in blackjack before bust)
playerHand DWORD 11 DUP(0)    ; player's cards
playerHandSize DWORD 0        ; number of cards in player hand
dealerHand DWORD 11 DUP(0)    ; dealer's cards
dealerHandSize DWORD 0        ; number of cards in dealer hand

; Test messages
msgHand BYTE "Hand: ", 0
msgTotal BYTE " = Total: ", 0
msgSpace BYTE " ", 0

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
; GetCardValue PROC
; Description: Converts card rank (1-13) to blackjack value
; Input: EAX = card rank (1-13)
; Output: EAX = blackjack value
;         1 (Ace) → 1
;         2-10 → face value (2-10)
;         11 (Jack), 12 (Queen), 13 (King) → 10
; Modifies: EAX only
;------------------------------------------
GetCardValue PROC
    ; If rank is 1 (Ace), return 1
    cmp eax, 1
    je aceValue

    ; If rank is 2-10, return face value
    cmp eax, 10
    jbe faceValue

    ; If rank is 11-13 (Jack, Queen, King), return 10
    mov eax, 10
    ret

aceValue:
    mov eax, 1
    ret

faceValue:
    ; EAX already contains the face value (2-10)
    ret
GetCardValue ENDP

;------------------------------------------
; CalculateHandValue PROC
; Description: Calculates the total value of a hand with Ace optimization
;              Aces are counted as 11 if it doesn't cause a bust, otherwise 1
; Input: ESI = pointer to hand array (DWORD array of card ranks)
;        ECX = hand size (number of cards)
; Output: EAX = total hand value
; Modifies: EAX, EBX, ECX, EDX
;------------------------------------------
CalculateHandValue PROC
    push esi
    push edi

    mov eax, 0            ; total = 0
    mov ebx, 0            ; aceCount = 0
    mov edi, ecx          ; save hand size

    ; If hand is empty, return 0
    cmp edi, 0
    je emptyHand

calculateLoop:
    ; Get current card rank
    mov edx, [esi]
    push eax              ; save current total
    mov eax, edx

    ; Check if it's an Ace
    cmp eax, 1
    jne notAce
    inc ebx               ; increment ace count

notAce:
    ; Convert rank to value
    call GetCardValue
    mov edx, eax          ; save card value
    pop eax               ; restore total
    add eax, edx          ; total += card value

    ; Move to next card
    add esi, 4
    dec edi
    jnz calculateLoop

    ; Now optimize Aces: if we have an Ace and total + 10 <= 21, add 10
    cmp ebx, 0            ; do we have any Aces?
    je noAceOptimization

    add eax, 10           ; try counting one Ace as 11
    cmp eax, 21
    jbe aceOptimized      ; if total <= 21, keep it
    sub eax, 10           ; otherwise, revert back

aceOptimized:
noAceOptimization:
emptyHand:
    pop edi
    pop esi
    ret
CalculateHandValue ENDP

;------------------------------------------
; DisplayHand PROC
; Description: Helper to display a hand and its total
; Input: ESI = pointer to hand array
;        ECX = hand size
;------------------------------------------
DisplayHand PROC
    push ecx
    push esi
    push eax
    push edx
    push ebx

    mov ebx, ecx          ; save hand size

    ; Display "Hand: "
    mov edx, OFFSET msgHand
    call WriteString

    ; Display each card
    mov ecx, ebx
displayLoop:
    mov eax, [esi]
    call WriteDec
    mov edx, OFFSET msgSpace
    call WriteString
    add esi, 4
    loop displayLoop

    ; Calculate and display total
    ; ebx still contains hand size
    ; Reset ESI to start of hand (subtract hand_size * 4 bytes)
    mov edx, ebx
    shl edx, 2            ; edx = hand_size * 4
    sub esi, edx          ; ESI back to start of hand
    mov ecx, ebx          ; ECX = hand size for CalculateHandValue
    call CalculateHandValue

    mov edx, OFFSET msgTotal
    call WriteString
    call WriteDec
    call Crlf

    pop ebx
    pop edx
    pop eax
    pop esi
    pop ecx
    ret
DisplayHand ENDP

;------------------------------------------
; main PROC
; Description: Test harness for CalculateHandValue
;------------------------------------------
main PROC
    call Randomize

    ; Test 1: [10, 7] = 17
    mov playerHand[0], 10
    mov playerHand[4], 7
    mov esi, OFFSET playerHand
    mov ecx, 2
    call DisplayHand

    ; Test 2: [1, 9] = 20 (Ace as 11)
    mov playerHand[0], 1
    mov playerHand[4], 9
    mov esi, OFFSET playerHand
    mov ecx, 2
    call DisplayHand

    ; Test 3: [1, 5, 10] = 16 (Ace as 1)
    mov playerHand[0], 1
    mov playerHand[4], 5
    mov playerHand[8], 10
    mov esi, OFFSET playerHand
    mov ecx, 3
    call DisplayHand

    ; Test 4: [1, 1, 9] = 21 (one Ace as 11, one as 1)
    mov playerHand[0], 1
    mov playerHand[4], 1
    mov playerHand[8], 9
    mov esi, OFFSET playerHand
    mov ecx, 3
    call DisplayHand

    ; Test 5: [1, 10] = 21 (Blackjack)
    mov playerHand[0], 1
    mov playerHand[4], 10
    mov esi, OFFSET playerHand
    mov ecx, 2
    call DisplayHand

    ; Test 6: [11, 12, 13] = 30 (all face cards = 10)
    mov playerHand[0], 11
    mov playerHand[4], 12
    mov playerHand[8], 13
    mov esi, OFFSET playerHand
    mov ecx, 3
    call DisplayHand

    ; Test 7: [7, 7, 7] = 21 (three 7s)
    mov playerHand[0], 7
    mov playerHand[4], 7
    mov playerHand[8], 7
    mov esi, OFFSET playerHand
    mov ecx, 3
    call DisplayHand

    invoke ExitProcess, 0
main ENDP
END main
