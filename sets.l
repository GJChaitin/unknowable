[[[[[

 Elementary Set Theory in LISP (finite sets)

]]]]]

[Set membership predicate:]

define (member? e[lement] set)
   [Is set empty?]
   if atom set [then] false [else]
   [Is the element that we are looking for the first element?]
   if = e car set [then] true [else]
   [recursion step!]
   [return] (member? e cdr set)

(member? 1 '(1 2 3))
(member? 4 '(1 2 3))

[Subset predicate:]

define (subset? set1 set2)
   [Is the first set empty?]
   if atom set1 [then] true [else]
   [Is the first element of the first set in the second set?]
   if (member? car set1 set2)
      [then] [recursion!] (subset? cdr set1 set2)
      [else] false

(subset? '(1 2) '(1 2 3))
(subset? '(1 4) '(1 2 3))

[Set union:]

define (union x y)
   [Is the first set empty?]
   if atom x [then] [return] y [else]
   [Is the first element of the first set in the second set?]
   if (member? car x y)
      [then] [return] (union cdr x y)
      [else] [return] cons car x (union cdr x y)

(union '(1 2 3) '(2 3 4))

[Union of a list of sets:]

define (unionl l) if atom l nil (union car l (unionl cdr l))

(unionl '((1 2) (2 3) (3 4)))

[Set intersection:]

define (intersection x y)
   [Is the first set empty?]
   if atom x [then] [return] nil [empty set] [else]
   [Is the first element of the first set in the second set?]
   if (member? car x y)
      [then] [return] cons car x (intersection cdr x y)
      [else] [return] (intersection cdr x y)

(intersection '(1 2 3) '(2 3 4))

[Relative complement of two sets x and y = x - y:]

define (complement x y)
   [Is the first set empty?]
   if atom x [then] [return] nil [empty set] [else]
   [Is the first element of the first set in the second set?]
   if (member? car x y)
      [then] [return] (complement cdr x y)
      [else] [return] cons car x (complement cdr x y)

(complement '(1 2 3) '(2 3 4))


[Cartesian product of an element with a list:]

define (product1 e y)
   if atom y
      [then] nil
      [else] cons cons e cons car y nil (product1 e cdr y)

(product1 3 '(4 5 6))

[Cartesian product of two sets = set of ordered pairs:]

define (product x y)
   [Is the first set empty?]
   if atom x [then] [return] nil [empty set] [else]
   [return] (union (product1 car x y) (product cdr x y))

(product '(1 2 3) '(x y z))

[Product of an element with a list of sets:]

define (product2 e y)
   if atom y
      [then] nil
      [else] cons cons e car y (product2 e cdr y)

(product2 3 '((4 5) (5 6) (6 7)))

[Set of all subsets of a given set:]

define (subsets x)
   if atom x
      [then] '(()) [else]
      let y [be] (subsets cdr x) [in]
      (union y (product2 car x y))

(subsets '(1 2 3))
length (subsets '(1 2 3))
(subsets '(1 2 3 4))
length (subsets '(1 2 3 4))
