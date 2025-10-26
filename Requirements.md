Simple Blackjack in Assembly - Planning Document

Questions
1.	Why not track the suit of the card? The suit of the card is not tracked because it is not useful in this game. In Blackjack, we care about adding the rank of the cards. Suits don't affect the value or gameplay.
2.	How can we represent cards for Blackjack in assembly? Since suits don't matter for game logic, you only need to track: 
o	Card rank (1-13): Store as a number where 1=Ace, 2-10=face value, 11=Jack, 12=Queen, 13=King
o	Card count: Track how many of each rank remain (start with 4 of each)
________________________________________

Requirements
Initial State & Random Generator
1.	The system should generate numbers from 1-13 (representing card ranks)
2.	The system should have a count of 4 for each rank initially (simulating a single deck)
3.	The system should decrement the count when a card is drawn
4.	The system should not allow drawing a card if its count is 0
Blackjack Logic
5.	The system should be able to determine blackjack based on the player and dealer's cards (Ace + 10-value card = 21 with 2 cards)
6.	The system should be able to calculate hand values, treating Aces as 1 or 11 appropriately
7.	The system should determine when the player or dealer busts (total > 21)
8.	The system should compare final hand values to determine the winner
9.	The system should handle dealer logic (dealer must hit on 16 or less, stand on 17 or more)
User Interaction
10.	The system should display the player's cards and current total
11.	The system should display one of the dealer's cards initially (hide the hole card)
12.	The system should prompt the player to Hit or Stand
13.	The system should display the final results and winner
________________________________________

Program Flow
1.	Initialize Game State 
o	Set card counts: each rank (1-13) has count = 4
o	Initialize player hand total = 0
o	Initialize dealer hand total = 0

2.	Initial Deal 
o	Generate random number 1-13, assign to player (card 1)
o	Decrement that rank's count
o	Generate random number 1-13, assign to dealer (card 1)
o	Decrement that rank's count
o	Generate random number 1-13, assign to player (card 2)
o	Decrement that rank's count
o	Generate random number 1-13, assign to dealer (card 2)
o	Decrement that rank's count

3.	Calculate Initial Hand Values 
o	Convert ranks to values (1=Ace=1 or 11, 2-10=face value, 11-13=10)
o	Calculate player total (handle Ace logic)
o	Calculate dealer total (handle Ace logic)

4.	Check for Natural Blackjack 
o	If player has 21 with 2 cards AND dealer doesn't: Player wins
o	If dealer has 21 with 2 cards AND player doesn't: Dealer wins
o	If both have 21 with 2 cards: Push (tie)
o	If either has blackjack, end game

5.	Player Turn (if no natural blackjack) 
o	Display player's cards and total
o	Display one dealer card
o	Prompt: "Hit or Stand?"
o	If Hit: 
    -Generate random number 1-13
    -Check if that rank's count > 0, if not, regenerate
    -Decrement count
    -Add to player hand
    -Recalculate player total
	-If player busts (> 21): Dealer wins, end game
    -If player < 21: repeat this step
oIf Stand: proceed to dealer turn

6.	Dealer Turn 
o	Reveal dealer's hidden card
o	While dealer total < 17: 
    -Generate random number 1-13 (with count checking)
    -Add to dealer hand
    -Recalculate dealer total
o	If dealer busts (> 21): Player wins, end game
o	If dealer >= 17: proceed to comparison

7.	Determine Winner 
o	If player total > dealer total: Player wins
o	If dealer total > player total: Dealer wins
o	If equal: Push (tie)

8.	Display Results 
o	Show final hands
o	Show totals
o	Announce winner



