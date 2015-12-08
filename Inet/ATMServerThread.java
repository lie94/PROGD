import java.io.*;
import java.net.*;

/**
*/
public class ATMServerThread extends Thread{
    private Socket socket = null;
    private BufferedReader in;
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

    private boolean validateUser() {
        return true;
    }

    private void readFromFile(){

    }        
    public void run(){
        try {
            out = new PrintWriter(socket.getOutputStream(), true);
            in = new BufferedReader
                (new InputStreamReader(socket.getInputStream()));
			
            String inputLine, outputLine;
            while(true){
                inputLine = readLine();
                switch(){
                    
                } 

            }
       	}catch (IOException e){
        	e.printStackTrace();
        }
    }
    /*public void run(){

    	try{
  			out = new PrintWriter(socket.getOutputStream(), true);
            in = new BufferedReader
                (new InputStreamReader(socket.getInputStream()));
			
            String inputLine, outputLine;

            int balance = 1000;
            int value;

            validateUser();
            out.println(""); 
            inputLine = readLine();
            int choise = Integer.parseInt(inputLine);
            while (choise != 4) {
                int deposit = 1;
                switch (choise) {
                case 2:
                    deposit = -1
                case 3:
                    out.println("Enter amount: ");	
                    inputLine= readLine();
                    value = Integer.parseInt(inputLine);
                    balance += deposit * value;
                case 1:
                    out.println("Current balance is " + balance + " dollars");  // 1 balance
                    out.println("(1)Balance, (2)Withdrawal, (3)Deposit, (4)Exit"); // 2
                    inputLine=readLine();
                    choise = Integer.parseInt(inputLine);
                    break;
                case 4:
                    break;
                default: 
                    break;
                }
            }
            out.println("Good Bye");
            out.close();
            in.close();
            socket.close();
        }catch (IOException e){
            e.printStackTrace();
        }
   
    }*/

}
