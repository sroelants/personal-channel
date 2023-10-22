(define-module (services kmonad)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages haskell-apps)
  #:use-module (guix gexp)
  #:export (kmonad-service))

(define (kmonad-shepherd-service config-path)
  ;; Tells shepherd how we want it to create a (single) <shepherd-service>
  ;; for kmonad from a string
  (list (shepherd-service
          (documentation "Run the kmonad daemon (kmonad-daemon).")
          (provision '(kmonad-daemon))
          (requirement '(udev user-processes))
          (start #~(make-forkexec-constructor
                     (list #$(file-append kmonad "/bin/kmonad")
                           #$config-path)))
          (stop #~(make-kill-destructor)))))

(define kmonad-service-type
  ;; Extend the shepherd root into a new type of service that takes a single
  ;; string
  (service-type
    (name 'kmonad)
    (description "The kmonad service type. Takes a config path as parameter and
                 starts up a kmonad process.")
    (extensions
      (list (service-extension shepherd-root-service-type
                               kmonad-shepherd-service)))))

(define (kmonad-service config-path)
  ;; Create a service from our service type, which takes a single parameter 
  (service kmonad-service-type config-path))
