#!/bin/bash

totalNumberOfMethods = `find ../.. -name OL*.j | xargs cat | grep '^[+|-]' | wc -l`

numberOfTests = `find ../.. -name OJ*Test.j | xargs cat | grep '^[+|-]' | wc -l`

numberOfMethods = `$totalNumberOfMethods - $numberOfTests`

ratio = `$numberOfMethods / $numberOfTests`

echo -n "Number of Methods: $numberOfMethods"
echo -n "Number of Tests  : $numberOfTests"
echo -n "Ratio            : $ratio"