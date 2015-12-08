public class ProtocolHandler{
	public static char[] intToCharArray(int value) {
	    return new char[] {
	            (char) (value >>> 24),
	            (char) (value >>> 16),
	            (char) (value >>> 8),
	            (char) value};
	}
	public static int getID(char message []){
		return (message[0] << 8) + message[1];

	}
	public static int getInstructionType(char message []){
		return (message[2] << 8) + message[3];    	
    }
	public static char [] defineInstruction(final int ID, final int instructionType, final int instructionNumber){
    	char temp [] = new char[10];
    	char array [] = intToCharArray(ID);
    	temp[0] = array[2];
    	temp[1] = array[3];
    	array = intToCharArray(instructionType);
    	temp[2] = array[2];
    	temp[3] = array[3];
    	array = intToCharArray(instructionNumber);
    	temp[9] = array[3];
    	return temp;
    }
}