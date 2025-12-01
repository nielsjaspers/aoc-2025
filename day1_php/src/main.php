<?php

$total = 50;
$count = 0;
$time_start = microtime(true);

$lines = file('data/day1/day1.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

foreach ($lines as $line) {
    $ticks = (int)substr($line,1);
    $f = intdiv($ticks,100);
    $count += $f;

    $ticks = $ticks % 100;

    if ($line[0] === 'R') {
        $new = $total + $ticks;
        $count += intdiv($new, 100);  // 1 if crossed, 0 if not
        $total = $new % 100;
    } else {
        $new = $total - $ticks;
        if ($total > 0 && $new <= 0) $count++;
        $total = ($new % 100 + 100) % 100;
    }
}

echo "Count: $count\n";

// time in microseconds
$time = (microtime(true) - $time_start) * 1_000_000;
echo "Time: $time µs\n";

echo "Count: $count\n";
?>