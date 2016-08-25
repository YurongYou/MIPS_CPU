import java.util.*;
import java.io.*;
import java.math.*;

public class data_gen{
	public static void main(String[] args) throws IOException, FileNotFoundException {
		File file = new File("/Users/youyurong/Dev/MIPS_CPU/testBenches/testData/data.data");
		PrintStream ps = new PrintStream(new FileOutputStream(file));
		for (int i = 0; i < 32; ++i)
			ps.println(b2d(1 << i, 32));
	}
	public static String b2d(int decNum , int digit) {
        String binStr = "";
        for(int i= digit-1;i>=0;i--) {
            binStr +=(decNum>>i)&1;
        }
        return binStr;
    }
}