// Authors: Felix Hedenström
//			Jonathan Rinnarv
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char * input[]){

	char * temp = malloc(100000 * sizeof(char));
	scanf("%s", temp);
	int totalchars = 0;

	//Float kanske inte är tillräckligt mycket
	float whitespaceratio = 0;
	float lowercaseratio = 0;
	float uppercaseratio = 0;
	float symbolsratio = 0;

	while(*temp != 0 && *temp != 10 && *temp != 3){
		char temp_char = *temp;
		if(temp_char == 95)
			whitespaceratio++;
		else if(temp_char <= 122 && temp_char >= 97) //lowercase
			lowercaseratio++;
		else if(temp_char <= 90 && temp_char >= 65) //highercase
			uppercaseratio++;
		else //symbol
			symbolsratio++;
		totalchars++;
		temp = temp + 1;
	}	
	printf("%.15f\n", whitespaceratio / totalchars);
	printf("%.15f\n", lowercaseratio / totalchars);
	printf("%.15f\n", uppercaseratio / totalchars);
	printf("%.15f\n", symbolsratio / totalchars);
}