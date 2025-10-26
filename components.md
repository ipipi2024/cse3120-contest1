 Component Break down
 
  Component 1: Random Number Generator (Foundation)

  - Build a basic random number generator that produces values 1-13
  - Test criteria:
    - Generate 100 numbers and verify all are in range [1, 13]
    - Display generated numbers to verify distribution looks reasonable
    - Ensure no crashes or invalid values

  Component 2: Deck State Management

  - Initialize array/memory to track card counts (4 per rank)
  - Implement draw card function that decrements count
  - Implement check to prevent drawing when count = 0
  - Test criteria:
    - Draw all 4 Aces, verify 5th draw either skips or regenerates
    - Display card counts after multiple draws
    - Verify all 52 cards can be drawn (4 × 13)

  Component 3: Card Value Conversion

  - Convert rank (1-13) to blackjack value
  - Handle simple cases: 2-10 = face value, J/Q/K = 10, Ace = 1 (initially)
  - Test criteria:
    - Test rank 1 → value 1 (or 11)
    - Test rank 7 → value 7
    - Test rank 11, 12, 13 → all value 10

  Component 4: Hand Total Calculation (including Ace logic)

  - Calculate total for a hand of cards
  - Implement Ace optimization (use 11 if it doesn't bust, otherwise 1)
  - Test criteria:
    - Hand [Ace, 9] → 20 (Ace as 11)
    - Hand [Ace, 5, 10] → 16 (Ace as 1, would bust as 11)
    - Hand [Ace, Ace, 9] → 21 (one Ace as 11, one as 1)
    - Hand [10, 7] → 17

  Component 5: User Input (Hit/Stand)

  - Prompt user for input
  - Accept 'H' or 'S' (or similar)
  - Validate input and re-prompt if invalid
  - Test criteria:
    - Enter 'H' → proceeds to hit
    - Enter 'S' → proceeds to stand
    - Enter invalid character → re-prompts

  Component 6: Display Functions

  - Display card rank as readable text (e.g., "Ace", "7", "King")
  - Display hand (list of cards + total)
  - Display game state (player hand, one dealer card)
  - Test criteria:
    - Display sample hands with correct formatting
    - Verify totals shown are accurate

  Component 7: Blackjack Detection

  - Check if a 2-card hand equals 21
  - Test criteria:
    - [Ace, 10] → natural blackjack
    - [Ace, King] → natural blackjack
    - [7, 7, 7] → 21 but NOT blackjack (3 cards)

  Component 8: Dealer Logic

  - Implement dealer hit/stand rules (hit < 17, stand ≥ 17)
  - Test criteria:
    - Dealer at 16 → must hit
    - Dealer at 17 → must stand
    - Dealer at soft 17 (Ace, 6) → follow your chosen rule

  Component 9: Win Condition Logic

  - Compare hands and determine winner
  - Handle bust, blackjack, push scenarios
  - Test criteria:
    - Player 20 vs Dealer 19 → Player wins
    - Player 18 vs Dealer 20 → Dealer wins
    - Both 19 → Push
    - Player bust → Dealer wins immediately
    - Player blackjack, Dealer 20 → Player wins

  Component 10: Full Game Integration

  - Connect all components into complete game flow
  - Test criteria:
    - Play complete games from start to finish
    - Test all code paths (player bust, dealer bust, blackjack, push, normal win)
    - Verify deck tracking across entire game
