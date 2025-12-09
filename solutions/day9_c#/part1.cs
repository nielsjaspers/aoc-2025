public static class Part1 {
    public static void Run() {
        string[] lines = File.ReadAllLines("data/day9/day9.txt"); // why the hell is reading a file so damn slow???
        long[][] points = new long[lines.Length][];

        for (int i = 0; i < lines.Length; i++) {
            string line = lines[i];
            long[] point = line.Split(',').Select(long.Parse).ToArray();
            points[i] = point;
        }
        long max_area = 0;
        long[] best_pair = new long[2];
        for (int i = 0; i < points.Length; i++) {
            for (int j = i + 1; j < points.Length; j++) {
                long[] point1 = points[i];
                long[] point2 = points[j];

                long area = Math.Abs((point1[0] - point2[0]) + 1) * Math.Abs((point1[1] - point2[1]) + 1); // +1 because the points are inclusive
                if (area > max_area) {
                    max_area = area;
                    best_pair = new long[] { i, j };
                }
            }
        }
        Console.WriteLine(max_area);
    }
}