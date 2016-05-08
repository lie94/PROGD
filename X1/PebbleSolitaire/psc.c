// Authors: Felix Hedenström
//			Jonathan Rinnarv
#include <stdio.h>
#include <stdlib.h>
//char * temp = malloc(100000 * sizeof(char));


const int BOARDLENGTH = 12;


// Copies an array
void copyArray(char * copyFrom, char * copyTo, const int length);
// Returns the lowest possible number of moves
int leastNumberOfMoves(char * board);

int main(int argc, char * input[]){
	// Number of games
	int games;
	// Read the first input, which is the number of boards 
	scanf("%d", &games);
	
	int i;
	char board [BOARDLENGTH]; 	// Acts as a temporary board

	for(i = 0; i < games; i++){		// Read and test a board, 'games' nr of times
	
		scanf("%s",board);					// Reads a new board
		int n = leastNumberOfMoves(board);	// Get the lowest amount of pebbles possible with this board
		printf("%d\n", n);					// Print the amount
	
	}
}

// Return the lowest number of pebbles possible with the board 
int leastNumberOfMoves(char * board){
	
	int i;
	int lowest_amount = BOARDLENGTH;	// Initiates the lowest amount as 12
	int count = 0;						// Initiates the counter as 0

	char no_moves_left = 1;				// Boolean that checks if there are no pebbles that can be moved, default true 

	// Go through each position on the board
	for(i = 0; i < BOARDLENGTH; i++){
		
		if(board[i] == 'o'){	// If there is a pebble on this position
			
			count++;			// Increment the pebble counter
			
			// The pebble can jump to the right
			if (i < BOARDLENGTH - 2 && board[i + 1] == 'o' && board[i + 2] == '-'){ 
				no_moves_left = 0;			// There are moves available on this boardstate

				// Create a copy of the board and modify it as the pebble moves to the right
				char boardcopy [BOARDLENGTH];										 
				copyArray(board, boardcopy, BOARDLENGTH);
				boardcopy[i] 		= '-';
				boardcopy[i + 1] 	= '-';
				boardcopy[i + 2] 	= 'o';

				// Find the lowest amount of pebbles possible if we make this move
				int temp = leastNumberOfMoves(boardcopy);
				// Is this number lower than the lowest number number we have found yet? If so, save it 
				lowest_amount = temp < lowest_amount ? temp : lowest_amount;
			
			}
			// The pebble can move to the left
			if (i > 1 && board[i - 1] == 'o' && board[i - 2] == '-'){
				no_moves_left = 0;	// There are moves available on this boardstate

				// Create a copy of the board and modify it as the pebble moves to the left
				char boardcopy [BOARDLENGTH];
				copyArray(board, boardcopy, BOARDLENGTH);
				boardcopy[i] 		= '-';
				boardcopy[i - 1] 	= '-';
				boardcopy[i - 2] 	= 'o';

				// Find the lowest amount of pebbles possible if we make this move
				int temp = leastNumberOfMoves(boardcopy);
				// Is this number lower than the lowest number number we have found yet? If so, save it
				lowest_amount = temp < lowest_amount ? temp : lowest_amount;
			}
		
		}
	
	}
	// If there are no moves available, return the amount of pebbles on the board
	if(no_moves_left){
	
		return count;
	
	}else{	// If there were moves available, return the lowest recursive result of that move? 
	
		return lowest_amount;
	
	}

}


// Copies an array
void copyArray(char * copyFrom, char * copyTo, const int length){
	int i;
	for(i = 0; i < length; i ++){
		copyTo[i] = copyFrom[i];
	}
}