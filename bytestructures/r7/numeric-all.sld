(define-library (bytestructures r7 numeric-all)
  (import
   (scheme base)
   (scheme complex)
   (scheme eval)
   (bytestructures r7 utils)
   (bytestructures r7 base)
   (bytestructures r7 bytevectors)
   (bytestructures r7 explicit-endianness))
  (include-library-declarations "numeric.exports.sld")
  (include-library-declarations "numeric-metadata.exports.sld")
  (include "body/numeric.scm"))
