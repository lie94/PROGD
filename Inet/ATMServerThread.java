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


    PrintWriter out;
    public ATMServerThread(Socket socket) {
        super("ATMServerThread");
        this.socket = socket;
    }

    private String readLine() throws IOException {
        String str = in.readLine();
        //System.out.println(""  + socket + " : " + str);
        return str;
    }

    private boolean validateUser(String filename, int code) {
        try {
            FileReader fileReader = 
                new FileReader(filename + ".txt");

            BufferedReader bufferedReader = 
                new BufferedReader(fileReader);
            int file_code = Integer.parseInt(bufferedReader.readLine());
            if(file_code * 2 - 1 == code){
                String tempString = bufferedReader.readLine(); 
                PrintWriter temp_out = new PrintWriter(filename + ".txt");
                temp_out.println(file_code + 1);
                temp_out.println(tempString);
                temp_out.close();      
                bufferedReader.close();         
                return true;
            }else{
                bufferedReader.close();
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

            String inputLine, outputLine;
	
            int balance = 1000;
            int value;
            
            while(!validated){
                char temp [] = in.readLine().toCharArray();
                if(ProtocolHandler.getInstructionType(temp) == ProtocolHandler.TYPE_AUTHENTICATION && ProtocolHandler.getInstructionNumber(temp) == 1 ){ //Following this is the card number and authentication code
                    String card_number = in.readLine();
                    int auth_number = Integer.parseInt(in.readLine());
                    validated = validateUser(card_number, auth_number);
                    if(validated){
                        out.println(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_AUTHENTICATION,1));
                    }else{
                        out.println(ProtocolHandler.defineInstruction(ProtocolHandler.TYPE_AUTHENTICATION,2));
                    }

                }
                
            }
            /*while(false){
                                
            }*/



            out.close();
            in.close();
            socket.close();
        }catch (IOException e){
            e.printStackTrace();
        }
    
    }
}
