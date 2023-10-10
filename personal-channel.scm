(define-module (personal-channel)
  #:use-module (gnu packages compression)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build utils)
  #:use-module (guix git-download)
  #:use-module (guix build-system font)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (nonguix build-system binary))

(define-public font-nerd-fonts
  (package
    (name "font-nerd-fonts")
    (version "2.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ryanoasis/nerd-fonts")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1la79y16k9rwcl2zsxk73c0kgdms2ma43kpjfqnq5jlbfdj0niwg"))))
    (build-system font-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'install 'make-files-writable
           (lambda _
             (for-each
              make-file-writable
              (find-files "." ".*\\.(otf|otc|ttf|ttc)$"))
             #t)))))
    (home-page "https://www.nerdfonts.com/")
    (synopsis "Iconic font aggregator, collection, and patcher")
    (description
     "Nerd Fonts patches developer targeted fonts with a high number
  of glyphs (icons).  Specifically to add a high number of extra glyphs
  from popular ‘iconic fonts’ such as Font Awesome, Devicons, Octicons,
  and others.")
    (license license:expat)))

(define-public rust-zellij-bin 
 (package
  (name "rust-zellij-bin")
  (version "0.38.2")
  (source 
    (origin
     (method url-fetch)
     (uri (string-append
            "https://github.com/zellij-org/zellij/releases/download/v" 
            version 
            "/zellij-x86_64-unknown-linux-musl.tar.gz"))
     (sha256
      (base32 "05ngkxvadxgh3wdsmj19dgq2ayh1nv5iyn3jib97a8kslzbigkvm"))))
  (build-system binary-build-system)
  (supported-systems '("x86_64-linux" "i686-linux"))
  (arguments '(
     #:install-plan '(("zellij" "bin/"))

     #:phases (modify-phases %standard-phases
		   (replace 'unpack
			  (lambda* (#:key source #:allow-other-keys)
			  	(invoke "tar" "xvf" source)
			  	#t)))))
  (home-page "https://zellij.dev")
  (synopsis "A terminal workspace with batteries included")
  (description
   "This package provides a terminal workspace with batteries included")
  (license license:expat)))
