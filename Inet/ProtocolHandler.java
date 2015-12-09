public class ProtocolHandler{
	final static int TYPE_AUTHENTICATION = 0, TYPE_WITHDRAWAL = 1, TYPE_BALANCE = 2, TYPE_CLOSE = 3, TYPE_DEPOSIT = 4;
	public static char[] intToCharArray(int value) {
	    return new char[] {
	            (char) (value >>> 24),
	            (char) (value >>> 16),
	            (char) (value >>> 8),
	            (char) value};
	}

	public static int charArrayToInt(char [] array){
		int temp = 0;
		for(int i = 0; i < array.length; i++){
			temp |= array[i] << (array.length -  1 - i) * 8;
		}
		/*temp |= array[3];
		temp |= array[2] << 8;
		temp |= array[1] << 16;
		temp |= array[0] << 24;*/
		return temp;
	}
	public static int getInstructionType(char message []){
		return (message[0] << 8) + message[1];    	
    }
    public static int getInstructionNumber(char message []){
    	return message[8];
    }
	public static char [] defineInstruction(final int instructionType, final int instructionNumber){
    	char temp [] = new char[10];
    	char array [] = intToCharArray(instructionType);
    	temp[0] = array[2];
    	temp[1] = array[3];
    	array = intToCharArray(instructionNumber);
    	temp[8] = array[3];
    	return temp;
    }
}