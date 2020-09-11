
(define-param sx 16) ; size of cell in X direction
(define-param sy 16) ; size of cell in Y direction
(define-param pad 4) ; padding distance between waveguide and cell edge
(define-param w 12)   ; width of waveguide
(define wvg-xcen (*  0.5 (- sx w (* 2 pad)))) ; x center of vert. wvg
(define wvg-ycen (* -0.5 (- sy w (* 2 pad)))) ; y center of horiz. wvg
(define-param fcen 0.35) ; pulse center frequency
(define-param df 0.1)    ; pulse width (in frequency)
(define-param del 0.01) ; detector delta from center

(set! geometry-lattice (make lattice (size sx sy no-size)))
(set! geometry (list
                (make block (center 0 0) (size infinity w  infinity)
                      (material (make medium (epsilon 12))))))

(set! pml-layers (list (make pml (thickness 1.0))))
(set! resolution 10)

(set! sources (list
               (make source
                 (src (make gaussian-src (frequency fcen) (fwidth df)))
                 (component Ez)
		 (amplitude 100)
		 (center (+ 1 (* -0.5 sx)) (+ 1 wvg-ycen)))
		 (make source
		 (src (make gaussian-src (frequency fcen) (fwidth df)))
		 (component Ez)
		 (amplitude 100)
		 (center (+ 1 (* -0.5 sx)) (+ (- 1) wvg-ycen)))
		 ))

(define-param nfreq 100) ; number of frequencies at which to compute flux             
(define det1 ; detector1
	(add-flux fcen df nfreq
		(make flux-region
			(center (- sx 10) (+ 0.01 wvg-ycen)) (size (/ w 8) 0))))
(define det2 ; detector1
	(add-flux fcen df nfreq
		(make flux-region
			(center (- sx 10) (+ (- 0.01) wvg-ycen)) (size (/ w 8) 0))))

(use-output-directory)
(define voldet1
	(volume (center (- sx 10) (+ del wvg-ycen)) (size (/ w 16) 0)))

(define voldet2 
	(volume (center (- sx 10) (+ (- del) wvg-ycen)) (size (/ w 16) 0)))

(define sum1 0)
(define ncount 0)
(define (myStep state) 
		(begin
				(display (electric-energy-in-box voldet1))
				(print ", ")
				(display (electric-energy-in-box voldet2))
				(print ", ")
				(display (* (electric-energy-in-box voldet1) (electric-energy-in-box voldet2)))
				(newline)
		))
				
				
;(run-until 200 (at-every 0.6 (output-png Ez "-Zc bluered")))
(run-sources myStep)
;(run-sources (output-png Ez "-Zc bluered"))

(define (average nums)
   (/ (apply + nums) (length nums)))

