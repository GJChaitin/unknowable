# A simple Makefile to build a LISP interpreter
.PHONY: all \
	clean \
	run-fixedpoint \
	run-godel \
	run-sets

#: Build everything
all: lisp

#: Build C LISP interpreter
lisp: lisp.c
	cc -O -olisp lisp.c

#: Run fixedpoint LISP example through the LISP interpreter
run-fixedpoint: lisp fixedpoint.l
	./lisp < fixedpoint.l

#: Run godel LISP example through the LISP interpreter
run-godel: lisp godel.l
	./lisp < godel.l

#: Run godel LISP example through the LISP interpreter
run-sets: lisp sets.l
	./lisp < sets.l

#: Clean programs
clean:
	@rm lisp
