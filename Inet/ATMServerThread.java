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

    

    public void run(){
         
        try {
            out = new PrintWriter(socket.getOutputStream(), true);
            in = new BufferedReader
                (new InputStreamReader(socket.getInputStream()));

            FileReader fileReader = null; 
            PrintWriter fileWriter = null; 
            BufferedReader bufferedReader = null;

            while(!validated){
                char temp [] = ProtocolHandler.readMessage(in);
                

                if(ProtocolHandler.getInstructionType(temp) == ProtocolHandler.TYPE_AUTHENTICATION && ProtocolHandler.getInstructionNumber(temp) == 1 ){ //Following this is the card number and authentication code
                    //String card_number = ProtocolHandler.charArrayToInt(in.readLine().toCharArray()) + "";
                    char [] temp2 = ProtocolHandler.readMessage(in);
                    System.out.println("Card number length: " + temp2.length);
                    for(char c : temp2){
                        System.out.println((int) c);
                    }

                    int auth_number = ProtocolHandler.charArrayToInt(in.readLine().toCharArray());
                    validated = validateUser(card_number, auth_number, fileReader, bufferedReader, fileWriter);
                    if(validated){
                        filename = card_number + ".txt";
                        out.println(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_AUTHENTICATION,1));
                    }else{
                        out.println(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_AUTHENTICATION,2));
                    }

                }
                
            }
            fileReader = new FileReader(filename);
            bufferedReader = new BufferedReader(fileReader);
            bufferedReader.mark(0);
            boolean running = true;
            while(running){ 
                char [] instruction = in.readLine().toCharArray();
                switch(ProtocolHandler.getInstructionType(instruction)){
                case ProtocolHandler.TYPE_BALANCE:
                    bufferedReader.reset();
                    bufferedReader.readLine(); // We don't need information from the first line
                    int temp = Integer.parseInt(bufferedReader.readLine());
                    out.println(ProtocolHandler.intToCharArray(temp));    
                    break;
                case ProtocolHandler.TYPE_CLOSE:
                    running = false;
                    break;
                case ProtocolHandler.TYPE_DEPOSIT:
                    bufferedReader.reset();
                    int added_amount = ProtocolHandler.charArrayToInt(in.readLine().toCharArray());
                    String line1 = bufferedReader.readLine();
                    int current_amount = Integer.parseInt(bufferedReader.readLine());
                    fileWriter = new PrintWriter(filename);
                    fileWriter.println(line1);
                    fileWriter.println((current_amount + added_amount) + "");
                    fileWriter.close();
                    break;
                default:
                    System.err.println(instruction);
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
