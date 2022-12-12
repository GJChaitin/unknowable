Here we have:

* LISP interpreters in
  - [C](https://github.com/GJChaitin/unknowable/blob/master/lisp.c),
  - [Python](https://github.com/GJChaitin/unknowable/blob/master/lisp.py),
  - [Mathematica](https://github.com/GJChaitin/unknowable/blob/master/lisp.m), and
  - [Java](https://github.com/GJChaitin/unknowable/blob/master/lisp.java),
* example LISP programs and output from "The Limits of Mathematics" (ISBN-13 978-1852336684), and
* example LISP programs from output from "The Unknowable" (ISBN-13: 978-9814021722)
* [Chapter 2](https://github.com/GJChaitin/unknowable/blob/master/ch2.md) rendered in Markdown so it appears nicely on Github.

All of the the above, books and software, are written by Gregory J. Chaitin.

The above material all comes Archive.org:

* [The UNKNOWABLE](https://web.archive.org/web/20060924160850/http://www.cs.auckland.ac.nz/CDMTCS/chaitin/unknowable/)
* [The UKNOWABLE Chapter 2 alternate location](https://www.cs.auckland.ac.nz/CDMTCS/chaitin/unknowable) and for portions of "The Limits of Mathematics" (2003).

Links to the code can be found off of the latter site.

Except for the LISP interpreter in Python, Most of the code was originally written circa 1999-2000. Surprisingly, the main LISP interpreter, `lisp.c` still runs as written but gives a couple of warning.
Removing warnings is a very trivial changes line (adding `int` to the front of `main()`) and adding a single `#include <stdlib.h>`

However to preserve everything as written, the git branch `urtext` was created. See that for the original sources (or as close as I can get).

File extensions ending in `.l` are LISP programs; extensions ending in `.r` is output from running the program through the LISP interpreter.

Running the C LISP interpreter
------------------------------

After building the lisp executable (`make lisp`), run a lisp program, e.g. sets.l like this:

```
./lisp < godel.l
```


Running the LISP Python interpreter
------------------------------------


To run a LISP program usin Python, Python 3.11 or newer is needed. You can run a program like `sets.l` this way:

```
python lisp.py < godel.l
```

Using `make` to simpilify running
----------------------------------

I have written a small Makefile to facilitate compiling the C program and running the code. If you have [`remake`](https://remake.readthedocs.io/en/latest/) installed, you can get a list of targets by running:
`remake --tasks`:

```
$ remake --tasks
all                  Build everything
clean                Clean programs
lisp                 Build C LISP interpreter
run-fixedpoint       Run fixedpoint LISP example through the LISP interpreter
run-godel            Run godel LISP example through the LISP interpreter
...
```

The above list is an example, it is abbreviated and probably out of date.

To run a LISP program using the C LISP interpreter, run `make` followed by the name of the LISP file, changing the final `.l` to `.run`.

For example, for `sets.l`:

```
make sets.run
```

To run a LISP program using the Python LISP interpreter, run `make` followed by the name of the LISP file, changing the final `.l` to `.python-run`.


For example, for `sets.l`:

```
make sets.python-run
```
