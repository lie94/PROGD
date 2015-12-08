import java.io.*;   
import java.net.*;  
import java.util.Scanner;

public class ATMClient {
    private static int connectionPort = 8989;
    private static String INPUT_ARROW = "> ";

    public static void main(String[] args) throws IOException {
        
        Socket ATMSocket = null;
        PrintWriter out = null;
        BufferedReader in = null;
        String adress = "";

        try {
            adress = args[0];
        } catch (ArrayIndexOutOfBoundsException e) {
            System.err.println("Missing argument ip-adress");
            System.exit(1);
        }

        try {
            ATMSocket = new Socket(adress, connectionPort); 
            out = new PrintWriter(ATMSocket.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader
                                    (ATMSocket.getInputStream()));
        } catch (UnknownHostException e) {
            System.err.println("Unknown host: " +adress);
            System.exit(1);
        } catch (IOException e) {
            System.err.println("Couldn't open connection to " + adress);
            System.exit(1);
        }

        Scanner scanner = new Scanner(System.in);
        



        boolean validated = false;
        while(!validated){
        	out.println(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_AUTHENTICATION, 1));
        	System.out.println("Enter your card number: ");
        	System.out.print(INPUT_ARROW);
        	out.println(scanner.nextInt());
        	System.out.println("Enter your authentication number: ");
        	System.out.print(INPUT_ARROW);
        	out.println(scanner.nextInt());
        	char temp [] = in.readLine().toCharArray();
        	if(ProtocolHandler.getInstructionType(temp) == ProtocolHandler.TYPE_AUTHENTICATION && ProtocolHandler.getInstructionNumber(temp) == 1){
        		validated = true;
        	}else{
        		System.out.println("Wrong information, try again.");
        	}
        }

        System.out.println("Contacting bank ... ");

        System.out.println(in.readLine()); 

        System.out.print("> ");
        int menuOption = scanner.nextInt();
        int userInput;
        out.println(menuOption);
        while(menuOption < 4) {
                if(menuOption == 1) {
                        System.out.println(in.readLine()); 
                        System.out.println(in.readLine());
                        System.out.print("> ");
                        menuOption = scanner.nextInt();
                        out.println(menuOption);           
                } else if (menuOption > 3) {
                    break;
                }	
                else {
                    System.out.println(in.readLine()); 
                    userInput = scanner.nextInt();
                    out.println(userInput);
                    String str;
                    do {
                        str = in.readLine();
                        System.out.println(str);
                    } while (! str.startsWith("(1)"));
                    System.out.print("> ");
                    menuOption = scanner.nextInt();
                    out.println(menuOption);           
                }	
        }		
		
        out.close();
        in.close();
        ATMSocket.close();
    }
}   
