<?php

$total = 50;

$count = 0;

$time_start = microtime(true);

$lines = file('data/day1/day1.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

foreach ($lines as $line) {
    $ticks = (int)substr($line, 1);
    $ticks = $ticks % 100;

    $total = ($line[0] === 'R')
        ? ($total + $ticks) % 100
        : ($total - $ticks + 100) % 100;

    if ($total === 0) {
        $count++;
    }
}
echo "Count: $count\n";

// time in microseconds
$time = (microtime(true) - $time_start) * 1_000_000;

echo "Time: $time µs\n";

?>