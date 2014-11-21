all:
	gcc -O3 -Wall -o build/playpause -framework Cocoa -framework IOKit main.m -v

clean:
	rm build/playpause

install:
	cp build/playpause /usr/local/bin
