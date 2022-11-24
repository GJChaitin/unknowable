# LISP interpreter for The Limits of Mathematics, The Unknowable, Exploring RANDOMNESS

## JDK1.1.2 VERSION

[This was taken from Archive.org: README.html and converted to Markdown - rocky]


[This Java applet version of my LISP is identical with the ``official'' C and Mathematica versions, except that it allows several M-exps per line, and in its normal non-echo mode M-exp input is not interspersed with the S-exp output. It will run all the LISP code in Exploring RANDOMNESS, The Unknowable and The Limits of Mathematics. Just cut and paste entire LISP .l source code files into the upper window, the M-exp input area, and click on run. The output will appear in the bottom window.]

For a tutorial on this LISP, see this chapter of The Unknowable, or this chapter of Exploring RANDOMNESS. For a summary, see below. For the Java code for the interpreter, click here and here.


**Example:** To define factorial, run `define (f n) if = display n 0 1 * n (f - n 1)`. To try it, run `(f 5)`. Use cut and paste to enter this without typing it.

**Syntax:** empty list nil = (), lists & sublists built up from atoms which are names and unsigned integers. Token delimiter characters are blank, single-quote, double-quote, parens, and square brackets. A double-quote is used to include an S-exp within an M-exp. Square brackets enclose comments, [like this], and comments may be nested.

**Functional notation**: _(f x y z)_ is _f(x,y,z)_. In M-exps parens for primitive functions are omitted, in S-exps all parens are given explicitly. Defined functions are of the form (lambda (parameter-list) function-body).

**List-processing functions:**

* `car` (one argument, first element of list),
* `cdr` (one arg, rest of list),
* `cons` (two args, add new element to beginning of list),
* `atom` (one argument, is-atom predicate), = (two args, equal S-exp predicate),
* `append` (two args, combines two lists),
* `length` (one arg, number of elements in list),
* `size` (one arg, number of characters in S-exp),
* `cadr` (one arg, second element of list),
* `caddr` (one arg, third element of list).

**Pseudo-functions:**
* `'` (one argument, quote, literally),
* `"` (one argument, S-exp within M-exp),
* `if` (three args, if-then-else selector function),
* `display` (one arg, identity function, shows arg),
* `let` (three args, let-be-in, temporary definition),
* `define` (two args, define-to-be, permanent definition—allowed at top level only),
* `eval` (one arg, evaluate S-exp in std environment),
* `lambda` (two args, associates list of parameters with function body).

**Arithmetic functions:**
* `+` (two args, addition),
* `-` (two args, subtraction),
* `*` (two args, multiplication),
* `^` (two args, exponentiation),
* `<` (two args, less-than predicate),
* `>` (two args, greater-than predicate),
* `<=` (two args, less-than-or-equal predicate),
* `>=` (two args, greater-than-or-equal predicate),
* `=` (two args, equality predicate),
* `base2-to-10` (one arg, converts list of bits to integer),
* `base10-to-2` (one arg, converts integer to list of bits).

**Advanced functions:** (For detailed explanations, see my book The Limits of Mathematics.)
* `try` (three args, try within time-limit to evaluate S-exp with given binary data),
* `debug` (one arg, identity function, shows arg—unlike display works within `try`),
* `read-bit` (no arg, reads the next bit of the binary data),
* `read-exp` (no arg, reads the next S-exp from the binary data),
* `bits` (one arg, converts S-exp to bit string of ASCII characters).

**[Experimental functions:**
* `was-read` (no arg, gives the binary data read so far in the current try),
* `run-utm-on` (one arg, runs a binary program on the universal Turing machine that's the basis for my computerized version of algorithmic information theory).

These functions are not in the C and Mathematica versions of this interpreter. For examples of use, click here. For an explanation, see this chapter of Exploring RANDOMNESS.]
