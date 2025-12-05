package solutions.day5_java;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

public class day5_part1 {
    public static void main(String[] args) {
        long start = System.nanoTime();

        BufferedReader reader;
        try {
            reader = new BufferedReader(new FileReader("data/day5/day5.txt"));
            String line = reader.readLine();

            ArrayList<ArrayList<Long>> ranges = new ArrayList<>();
            ArrayList<Long> ids = new ArrayList<>();

            while (line != null && !line.trim().isEmpty()) {
                ranges.add(getRange(line));
                line = reader.readLine();

            }
            while (line != null) {
                if (line.trim().isEmpty()) {
                    line = reader.readLine();
                    continue;
                }
                ids.add(Long.parseLong(line));
                line = reader.readLine();
            }
            reader.close();
            ranges.sort((a, b) -> Long.compare(a.get(0), b.get(0)));
            // System.out.println(ranges);
            ranges = mergeOverlappingRanges(ranges);

            // System.out.println(ranges);
            int total = 0;
            for (long id : ids) {
                if (contains(ranges, id)) {
                    // System.out.println(id);
                    total++;
                }
            }
            System.out.println(total);
        } catch (IOException e) {
            e.printStackTrace();
        }

        long end = System.nanoTime();
        System.out.println("Time: " + (end - start) / 1_000_000 + " ms");
    }

    private static ArrayList<Long> getRange(String line) {
        String[] numbers = line.split("-");
        return new ArrayList<>(Arrays.asList(Long.parseLong(numbers[0]), Long.parseLong(numbers[1])));
    }

    private static ArrayList<ArrayList<Long>> mergeOverlappingRanges(ArrayList<ArrayList<Long>> ranges) {
        ArrayList<ArrayList<Long>> mergedRanges = new ArrayList<>();

        for (ArrayList<Long> range : ranges) {
            if (mergedRanges.isEmpty() || mergedRanges.get(mergedRanges.size() - 1).get(1) < range.get(0)) {
                mergedRanges.add(range);
            } else {
                mergedRanges.get(mergedRanges.size() - 1).set(1, Math.max(mergedRanges.get(mergedRanges.size() - 1).get(1), range.get(1)));
            }
        }
        return mergedRanges;
    }

    private static boolean contains(ArrayList<ArrayList<Long>> ranges, long id) {
        int lo = 0, hi = ranges.size() - 1, idx = -1;
        while (lo <= hi) {
            int mid = (lo + hi) >>> 1;
            if (ranges.get(mid).get(0) <= id) {
                idx = mid; lo = mid + 1;
            } else {
                hi = mid - 1;
            }
        }
        return idx >= 0 && id <= ranges.get(idx).get(1);
    }
}