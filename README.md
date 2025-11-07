Florida Institute of Technology
CSE 3120, Fall 2025
Professor Marius Silaghi

## Contest 1 Submission - Blackjack

### Usage:
1. Add `main.asm` to a Visual Studio project.
    * Or open `Project.sln` (project set on VS 2019, but can be "upgraded" to a newer version)
    * `PipiRamsey_Contest1_Blackjack.asm` on Canvas is equivalent to `main.asm`.
3. Build solution and run the resulting executable.

### Gameplay:
1. The game begins with both the player and dealer auto-drawing 2 cards. One of the dealer's cards is hidden.
2. The player is given the total value of their hand and given two options:
    * **Hit** (`H`) - Draws a card from the deck, adding to the player's total.
    * **Stand** (`S`) - Player draws no more cards, and the game turn proceeds to the dealer.
4. The goal is to get a hand total as close as possible to 21, but not over. If any hand goes over 21, it is an automatic loss.
    * Aces are valued at 11 until the hand is over 21, then revert to 1.
5. Once both the player and dealer finish their turn, the highest hand value (not over 21) wins.
