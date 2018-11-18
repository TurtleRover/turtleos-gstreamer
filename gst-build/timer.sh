#!/bin/bash

# run a child process in the background that outputs elapsed time
(
SECONDS=0

while true 
do
    sleep 60
    elapsed=$SECONDS
    echo "$(($elapsed / 3600)) hours and $((($elapsed / 60) % 60)) minutes elapsed"
done
) &

# redirect standard input to standard output
cat 

# kill the child process
kill -- $!