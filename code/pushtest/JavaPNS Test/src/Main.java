
import java.io.File;
import java.util.Scanner;
import javapns.Push;
import javapns.communication.exceptions.CommunicationException;
import javapns.communication.exceptions.KeystoreException;

/**
 * @author Alex Layton
 */
public class Main 
{

    public static void main(String[] args) throws CommunicationException, KeystoreException 
    {
        Scanner in = new Scanner(System.in);
        System.out.println("Enter payload: ");
        String message = in.nextLine();
        String path = "/Users/alex/Dropbox/Projects/pushtest/PushTestKey.p12";
        String token = "7cf7f6afcfa385b5b3692505e70ca0032aecd29eb2244fb2ff589c0ebc28b853";
        Push.alert(message, path, "villa", false, token);
    } //main
    
}
