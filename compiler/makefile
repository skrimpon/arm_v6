# Makefile. If you change it, remember than in makefiles multiple spaces
# ARE NOT EQUIVALENT to tabs. The line after a rule starts with a tab!

#Add any executable you want to be created here.
EXECUTABLES	= parser

#This is the compiler to use
CC = g++

#These are the flags passed to the compiler. Change accordingly
CFLAGS = -std=c++11 -Wall -O0

#These are the flags passed to the linker. Nothing in our case

# make all will create all executables
all: $(EXECUTABLES)

# This is the rule to create any executable from the corresponding .c 
# file with the same name.
%: %.cpp
	$(CC) $(CFLAGS) $< -o $@

# make clean will remove all executables, jpg files and the 
# output of previous executions.
clean:
	rm -f $(EXECUTABLES) program.out
