all:
	gcc -O3 -Wall -o build/playpause -framework Cocoa -framework IOKit main.m -v
