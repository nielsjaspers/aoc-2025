package solutions.day5_java;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;

public class day5_part2 {
    public static void main(String[] args) {
        long start = System.nanoTime();

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

        long[] rangeStarts = new long[totalLines]; 
        long[] rangeEnds = new long[totalLines];
        int numRanges = 0;

        BufferedReader reader;
        try {
            reader = new BufferedReader(new FileReader("data/day5/day5.txt"));
            String line;


            // parse ranges until split by a blank line
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) break; 
                int dash = line.indexOf('-');
                rangeStarts[numRanges] = Long.parseLong(line.substring(0, dash));
                rangeEnds[numRanges] = Long.parseLong(line.substring(dash + 1));
                numRanges++;
            }

            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (numRanges > 1) {
            // create final copies to avoid lambda capture issues
            final long[] startsForLambda = rangeStarts;
            final long[] endsForLambda = rangeEnds;
            
            Integer[] idx = new Integer[numRanges];
            for (int i = 0; i < numRanges; i++) idx[i] = i;
            
            Arrays.sort(idx, (a, b) -> {
                int cmp = Long.compare(startsForLambda[a], startsForLambda[b]);
                return (cmp != 0) ? cmp : Long.compare(endsForLambda[a], endsForLambda[b]);
            });
            
            long[] sortedStarts = new long[numRanges];
            long[] sortedEnds = new long[numRanges];
            for (int k = 0; k < numRanges; k++) {
                sortedStarts[k] = startsForLambda[idx[k]];
                sortedEnds[k] = endsForLambda[idx[k]];
            }
            rangeStarts = sortedStarts;
            rangeEnds = sortedEnds;
        }

        // merge overlapping ranges
        if (numRanges == 0) {
            System.out.println(0);
            return;
        }
        
        int write = 0;
        long curStart = rangeStarts[0];
        long curEnd = rangeEnds[0];
        
        for (int i = 1; i < numRanges; i++) {
            long s = rangeStarts[i];
            long e = rangeEnds[i];
            
            if (s <= curEnd + 1) {
                curEnd = Math.max(curEnd, e);
            } else {
                rangeStarts[write] = curStart;
                rangeEnds[write] = curEnd;
                write++;
                curStart = s;
                curEnd = e;
            }
        }
        
        // write the last merged range
        rangeStarts[write] = curStart;
        rangeEnds[write] = curEnd;
        write++;

        long total = 0;
        for (int k = 0; k < write; k++) {
            total += (rangeEnds[k] - rangeStarts[k] + 1);
        }
        System.out.println(total);
                

        long end = System.nanoTime();
        System.out.printf("Time: %.5f ms%n", (end - start) / 1_000_000.0);
    }
}