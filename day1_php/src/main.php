<?php

echo "This is a placeholder!\n";

$input = file_get_contents('data/day1/day1.test');

$lines = explode("\n", $input);

foreach ($lines as $line) {
    echo $line . "\n";
}