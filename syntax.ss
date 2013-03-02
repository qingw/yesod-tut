
(define name "James Bond")

(define age 50)


(define (nextInt n) 
  ( + n 1))

(define (equal? x y) ( = x y))
(define (even? x)
  (= (mod x 2)
     0))
(define even??
 (lambda (x) (= (mod x 2) 0)))

(define (fact n)
 (cond ((= n 0) 0)
       (else (* n (fact (- n 1)))))

 
(define ls (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 '()))))))
(define ls1 '(1 2 3 4 5))



(define (fromTo start end)
 (cond ((= start end) '())
       ((< start end) (cons start (fromTo (+ start 1) end)))
       ((> start end) (cons start (fromTo (- start 1) end)))))



(define fromZero
 (lambda (end) (fromTo 0 end)))
