<?php

$total = 50;

$count = 0;

$time_start = microtime(true);

$lines = file('data/day1/day1.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

foreach ($lines as $line) {
    $result = sscanf($line, "%c%d");
    calculate($result[0], $result[1]);
}

// calculate("L",50);
echo "Count: $count\n";

// time in microseconds
$time = (microtime(true) - $time_start) * 1_000_000;

echo "Time: $time µs\n";


function calculate($direction, $ticks) {
    global $total;
    global $count;

    $f = intdiv($ticks,100);
    $ticks = $ticks % 100;

    if ($f > 0){
        $count += $f;
    }
    // echo "Direction: $direction, Ticks: $ticks, Total: $total\n";
    if ($direction === 'R') {
        $total = upperBound($total, $ticks);
        // echo "Upper bound: $total\n";
    } else {
        $total = lowerBound($total, $ticks);
        // echo "Lower bound: $total\n";
    }
}
echo "Count: $count\n";

function upperBound($tot, $ticks) {
    global $count;
    if ($tot + $ticks > 99) {
        $count++;
        // echo "Passed 100!!\n";
        return $tot + $ticks - 100;
    }
    return $tot + $ticks;
}

function lowerBound($tot, $ticks) {
    global $count;
    $result = $tot - $ticks;
    
    if ($tot > 0 && $result <= 0) {
        $count++;
        // echo "Passed 0!!\n";
    }
    
    if ($result < 0) {
        return $result + 100;
    }
    return $result;
}

?>