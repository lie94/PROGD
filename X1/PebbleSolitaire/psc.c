// Authors: Felix Hedenström
//			Jonathan Rinnarv
#include <stdio.h>
#include <stdlib.h>
//char * temp = malloc(100000 * sizeof(char));


const int BOARDLENGTH = 12;

void copyArray(char * copyFrom, char * copyTo, const int length);
int leastNumberOfMoves(char * board);

int main(int argc, char * input[]){
	int games;

	scanf("%d", &games);
	
	int i;
	char board [BOARDLENGTH];
	

	for(i = 0; i < games; i++){
	
		scanf("%s",board);
		int n = leastNumberOfMoves(board);
		printf("%d\n", n);
	
	}
}

int leastNumberOfMoves(char * board){
	int i;
	int lowest_amount = BOARDLENGTH;
	int count = 0;

	char no_moves_left = 1;

	for(i = 0; i < BOARDLENGTH; i++){
		
		if(board[i] == 'o'){
			count++;
			if (i < BOARDLENGTH - 2 && board[i + 1] == 'o' && board[i + 2] == '-'){ // The pebble can jump forward
				no_moves_left = 0;
				char boardcopy [BOARDLENGTH];
				copyArray(board, boardcopy, BOARDLENGTH);
				
				boardcopy[i] 		= '-';
				boardcopy[i + 1] 	= '-';
				boardcopy[i + 2] 	= 'o';

				int temp = leastNumberOfMoves(boardcopy);
				lowest_amount = temp < lowest_amount ? temp : lowest_amount;
			
			}
			if (i > 1 && board[i - 1] == 'o' && board[i - 2] == '-'){
				no_moves_left = 0;
				char boardcopy [BOARDLENGTH];
				copyArray(board, boardcopy, BOARDLENGTH);
				
				boardcopy[i] 		= '-';
				boardcopy[i - 1] 	= '-';
				boardcopy[i - 2] 	= 'o';
				
				int temp = leastNumberOfMoves(boardcopy);
				lowest_amount = temp < lowest_amount ? temp : lowest_amount;
			}
		
		}
	
	}
	if(no_moves_left){
		return count;
	}else{
		return lowest_amount;
	}

}

void copyArray(char * copyFrom, char * copyTo, const int length){
	int i;
	for(i = 0; i < length; i ++){
		copyTo[i] = copyFrom[i];
	}
}