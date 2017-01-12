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

;; Fold: Abstraction from Templates (a la CPSC110)

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
        [interp-for-add +]
        [interp-for-sub -])
    (let ([interp-folder
           (make-folder interp-for-num interp-for-add interp-for-sub)])
      (fold-ae interp-folder ae))))