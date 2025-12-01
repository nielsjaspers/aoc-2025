<?php

$total = 50;

$count = 0;

function main() {
    $time_start = microtime(true);

    $lines = file('data/day1/day1.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    global $total;
    global $count;

    foreach ($lines as $line) {
        $result = sscanf($line, "%c%d");
        calculate($result[0], $result[1]);
    }
    echo "Count: $count\n";

    // time in microseconds
    $time = (microtime(true) - $time_start) * 1_000_000;

    echo "Time: $time µs\n";
}


function calculate($direction, $ticks) {
    global $total;
    global $count;

    // $f = intdiv($ticks,100);
    $ticks = $ticks % 100;

    // if ($f > 0){
    //     $count += $f;
    // }
    // echo "Direction: $direction, Ticks: $ticks, Total: $total\n";
    if ($direction === 'R') {
        $total = upperBound($total, $ticks);
        // echo "Upper bound: $total\n";
    } else {
        $total = lowerBound($total, $ticks);
        // echo "Lower bound: $total\n";
    }
    if ($total === 0) {
        $count++;
        // echo "Count: $count\n";
    }
}

// checks if the total is greater than 100, if so, increments the count and returns the total - 100
// if not, returns the total + ticks
function upperBound($tot, $ticks) {
    if ($tot + $ticks > 99) {
        return $tot + $ticks - 100;
    }
    return $tot + $ticks;
}

// checks if the total is less than 0, if so, increment the count and returns the total - ticks + 100
// if not, returns the total - ticks
function lowerBound($tot, $ticks) {
    if ($tot - $ticks < 0) {
        return $tot - $ticks + 100;
    }
    return $tot - $ticks;
}

main()
?>