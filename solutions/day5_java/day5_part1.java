package solutions.day5_java;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;

public class day5_part1 {
    public static void main(String[] args) {
        long start = System.nanoTime();

        // get total lines in file without loading the file into memory using byte scan
        int totalLines = 0;
        try {
            File file = new File("data/day5/day5.txt");
            FileInputStream fis = new FileInputStream(file);
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                totalLines += bytesRead;
            }
            fis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // parse ranges into arrays for faster lookup
        // this is faster than using ArrayList because we can pre-allocate the arrays and avoid resizing
        long[] rangeStarts = new long[totalLines];
        long[] rangeEnds = new long[totalLines];
        int numRanges = 0;

        BufferedReader reader;
        try {
            reader = new BufferedReader(new FileReader("data/day5/day5.txt"));
            String line;


            // parse ranges until split by a blank line
            while ((line = reader.readLine()) != null && !line.trim().isEmpty()) {
                int dash = line.indexOf('-');
                rangeStarts[numRanges] = Long.parseLong(line.substring(0, dash));
                rangeEnds[numRanges] = Long.parseLong(line.substring(dash + 1));
                numRanges++;
            }

            int total = 0;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue; 
                long id = Long.parseLong(line);
                for (int i = 0; i < numRanges; i++) {
                    if (id >= rangeStarts[i] && id <= rangeEnds[i]) {
                        total++;
                        break;
                    }
                }
            }
            System.out.println(total);
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        long end = System.nanoTime();
        System.out.printf("Time: %.5f ms%n", (end - start) / 1_000_000.0);
    }
}