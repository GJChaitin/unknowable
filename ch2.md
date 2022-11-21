II. LISP: A Formalism for Expressing Mathematical Algorithms
============================================================

Synopsis
--------

_Why LISP?! S-expressions, lists & atoms. The empty list. Arithmetic in LISP. M-expressions. Recursive definitions. Factorial. Manipulating lists: car, cdr, cons. Conditional expressions: if-then-else, atom, =. Quote, display, eval. Length & size. Lambda expressions. Bindings and the environment. Let-be-in & define. Manipulating finite sets in LISP. LISP interpreter run with the exercises._

Why LISP?!
----------

You might expect that a book on the incompleteness theorems would include material on symbolic logic and that it would present a formal axiomatic system, for example, Peano arithmetic. Well, this book won't! First, because formalisms for deduction failed and formalisms for computation succeeded. So instead I'll show you a beautiful and highly mathematical formalism for expressing algorithms, LISP. The other important reason for showing you LISP instead of a formal axiomatic system is that I can prove incompleteness results in a very general way without caring about the internal details of the formal axiomatic system. To me a formal axiomatic system is like a black box that theorems come out of. My methods for obtaining incompleteness theorems are so general that all I need to know is that there's a proof-checking algorithm.

So this is a post-modern book on incompleteness! If you look at another little book on incompleteness, Nagel & Newman's _G&#246;del's Proof,_ which I enjoyed greatly as a child, you'll see plenty of material on symbolic logic, and **no** material on computing. In my opinion the right way to think about all this now is to start with computing, not with logic. So that's the way I'm going to do things here. There's no point in writing this book if I do everything the way everyone else does!

LISP means "list processing," and was invented by John McCarthy and others at the MIT Artificial Intelligence Lab around 1960. You can do numerical calculations in LISP, but it's really intended for symbolic calculations. In fact LISP is really a computerized version of set theory, at least set theory for finite sets. It's a simple but very powerful mathematical formalism for expressing algorithms, and I'm going to use it in Chapters III, IV & V to present G&#246;del, Turing's and my work in detail. The idea is to start with a small number of powerful concepts, and get everything from that. So LISP, the way I do it, is more like mathematics than computing.

And LISP is rather different from ordinary work-a-day programming languages, because instead of executing or running programs you think about evaluating expressions. It's an expression-based or functional programming language rather than a statement-based imperative programming language.

Two versions of the LISP interpreter for this book are available at my web site: one is [300 lines of _Mathematica_](https://github.com/GJChaitin/unknowable/blob/master/lisp.m), and the other is [a thousand lines of _C_](https://github.com/GJChaitin/unknowable/blob/master/lisp.c).

S-expressions, lists & atoms, the empty list
--------------------------------------------

The basic concept in LISP is that of a _symbolic_ or S-expression. What's an S-expression? Well, an S-expression is either an _atom_, which can either be a natural number like 345 or a word like Frederick, or it's a _list_ of atoms or sub-lists. Here are three examples of S-expressions:

1. `()`
1. `(a b c)`
1. `(+ (* 3 4) (* 5 6))`

The first example is the empty list (), also called _nil_. The second example is a list of three elements, the atoms _a_, _b_ and _c_. And the third example is a list of three elements. The first is the atom +, and the second and the third are lists of three elements, which are atoms. And you can nest lists to arbitrary depth. You can have lists of lists of lists...

The empty list () is the only list that's also an atom, it has no elements. It's indivisible, which is what atom means in Greek. It can't be broken into smaller pieces.

Elements of a list can be repeated, e.g., (a a a). And changing the order of the elements changes the list. So (a b c) is **not** the same as (c b a) even though it has the same elements, because they are in a different order. Hence _lists_ are different from _sets_, where elements cannot be repeated and the order of the elements is irrelevant.

Now in LISP **everything**, programs, data, and output, they are all S-expressions. That's our universal substance, that's how we build everything!

* * *

Arithmetic in LISP
------------------

Let's look at some simple LISP expressions, expressions for doing arithmetic. For example, here is an arithmetic expression that adds the product of 3 and 4 to the product of 5 and 6:

```lisp
3*4 + 5*6
```

The first step to convert this to LISP is to put in **all** the parentheses:

```lisp
((3*4) + (5*6))
```

And the next step to convert this to LISP is to put the operators before the operands (prefix notation), rather than in the middle (infix notation):

```lisp
> (+(*34)(*56))
```

And now we need to use blanks to separate the elements of a list if parentheses don't do that for us. So the final result is:

```
(+(* 3 4)(* 5 6))
```

which is already understandable, or

```
(+ (* 3 4) (* 5 6))
```

which is the standard LISP notation in which the successive elements of a list are always separated by a single blank. Extra blanks, if included, are ignored. Extra parentheses are **not** ignored, they completely change the meaning of an S-expression.

```lisp
(((X)))
```
is **not** the same as X!

What are the built-in operators, i.e., the primitive functions, that are provided for doing arithmetic in LISP? Well, in my LISP there's

* addition `+`,
* multiplication `*`,
* subtraction `-`
* exponentiation `^`,

and, for comparisons,

* less-than `<`,
* greater-than `>`,
* equal `=`,
* less-than-or-equal `<=`, and
* greater-than-or-equal `>=`.

I only provide natural numbers in my LISP, so there are no negative integers. If the result of a subtraction is less than zero, it gives 0 instead. Comparisons either give _true_ or _false_. All these operators, or functions, always have two operands, or arguments. Addition and multiplication of more than two operands requires several + or * operations. Here are examples of arithmetic expressions in LISP, together with their values.

```lisp
(+ 1 (+ 2 (+ 3 4)))
```
is the same as
```lisp
(+ 1 (+ 2 7))
```
is the same as `(+ 1 9)` which yields 10,

```lisp
(+ (+ 1 2) (+ 3 4))
```
is the same as `(+ 3 7)` which yields 10,

```lisp
(- 10 7)
```
yields 3,

```lisp
(- 7 10)
```
yields 0,

```lisp
(+ (* 3 4) (* 5 6))
```
is the same as `(+ 12 30)` which yields 42,

```lisp
(^ 2 10)
```
yields 1024,

```lisp
(< (* 10 10) 101)
```
is the same as `(< 100 101)` which yields _true_,

```lisp
(= (* 10 10) 101)
```

is the same as `(= 100 101)` which yields _false_.

M-expressions
-------------

In addition to the official LISP S-expressions, there are also _meta_ or M-expressions. These are just intended to be helpful, as a convenient abbreviation for the official S-expressions. Programmers usually write M-expressions, and then the LISP interpreter converts them into S-expressions before processing them. M-expressions omit some of the parentheses, the ones that group the primitive built-in functions together with their arguments. M-expression notation works because all built-in primitive functions in my LISP have a fixed-number of operands or arguments. Here are the M-expressions for the above examples.

```lisp
+ 1 + 2 + 3 4
```
is the same as `(+ 1 (+ 2 (+ 3 4)))`,

```lisp
+ + 1 2 + 3 4
```
is the same as `(+ (+ 1 2) (+ 3 4))`,

```lisp
- 10 7
```

is the same as `(- 10 7)` ,

```lisp
- 7 10
```
is the same as `(- 7 10)`,

```lisp
+ * 3 4 * 5 6

```

is the same as `(+ (* 3 4) (* 5 6))`,

```
^ 2 10
```

is the same as `(^ 2 10)`,

```
< * 10 10 101
```
is the same as `(< (* 10 10) 101)`,

```lisp
= * 10 10 101
```
is the same as `(= (* 10 10) 101)`.

If you look at these examples you can convince yourself that there is never any ambiguity in restoring the missing parentheses, if you know how many arguments each operator has. So M-expressions are an example of what used to be called parenthesis-free or Polish notation. (This is in honor of a brilliant school of Polish logicians and set theorists.)

There are circumstances in which one wants to give parentheses explicitly rather than implicitly. So I use the notation " within an M-expression to indicate that what follows is an S-expression. Here are three examples:

> The M-expression `"(+ + +)` denotes the S-expression `(+ + +)`.
> The M-expression `("+ "- "*)` denotes the S-expression `(+ - *)`.
> The M-expression `+ "* "^` denotes the S-expression `(+ * ^)`.

If one didn't use the double quotes, these arithmetic operators would have to have operands, but here they are just used as symbols. But these are not useful S-expressions, because they are not valid arithmetical expressions.

Recursive definitions & factorial
---------------------------------

Now let me jump ahead and give the traditional first example of a complete LISP program. Later I'll explain everything in more detail. So here is how you define factorial in LISP. What's factorial? Well, the factorial of _N_, usually denoted _N_!, is the product of all natural numbers from 1 to _N_. So how do we do this in LISP? Well, we define factorial recursively:

> (define (fact N) (if (= N 0) \[then\] 1 \[else\] (\* N (fact (- N 1)))))

Here comments are enclosed in square brackets. This is the definition in the official S-expression notation. Here the definition is written in the more convenient M-expression notation.

> define (fact N)
> if = N 0 \[then\] 1
> \[else\] \* N (fact - N 1)

This can be interpreted unambiguously if you know that "define" always has two operands, and "if" always has three.

Let's state this definition in words.

The factorial function has one argument, _N_, and is defined as follows. If _N_ is equal to 0 then factorial of _N_ is equal to 1. Otherwise factorial of _N_ is equal to _N_ times factorial of _N_ minus 1.

So using this definition, we see that (fact 4) is the same as

```lisp
(* 4 (fact 3))
(* 4 (* 3 (fact 2)))
(* 4 (* 3 (* 2 (fact 1))))
(* 4 (* 3 (* 2 (* 1 (fact 0)))))
(* 4 (* 3 (* 2 (* 1 1))))
(* 4 (* 3 (* 2 1)))
(* 4 (* 3 2))
(* 4 6)
```

which yields 24.

So in LISP you define functions instead of indicating how to calculate them. The LISP interpreter's job is to figure out how to calculate them using their definitions. And instead of loops, in LISP you use recursive function definitions. In other words, the function that you are defining recurs in its own definition. The general idea is to reduce a complicated case of the function to a simpler case, etc., etc., until you get to cases where the answer is obvious.

Manipulating lists: `car`, `cdr`, `cons`
----------------------------------------

The examples I've given so far are all numerical arithmetic. But LISP is actually intended for symbolic processing. It's actually an arithmetic for lists, for breaking apart and putting together lists of things. So let me show you some list expressions instead of numerical expressions.

_Car_ and _cdr_ are the funny names of the operations for breaking a list into pieces. These names were chosen for historical reasons, and no longer make any sense, but everyone knows them. If one could start over you'd call car, head or first and you'd call cdr, tail or rest. Car returns the first element of a list, and cdr returns what's left without the first element. And _cons_ is the inverse operation, it joins a head to a tail, it adds an element to the beginning of a list. Here are some examples, written in S-expression notation:

* `(car (' (a b c)))` yields `a`,
* `(cdr (' (a b c)))` yields `(b c)`,
* `(car (' ((a) (b) (c))))` yields `(a)`,
* `(cdr (' ((a) (b) (c))))` yields `((b) (c))`,
* `(car (' (a)))` yields `a`,
* `(cdr (' (a)))` yields `()`,
* `(cons (' a) (' (b c)))` yields `(a b c)`,
* `(cons (' (a)) (' ((b) (c))))` yields `((a) (b) (c))`,
* `(cons (' a) (' ()))` yields `(a)`,
* `(cons (' a) nil)` yields `(a)`,
* `(cons a nil)` yields `(a)`.


Maybe these are easier to understand in M-expression notation:

* `car '(a b c)` yields `a`,
* `cdr '(a b c) yields` `(b c)`,
* `car '((a) (b) (c))` yields `(a)`,
* `cdr '((a) (b) (c))` yields `((b) (c))`,
* `car '(a)` yields `a`,
* `cdr '(a)` yields `()`,
* `cons 'a '(b c)` yields `(a b c)`,
* `cons '(a) '((b) (c))` yields `((a) (b) (c))`,
* `cons 'a '()` yields `(a)`,
* `cons 'a nil` yields `(a)`,
* `cons a nil` yields `(a)`.

There are some things to explain here. What is the single quote function? Well, it just indicates that its operand is data, not an expression to be evaluated. In other words, single quote means \`\`literally this.'' And you also see that the value of nil is (), it's a friendlier way to name the empty list. Also, in the last example, _a_ isn't quoted, because initially all atoms evaluate to themselves, are bound to themselves. Except for nil, which has the value (), every atom gives itself as its value initially. This will change if an atom is used as the parameter of a function and is bound to the value of an argument of the function. Numbers though, **always** give themselves as value.

Here are some more examples, this time in M-expression notation. Note that the operations are done from the inside out.

* `car '(1 2 3 4 5)` yields 1,
* `car cdr '(1 2 3 4 5)` yields 2,
* `car cdr cdr '(1 2 3 4 5)` yields 3,
* `car cdr cdr cdr '(1 2 3 4 5)` yields 4,
* `car cdr cdr cdr cdr '(1 2 3 4 5)` yields 5,
* `cons 1 cons 2 cons 3 cons 4 cons 5 nil` yields (1 2 3 4 5).

This is how to get the second, third, fourth and fifth elements of a list. These operations are so frequent in LISP that they are usually abbreviated as cadr, caddr, cadddr, caddddr, etc., and so on and so forth with all possible combinations of car and cdr. My LISP though, only provides the first two of these abbreviations, cadr and caddr, for the second and third elements of a list.

Conditional expressions: `if-then-else`, `atom`, `=`
-----------------------------------------------------

Now I'll give a detailed explanation of the three-argument function if-then-else that we used in the definition of factorial.

```lisp
(if predicate then-value else-value)
```

This is a way to use a logical condition, or predicate, to choose between two alternative values. In other words, it's a way to define a function by cases. If the predicate is true, then the then-value is evaluated, and if the predicate is false, then the else-value is evaluated. The unselected value is **not** evaluated. So if-then-else and single quote are unusual in that they do not evaluate all their arguments. Single quote never evaluates its one argument, and if-then-else only evaluates two of its three arguments. So these are pseudo-functions, they are not really normal functions, even though they are written the same way that normal functions are.

And what does one use as a predicate for if-then-else? Well, for numerical work one has the numerical comparison operators <, >, <=, >=, and =. But for work with S-expressions there are just two predicates, _atom_ and =. Atom returns true or false depending upon whether its one argument is an atom or not. = returns true or false depending upon whether two S-expressions are identical or not. Here are some examples written in S-expression notation:

* `(if (= 10 10) abc def)` yields `abc`,
* `(if (= 10 20) abc def)` yields `def`,
* `(if (atom nil) 777 888)` yields 777,
* `(if (atom (cons a nil)) 777 888)` yields 888,
* `(if (= a a) X Y)` yields X,
* `(if (= a b) X Y)` yields Y.

Quote, display, eval
--------------------

So, to repeat, single quote never evaluates its argument. Single quote indicates that its operand is **data**, not an expression to be evaluated. In other words, single quote means \`\`literally this.'' Double quote is for including S-expressions inside of M-expressions. Double quote indicates that parentheses will be given explicitly in this part of an M-expression. For example, the M-expressions '+ 10 10 and ' "(+ 10 10) and '("+ 10 10) all denote the S-expression (' (+ 10 10)), which yields value (+ 10 10), **not** 20.

_Display_, which is useful for obtaining intermediate values in addition to the final value, is just an identity function. Its value is the same as the value of its argument, but it has the side-effect of displaying its argument. Here is an example written in M-expression notation:

```
car display cdr display cdr display cdr '(1 2 3 4 5)
displays (2 3 4 5)
displays (3 4 5)
displays (4 5)
```
and yields value 4.

_Eval_ provides a way of doing a **stand-alone** evaluation of an expression that one has constructed. For example:

`eval display cons "^ cons 2 cons 10 nil` displays `(^ 2 10)` and yields value 1024.

This works because LISP is interpreted, not compiled. Instead of translating a LISP expression into machine language and then running it, the LISP interpreter is always present doing evaluations and printing results. It is very important that the argument of eval is always evaluated in a clean, initial environment, not in the current environment. I.e., the only binding in effect will be that nil is bound to (). All other atoms are bound to themselves. In other words, the expression being evaled must be self-contained. This is important because in this way the result of an eval doesn't depend on the circumstances when it is used. It always gives the same value if it is given the same argument.

Length & size
-------------

Here are two ways to measure how big an S-expression is. _Length_ returns the number of elements in a list, i.e., at the top level of an S-expression. And _size_ gives the number of characters in an S-expression when it is written in standard notation, i.e., with exactly one blank separating successive elements of a list. For example, in M-expression notation:

```
length '(a b c)
```
yields 3,

```
size '(a b c)
```

yields 7.

Note that the size of (a b c) is 7, not 8, because when size evaluates its argument the single quote disappears. (If it didn't, its size would be the size of (' (a b c)), which is 11)

Lambda expressions
------------------

Here is how to define a function.

```lisp
> (lambda (list-of-parameter-names) function-body)
```

For example, here is the function that forms a pair in reverse order.

```lisp
(lambda (x y) (cons y (cons x nil)))
```

Functions can be literally given in place (here I've switched to M-expression notation):

```
('lambda (x y) cons y cons x nil A B) yields (B A)
```

Or, if _f_ is bound to the above function definition, then you can use it like this

```
(f A B) yields (B A)
```

(The general idea is that the function is always evaluated before its arguments are, then the parameters are bound to the argument values, and then the function body is evaluated in this new environment.) How can we bind _f_ to this function definition? Here's a way that's permanent.

```
define (f x y) cons y cons x nil
```

Then _(f A B)_ yields _(B A)_. And here's a way that's local.

```
('lambda (f) (f A B) 'lambda (x y) cons y cons x nil)
```

This yields (B A) too. If you can understand this example, then you understand all of my LISP! It's a list with two elements, the expression to be evaluated that uses the function, and the function's definition. Here's factorial done the same way:

```
('lambda (fact) (fact 4) 'lambda (N) if = display N 0 1 * N (fact - N 1))
```

This displays 4, 3, 2, 1, and 0, and then yields the value 24. Please try to understand this final example, because it **really** shows how my LISP works!

Bindings and the environment
----------------------------

Now let's look at defined (as opposed to primitive) functions more carefully. To define a function, one gives a name to the value of each of its arguments. These names are called parameters. And then one indicates the body of the function, i.e., how to compute the final value. So within the scope of a function definition the parameters are bound to the values of the arguments.

Here is an example, in which a function returns one of its arguments without doing anything to it. ('lambda (x y) x 1 2) yields 1, and ('lambda (x y) y 1 2) yields 2. Why? Because inside the function definition _x_ is bound to 1 and _y_ is bound to 2. But all previous bindings are still in effect except for bindings for _x_ and _y_. And, as I've said before, in the initial, clean environment every atom except for nil is bound to itself. Nil is bound to (). Also, the initial bindings for numbers can never be changed, so that they are constants.

Let-be-in & define
------------------

Local bindings of functions and variables are so common, that we introduce an abbreviation for the lambda expressions that achieve this. To bind a variable to a value we write:

```
(let variable \[be\] value \[in\] expression)
```

And to bind a function name to its definition we write it like this.

``
(let (function-name parameter1 parameter2...) \[be\] function-body \[in\] expression)
``

For example (and now I've switched to M-expression notation)

```
let x 1 let y 2 + x y yields 3.
```

And

```
let (fact N) if = N 0 1 * N (fact - N 1) (fact 4)
```
yields 24.

_Define_ actually has two cases like let-be-in, one for defining variables and another for defining functions:

> (define variable \[to be\] value)

and

> (define (function-name parameter1 parameter2...) \[to be\] function-body)

The scope of a define is from the point of definition until the end of the LISP interpreter run, or until a redefinition occurs. For example:

```lisp
define x 1
define y 2
```

Then `+ x y` yields 3.

```lisp
define (fact N) if = N 0 1 * N (fact - N 1)
```

Then `(fact 4)` yields 24.

Define can only be used at the "top level." You are not allowed to include a define inside a larger S-expression. In other words, define is not really in my LISP. Actually all bindings are local and should be done with let-be-in, i.e., with lambda bindings. Like M-expressions, define and let-be-in are a convenience for the programmer, but they're not officially in my LISP, which only allows lambda expressions and temporary local bindings. Why? **Because in theory each LISP expression is supposed to be totally self-contained, with all the definitions that it needs made locally!** Why? Because that way the size of the smallest expression that has a given value, i.e., the LISP program-size complexity, does not depend on the environment.

Manipulating finite sets in LISP
--------------------------------

Well, that's all of my LISP! That's all there is! It's a very simple language, but a powerful one. At least for theoretical purposes.

To illustrate all this, let me show you how to manipulate finite sets�sets, not lists. We'll define in LISP all the basic set-theoretic operations on finite sets. Recall that in a set the order doesn't count, and no elements can be repeated.

First let's see how to define the set membership predicate in LISP. This function, called _member?_, has two arguments, an S-expression and a set of S-expressions. It returns true if the S-expression is in the set, and false otherwise. It calls itself again and again, and each time the set, s, is smaller.

> define (member? e s) \[is e in s?\]
> if atom s false \[if s is empty, then e isn't in s\]
> if = e car s true \[if e is the first element of s, then it's in s\]
> (member? e cdr s) \[otherwise, look if e is in the rest of s\]
>
> Then (member? 2 '(1 2 3)) yields true.
> And (member? 4 '(1 2 3)) yields false.

Let me state this in English. Membership of _e_ in _s_ is defined as follows. First of all, if _s_ is empty, then _e_ is not a member of _s_. Second, if _e_ is the first element of _s_, then _e_ is a member of _s_. Third, if _e_ is not the first element of _s_, then _e_ is a member of _s_ iff _e_ is a member of the rest of _s_.

Now here's the intersection of two sets, i.e., the set of all the elements that they have in common, that are in **both** sets.

```
define (intersection s t) [elements that two sets have in common]
if atom s nil [if the first set is empty, so is the intersection]
if (member? car s t) [is the first element of s in t?]
[if so] cons car s (intersection cdr s t)
[if not] (intersection cdr s t)
```

Then `(intersection '(1 2 3) '(2 3 4))` yields (2 3).

Here's the dual of intersection, the union of two sets, i.e., the set of all the elements that are in **either** set.

```lisp
define (union s t) [elements in either of two sets]
if atom s t [if the first set is empty, then the union is the second set]
if (member? car s t) [is the first element of s in t?]
[if so] (union cdr s t)
[if not] cons car s (union cdr s t)
```

Then `(union '(1 2 3) '(2 3 4))` yields (1 2 3 4).

Now please do some exercises. First define the subset predicate, which checks if one set is contained in another. Then define the relative complement of one set _s_ minus a second set _t_. That's the set of all the elements of _s_ that are not in _t_. Then define _unionl_ which is the union of a list of sets. Then define the cartesian product of two sets. That's the set of all ordered pairs in which the first element is from the first set and the second element is from the second set. Finally, define the set of all subsets of a given set. If a set has _N_ elements, then the set of all its subsets will have 2_N_ elements.

The answers to these exercises are in the LISP run in the next section. But don't look until you try to do them yourself!

Once you can do these exercises, we're finally ready to **use** LISP to prove G&#246;del's incompleteness theorem and Turing's theorem that the halting problem cannot be solved! But we'll start Chapter III by seeing how to do a **fixed point** in LISP. That's a LISP expression that yields itself as its value! Can you figure out how to do this before I explain how?

LISP Interpreter Run with the Exercises
---------------------------------------

LISP Interpreter Run

```
\[\[\[\[\[

 Elementary Set Theory in LISP (finite sets)

\]\]\]\]\]

\[Set membership predicate:\]

define (member? e\[lement\] set)
   \[Is set empty?\]
   if atom set \[then\] false \[else\]
   \[Is the element that we are looking for the first element?\]
   if = e car set \[then\] true \[else\]
   \[recursion step!\]
   \[return\] (member? e cdr set)

define      member?
value       (lambda (e set) (if (atom set) false (if (= e (car
             set)) true (member? e (cdr set)))))


(member? 1 '(1 2 3))

expression  (member? 1 (' (1 2 3)))
value       true

(member? 4 '(1 2 3))

expression  (member? 4 (' (1 2 3)))
value       false


\[Subset predicate:\]

define (subset? set1 set2)
   \[Is the first set empty?\]
   if atom set1 \[then\] true \[else\]
   \[Is the first element of the first set in the second set?\]
   if (member? car set1 set2)
      \[then\] \[recursion!\] (subset? cdr set1 set2)
      \[else\] false

define      subset?
value       (lambda (set1 set2) (if (atom set1) true (if (memb
            er? (car set1) set2) (subset? (cdr set1) set2) fal
            se)))


(subset? '(1 2) '(1 2 3))

expression  (subset? (' (1 2)) (' (1 2 3)))
value       true

(subset? '(1 4) '(1 2 3))

expression  (subset? (' (1 4)) (' (1 2 3)))
value       false


\[Set union:\]

define (union x y)
   \[Is the first set empty?\]
   if atom x \[then\] \[return\] y \[else\]
   \[Is the first element of the first set in the second set?\]
   if (member? car x y)
      \[then\] \[return\] (union cdr x y)
      \[else\] \[return\] cons car x (union cdr x y)

define      union
value       (lambda (x y) (if (atom x) y (if (member? (car x)
            y) (union (cdr x) y) (cons (car x) (union (cdr x)
            y)))))


(union '(1 2 3) '(2 3 4))

expression  (union (' (1 2 3)) (' (2 3 4)))
value       (1 2 3 4)


\[Union of a list of sets:\]

define (unionl l) if atom l nil (union car l (unionl cdr l))

define      unionl
value       (lambda (l) (if (atom l) nil (union (car l) (union
            l (cdr l)))))


(unionl '((1 2) (2 3) (3 4)))

expression  (unionl (' ((1 2) (2 3) (3 4))))
value       (1 2 3 4)


\[Set intersection:\]

define (intersection x y)
   \[Is the first set empty?\]
   if atom x \[then\] \[return\] nil \[empty set\] \[else\]
   \[Is the first element of the first set in the second set?\]
   if (member? car x y)
      \[then\] \[return\] cons car x (intersection cdr x y)
      \[else\] \[return\] (intersection cdr x y)

define      intersection
value       (lambda (x y) (if (atom x) nil (if (member? (car x
            ) y) (cons (car x) (intersection (cdr x) y)) (inte
            rsection (cdr x) y))))


(intersection '(1 2 3) '(2 3 4))

expression  (intersection (' (1 2 3)) (' (2 3 4)))
value       (2 3)


\[Relative complement of two sets x and y = x - y:\]

define (complement x y)
   \[Is the first set empty?\]
   if atom x \[then\] \[return\] nil \[empty set\] \[else\]
   \[Is the first element of the first set in the second set?\]
   if (member? car x y)
      \[then\] \[return\] (complement cdr x y)
      \[else\] \[return\] cons car x (complement cdr x y)

define      complement
value       (lambda (x y) (if (atom x) nil (if (member? (car x
            ) y) (complement (cdr x) y) (cons (car x) (complem
            ent (cdr x) y)))))


(complement '(1 2 3) '(2 3 4))

expression  (complement (' (1 2 3)) (' (2 3 4)))
value       (1)



\[Cartesian product of an element with a list:\]

define (product1 e y)
   if atom y
      \[then\] nil
      \[else\] cons cons e cons car y nil (product1 e cdr y)

define      product1
value       (lambda (e y) (if (atom y) nil (cons (cons e (cons
             (car y) nil)) (product1 e (cdr y)))))


(product1 3 '(4 5 6))

expression  (product1 3 (' (4 5 6)))
value       ((3 4) (3 5) (3 6))


\[Cartesian product of two sets = set of ordered pairs:\]

define (product x y)
   \[Is the first set empty?\]
   if atom x \[then\] \[return\] nil \[empty set\] \[else\]
   \[return\] (union (product1 car x y) (product cdr x y))

define      product
value       (lambda (x y) (if (atom x) nil (union (product1 (c
            ar x) y) (product (cdr x) y))))


(product '(1 2 3) '(x y z))

expression  (product (' (1 2 3)) (' (x y z)))
value       ((1 x) (1 y) (1 z) (2 x) (2 y) (2 z) (3 x) (3 y) (
            3 z))


\[Product of an element with a list of sets:\]

define (product2 e y)
   if atom y
      \[then\] nil
      \[else\] cons cons e car y (product2 e cdr y)

define      product2
value       (lambda (e y) (if (atom y) nil (cons (cons e (car
            y)) (product2 e (cdr y)))))


(product2 3 '((4 5) (5 6) (6 7)))

expression  (product2 3 (' ((4 5) (5 6) (6 7))))
value       ((3 4 5) (3 5 6) (3 6 7))


\[Set of all subsets of a given set:\]

define (subsets x)
   if atom x
      \[then\] '(()) \[else\]
      let y \[be\] (subsets cdr x) \[in\]
      (union y (product2 car x y))

define      subsets
value       (lambda (x) (if (atom x) (' (())) ((' (lambda (y)
            (union y (product2 (car x) y)))) (subsets (cdr x))
            )))


(subsets '(1 2 3))

expression  (subsets (' (1 2 3)))
value       (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))

length (subsets '(1 2 3))

expression  (length (subsets (' (1 2 3))))
value       8

(subsets '(1 2 3 4))

expression  (subsets (' (1 2 3 4)))
value       (() (4) (3) (3 4) (2) (2 4) (2 3) (2 3 4) (1) (1 4
            ) (1 3) (1 3 4) (1 2) (1 2 4) (1 2 3) (1 2 3 4))

length (subsets '(1 2 3 4))

expression  (length (subsets (' (1 2 3 4))))
value       16

End of LISP Run

Elapsed time is 0 seconds.

```
