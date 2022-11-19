; Tugas Besar 2 IF3170 Inteligensi Buatan
; Pembangunan Sistem Berbasis Rule dengan menggunakan CLIPS
; 13520004 - 13520050 - 13520055

; Program untuk mendiagnosis Hepatitis B

; Start Banner
(defrule start ""
  (declare (salience 10))
  =>
  (printout t "Tugas Besar 2 IF3170 Inteligensi Buatan" crlf)
  (printout t "Pembangunan Sistem Berbasis Rule dengan menggunakan CLIPS" crlf crlf)
  (printout t "Selamat datang ke program diagnosis Hepatitis B!" crlf)
  (printout t "13520004 - 13520050 - 13520055" crlf crlf)
  (printout t "Silakan menjawab pertanyaan-pertanyaan berikut." crlf)
)


; DEFINING FUNCTIONS
; To avoid redundancy in asking for user's inputs, we create a function template by using deffunction

; This function accepts two inputs: the question in particular and the allowed inputs from the user
; Note the `$` sign in front of the `allowed-inputs` variable. This is a multifield wildcard since it accepts multiple inputs

(deffunction AskQuestion (?question $?allowed-inputs) 
  (printout t ?question) ; Prints the question to the default output device (denoted by the `t`), which is the terminal in most cases
  (bind ?answer (read)) ; Asks the user for an input and binds it into a variable named `answer`
  ; lexemep is a function that checks if the argument is a string or a symbol. Returns TRUE if yes
  ; If the lexemep checks out, then set the answer to lowercase to avoid false negative by difference in upper/lower cases
  (while (not (lexemep ?answer)) do 
    (bind ?answer (read)))
  (if (lexemep ?answer)
    then (bind ?answer (lowcase ?answer)))
  ; The following code checks whether the answer is within accepted results. If yes, it returns the result. If not, it asks the question again
  (while (not (member$ ?answer ?allowed-inputs)) do 
    (printout t ?question)
    (bind ?answer (read))
    (while (not (lexemep ?answer)) do 
      (bind ?answer (read)))
    (if (lexemep ?answer)
      then (bind ?answer (lowcase ?answer))))
  ?answer
)

; Since every question asks the same thing just with different confirmation items,
; we need to create an intermediate function to list every possible input with the result (is it a POSITIVE or a NEGATIVE)
(deffunction extractResults (?question)
  ; In summary, all questions will only accepts inputs from this list:
  ; `Positive` and `+` will result in a POSITIVE assertion
  ; `Negative` and `-` will result in a NEGATIVE assertion
  (bind ?response (AskQuestion ?question positive negative + -))
  (if or (eq ?response positive) (eq ?response +)
    then positive
    else negative
  )  
)

; DEFINING RULES AND QUERIES
; Since CLIPS processes rules top-down, we must define the rules from the root of the decision tree
; Then, we divide the tree into the left branches/nodes and right branches/nodes
; Note that for every non-root node, it must contain a condition of TRUE/FALSE for it's parent
; The TRUE/FALSE condition is determined whether the node is a left child of the parent node or the right child.

; Starts from the root of the tree (is the patient's HBsAg positive or negative)
; We use the functions that we have declared from before
(defrule isHBsAg
  =>
  (assert (HBsAg (extractResults "HBsAg [positive/negative]? ")))
)

; Then we proceeds with the left sub-tree/branches and the right sub-tree/branches
(defrule isAntiHDV
  (HBsAg positive)
  =>
  (printout t "anti-HDV [positive/negative]? ")
  (assert (antiHDV (read)))
)

(defrule isAntiHBs
  (or
    (HBsAg negative)
    (and
      (antiHBc positive)
      (antiHDV negative)
      (HBsAg positive)
    )
  )
  =>
  (printout t "anti-HBs [positive/negative]? ")
  (assert (antiHBs (read)))
)

(defrule isAntiHBc
  (or
    (antiHDV negative)
    (HBsAg negative)
  )
  =>
  (printout t "anti-HBc [positive/negative]? ")
  (assert (antiHBc (read)))
)

(defrule isIgMAntiHBc
  (and
    (antiHBs negative)
    (antiHBc positive)
    (antiHDV negative)
    (HBsAg positive)
  )
  =>
  (printout t "IgM anti-HBc [positive/negative]? ")
  (assert (IgMAntiHBc (read)))
)

;--------------------------
(defrule predHepBD
  (and 
    (HBsAg positive)
    (antiHDV positive)
  )
  =>
  (printout t crlf "Hasil Prediksi = Hepatitis B+D" crlf crlf)
)

(defrule predCured
  (and 
    (antiHBc positive)
    (antiHBs positive)
    (HBsAg negative)
  )
  =>
  (printout t crlf "Hasil Prediksi = Cured" crlf crlf)
)

; TOOO: add more prediction rules