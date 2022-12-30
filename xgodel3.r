LISP Interpreter Run

[godel3.l]

[Show that a formal system of complexity N]
[can't determine more than N + 9488 + 6912]
[= N + 16400 bits of Omega.]
[Formal system is a never halting lisp expression]
[that outputs lists of the form (1 0 X 0 X X X X 1 0).]
[This stands for the fractional part of Omega,]
[and means that these 0,1 bits of Omega are known.]
[X stands for an unknown bit.]

[Count number of bits in an omega that are determined.]
define (number-of-bits-determined w)
    if atom w 0
    + (number-of-bits-determined cdr w)
      if = X car w
         0
         1

define      number-of-bits-determined
value       (lambda (w) (if (atom w) 0 (+ (number-of-bits-dete
            rmined (cdr w)) (if (= X (car w)) 0 1))))

[Test it.]
(number-of-bits-determined '(X X X))

expression  (number-of-bits-determined (' (X X X)))
value       0

(number-of-bits-determined '(1 X X))

expression  (number-of-bits-determined (' (1 X X)))
value       1

(number-of-bits-determined '(1 X 0))

expression  (number-of-bits-determined (' (1 X 0)))
value       2

(number-of-bits-determined '(1 1 0))

expression  (number-of-bits-determined (' (1 1 0)))
value       3


[Merge bits of data into unknown bits of an omega.]
define (supply-missing-bits w)
    if atom w nil
    cons if = X car w
            read-bit
            car w
    (supply-missing-bits cdr w)

define      supply-missing-bits
value       (lambda (w) (if (atom w) nil (cons (if (= X (car w
            )) (read-bit) (car w)) (supply-missing-bits (cdr w
            )))))

[Test it.]
cadr try no-time-limit '
let (supply-missing-bits w)
    if atom w nil
    cons if = X car w
            read-bit
            car w
    (supply-missing-bits cdr w)
(supply-missing-bits '(0 0 X 0 0 X 0 0 X))
'(1 1 1)

expression  (car (cdr (try no-time-limit (' ((' (lambda (suppl
            y-missing-bits) (supply-missing-bits (' (0 0 X 0 0
             X 0 0 X))))) (' (lambda (w) (if (atom w) nil (con
            s (if (= X (car w)) (read-bit) (car w)) (supply-mi
            ssing-bits (cdr w)))))))) (' (1 1 1)))))
value       (0 0 1 0 0 1 0 0 1)

cadr try no-time-limit '
let (supply-missing-bits w)
    if atom w nil
    cons if = X car w
            read-bit
            car w
    (supply-missing-bits cdr w)
(supply-missing-bits '(1 1 X 1 1 X 1 1 1))
'(0 0)

expression  (car (cdr (try no-time-limit (' ((' (lambda (suppl
            y-missing-bits) (supply-missing-bits (' (1 1 X 1 1
             X 1 1 1))))) (' (lambda (w) (if (atom w) nil (con
            s (if (= X (car w)) (read-bit) (car w)) (supply-mi
            ssing-bits (cdr w)))))))) (' (0 0)))))
value       (1 1 0 1 1 0 1 1 1)


[Examine omegas in list w to see if in any one of them]
[the number of bits that are determined is greater than n.]
[Returns false to indicate not found, or what it found.]
define (examine w n)
    if atom w false
    if < n (number-of-bits-determined car w)
       car w
       (examine cdr w n)

define      examine
value       (lambda (w n) (if (atom w) false (if (< n (number-
            of-bits-determined (car w))) (car w) (examine (cdr
             w) n))))

[Test it.]
(examine '((1 1)(1 1 1)) 0)

expression  (examine (' ((1 1) (1 1 1))) 0)
value       (1 1)

(examine '((1 1)(1 1 1)) 1)

expression  (examine (' ((1 1) (1 1 1))) 1)
value       (1 1)

(examine '((1 1)(1 1 1)) 2)

expression  (examine (' ((1 1) (1 1 1))) 2)
value       (1 1 1)

(examine '((1 1)(1 1 1)) 3)

expression  (examine (' ((1 1) (1 1 1))) 3)
value       false

(examine '((1 1)(1 1 1)) 4)

expression  (examine (' ((1 1) (1 1 1))) 4)
value       false


[This is an identity function with the size-effect of]
[displaying the number of bits in a binary string.]
define (display-number-of-bits string)
    cadr cons display length string
         cons string
              nil

define      display-number-of-bits
value       (lambda (string) (car (cdr (cons (display (length
            string)) (cons string nil)))))


[This is the universal Turing machine U followed by its program.]
cadr try no-time-limit 'eval read-exp

append [Append missing bits of Omega to rest of program.]

[Display number of bits in entire program excepting the missing bits of Omega.]
(display-number-of-bits

append [Append prefix and formal axiomatic system.]

[Display number of bits in the prefix.]
(display-number-of-bits bits '

[Count number of bits in an omega that are determined.]
let (number-of-bits-determined w)
    if atom w 0
    + (number-of-bits-determined cdr w)
      if = X car w
         0
         1

[Merge bits of data into unknown bits of an omega.]
let (supply-missing-bits w)
    if atom w nil
    cons if = X car w
            read-bit
            car w
    (supply-missing-bits cdr w)

[Examine omegas in list w to see if in any one of them]
[the number of bits that are determined is greater than n.]
[Return false to indicate not found, or what it found.]
let (examine w n)
    if atom w false
[]
[   if < n (number-of-bits-determined car w)  <==== Change n to 1 here so will succeed.]
[]
    if < 1 (number-of-bits-determined car w)
       car w
       (examine cdr w n)

                              []
[Main Loop - t is time limit, fas is bits of formal axiomatic system read so far.]
let (loop t fas)              [Run formal axiomatic system again.]
 let v debug try debug t 'eval read-exp debug fas
 []
 [Look for theorem which determines more than]
 [   (c + # of bits read + size of this prefix)]
 [bits of Omega.  Here c = 9488 is the constant in the inequality]
 [   H(Omega_n) > n - c]
 [(see omega3.l and omega3.r).]
 []
 let s (examine caddr v + 9488 debug + length fas 6912)
 if s (supply-missing-bits s) [Found it! Merge in undetermined bits, output result, and halt. Contradiction!]
 if = car v success  failure  [Surprise, formal system halts, so we do too.]
 if = cadr v out-of-data  (loop t append fas cons read-bit nil)
                              [Read another bit of the formal axiomatic system.]
 if = cadr v out-of-time  (loop + t 1 fas)
                              [Increase time limit.]
 unexpected-condition         [This should never happen.]
                              []
(loop 0 nil)    [Initially, 0 time limit and no bits of formal axiomatic system read.]

) [end of prefix, start of formal axiomatic system]

[Toy formal system with only one theorem.]
bits 'display '(1 X 0)

) [end of prefix and formal axiomatic system]

'(1) [Missing bit of Omega that is needed.]

expression  (car (cdr (try no-time-limit (' (eval (read-exp)))
             (append (display-number-of-bits (append (display-
            number-of-bits (bits (' ((' (lambda (number-of-bit
            s-determined) ((' (lambda (supply-missing-bits) ((
            ' (lambda (examine) ((' (lambda (loop) (loop 0 nil
            ))) (' (lambda (t fas) ((' (lambda (v) ((' (lambda
             (s) (if s (supply-missing-bits s) (if (= (car v)
            success) failure (if (= (car (cdr v)) out-of-data)
             (loop t (append fas (cons (read-bit) nil))) (if (
            = (car (cdr v)) out-of-time) (loop (+ t 1) fas) un
            expected-condition)))))) (examine (car (cdr (cdr v
            ))) (+ 9488 (debug (+ (length fas) 6912))))))) (de
            bug (try (debug t) (' (eval (read-exp))) (debug fa
            s))))))))) (' (lambda (w n) (if (atom w) false (if
             (< 1 (number-of-bits-determined (car w))) (car w)
             (examine (cdr w) n)))))))) (' (lambda (w) (if (at
            om w) nil (cons (if (= X (car w)) (read-bit) (car
            w)) (supply-missing-bits (cdr w))))))))) (' (lambd
            a (w) (if (atom w) 0 (+ (number-of-bits-determined
             (cdr w)) (if (= X (car w)) 0 1))))))))) (bits ('
            (display (' (1 X 0))))))) (' (1))))))
display     6912
display     7088
debug       0
debug       ()
debug       (failure out-of-data ())
debug       6912
debug       0
debug       (0)
debug       (failure out-of-data ())
debug       6913
debug       0
debug       (0 0)
debug       (failure out-of-data ())
debug       6914
debug       0
debug       (0 0 1)
debug       (failure out-of-data ())
debug       6915
debug       0
debug       (0 0 1 0)
debug       (failure out-of-data ())
debug       6916
debug       0
debug       (0 0 1 0 1)
debug       (failure out-of-data ())
debug       6917
debug       0
debug       (0 0 1 0 1 0)
debug       (failure out-of-data ())
debug       6918
debug       0
debug       (0 0 1 0 1 0 0)
debug       (failure out-of-data ())
debug       6919
debug       0
debug       (0 0 1 0 1 0 0 0)
debug       (failure out-of-data ())
debug       6920
debug       0
debug       (0 0 1 0 1 0 0 0 0)
debug       (failure out-of-data ())
debug       6921
debug       0
debug       (0 0 1 0 1 0 0 0 0 1)
debug       (failure out-of-data ())
debug       6922
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1)
debug       (failure out-of-data ())
debug       6923
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0)
debug       (failure out-of-data ())
debug       6924
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0)
debug       (failure out-of-data ())
debug       6925
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1)
debug       (failure out-of-data ())
debug       6926
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0)
debug       (failure out-of-data ())
debug       6927
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0)
debug       (failure out-of-data ())
debug       6928
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0)
debug       (failure out-of-data ())
debug       6929
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1)
debug       (failure out-of-data ())
debug       6930
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1)
debug       (failure out-of-data ())
debug       6931
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0)
debug       (failure out-of-data ())
debug       6932
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1)
debug       (failure out-of-data ())
debug       6933
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0)
debug       (failure out-of-data ())
debug       6934
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0)
debug       (failure out-of-data ())
debug       6935
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1)
debug       (failure out-of-data ())
debug       6936
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
            )
debug       (failure out-of-data ())
debug       6937
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1)
debug       (failure out-of-data ())
debug       6938
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1)
debug       (failure out-of-data ())
debug       6939
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1)
debug       (failure out-of-data ())
debug       6940
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0)
debug       (failure out-of-data ())
debug       6941
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0)
debug       (failure out-of-data ())
debug       6942
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1)
debug       (failure out-of-data ())
debug       6943
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1)
debug       (failure out-of-data ())
debug       6944
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0)
debug       (failure out-of-data ())
debug       6945
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1)
debug       (failure out-of-data ())
debug       6946
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1)
debug       (failure out-of-data ())
debug       6947
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1)
debug       (failure out-of-data ())
debug       6948
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0)
debug       (failure out-of-data ())
debug       6949
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0)
debug       (failure out-of-data ())
debug       6950
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0)
debug       (failure out-of-data ())
debug       6951
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0)
debug       (failure out-of-data ())
debug       6952
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0)
debug       (failure out-of-data ())
debug       6953
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1)
debug       (failure out-of-data ())
debug       6954
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1)
debug       (failure out-of-data ())
debug       6955
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0)
debug       (failure out-of-data ())
debug       6956
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1)
debug       (failure out-of-data ())
debug       6957
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1)
debug       (failure out-of-data ())
debug       6958
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0)
debug       (failure out-of-data ())
debug       6959
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0)
debug       (failure out-of-data ())
debug       6960
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0)
debug       (failure out-of-data ())
debug       6961
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
            )
debug       (failure out-of-data ())
debug       6962
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1)
debug       (failure out-of-data ())
debug       6963
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0)
debug       (failure out-of-data ())
debug       6964
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0)
debug       (failure out-of-data ())
debug       6965
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0)
debug       (failure out-of-data ())
debug       6966
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0)
debug       (failure out-of-data ())
debug       6967
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1)
debug       (failure out-of-data ())
debug       6968
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0)
debug       (failure out-of-data ())
debug       6969
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1)
debug       (failure out-of-data ())
debug       6970
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1)
debug       (failure out-of-data ())
debug       6971
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1)
debug       (failure out-of-data ())
debug       6972
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1)
debug       (failure out-of-data ())
debug       6973
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0)
debug       (failure out-of-data ())
debug       6974
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0)
debug       (failure out-of-data ())
debug       6975
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1)
debug       (failure out-of-data ())
debug       6976
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0)
debug       (failure out-of-data ())
debug       6977
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0)
debug       (failure out-of-data ())
debug       6978
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1)
debug       (failure out-of-data ())
debug       6979
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0)
debug       (failure out-of-data ())
debug       6980
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0)
debug       (failure out-of-data ())
debug       6981
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0)
debug       (failure out-of-data ())
debug       6982
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0)
debug       (failure out-of-data ())
debug       6983
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0)
debug       (failure out-of-data ())
debug       6984
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0)
debug       (failure out-of-data ())
debug       6985
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0)
debug       (failure out-of-data ())
debug       6986
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
            )
debug       (failure out-of-data ())
debug       6987
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0)
debug       (failure out-of-data ())
debug       6988
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1)
debug       (failure out-of-data ())
debug       6989
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0)
debug       (failure out-of-data ())
debug       6990
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0)
debug       (failure out-of-data ())
debug       6991
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0)
debug       (failure out-of-data ())
debug       6992
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0)
debug       (failure out-of-data ())
debug       6993
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0)
debug       (failure out-of-data ())
debug       6994
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1)
debug       (failure out-of-data ())
debug       6995
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0)
debug       (failure out-of-data ())
debug       6996
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0)
debug       (failure out-of-data ())
debug       6997
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1)
debug       (failure out-of-data ())
debug       6998
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1)
debug       (failure out-of-data ())
debug       6999
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1)
debug       (failure out-of-data ())
debug       7000
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0)
debug       (failure out-of-data ())
debug       7001
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0)
debug       (failure out-of-data ())
debug       7002
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1)
debug       (failure out-of-data ())
debug       7003
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0)
debug       (failure out-of-data ())
debug       7004
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0)
debug       (failure out-of-data ())
debug       7005
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0)
debug       (failure out-of-data ())
debug       7006
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0)
debug       (failure out-of-data ())
debug       7007
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7008
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7009
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7010
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1)
debug       (failure out-of-data ())
debug       7011
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
            )
debug       (failure out-of-data ())
debug       7012
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1)
debug       (failure out-of-data ())
debug       7013
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0)
debug       (failure out-of-data ())
debug       7014
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0)
debug       (failure out-of-data ())
debug       7015
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0)
debug       (failure out-of-data ())
debug       7016
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0)
debug       (failure out-of-data ())
debug       7017
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7018
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1)
debug       (failure out-of-data ())
debug       7019
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1)
debug       (failure out-of-data ())
debug       7020
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0)
debug       (failure out-of-data ())
debug       7021
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0)
debug       (failure out-of-data ())
debug       7022
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0)
debug       (failure out-of-data ())
debug       7023
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1)
debug       (failure out-of-data ())
debug       7024
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0)
debug       (failure out-of-data ())
debug       7025
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0)
debug       (failure out-of-data ())
debug       7026
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1)
debug       (failure out-of-data ())
debug       7027
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0)
debug       (failure out-of-data ())
debug       7028
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0)
debug       (failure out-of-data ())
debug       7029
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0)
debug       (failure out-of-data ())
debug       7030
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0)
debug       (failure out-of-data ())
debug       7031
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7032
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7033
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1)
debug       (failure out-of-data ())
debug       7034
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0)
debug       (failure out-of-data ())
debug       7035
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1)
debug       (failure out-of-data ())
debug       7036
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
            )
debug       (failure out-of-data ())
debug       7037
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0)
debug       (failure out-of-data ())
debug       7038
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0)
debug       (failure out-of-data ())
debug       7039
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0)
debug       (failure out-of-data ())
debug       7040
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0)
debug       (failure out-of-data ())
debug       7041
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0)
debug       (failure out-of-data ())
debug       7042
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1)
debug       (failure out-of-data ())
debug       7043
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0)
debug       (failure out-of-data ())
debug       7044
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0)
debug       (failure out-of-data ())
debug       7045
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0)
debug       (failure out-of-data ())
debug       7046
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0)
debug       (failure out-of-data ())
debug       7047
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7048
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7049
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7050
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1)
debug       (failure out-of-data ())
debug       7051
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1)
debug       (failure out-of-data ())
debug       7052
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0)
debug       (failure out-of-data ())
debug       7053
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0)
debug       (failure out-of-data ())
debug       7054
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0)
debug       (failure out-of-data ())
debug       7055
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0)
debug       (failure out-of-data ())
debug       7056
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7057
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0)
debug       (failure out-of-data ())
debug       7058
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1)
debug       (failure out-of-data ())
debug       7059
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0)
debug       (failure out-of-data ())
debug       7060
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1)
debug       (failure out-of-data ())
debug       7061
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
            )
debug       (failure out-of-data ())
debug       7062
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0)
debug       (failure out-of-data ())
debug       7063
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1)
debug       (failure out-of-data ())
debug       7064
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0)
debug       (failure out-of-data ())
debug       7065
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0)
debug       (failure out-of-data ())
debug       7066
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1)
debug       (failure out-of-data ())
debug       7067
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0)
debug       (failure out-of-data ())
debug       7068
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1)
debug       (failure out-of-data ())
debug       7069
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0)
debug       (failure out-of-data ())
debug       7070
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0)
debug       (failure out-of-data ())
debug       7071
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1)
debug       (failure out-of-data ())
debug       7072
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0)
debug       (failure out-of-data ())
debug       7073
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0)
debug       (failure out-of-data ())
debug       7074
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1)
debug       (failure out-of-data ())
debug       7075
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0)
debug       (failure out-of-data ())
debug       7076
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1)
debug       (failure out-of-data ())
debug       7077
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0)
debug       (failure out-of-data ())
debug       7078
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0)
debug       (failure out-of-data ())
debug       7079
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1)
debug       (failure out-of-data ())
debug       7080
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0)
debug       (failure out-of-data ())
debug       7081
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0)
debug       (failure out-of-data ())
debug       7082
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 0)
debug       (failure out-of-data ())
debug       7083
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0)
debug       (failure out-of-data ())
debug       7084
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 1)
debug       (failure out-of-data ())
debug       7085
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 1 0)
debug       (failure out-of-data ())
debug       7086
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 1 0 1
            )
debug       (failure out-of-data ())
debug       7087
debug       0
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 1 0 1
             0)
debug       (failure out-of-time ())
debug       7088
debug       1
debug       (0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0
             1 1 1 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 1
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 1 0 1
             0)
debug       (success (1 X 0) ((1 X 0)))
debug       7088
value       (1 1 0)

End of LISP Run

Elapsed time is 1 seconds.LISP Interpreter Run

[omega3.l]

[Show that]
[   H(Omega_n) > n - 9488.]
[Omega_n is the first n bits of Omega,]
[where we choose]
[   Omega = xxx0111111...]
[instead of]
[   Omega = xxx1000000...]
[if necessary.]

[This is an identity function with the size-effect of]
[displaying the length in bits of the binary prefix.]
define (display-length-of-prefix prefix)
    cadr cons display length prefix cons prefix nil

define      display-length-of-prefix
value       (lambda (prefix) (car (cdr (cons (display (length
            prefix)) (cons prefix nil)))))


cadr try no-time-limit 'eval read-exp [Universal Turing machine U ---]

display
[--- followed by its program.]
append [Append prefix and data.]

[Code to display size of prefix in bits.]
(display-length-of-prefix bits '

[]
[Omega2.l follows.]
[]

let (count-halt prefix time bits-left-to-extend)
    if = bits-left-to-extend 0
    if = success car try time 'eval read-exp prefix
       1 0
    + (count-halt append prefix '(0) time - bits-left-to-extend 1)
      (count-halt append prefix '(1) time - bits-left-to-extend 1)

let (omega k) cons (count-halt nil k k)
              cons /
              cons ^ 2 k
                   nil

[]
[Read and execute from remainder of tape]
[a program to compute an n-bit]
[initial piece of Omega.]
[]
let w debug eval debug read-exp

[]
[Convert Omega to ratio of integers,]
[i.e., from a bit string to a rational number.]
[]
let n length w
let w debug cons base2-to-10 w
            cons /
            cons ^ 2 n
                 nil
                                     []
let (loop k)                         [Main Loop ---]
  let x debug (omega debug k)        [Compute the kth lower bound on Omega.]
  if debug (<=rat w x) (big nil k n) [Are the first n bits OK?  If not, bump k.]
     (loop + k 1)                    [If so, form the union of all output of n-bit]
                                     [programs within time k, output it, and halt.]
                                     [All n-bit programs that ever halt halt by time k.]
                                     [Thus this union is bigger than anything of complexity]
                                     [less than or equal to n!]
[                                    ]
[This total output will be bigger than each individual output,]
[and therefore must come from a program with more than n bits.]
[Therefore this program itself must be more than n bits long.]
[I.e., 9488 + H(Omega_n) > n. Q.E.D.]
[]

[Compare two rational numbers, i.e., is x= (a / b) <= y= (c / d)?]
let (<=rat x y)
    let a car debug x
    let b caddr x
    let c car debug y
    let d caddr y
    <= * a d * b c

[Union of all output of n-bit programs within time k.]
let (big prefix time bits-left-to-add)
 if = 0 bits-left-to-add
 try time 'eval read-exp prefix
 append (big append prefix '(0) time - bits-left-to-add 1)
        (big append prefix '(1) time - bits-left-to-add 1)

(loop 0)         [Start main loop running with k = 0.]

)  [end of prefix]

bits '           [Here is the data: an optimal program to compute n bits of Omega.]

'(0 0 0 0  0 0 0 1)       [n = 8! Are these really the first 8 bits of Omega?]

expression  (car (cdr (try no-time-limit (' (eval (read-exp)))
             (display (append (display-length-of-prefix (bits
            (' ((' (lambda (count-halt) ((' (lambda (omega) ((
            ' (lambda (w) ((' (lambda (n) ((' (lambda (w) (('
            (lambda (loop) ((' (lambda (<=rat) ((' (lambda (bi
            g) (loop 0))) (' (lambda (prefix time bits-left-to
            -add) (if (= 0 bits-left-to-add) (try time (' (eva
            l (read-exp))) prefix) (append (big (append prefix
             (' (0))) time (- bits-left-to-add 1)) (big (appen
            d prefix (' (1))) time (- bits-left-to-add 1))))))
            ))) (' (lambda (x y) ((' (lambda (a) ((' (lambda (
            b) ((' (lambda (c) ((' (lambda (d) (<= (* a d) (*
            b c)))) (car (cdr (cdr y)))))) (car (debug y)))))
            (car (cdr (cdr x)))))) (car (debug x)))))))) (' (l
            ambda (k) ((' (lambda (x) (if (debug (<=rat w x))
            (big nil k n) (loop (+ k 1))))) (debug (omega (deb
            ug k))))))))) (debug (cons (base2-to-10 w) (cons /
             (cons (^ 2 n) nil))))))) (length w)))) (debug (ev
            al (debug (read-exp))))))) (' (lambda (k) (cons (c
            ount-halt nil k k) (cons / (cons (^ 2 k) nil))))))
            )) (' (lambda (prefix time bits-left-to-extend) (i
            f (= bits-left-to-extend 0) (if (= success (car (t
            ry time (' (eval (read-exp))) prefix))) 1 0) (+ (c
            ount-halt (append prefix (' (0))) time (- bits-lef
            t-to-extend 1)) (count-halt (append prefix (' (1))
            ) time (- bits-left-to-extend 1)))))))))) (bits ('
             (' (0 0 0 0 0 0 0 1)))))))))
display     9488
display     (0 0 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0
             0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1
             0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 1 1 0 0 0 1 1 0 1 1 0 1 1 1 1 0 1 1 1 0
             1 0 1 0 1 1 0 1 1 1 0 0 1 1 1 0 1 0 0 0 0 1 0 1 1
             0 1 0 1 1 0 1 0 0 0 0 1 1 0 0 0 0 1 0 1 1 0 1 1 0
             0 0 1 1 1 0 1 0 0 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0
             0 0 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0
             0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1
             0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 1 1 0 1 1 1 1 0 1 1 0 1 1 0 1 0 1 1 0 0
             1 0 1 0 1 1 0 0 1 1 1 0 1 1 0 0 0 0 1 0 0 1 0 1 0
             0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 0 0
             0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0
             0 1 1 0 1 1 0 0 0 1 1 0 0 0 0 1 0 1 1 0 1 1 0 1 0
             1 1 0 0 0 1 0 0 1 1 0 0 1 0 0 0 1 1 0 0 0 0 1 0 0
             1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 1 0 1 1 1 0 0 1
             0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1
             0 0 0 0 1 1 0 1 1 0 0 0 1 1 0 0 0 0 1 0 1 1 0 1 1
             0 1 0 1 1 0 0 0 1 0 0 1 1 0 0 1 0 0 0 1 1 0 0 0 0
             1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 1 0
             0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0
             0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0
             1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1 1 0 0 0 0 1 0 1 1
             0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1 0 0 1 0 0 0 1 1 0
             0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 1 0
             1 1 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0
             0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0
             0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1 1 0 0 0 0 1
             0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1 0 0 1 0 0 0
             1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1
             1 0 1 1 0 0 0 1 1 0 1 1 1 1 0 1 1 0 1 1 1 1 0 1 1
             1 0 0 0 0 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0
             0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1 1 0 0 0
             0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1 0 0 1 0
             0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0
             0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 1 0 1 1 1 0 0 1 0 0
             1 1 0 0 0 0 1 0 1 1 1 0 1 0 0 0 0 1 0 1 0 0 1 0 0
             1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1
             0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0
             1 1 0 0 0 1 1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0
             0 1 0 0 1 1 0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0
             0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1 0 0 1 1 0 1 0 0
             1 0 1 1 0 0 1 1 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0
             0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1 1 0 1 1 1 1 0
             1 1 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0
             1 1 0 0 0 0 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1
             0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0
             0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1
             1 0 0 0 1 1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0
             1 0 0 1 1 0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0
             0 0 0 1 0 1 0 0 0 0 1 1 1 0 0 0 0 0 1 1 1 0 0 1 0
             0 1 1 0 0 1 0 1 0 1 1 0 0 1 1 0 0 1 1 0 1 0 0 1 0
             1 1 1 1 0 0 0 0 0 1 0 0 0 0 0 0 1 1 1 0 1 0 0 0 1
             1 0 1 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 1 0 1 0 0 1
             0 0 0 0 0 0 1 1 0 0 0 1 0 0 1 1 0 1 0 0 1 0 1 1 1
             0 1 0 0 0 1 1 1 0 0 1 1 0 0 1 0 1 1 0 1 0 1 1 0 1
             1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0 1 1 0 0 1 1 1 0 1
             0 0 0 0 1 0 1 1 0 1 0 1 1 1 0 1 0 0 0 1 1 0 1 1 1
             1 0 0 1 0 1 1 0 1 0 1 1 0 0 0 0 1 0 1 1 0 0 1 0 0
             0 1 1 0 0 1 0 0 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0
             0 1 0 1 0 0 0 0 1 1 0 1 0 0 1 0 1 1 0 0 1 1 0 0 0
             1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 1 1 1 0 1 0 0 1
             0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 0
             0 0 1 0 0 1 1 0 1 0 0 1 0 1 1 1 0 1 0 0 0 1 1 1 0
             0 1 1 0 0 1 0 1 1 0 1 0 1 1 0 1 1 0 0 0 1 1 0 0 1
             0 1 0 1 1 0 0 1 1 0 0 1 1 1 0 1 0 0 0 0 1 0 1 1 0
             1 0 1 1 1 0 1 0 0 0 1 1 0 1 1 1 1 0 0 1 0 1 1 0 1
             0 1 1 0 0 0 0 1 0 1 1 0 0 1 0 0 0 1 1 0 0 1 0 0 0
             0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1
             1 1 0 1 0 0 0 1 1 1 0 0 1 0 0 1 1 1 1 0 0 1 0 0 1
             0 0 0 0 0 0 1 1 1 0 1 0 0 0 1 1 0 1 0 0 1 0 1 1 0
             1 1 0 1 0 1 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1
             0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0
             0 0 0 1 1 0 0 1 0 1 0 1 1 1 0 1 1 0 0 1 1 0 0 0 0
             1 0 1 1 0 1 1 0 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0
             0 1 1 1 0 0 1 0 0 1 1 0 0 1 0 1 0 1 1 0 0 0 0 1 0
             1 1 0 0 1 0 0 0 0 1 0 1 1 0 1 0 1 1 0 0 1 0 1 0 1
             1 1 1 0 0 0 0 1 1 1 0 0 0 0 0 0 1 0 1 0 0 1 0 0 1
             0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 1 1 1
             0 0 0 0 0 1 1 1 0 0 1 0 0 1 1 0 0 1 0 1 0 1 1 0 0
             1 1 0 0 1 1 0 1 0 0 1 0 1 1 1 1 0 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 0
             1 0 1 1 1 0 0 0 0 0 1 1 1 0 0 0 0 0 1 1 0 0 1 0 1
             0 1 1 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0
             0 1 0 1 0 0 0 0 1 1 0 0 0 1 0 0 1 1 0 1 0 0 1 0 1
             1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1
             0 0 0 0 1 0 1 1 1 0 0 0 0 0 1 1 1 0 0 0 0 0 1 1 0
             0 1 0 1 0 1 1 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 1 0 0
             0 0 0 0 1 1 1 0 0 0 0 0 1 1 1 0 0 1 0 0 1 1 0 0 1
             0 1 0 1 1 0 0 1 1 0 0 1 1 0 1 0 0 1 0 1 1 1 1 0 0
             0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1
             0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 1 0 0 0 0 0
             0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0
             1 0 0 0 0 0 0 1 1 1 0 1 0 0 0 1 1 0 1 0 0 1 0 1 1
             0 1 1 0 1 0 1 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 0 1 0 1 1 0 1 0 0 1 0 0 0 0 0 0 1 1 0 0
             0 1 0 0 1 1 0 1 0 0 1 0 1 1 1 0 1 0 0 0 1 1 1 0 0
             1 1 0 0 1 0 1 1 0 1 0 1 1 0 1 1 0 0 0 1 1 0 0 1 0
             1 0 1 1 0 0 1 1 0 0 1 1 1 0 1 0 0 0 0 1 0 1 1 0 1
             0 1 1 1 0 1 0 0 0 1 1 0 1 1 1 1 0 0 1 0 1 1 0 1 0
             1 1 0 0 0 0 1 0 1 1 0 0 1 0 0 0 1 1 0 0 1 0 0 0 0
             1 0 0 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 1 0 0 1 0 0 1
             0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0
             0 0 1 0 0 1 1 0 1 0 0 1 0 1 1 0 0 1 1 1 0 0 1 0 0
             0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 0 1 0 1 1 1 0 0
             0 0 0 1 1 1 0 0 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1
             0 0 1 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 1 1 1 0 0 0 0
             0 1 1 1 0 0 1 0 0 1 1 0 0 1 0 1 0 1 1 0 0 1 1 0 0
             1 1 0 1 0 0 1 0 1 1 1 1 0 0 0 0 0 1 0 0 0 0 0 0 0
             1 0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0
             1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 1 1 1 0
             1 0 0 0 1 1 0 1 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 1
             0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 1 0
             1 0 0 1 0 0 0 0 0 0 1 1 0 0 0 1 0 0 1 1 0 1 0 0 1
             0 1 1 1 0 1 0 0 0 1 1 1 0 0 1 1 0 0 1 0 1 1 0 1 0
             1 1 0 1 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0 1 1 0 0 1
             1 1 0 1 0 0 0 0 1 0 1 1 0 1 0 1 1 1 0 1 0 0 0 1 1
             0 1 1 1 1 0 0 1 0 1 1 0 1 0 1 1 0 0 0 0 1 0 1 1 0
             0 1 0 0 0 1 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0
             0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0
             1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1
             0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0
             0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1
             0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 1 1 1 1 0 0 0 0 0 1 0 0 0 0 0 0 1 1 1 1
             0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0
             0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0
             0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1 1 0 0 0 0 1
             0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1 0 0 1 0 0 0
             1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1
             1 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0
             0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1 1 0 0
             0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1 0 0 1
             0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0
             0 0 1 1 0 0 0 1 0 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0
             0 0 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0
             0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1
             1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1
             0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 1 1 0 0 0 1 1 0 0 1 0 1 0 0 1 0 0 1 0 0
             0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1
             1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0
             0 0 1 1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0
             0 1 1 0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0
             0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 0 1 0 1 0 0 1 0 0
             1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 1 1 1 0 0 0 0 1
             1 1 1 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0
             1 0 1 0 0 0 1 0 0 0 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0
             0 0 0 0 1 1 0 0 1 0 0 0 0 1 0 1 0 0 1 0 0 1 0 0 0
             0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 0 1 0 0 0 1 0 0 0 0
             0 0 1 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 1 0 0 0 1 1
             0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0
             0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1
             1 0 0 0 1 1 0 1 1 0 0 0 0 1 0 1 1 1 0 0 1 0 0 0 1
             0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1 1 0 1 1 0
             0 1 0 0 0 1 1 1 0 0 1 0 0 0 1 0 0 0 0 0 0 0 1 0 1
             0 0 0 0 1 1 0 0 0 1 1 0 1 1 0 0 1 0 0 0 1 1 1 0 0
             1 0 0 0 1 0 0 0 0 0 0 1 1 1 1 0 0 1 0 0 1 0 1 0 0
             1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1
             0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0
             0 1 0 1 0 0 0 0 1 1 0 0 0 1 1 0 1 1 0 0 0 0 1 0 1
             1 1 0 0 1 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1
             0 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 1 1 1
             0 1 0 1 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 1 1 1 1
             0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0
             0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1 1 0 1 1 0 0 0 0 1
             0 1 1 1 0 0 1 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0
             1 1 0 0 0 1 1 0 1 1 0 0 1 0 0 0 1 1 1 0 0 1 0 0 0
             1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1 1 0 1 1
             0 0 1 0 0 0 1 1 1 0 0 1 0 0 0 1 0 0 0 0 0 0 1 1 1
             1 0 0 0 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1
             0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0
             0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1
             1 0 1 1 0 0 0 0 1 0 1 1 1 0 0 1 0 0 0 1 0 0 0 0 0
             0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 0 1 0 1 0
             1 1 0 0 0 1 0 0 1 1 1 0 1 0 1 0 1 1 0 0 1 1 1 0 0
             1 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 1 0 1 0 0 1 0 0 1
             0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0
             1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1
             0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1
             1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0
             0 0 1 1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0 1 0
             0 1 1 0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0
             0 1 0 1 0 0 0 0 1 1 0 1 0 1 1 0 0 1 0 1 0 0 1 0 0
             1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1
             0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0
             1 1 0 0 0 1 1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0
             0 1 0 0 1 1 0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0
             0 0 0 0 1 0 1 0 0 0 0 1 1 1 1 0 0 0 0 0 1 0 1 0 0
             1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 0 0 1
             0 1 1 0 0 1 1 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0
             1 1 0 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 1
             1 1 0 1 0 1 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1
             0 1 0 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 1 0 1 1 1
             0 0 1 0 0 1 1 0 0 0 0 1 0 1 1 1 0 1 0 0 0 0 1 0 0
             0 0 0 0 1 1 1 0 1 1 1 0 0 1 0 0 0 0 0 0 1 1 1 1 0
             0 0 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0
             0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1 0 0 1 1 0 1 0 0 1
             0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 1 1 0 1 1 1 0 0
             1 1 0 1 0 0 1 0 1 1 0 1 1 0 0 0 0 1 0 0 0 0 0 0 1
             1 0 1 0 1 1 0 0 1 0 0 0 0 0 0 1 1 0 1 1 1 0 0 0 1
             0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0
             1 1 0 0 0 1 1 0 1 1 1 1 0 1 1 0 1 1 1 1 0 1 1 1 0
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 0
             1 1 0 0 1 0 0 0 0 0 0 1 1 0 1 0 1 1 0 0 1 0 0 0 0
             0 0 0 1 1 0 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1
             0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0
             0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1
             1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 1 1 1 0 1 0 1 0 1 1
             0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0
             1 1 1 1 0 1 1 0 1 1 0 1 0 1 1 0 0 1 0 1 0 1 1 0 0
             1 1 1 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0
             0 0 0 1 1 0 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1
             0 0 1 1 1 0 1 0 1 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0
             0 1 1 0 1 0 1 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0
             0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0
             1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1
             0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0
             0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 1 1 1 0
             1 0 1 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0
             0 0 0 1 1 0 0 0 1 1 0 1 1 0 1 1 1 1 0 1 1 0 1 1 1
             0 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0
             0 1 1 0 0 0 1 0 0 1 1 0 0 0 0 1 0 1 1 1 0 0 1 1 0
             1 1 0 0 1 0 1 0 0 1 1 0 0 1 0 0 0 1 0 1 1 0 1 0 1
             1 1 0 1 0 0 0 1 1 0 1 1 1 1 0 0 1 0 1 1 0 1 0 0 1
             1 0 0 0 1 0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 1
             0 1 1 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1
             0 0 0 0 1 1 0 0 0 1 1 0 1 1 0 1 1 1 1 0 1 1 0 1 1
             1 0 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 1 1
             1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1 1
             0 1 1 0 1 1 1 1 0 1 1 0 1 1 1 0 0 1 1 1 0 0 1 1 0
             0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 0 1 1 1 1 0 0 0
             1 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 1 0 0 0 0 0 0 1 1
             0 1 1 1 0 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 1 1 0
             1 1 1 0 0 1 1 0 1 0 0 1 0 1 1 0 1 1 0 0 0 0 1 0 1
             0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0
             1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0
             0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 0 0 1 1 0 0 1 1 1 0
             1 1 1 0 1 0 0 0 1 1 0 1 0 0 0 0 0 1 0 0 0 0 0 0 1
             1 1 0 1 1 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1
             0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0
             1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0
             0 1 0 0 1 1 1 0 1 0 1 0 1 1 0 0 1 1 1 0 0 1 0 0 0
             0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 1 0 1 1 1 0 1 1
             0 0 1 1 0 0 0 0 1 0 1 1 0 1 1 0 0 0 0 1 0 0 0 0 0
             0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 0 1 1 0 0 1 0 1 0
             1 1 0 0 0 1 0 0 1 1 1 0 1 0 1 0 1 1 0 0 1 1 1 0 0
             1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 1 0 0 1 0 0 1 1
             0 0 1 0 1 0 1 1 0 0 0 0 1 0 1 1 0 0 1 0 0 0 0 1 0
             1 1 0 1 0 1 1 0 0 1 0 1 0 1 1 1 1 0 0 0 0 1 1 1 0
             0 0 0 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0
             1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0
             0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0
             1 1 0 1 1 0 0 0 1 1 0 0 0 0 1 0 1 1 0 1 1 0 1 0 1
             1 0 0 0 1 0 0 1 1 0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 1
             0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 0 1 1 0 0 1 0
             1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0
             0 1 1 0 1 1 0 1 1 1 1 0 1 1 0 1 1 1 0 0 1 1 1 0 0
             1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1
             1 0 1 1 0 1 1 1 1 0 1 1 1 0 1 0 1 0 1 1 0 1 1 1 0
             0 1 1 1 0 1 0 0 0 0 1 0 1 1 0 1 0 1 1 0 1 0 0 0 0
             1 1 0 0 0 0 1 0 1 1 0 1 1 0 0 0 1 1 1 0 1 0 0 0 0
             1 0 0 0 0 0 0 1 1 0 1 1 1 0 0 1 1 0 1 0 0 1 0 1 1
             0 1 1 0 0 0 0 1 0 0 0 0 0 0 1 1 0 1 0 1 1 0 0 1 0
             0 0 0 0 0 1 1 0 1 0 1 1 0 0 1 0 1 0 0 1 0 0 1 0 0
             0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1 1 0 1 1 0 1 1
             1 1 0 1 1 0 1 1 1 0 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0
             0 0 0 1 0 1 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0
             0 1 1 0 0 0 1 1 0 1 1 0 1 1 1 1 0 1 1 0 1 1 1 0 0
             1 1 1 0 0 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1
             0 1 1 1 1 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 1
             0 0 0 0 0 0 1 1 0 1 0 1 1 0 0 1 0 1 0 0 1 0 0 1 0
             0 0 0 0 0 1 1 0 1 1 1 0 0 1 1 0 1 0 0 1 0 1 1 0 1
             1 0 0 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0
             0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0
             1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0
             0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0
             0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 0 1 1 0 0 0 0 1 0 1
             1 0 1 1 0 1 0 1 1 0 0 0 1 0 0 1 1 0 0 1 0 0 0 1 1
             0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 1
             0 0 0 0 0 1 1 1 0 0 1 0 0 1 1 0 0 1 0 1 0 1 1 0 0
             1 1 0 0 1 1 0 1 0 0 1 0 1 1 1 1 0 0 0 0 0 1 0 0 0
             0 0 0 1 1 1 0 1 0 0 0 1 1 0 1 0 0 1 0 1 1 0 1 1 0
             1 0 1 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 1 1 0 0 0 1 0
             0 1 1 0 1 0 0 1 0 1 1 1 0 1 0 0 0 1 1 1 0 0 1 1 0
             0 1 0 1 1 0 1 0 1 1 0 1 1 0 0 0 1 1 0 0 1 0 1 0 1
             1 0 0 1 1 0 0 1 1 1 0 1 0 0 0 0 1 0 1 1 0 1 0 1 1
             1 0 1 0 0 0 1 1 0 1 1 1 1 0 0 1 0 1 1 0 1 0 1 1 0
             0 1 0 1 0 1 1 1 1 0 0 0 0 1 1 1 0 1 0 0 0 1 1 0 0
             1 0 1 0 1 1 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 1 0 1 0
             0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 0 0
             1 0 1 1 0 0 1 1 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0
             0 0 1 1 1 1 0 1 0 0 1 0 0 0 0 0 0 1 1 0 0 0 1 0 0
             1 1 0 1 0 0 1 0 1 1 1 0 1 0 0 0 1 1 1 0 0 1 1 0 0
             1 0 1 1 0 1 0 1 1 0 1 1 0 0 0 1 1 0 0 1 0 1 0 1 1
             0 0 1 1 0 0 1 1 1 0 1 0 0 0 0 1 0 1 1 0 1 0 1 1 1
             0 1 0 0 0 1 1 0 1 1 1 1 0 0 1 0 1 1 0 1 0 1 1 0 0
             1 0 1 0 1 1 1 1 0 0 0 0 1 1 1 0 1 0 0 0 1 1 0 0 1
             0 1 0 1 1 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 1 0 0 0 0
             0 0 0 1 1 0 0 0 0 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0
             0 0 1 0 1 0 0 0 0 1 1 0 1 0 0 1 0 1 1 0 0 1 1 0 0
             0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 1 1 1 0 1 0 0
             1 0 0 0 0 0 0 1 1 1 0 0 1 1 0 1 1 1 0 1 0 1 0 1 1
             0 0 0 1 1 0 1 1 0 0 0 1 1 0 1 1 0 0 1 0 1 0 1 1 1
             0 0 1 1 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1
             0 0 0 0 1 1 0 0 0 1 1 0 1 1 0 0 0 0 1 0 1 1 1 0 0
             1 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 1 0 1 0
             0 0 1 1 1 0 0 1 0 0 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0
             0 1 1 1 0 1 0 0 0 1 1 0 1 0 0 1 0 1 1 0 1 1 0 1 0
             1 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0
             1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1
             0 0 1 0 1 0 1 1 1 0 1 1 0 0 1 1 0 0 0 0 1 0 1 1 0
             1 1 0 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 1 0
             0 1 0 0 1 1 0 0 1 0 1 0 1 1 0 0 0 0 1 0 1 1 0 0 1
             0 0 0 0 1 0 1 1 0 1 0 1 1 0 0 1 0 1 0 1 1 1 1 0 0
             0 0 1 1 1 0 0 0 0 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1
             0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 1 1 1 0 0 0 0 0
             1 1 1 0 0 1 0 0 1 1 0 0 1 0 1 0 1 1 0 0 1 1 0 0 1
             1 0 1 0 0 1 0 1 1 1 1 0 0 0 0 0 1 0 1 0 0 1 0 0 1
             0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 1 1
             0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1
             0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 0
             1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1
             1 0 1 1 0 1 1 1 1 0 1 1 1 0 1 0 1 0 1 1 0 1 1 1 0
             0 1 1 1 0 1 0 0 0 0 1 0 1 1 0 1 0 1 1 0 1 0 0 0 0
             1 1 0 0 0 0 1 0 1 1 0 1 1 0 0 0 1 1 1 0 1 0 0 0 0
             1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 0 1 0 1 1
             1 0 0 0 0 0 1 1 1 0 0 0 0 0 1 1 0 0 1 0 1 0 1 1 0
             1 1 1 0 0 1 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 1 1 1 0
             0 0 0 0 1 1 1 0 0 1 0 0 1 1 0 0 1 0 1 0 1 1 0 0 1
             1 0 0 1 1 0 1 0 0 1 0 1 1 1 1 0 0 0 0 0 1 0 0 0 0
             0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0
             0 0 1 0 1 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0 0 1 0
             0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 1
             1 1 0 1 0 0 0 1 1 0 1 0 0 1 0 1 1 0 1 1 0 1 0 1 1
             0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0
             1 1 0 1 0 0 1 0 0 0 0 0 0 1 1 0 0 0 1 0 0 1 1 0 1
             0 0 1 0 1 1 1 0 1 0 0 0 1 1 1 0 0 1 1 0 0 1 0 1 1
             0 1 0 1 1 0 1 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0 1 1
             0 0 1 1 1 0 1 0 0 0 0 1 0 1 1 0 1 0 1 1 1 0 1 0 0
             0 1 1 0 1 1 1 1 0 0 1 0 1 1 0 1 0 1 1 0 0 1 0 1 0
             1 1 1 1 0 0 0 0 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1
             1 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1
             1 0 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0
             0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 1 1 0 1 1 0 1
             1 1 1 0 1 1 1 0 1 0 1 0 1 1 0 1 1 1 0 0 1 1 1 0 1
             0 0 0 0 1 0 1 1 0 1 0 1 1 0 1 0 0 0 0 1 1 0 0 0 0
             1 0 1 1 0 1 1 0 0 0 1 1 1 0 1 0 0 0 0 1 0 0 0 0 0
             0 0 1 0 1 0 0 0 0 1 1 0 0 0 0 1 0 1 1 1 0 0 0 0 0
             1 1 1 0 0 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 0 0 1
             1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 1 1 1 0 0 0 0 0 1 1
             1 0 0 1 0 0 1 1 0 0 1 0 1 0 1 1 0 0 1 1 0 0 1 1 0
             1 0 0 1 0 1 1 1 1 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 1
             0 0 0 0 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0
             0 0 0 0 1 1 0 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0
             1 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 1 1 1 0 1 0 0
             0 1 1 0 1 0 0 1 0 1 1 0 1 1 0 1 0 1 1 0 0 1 0 1 0
             0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 1 0 1 0 0
             1 0 0 0 0 0 0 1 1 0 0 0 1 0 0 1 1 0 1 0 0 1 0 1 1
             1 0 1 0 0 0 1 1 1 0 0 1 1 0 0 1 0 1 1 0 1 0 1 1 0
             1 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0 1 1 0 0 1 1 1 0
             1 0 0 0 0 1 0 1 1 0 1 0 1 1 1 0 1 0 0 0 1 1 0 1 1
             1 1 0 0 1 0 1 1 0 1 0 1 1 0 0 1 0 1 0 1 1 1 1 0 0
             0 0 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 0
             0 1 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 1 0
             0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0
             1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1
             0 1 0 0 1 0 0 0 0 1 0 1 0 0 0 1 0 1 0 0 0 0 0 1 0
             0 1 1 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 1 0
             0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0
             0 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0
             0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0
             0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0
             0 1 0 0 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 1 0 0 1 0 0
             1 0 1 0 0 1 0 0 0 0 1 0 1 0)
debug       (' (0 0 0 0 0 0 0 1))
debug       (0 0 0 0 0 0 0 1)
debug       (1 / 256)
debug       0
debug       (0 / 1)
debug       (1 / 256)
debug       (0 / 1)
debug       false
debug       1
debug       (0 / 2)
debug       (1 / 256)
debug       (0 / 2)
debug       false
debug       2
debug       (0 / 4)
debug       (1 / 256)
debug       (0 / 4)
debug       false
debug       3
debug       (0 / 8)
debug       (1 / 256)
debug       (0 / 8)
debug       false
debug       4
debug       (0 / 16)
debug       (1 / 256)
debug       (0 / 16)
debug       false
debug       5
debug       (0 / 32)
debug       (1 / 256)
debug       (0 / 32)
debug       false
debug       6
debug       (0 / 64)
debug       (1 / 256)
debug       (0 / 64)
debug       false
debug       7
debug       (0 / 128)
debug       (1 / 256)
debug       (0 / 128)
debug       false
debug       8
debug       (1 / 256)
debug       (1 / 256)
debug       (1 / 256)
debug       true
value       (failure out-of-data () failure out-of-data () fai
            lure out-of-data () failure out-of-data () failure
             out-of-data () failure out-of-data () failure out
            -of-data () failure out-of-data () failure out-of-
            data () failure out-of-data () success () () failu
            re out-of-data () failure out-of-data () failure o
            ut-of-data () failure out-of-data () failure out-o
            f-data () failure out-of-data () failure out-of-da
            ta () failure out-of-data () failure out-of-data (
            ) failure out-of-data () failure out-of-data () fa
            ilure out-of-data () failure out-of-data () failur
            e out-of-data () failure out-of-data () failure ou
            t-of-data () failure out-of-data () failure out-of
            -data () failure out-of-data () failure out-of-dat
            a () failure out-of-data () failure out-of-data ()
             failure out-of-data () failure out-of-data () fai
            lure out-of-data () failure out-of-data () failure
             out-of-data () failure out-of-data () failure out
            -of-data () failure out-of-data () failure out-of-
            data () failure out-of-data () failure out-of-data
             () failure out-of-data () failure out-of-data ()
            failure out-of-data () failure out-of-data () fail
            ure out-of-data () failure out-of-data () failure
            out-of-data () failure out-of-data () failure out-
            of-data () failure out-of-data () failure out-of-d
            ata () failure out-of-data () failure out-of-data
            () failure out-of-data () failure out-of-data () f
            ailure out-of-data () failure out-of-data () failu
            re out-of-data () failure out-of-data () failure o
            ut-of-data () failure out-of-data () failure out-o
            f-data () failure out-of-data () failure out-of-da
            ta () failure out-of-data () failure out-of-data (
            ) failure out-of-data () failure out-of-data () fa
            ilure out-of-data () failure out-of-data () failur
            e out-of-data () failure out-of-data () failure ou
            t-of-data () failure out-of-data () failure out-of
            -data () failure out-of-data () failure out-of-dat
            a () failure out-of-data () failure out-of-data ()
             failure out-of-data () failure out-of-data () fai
            lure out-of-data () failure out-of-data () failure
             out-of-data () failure out-of-data () failure out
            -of-data () failure out-of-data () failure out-of-
            data () failure out-of-data () failure out-of-data
             () failure out-of-data () failure out-of-data ()
            failure out-of-data () failure out-of-data () fail
            ure out-of-data () failure out-of-data () failure
            out-of-data () failure out-of-data () failure out-
            of-data () failure out-of-data () failure out-of-d
            ata () failure out-of-data () failure out-of-data
            () failure out-of-data () failure out-of-data () f
            ailure out-of-data () failure out-of-data () failu
            re out-of-data () failure out-of-data () failure o
            ut-of-data () failure out-of-data () failure out-o
            f-data () failure out-of-data () failure out-of-da
            ta () failure out-of-data () failure out-of-data (
            ) failure out-of-data () failure out-of-data () fa
            ilure out-of-data () failure out-of-data () failur
            e out-of-data () failure out-of-data () failure ou
            t-of-data () failure out-of-data () failure out-of
            -data () failure out-of-data () failure out-of-dat
            a () failure out-of-data () failure out-of-data ()
             failure out-of-data () failure out-of-data () fai
            lure out-of-data () failure out-of-data () failure
             out-of-data () failure out-of-data () failure out
            -of-data () failure out-of-data () failure out-of-
            data () failure out-of-data () failure out-of-data
             () failure out-of-data () failure out-of-data ()
            failure out-of-data () failure out-of-data () fail
            ure out-of-data () failure out-of-data () failure
            out-of-data () failure out-of-data () failure out-
            of-data () failure out-of-data () failure out-of-d
            ata () failure out-of-data () failure out-of-data
            () failure out-of-data () failure out-of-data () f
            ailure out-of-data () failure out-of-data () failu
            re out-of-data () failure out-of-data () failure o
            ut-of-data () failure out-of-data () failure out-o
            f-data () failure out-of-data () failure out-of-da
            ta () failure out-of-data () failure out-of-data (
            ) failure out-of-data () failure out-of-data () fa
            ilure out-of-data () failure out-of-data () failur
            e out-of-data () failure out-of-data () failure ou
            t-of-data () failure out-of-data () failure out-of
            -data () failure out-of-data () failure out-of-dat
            a () failure out-of-data () failure out-of-data ()
             failure out-of-data () failure out-of-data () fai
            lure out-of-data () failure out-of-data () failure
             out-of-data () failure out-of-data () failure out
            -of-data () failure out-of-data () failure out-of-
            data () failure out-of-data () failure out-of-data
             () failure out-of-data () failure out-of-data ()
            failure out-of-data () failure out-of-data () fail
            ure out-of-data () failure out-of-data () failure
            out-of-data () failure out-of-data () failure out-
            of-data () failure out-of-data () failure out-of-d
            ata () failure out-of-data () failure out-of-data
            () failure out-of-data () failure out-of-data () f
            ailure out-of-data () failure out-of-data () failu
            re out-of-data () failure out-of-data () failure o
            ut-of-data () failure out-of-data () failure out-o
            f-data () failure out-of-data () failure out-of-da
            ta () failure out-of-data () failure out-of-data (
            ) failure out-of-data () failure out-of-data () fa
            ilure out-of-data () failure out-of-data () failur
            e out-of-data () failure out-of-data () failure ou
            t-of-data () failure out-of-data () failure out-of
            -data () failure out-of-data () failure out-of-dat
            a () failure out-of-data () failure out-of-data ()
             failure out-of-data () failure out-of-data () fai
            lure out-of-data () failure out-of-data () failure
             out-of-data () failure out-of-data () failure out
            -of-data () failure out-of-data () failure out-of-
            data () failure out-of-data () failure out-of-data
             () failure out-of-data () failure out-of-data ()
            failure out-of-data () failure out-of-data () fail
            ure out-of-data () failure out-of-data () failure
            out-of-data () failure out-of-data () failure out-
            of-data () failure out-of-data () failure out-of-d
            ata () failure out-of-data ())

End of LISP Run

Elapsed time is 2 seconds.
