public class Program {
    public static void Main(string[] args) {
        if (args[0] == "part1") {
            var start = DateTime.Now;
            Part1.Run();
            var end = DateTime.Now;
            var elapsed = end - start;
            Console.WriteLine($"Time taken: {elapsed.TotalMilliseconds} ms");
        }
        else if (args[0] == "part2") {
            var start = DateTime.Now;
            Part2.Run();
            var end = DateTime.Now;
            var elapsed = end - start;
            Console.WriteLine($"Time taken: {elapsed.TotalMilliseconds} ms");
        }
        else {
            Console.WriteLine("Usage: dotnet run --project solutions/day9_c#/day9.csproj part1 or dotnet run --project solutions/day9_c#/day9.csproj part2");
        }
    }
}