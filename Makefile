# A simple makefile to build a LISP interpreter
.PHONY: all clean

#: Build everything
all: lisp

#: Build LISP interpreter
lisp: lisp.c
	cc -O -olisp lisp.c

#: Clean programs
clean:
	@rm lisp
