#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <filesdir> <searchstr>"
	exit 1
fi

filesdir="$1"
searchstr="$2"

if [ ! -d "$filesdir" ]; then
	echo "Error: $filesdir is not a directory."
	exit 1
fi

Y=$(grep -r "$searchstr" "$filesdir" | wc -l)

X=$(find "$filesdir" -type f | wc -l)

# Print the result
echo "The number of files are $X and the number of matching lines are $Y"
