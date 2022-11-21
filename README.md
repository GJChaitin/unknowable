Here we have:

* LISP interpreters in
  - [C](https://github.com/GJChaitin/unknowable/blob/master/lisp.c),
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

File extensions ending in `.l` are LISPx programs; extensions ending in `.r` is output from running the program through the LISP interpreter.

I have written a small Makefile to facilitate compiling and running the code. If you have [`remake`](https://remake.readthedocs.io/en/latest/) installed, you can get a list of targets by running:
`remake --tasks`:

```
$ remake --tasks
all                  Build everything
clean                Clean programs
lisp                 Build C LISP interpreter
run-fixedpoint       Run fixedpoint LISP example through the LISP interpreter
...
```

(The above list is an example, it is abbreviated and probably out of date.)
