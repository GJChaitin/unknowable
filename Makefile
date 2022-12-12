# A simple Makefile to build a LISP interpreter
.PHONY: all \
	clean \
	run-fixedpoint \
	run-godel \
	run-sets

ALL=lisp lisp.class

# Define this to change the maximum number of storage nodes in S-expression
SIZE=1000000

# C compiler options you can tweak.
COPTS=-g -O

#: Build everything
all: $(ALL)

#: Build C LISP interpreter
lisp: lisp.c
	cc $(COPTS) -olisp lisp.c

#: Build Java LISP interpreter
lisp.class: lisp.java
	javac lisp.java

#: Run programs via C LISP interpreter
%.run:
	./lisp < $(@:.run=.l)

#: Run programs via Python LISP interpreter
%.run-python:
	python ./lisp.py < $(@:.run-python=.l)

#: Run fixedpoint LISP example through the LISP interpreter
fixedpoint: lisp fixedpoint.l
	./lisp < fixedpoint.l

#: Run godel LISP example through the LISP interpreter
godel: lisp godel.l
	./lisp < godel.l

#: Run godel LISP example through the LISP interpreter
run-sets: lisp sets.l
	./lisp < sets.l

#: Clean programs
clean:
	@rm $(ALL) 2>/dev/null || true
