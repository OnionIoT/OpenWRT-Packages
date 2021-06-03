p44ledchaintest:main.o
	$(CC) $(LDFLAGS) main.o -o p44ledchaintest
main.o:main.c
	$(CC) $(CCFLAGS) -c main.c


# remove object files and executable when user executes "make clean"
clean:
	rm *.o p44ledchaintest
