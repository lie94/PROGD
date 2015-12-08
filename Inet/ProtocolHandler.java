public class ProtocolHandler{
	final static int TYPE_AUTHENTICATION = 0;
	public static char[] intToCharArray(int value) {
	    return new char[] {
	            (char) (value >>> 24),
	            (char) (value >>> 16),
	            (char) (value >>> 8),
	            (char) value};
	}
	public static int getInstructionType(char message []){
		return (message[0] << 8) + message[1];    	
    }
    public static int getInstructionNumber(char message []){
    	return message[9];
    }
	public static char [] defineInstruction(final int instructionType, final int instructionNumber){
    	char temp [] = new char[10];
    	char array [] = intToCharArray(instructionType);
    	temp[0] = array[2];
    	temp[1] = array[3];
    	array = intToCharArray(instructionNumber);
    	temp[9] = array[3];
    	return temp;
    }
}