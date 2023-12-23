CC = gcc
#CROSS_COMPILE ?= aarch64-none-linux-gnu-
CROSS_COMPILE ?=

writer: writer.c
	$(CROSS_COMPILE)$(CC) -o writer writer.c

clean:
	rm -f writer
