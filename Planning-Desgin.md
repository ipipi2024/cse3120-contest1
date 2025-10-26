2. Data Structures
2.1 Memory Layout (MASM)
.386
.model flat, stdcall
.stack 4096

.data
    ; ===== DECK DATA =====
    cardCounts BYTE 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4  ; Counts for ranks 1-13
    
    ; ===== PLAYER DATA =====
    playerCards BYTE 11 DUP(?)     ; Max 11 cards (4 Aces, 4 Twos, 3 Threes)
    playerCardCount BYTE 0          ; Number of cards in hand
    playerTotal BYTE 0              ; Current hand total
    playerAceCount BYTE 0           ; Number of Aces (for 1/11 logic)
    playerBusted BYTE 0             ; 0 = not busted, 1 = busted
    
    ; ===== DEALER DATA =====
    dealerCards BYTE 11 DUP(?)     ; Max 11 cards
    dealerCardCount BYTE 0          ; Number of cards in hand
    dealerTotal BYTE 0              ; Current hand total
    dealerAceCount BYTE 0           ; Number of Aces
    dealerBusted BYTE 0             ; 0 = not busted, 1 = busted
    
    ; ===== GAME STATE =====
    gameOver BYTE 0                 ; 0 = continue, 1 = game over
    winner BYTE 0                   ; 0 = none, 1 = player, 2 = dealer, 3 = push
    
    ; ===== RANDOM NUMBER GENERATOR =====
    randSeed DWORD ?                ; Seed for random number generator
    
    ; ===== DISPLAY STRINGS =====
    msgWelcome BYTE "=== BLACKJACK ===", 0Dh, 0Ah, 0
    msgPlayerCards BYTE "Your cards: ", 0
    msgDealerCards BYTE "Dealer cards: ", 0
    msgPlayerTotal BYTE "Your total: ", 0
    msgDealerTotal BYTE "Dealer total: ", 0
    msgHitStand BYTE "Hit (H) or Stand (S)? ", 0
    msgPlayerWin BYTE "You WIN!", 0Dh, 0Ah, 0
    msgDealerWin BYTE "Dealer WINS!", 0Dh, 0Ah, 0
    msgPush BYTE "PUSH (Tie)", 0Dh, 0Ah, 0
    msgBlackjack BYTE "BLACKJACK!", 0Dh, 0Ah, 0
    msgBust BYTE "BUST!", 0Dh, 0Ah, 0
    msgHidden BYTE "[Hidden] ", 0
    msgSpace BYTE " ", 0
    msgNewline BYTE 0Dh, 0Ah, 0
    
    ; Card rank names for display
    cardNames BYTE "A ", 0, "2 ", 0, "3 ", 0, "4 ", 0, "5 ", 0
              BYTE "6 ", 0, "7 ", 0, "8 ", 0, "9 ", 0, "10", 0
              BYTE "J ", 0, "Q ", 0, "K ", 0

.code