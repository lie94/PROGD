import java.io.*;

public class ProtocolHandler{
	final static int TYPE_AUTHENTICATION = 0, TYPE_WITHDRAWAL = 1, TYPE_BALANCE = 2, TYPE_CLOSE = 3, TYPE_DEPOSIT = 4, TYPE_LANGUAGE = 5, TYPE_BANNER = 6;
	final static String STRING_HAS_ENDED = "-";
	public static char[] intToCharArray(int value) {
	    return new char[] {
	            (char) (value >>> 24),
	            (char) (value >>> 16),
	            (char) (value >>> 8),
	            (char) value};
	}

	public static int charArrayToInt(char [] array) {
		int temp = 0;
		for(int i = 0; i < array.length; i++){
			temp |= array[i] << (array.length -  1 - i) * 8;
		}
		return temp;
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
    public static void printMessage(char [] array){
    	for(char c : array)
    		System.out.print((int) c + " |");
    	System.out.println();
    }
    public static void writeInstruction(PrintWriter out, char [] message){
    	for(char c : message)
    		out.write(c);
    	out.flush();
    }
    
    public static void writeInt(PrintWriter out, int n){
    	char temp [] = intToCharArray(n);
    	char send_a [] = new char[10];
    	for(int i = 0; i < 4; i++){
    		send_a[6 + i] = temp[i];
    	}
    	writeInstruction(out,send_a);
    }

    public static char [] readInstruction(BufferedReader in) throws IOException{
    	char temp [] = new char[10];
    	for(int i = 0; i < 10; i++)
    		temp[i] = (char) in.read();
    	return temp;
    }

    public static int readInt(BufferedReader in) throws IOException{
    	char temp [] = readInstruction(in);
    	return charArrayToInt(temp);
    }
}