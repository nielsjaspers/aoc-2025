defmodule Day7 do
  def solve(input) do
    start_time = System.monotonic_time(:microsecond)
    lines = String.split(input, "\n", trim: true)
    grid = Enum.map(lines, &String.graphemes/1)
    # IO.inspect(grid)

    {start_row, start_col} = find_s(grid)

    split_count = process_queue([{start_row, start_col}], MapSet.new(), grid, MapSet.new(), 0)

    end_time = System.monotonic_time(:microsecond)
    microseconds = end_time - start_time
    milliseconds = microseconds / 1000.0
    IO.puts("Time taken: #{microseconds} µs (#{:io_lib.format("~.5f", [milliseconds])} ms)")
    split_count
  end

  defp find_s(grid) do
    Enum.reduce_while(Enum.with_index(grid), nil, fn {row, row_idx}, _acc ->
      case Enum.find_index(row, fn cell -> cell == "S" end) do
        nil -> {:cont, nil}
        col_idx -> {:halt, {row_idx, col_idx}}
      end
    end)
  end

  defp process_queue([], _visited, _grid, _hit_splitters, split_count), do: split_count

  defp process_queue([{row, col} | rest], visited, grid, hit_splitters, split_count) do
    cond do
      MapSet.member?(visited, {row, col}) ->
        process_queue(rest, visited, grid, hit_splitters, split_count)

      col < 0 or col >= length(Enum.at(grid, 0)) ->
        process_queue(rest, visited, grid, hit_splitters, split_count)

      true ->
        {new_beams, new_hit_splitters, new_splits} = simulate_beam(row, col, grid, hit_splitters)
        new_visited = MapSet.put(visited, {row, col})

        process_queue(
          rest ++ new_beams,
          new_visited,
          grid,
          new_hit_splitters,
          split_count + new_splits
        )
    end
  end

  defp simulate_beam(row, col, grid, hit_splitters) do
    simulate_beam_down(row + 1, col, grid, hit_splitters, [], 0)
  end

  defp simulate_beam_down(row, _col, grid, hit_splitters, new_beams, splits)
       when row >= length(grid) do
    {new_beams, hit_splitters, splits}
  end

  defp simulate_beam_down(row, col, grid, hit_splitters, new_beams, splits) do
    cell = Enum.at(grid, row) |> Enum.at(col)

    if cell == "^" do
      if MapSet.member?(hit_splitters, {row, col}) do
        # already hit this splitter, don't count again
        {new_beams, hit_splitters, splits}
      else
        # new splitter found
        {new_beams ++ [{row, col - 1}, {row, col + 1}], MapSet.put(hit_splitters, {row, col}),
         splits + 1}
      end
    else
      simulate_beam_down(row + 1, col, grid, hit_splitters, new_beams, splits)
    end
  end
end

IO.puts(Day7.solve(File.read!("data/day7/day7.txt")))

# fuck this language man
