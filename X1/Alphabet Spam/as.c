// Authors: Felix Hedenström
//			Jonathan Rinnarv
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char * input[]){
	// Allocate a char array that allowes for 100 000 characters
	char * temp = malloc(100000 * sizeof(char));
	scanf("%s", temp); 	// Read the string
	int totalchars = 0;	// Counter of chars

	// Counters that keep track how often a character has appeared
	float whitespaceratio = 0;
	float lowercaseratio = 0;
	float uppercaseratio = 0;
	float symbolsratio = 0;

	// Go through the string until you find an end of line character
	while(*temp != 0 && *temp != 10 && *temp != 3){

		char temp_char = *temp; // Save a character from the string

		if(temp_char == 95)		// The character is a whitespace
			whitespaceratio++;
		else if(temp_char <= 122 && temp_char >= 97) // Lowercase character
			lowercaseratio++;
		else if(temp_char <= 90 && temp_char >= 65) // Uppercase character
			uppercaseratio++;
		else 										// Symbol
			symbolsratio++;
		
		totalchars++; 		// Add to the total
		temp = temp + 1; 	// Iterate the pointer
	
	}	
	// Print the ratios 
	printf("%.15f\n", whitespaceratio / totalchars);
	printf("%.15f\n", lowercaseratio / totalchars);
	printf("%.15f\n", uppercaseratio / totalchars);
	printf("%.15f\n", symbolsratio / totalchars);

}