import java.io.*;   
import java.net.*;  
import java.util.Scanner;	



/**
*/
public class ATMClient{
	
    private static int connectionPort = 8989;
    
    private static char AUTHENTICATION = 00; 

    private static String Greeting = "Welcome to Bank! (1)Balance, (2)Withdrawal, (3)Deposit, (4)Exit";
    private static String authentication_strings [] = {"Card number: ", "Authentication number: ", "Authenticating...", "Error, wrong card number or authentication number. Please try again."};

    private static String command_line = "> ";	

    private static char[] recieveServerMessage(BufferedReader in){
    	char[] temp = null;
    	try{
    		temp = in.readLine().toCharArray();
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	return temp;
    }
    private static void client(PrintWriter out, BufferedReader in){

    	boolean authenticated = false;
        char message [];
        int client_id = 00;
        Scanner scanner = new Scanner(System.in);
        

        while(!authenticated){
        	System.out.println(authentication_strings[0]);
        	System.out.print(command_line);
        	int card_number = scanner.nextInt();
        	System.out.println(authentication_strings[1]);
        	System.out.print(command_line);
        	int authentication_number = scanner.nextInt();
        	System.out.println(authentication_strings[2]);
        	out.println(ProtocolHandler.defineInstruction(client_id,AUTHENTICATION,1));
        	out.println(card_number);
        	out.println(authentication_number);	
			message = recieveServerMessage(in);
			if(ProtocolHandler.getInstructionType(message) == AUTHENTICATION && ProtocolHandler.getID(message) != 0){
				authenticated = true;
				client_id = ProtocolHandler.getID(message); 
			}else{
				System.out.println(authentication_strings[3]);
			}
        }
        System.out.println("DU HAR VUNNIT");
        System.out.print("DITT ID ÄR: ");
        System.out.println(client_id);
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
        
        client(out,in);

        System.out.println("Contacting bank ... ");
        System.out.println(in.readLine()); 
        Scanner scanner = new Scanner(System.in);
        int menuOption = scanner.nextInt();
        int userInput;
        //Cliend
        //ou.sendRequest
        //in.recieve
        //while(true)
        //in.recieve
        //out.sent
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
