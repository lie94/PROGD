import java.io.*;   
import java.net.*;  
import java.util.Scanner;

public class ATMClient {
    private static int connectionPort = 8989;
    private static String INPUT_ARROW = "> ";

    public static void displayMenuOptions(String banner){
    	System.out.println(banner);
    	System.out.println("+-----------------------+");
        System.out.println("| Choose a menu option: |");
        System.out.println("+-----------------------+");
        System.out.println("| 1. Balance\t\t|");
        System.out.println("| 2. Withdrawal\t\t|");
        System.out.println("| 3. Deposit\t\t|");
        System.out.println("| 4. Change language\t|");
        System.out.println("| 5. Exit\t\t|");
        System.out.println("+-----------------------+");
    }
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
        


        System.out.println("Contacting bank ... ");							

        boolean validated = false;
        while(!validated){
        	out.println(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_AUTHENTICATION, 1));
        	System.out.println("Enter your card number: ");
        	System.out.print(INPUT_ARROW);
        	out.println(ProtocolHandler.intToCharArray(scanner.nextInt()));
        	System.out.println("Enter your authentication number: ");
        	System.out.print(INPUT_ARROW);
        	out.println(ProtocolHandler.intToCharArray(scanner.nextInt()));
        	char temp [] = in.readLine().toCharArray();
        	if(ProtocolHandler.getInstructionType(temp) == ProtocolHandler.TYPE_AUTHENTICATION && ProtocolHandler.getInstructionNumber(temp) == 1){
        		validated = true;
        	}else{
        		System.out.println("Wrong information, try again.");
        	}
        }
        
        boolean running = true;
        while(running){
        	displayMenuOptions("");
        	System.out.print(INPUT_ARROW);
        	int menuOption = scanner.nextInt();
        	switch(menuOption){
        	case 3:
        		out.println(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_DEPOSIT,1));
        		System.out.println("Enter the amount to deposit:");
        		System.out.print(INPUT_ARROW);
        		out.println(ProtocolHandler.intToCharArray(scanner.nextInt()));
        	case 1:
        		out.println(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_BALANCE,1));
        		System.out.println("Your balance is: " + ProtocolHandler.charArrayToInt(in.readLine().toCharArray()));
        		break;
        	case 2:
        		break;
        	case 4:
        		//TODO
        		break;
        	case 5:
        		out.println(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_CLOSE, 1));
        		running = false;
        		break;
        	default:
        		System.out.println("Must choose a menu option between 1 and 5");
        	}
        }
        
        /*int userInput;
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
        }*/
		
        out.close();
        in.close();
        ATMSocket.close();
    }
}   
