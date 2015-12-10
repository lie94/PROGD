import java.io.*;   
import java.net.*;  
import java.util.Scanner;
/**
 * Authors: Felix Hedenström Jonathan Rinnarv
 */
public class ATMClient {
    private static int connectionPort = 8989;
    private static String INPUT_ARROW = "> ";
    /**
     * Waits for the user to press enter before showing the next options
     */
    public static void pressEnterToContinue(Scanner scanner){
        System.out.println("Press enter to continue");    
        try{
            System.in.read(); //Strunta i vad som skrivs    
        } catch(Exception e){

        }
    }
    /**
     * Displays all menu options. 
     * input:
     * String banner : A string containing the preferred banner to be shown.
     */
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
        Language lang = new Language("standard_client_language.txt");

        // Retrieve the IP from the terminal
        try {
            adress = args[0];
        } catch (ArrayIndexOutOfBoundsException e) {
            System.err.println("Missing argument ip-adress");
            System.exit(1);
        }
        // Connect to the socket
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

        System.out.println(lang.authentication_frases[0]);							

        // Validate user before allowing access to any other menu options
        boolean validated = false;
        while(!validated){
        	ProtocolHandler.writeInstruction(out,(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_AUTHENTICATION, 1)));
        	System.out.println(lang.authentication_frases[1]);
        	System.out.print(INPUT_ARROW);
        	ProtocolHandler.writeInt(out,(scanner.nextInt()));
        	System.out.println(lang.authentication_frases[2]);
        	System.out.print(INPUT_ARROW);
        	ProtocolHandler.writeInt(out,scanner.nextInt());
        	char temp [] = ProtocolHandler.readInstruction(in);
        	if(ProtocolHandler.getInstructionType(temp) == ProtocolHandler.TYPE_AUTHENTICATION && ProtocolHandler.getInstructionNumber(temp) == 1){
        		validated = true;
        	}else{
        		System.out.println(lang.authentication_frases[3]);
                pressEnterToContinue(scanner);
        	}  
        }
        
        // A loop that keeps running as long as the user wants to stay in the menu.
        boolean running = true;
        while(running){
            System.out.println(lang.getBanner(in,out));
            System.out.println(lang.menu[0]);
        	System.out.print(INPUT_ARROW);
        	int menuOption = scanner.nextInt();
        	switch(menuOption){
        	case 3:    // Deposition
        		ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_DEPOSIT,1)); // Send the deposition instruction
        		System.out.println(lang.deposit[0]);
        		System.out.print(INPUT_ARROW);
        		ProtocolHandler.writeInt(out,scanner.nextInt()); // Sent the entered int                                                   
                System.out.println(lang.deposit[1]);
                pressEnterToContinue(scanner);
                break;
        	case 1: // Balance
        		ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_BALANCE,1)); // Send the balance instruction
        		System.out.println(lang.balance[0] + ProtocolHandler.readInt(in));
                pressEnterToContinue(scanner);
        		break;
        	case 2: // Withdraw
                ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_WITHDRAWAL,1)); // send the withdraw instruction
                System.out.println(lang.withdrawal[0]);
                System.out.print(INPUT_ARROW);
                // Send authenticationcode
                ProtocolHandler.writeInt(out, scanner.nextInt()); 
                char [] temp = ProtocolHandler.readInstruction(in);
                // if the authenticationcode was correct
                if(ProtocolHandler.getInstructionType(temp) == ProtocolHandler.TYPE_WITHDRAWAL && ProtocolHandler.getInstructionNumber(temp) == 1){ 
                    System.out.println(lang.withdrawal[1]);
                    System.out.print(INPUT_ARROW);
                    ProtocolHandler.writeInt(out,scanner.nextInt());
                    temp = ProtocolHandler.readInstruction(in);
                    // if the withdrawal-amount was larger then the current balance
                    if(ProtocolHandler.getInstructionType(temp) == ProtocolHandler.TYPE_WITHDRAWAL && ProtocolHandler.getInstructionNumber(temp) == 4){ 
                        System.out.println(withdrawal[2]);
                    // if the withdrawalamount was small enough
                    }else{     
                        System.out.println(withdrawal[3]);
                    }
                //if the authenticationcode was incorrect
                }else{ 
                    System.out.println(withdrawal[4]);
                }
                pressEnterToContinue(scanner);
        		break;
        	case 4: // Change language
        		//TODO
        		break;
        	case 5:    // Close the client and server thread
        		ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_CLOSE, 1));
        		running = false;
        		break;
        	default:
        		System.out.println(lang.menu[1]);
        	    pressEnterToContinue(scanner);
            }
        }
        out.close();
        in.close();
        ATMSocket.close();
    }
    private static class Language{
        public String authentication_frases [];
        public String menu [];
        public String deposit [];
        public String withdrawal [];
        public String balance [];
        public String banner;
        public String changeLanguage;
        public int version;
        public Language(String filepath){
            try {
                FileReader fileReader = new FileReader(filepath);
                BufferedReader bufferedReader = new BufferedReader(fileReader);
                authentication_frases = new String[4];
                addStrings(authentication_frases, bufferedReader);
                menu = new String[2];
                addStrings(menu, bufferedReader);
                balance = new String[1];
                addStrings(balance, bufferedReader);
                deposit = new String[2];
                addStrings(deposit,bufferedReader);
                withdrawal = new String[5];
                addStrings(withdrawal,bufferedReader);
                version = 0;
                fileReader.close();
                bufferedReader.close();
            } catch(Exception e){
                e.printStackTrace();
            }
        }
        public void addStrings(String [] array, BufferedReader bufferedReader) throws IOException{
            for(int i = 0; i < array.length; i++){
                String temp = bufferedReader.readLine();
                array[i] = temp;
                temp = bufferedReader.readLine();
                while(temp != null && !temp.isEmpty() ){
                    array[i] += "\n" + temp;
                    temp = bufferedReader.readLine();
                }
            }
        }
        public String getBanner(BufferedReader in, PrintWriter out){
            return "DU ÄR EN COOL SNUBBE/SNUBBINA";
        
        }
    }
}   
