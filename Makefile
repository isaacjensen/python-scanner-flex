default: all

scanner: scanner.l
	flex -o scanner.cpp scanner.l

main: scanner.cpp
	g++ scanner.cpp -o scanner

clean:
	rm -f scan
	rm -f scanner.cpp
	rm -f *.out