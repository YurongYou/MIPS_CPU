import java.util.*;
import java.io.*;
import java.util.regex.*;

public class converter{
	public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader("branch_in.data"));
        BufferedWriter wr = new BufferedWriter(new FileWriter("branch.data"));
        String data = br.readLine();
        while (data != null){
            String[] insts = data.split(" ");
            String temp;
            for (int i = 0; i < insts.length; i = i + 2){
                temp = insts[i] + insts[i + 1];
                wr.write(temp);
                wr.newLine();
                System.out.println(temp);
            }
            data = br.readLine();
        }
        wr.close();
    }
}