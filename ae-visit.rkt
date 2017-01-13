#lang plai

;; BNF of arithmetic expressions:
;;
;;  <AE> ::= <num>
;;         | {+ <AE> <AE>}
;;         | {- <AE> <AE>}

;; Abstract syntax of arithmetic expressions:
(define-type AE
  [Num (n number?)]
  [Add (lhs AE?) (rhs AE?)]
  [Sub (lhs AE?) (rhs AE?)])

;; Parser for arithmetic expressions:
(define (parse-ae sexp)
  (cond
    [(number? sexp) (Num sexp)]
    [(list? sexp)
     (case (first sexp)
       [(+) (if (= (length sexp) 3)
               (Add (parse-ae (second sexp)) (parse-ae (third sexp)))
               (error "parse-ae: + needs exactly 2 arguments"))]
       [(-) (if (= (length sexp) 3)
               (Sub (parse-ae (second sexp)) (parse-ae (third sexp)))
               (error "parse-ae: - needs exactly 2 arguments"))]
       [else (error "parse-ae: I only understand + and -")])]
    [else (error "parse-ae: syntax error")]))



;; AE -> Number
;; Produce the result of interpreting the given AE
(define (interp ae)
  (type-case AE ae
    [Num (n) n]
    [Add (ae1 ae2) (+ (interp ae1) (interp ae2))]    
    [Sub (ae1 ae2) (- (interp ae1) (interp ae2))]))


;;
;; Fold: Abstraction from Templates (a la CPSC110)
;;

;; Template for ae
#;(define (fn-for-ae ae)
  (type-case AE ae
    [Num (n) (... n)]
    [Add (ae1 ae2)
         (... (fn-for-ae ae1) (fn-for-ae ae2))]
    [Sub (ae1 ae2)
         (... (fn-for-ae ae1) (fn-for-ae ae2))]))


;; (Number -> X) (X X -> X) (X X -> X) AE -> X
;; classic fold function:  TOO MANY ARGUMENTS!
(define (fold-ae0 for-num for-add for-sub ae)
  (type-case AE ae
    [Num (n) (for-num n)]
    [Add (ae1 ae2)
         (for-add (fold-ae0 for-num for-add for-sub ae1)
                  (fold-ae0 for-num for-add for-sub ae2))]
    [Sub (ae1 ae2)
         (for-sub (fold-ae0 for-num for-add for-sub ae1)
                  (fold-ae0 for-num for-add for-sub ae2))]))

;;
;; Twist 0:
;; Let's package the fold-ae combination functions into an interface
;;

(define-struct folder (num add sub)) 
;; (FolderOf X): Package the fold combination functions
;; for-num :: (FolderOf X) -> (Number -> X)
;; for-add :: (FolderOf X) -> (X X -> X)
;; for-sub :: (FolderOf X) -> (X X -> X)
(define (for-num fr) (folder-num fr))
(define (for-add fr) (folder-add fr))
(define (for-sub fr) (folder-sub fr))


;; (FolderOf X) AE -> X
;; Folder-based fold
(define (fold-ae fr ae)
  (type-case AE ae
    [Num (n) ((for-num fr) n)]
    [Add (ae1 ae2)
         ((for-add fr) (fold-ae fr ae1)
                       (fold-ae fr ae2))]
    [Sub (ae1 ae2)
         ((for-sub fr) (fold-ae fr ae1)
                       (fold-ae fr ae2))]))

;; AE -> Number
(define (interp2 ae)
  (let ([interp-for-num (λ (n) n)]
        [interp-for-add (λ (n1 n2) (+ n1 n2))]
        [interp-for-sub (λ (n1 n2) (- n1 n2))])
    (let ([interp-folder
           (make-folder interp-for-num interp-for-add interp-for-sub)])
      (fold-ae interp-folder ae))))

;; AE -> Boolean
;; This has-zero? may recur more often then the normal implementation
(define (has-zero? ae)
  (let ([hz-for-num (λ (n) (= n 0))]
        [hz-for-add (λ (b1 b2) (or b1 b2))]
        [hz-for-sub (λ (b1 b2) (or b1 b2))])
    (fold-ae (make-folder hz-for-num hz-for-add hz-for-sub) ae)))


;;
;; Twist 1:
;; Fold doesn't let us control recursion (e.g. has-zero? works too hard),
;; so move the natural recursions into the problem-specific Folder:
;;

;; (FolderOf2 X): Package the fold combination functions
;; for-num :: (FolderOf2 X) -> ((FolderOf2 X) Number -> X)
;; for-add :: (FolderOf2 X) -> ((FolderOf2 X) AE AE -> X)
;; for-sub :: (FolderOf2 X) -> ((FolderOf2 X) AE AE -> X)
;; NOTE: Reusing the folder struct and for-* functions (yay dynamic typing!)

;; (FolderOf2 X) AE -> X
;; Folder2-based fold
(define (fold2-ae fr ae)
  (type-case AE ae
    [Num (n) ((for-num fr) fr n)]
    [Add (ae1 ae2)
         ((for-add fr) fr ae1 ae2)]
    [Sub (ae1 ae2)
         ((for-sub fr) fr ae1 ae2)]))

;; AE -> Number
(define (interp3 ae)
  (let ([interp-for-num (λ (fr n) n)]
        [interp-for-add (λ (fr ae1 ae2) (+ (fold2-ae fr ae1)
                                           (fold2-ae fr ae2)))]
        [interp-for-sub (λ (fr ae1 ae2) (- (fold2-ae fr ae1)
                                           (fold2-ae fr ae2)))])
    (let ([interp-folder
           (make-folder interp-for-num interp-for-add interp-for-sub)])
      (fold2-ae interp-folder ae))))


;; The following has-zero? only recurs if it has to, thanks to
;; short-circuiting or

;; AE -> Boolean
;; Given an AE, produce true if the AE has a 0 in it somewhere
(define (has-zero2? ae)
  (let ([hz-for-num (λ (fr n) (= n 0))]
        [hz-for-add (λ (fr ae1 ae2)
                      ;; This or only recurs on ae2 if folding ae1 yields false
                      (or (fold2-ae fr ae1)  
                          (fold2-ae fr ae2)))]
        [hz-for-sub (λ (fr ae1 ae2)
                      ;; Same here
                      (or (fold2-ae fr ae1)  
                          (fold2-ae fr ae2)))])
    (fold2-ae (make-folder hz-for-num hz-for-add hz-for-sub) ae)))

;;
;; Twist2: Full Visitors!
;; Pass the entire datum to the function-specific Visitor
;;

(define-struct visitor (num add sub))
;; (VisitorOf X): Package the fold combination functions
;; visit-num :: (VisitorOf X) -> ((VisitorOf X) Num -> X)
;; visit-add :: (VisitorOf X) -> ((VisitorOf X) Add -> X)
;; visit-sub :: (VisitorOf X) -> ((VisitorOf X) Sub -> X)
(define visit-num visitor-num)
(define visit-add visitor-add)
(define visit-sub visitor-sub)

;; (VisitorOf X) AE -> X
;; "accept" is the name that the Visitor pattern uses for this generalized fold
(define (accept fr ae)
  (type-case AE ae
    [Num (n) ((visit-num fr) fr ae)]
    [Add (ae1 ae2)
         ((visit-add fr) fr ae)]
    [Sub (ae1 ae2)
         ((visit-sub fr) fr ae)]))

;; AE -> Number
(define (interp4 ae)
  (let ([interp-visit-num (λ (fr nm) (Num-n nm))]
        [interp-visit-add (λ (fr ad)
                            (+ (accept fr (Add-lhs ad))
                               (accept fr (Add-rhs ad))))]
        [interp-visit-sub (λ (fr sb)
                            (- (accept fr (Sub-lhs sb))
                               (accept fr (Sub-rhs sb))))])
    (let ([interp-visitor
           (make-visitor interp-visit-num interp-visit-add interp-visit-sub)])
      (accept interp-visitor ae))))