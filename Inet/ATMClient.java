import java.io.*;   
import java.net.*;  
import java.util.Scanner;
/**
 * Authors: Felix Hedenström Jonathan Rinnarv
 */
public class ATMClient {
    private static int connectionPort = 8989;
    private static String INPUT_ARROW = "> ";
    private static String LANGUAGE_PATH = "client_language.txt"; 
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
    public static void reciveLanguage(BufferedReader in){
        try{
            PrintWriter fileWriter = new PrintWriter(LANGUAGE_PATH);
            String temp = in.readLine();
            while(!temp.equals(ProtocolHandler.STRING_HAS_ENDED)){
                fileWriter.println(temp);
                temp = in.readLine();
            }
            fileWriter.close();
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    public static void main(String[] args) throws IOException {
        
        Socket ATMSocket = null;
        PrintWriter out = null;
        BufferedReader in = null;
        String adress = "";
        Language lang = new Language(LANGUAGE_PATH);
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
                        System.out.println(lang.withdrawal[2]);
                    // if the withdrawalamount was small enough
                    }else{     
                        System.out.println(lang.withdrawal[3]);
                    }
                //if the authenticationcode was incorrect
                }else{ 
                    System.out.println(lang.withdrawal[4]);
                }
                pressEnterToContinue(scanner);
        		break;
        	case 4: // Change language
        		System.out.println(lang.changeLanguage[0]);
                System.out.print(INPUT_ARROW);
                int language;
                language = scanner.nextInt(); 
                if(language > 0 && language < 3){
                    // Create an instruction requesting a new language
                    ProtocolHandler.writeInstruction(out, ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_LANGUAGE, language));
                    reciveLanguage(in);
                    lang = new Language(LANGUAGE_PATH);
                }else{ 
                    // Out of bounds index
                    System.out.println(lang.changeLanguage[1]);
                }
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
        public String changeLanguage [];

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
                changeLanguage = new String[2];
                addStrings(changeLanguage, bufferedReader);
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
