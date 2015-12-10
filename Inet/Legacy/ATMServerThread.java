import java.io.*;
import java.net.*;

/**
 *  @author Viebrapadata
 */
public class ATMServerThread extends Thread {
    private Socket socket = null;
    private BufferedReader in;
    private String card_number = "";
    private boolean validated = false;
    private String filename;

    PrintWriter out;
    public ATMServerThread(Socket socket) {
        super("ATMServerThread");
        this.socket = socket;
    }
    /**
     * Validates the user if the username is 
     */
    private boolean validateUser(String filename, int code, FileReader fileReader, BufferedReader bufferedReader, PrintWriter fileWriter) {
        try {
            fileReader = new FileReader(filename + ".txt");

            bufferedReader = new BufferedReader(fileReader);
            
            int file_code = Integer.parseInt(bufferedReader.readLine());
            if(file_code * 2 - 1 == code){
                String tempString = bufferedReader.readLine(); 
                fileWriter = new PrintWriter(filename + ".txt");
                fileWriter.println(file_code + 1);
                fileWriter.println(tempString);
                fileWriter.close();
                return true;
            }else{
                return false;
            }
        } catch(Exception e) {
            return false;
        }
    }

    private void sendMessage(BufferedReader read_local, PrintWriter out){
        try{
            String temp = read_local.readLine();
            while(temp != null){
                out.println(temp);
                temp = read_local.readLine();     
            }
            out.println(ProtocolHandler.STRING_HAS_ENDED);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void run(){
         
        try {
            out = new PrintWriter(socket.getOutputStream(), true);
            in = new BufferedReader
                (new InputStreamReader(socket.getInputStream()));

            FileReader fileReader = null; 
            PrintWriter fileWriter = null; 
            BufferedReader bufferedReader = null;
            
            // Validate user credentials
            while(!validated){
                char temp [] = ProtocolHandler.readInstruction(in);
                // If it is an instruction message
                if(ProtocolHandler.getInstructionType(temp) == ProtocolHandler.TYPE_AUTHENTICATION && ProtocolHandler.getInstructionNumber(temp) == 1 ){ //Following this is the card number and authentication code
                    String card_number = ProtocolHandler.readInt(in) + "";
                    int auth_number = ProtocolHandler.readInt(in);
                    validated = validateUser(card_number, auth_number, fileReader, bufferedReader, fileWriter);
                    // If the 
                    if(validated){
                        filename = card_number + ".txt";
                        ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_AUTHENTICATION,1));
                    }else{
                        ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_AUTHENTICATION,2));
                    }   
                }
            } 

            boolean running = true;
            while(running){ 
                char [] instruction = ProtocolHandler.readInstruction(in);
                //ProtocolHandler.printMessage(instruction);
                switch(ProtocolHandler.getInstructionType(instruction)){
                case ProtocolHandler.TYPE_BALANCE:
                    fileReader = new FileReader(filename);
                    bufferedReader = new BufferedReader(fileReader);
                    bufferedReader.readLine(); // We don't need information from the first line
                    int balance = Integer.parseInt(bufferedReader.readLine());
                    ProtocolHandler.writeInt(out,balance);
                    fileReader.close();
                    break;
                case ProtocolHandler.TYPE_CLOSE:
                    running = false;
                    break;
                case ProtocolHandler.TYPE_DEPOSIT:
                    fileReader = new FileReader(filename);
                    bufferedReader = new BufferedReader(fileReader);
                    int added_amount = ProtocolHandler.readInt(in);
                    String line1 = bufferedReader.readLine();
                    int current_amount = Integer.parseInt(bufferedReader.readLine());
                    fileWriter = new PrintWriter(filename);
                    fileWriter.println(line1);
                    fileWriter.println((current_amount + added_amount) + "");
                    fileWriter.close();
                    break;
                case ProtocolHandler.TYPE_WITHDRAWAL:
                    fileReader = new FileReader(filename);  
                    bufferedReader = new BufferedReader(fileReader);
                    int iter = Integer.parseInt(bufferedReader.readLine());
                    int test_code = ProtocolHandler.readInt(in);                // Read possible authentication code
                    if(test_code == iter * 2 - 1){
                        ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_WITHDRAWAL,1));
                        int withdraw_amount = ProtocolHandler.readInt(in);
                        int old_balance = Integer.parseInt(bufferedReader.readLine());
                        if(withdraw_amount > old_balance){
                            withdraw_amount = 0;
                            ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_WITHDRAWAL,4));
                        }else{
                            ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_WITHDRAWAL,3));
                        }
                        fileWriter = new PrintWriter(filename);
                        fileWriter.println(iter + 1);
                        fileWriter.println(old_balance - withdraw_amount);
                    }else{
                        ProtocolHandler.writeInstruction(out,ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_WITHDRAWAL,2));
                    }
                    fileWriter.close();
                    bufferedReader.close();
                    break;
                case ProtocolHandler.TYPE_LANGUAGE:
                    // English
                    if(ProtocolHandler.getInstructionNumber(instruction) == 1){
                        fileReader = new FileReader("standard_english.txt");
                    // Swedish
                    }else if(ProtocolHandler.getInstructionNumber(instruction) == 2){
                        fileReader = new FileReader("standard_swedish.txt");
                    }else{
                        System.err.println("IMPOSSIBLE CLIENT REQUEST TYPE_LANGUAGE");
                        break;
                    }
                    bufferedReader = new BufferedReader(fileReader);
                    sendMessage(bufferedReader,out);
                    break;
                case ProtocolHandler.TYPE_BANNER:
                    fileReader = new FileReader("banner.txt");
                    bufferedReader = new BufferedReader(fileReader);
                    sendMessage(bufferedReader,out);
                    break;
                default:
                    ProtocolHandler.printMessage(instruction);
                    //running = false;
                }
            }
            bufferedReader.close();               
            fileReader.close();
            out.close();
            in.close();
            socket.close();
        }catch (IOException e){
            e.printStackTrace();
        }
    }
}
