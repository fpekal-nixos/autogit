build:
	g++ -O3 -o autogit autogit.cpp

install:
	mkdir -p $(out)/bin
	cp autogit $(out)/bin
