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

;--------------------------
(defrule isHBsAg
  =>
  (printout t "HBsAg [positive/negative]? ")
  (assert (HBsAg (read)))
)

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
  (assert (match true))
)

(defrule predCured
  (and 
    (antiHBc positive)
    (antiHBs positive)
    (HBsAg negative)
  )
  =>
  (printout t crlf "Hasil Prediksi = Cured" crlf crlf)
  (assert (match true))
)

; TOOO: add more prediction rules