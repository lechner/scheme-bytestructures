;;; numeric.scm --- Numeric types as supported by (rnrs bytevectors).

;; Copyright (C) 2013 - 2015  Taylan Ulrich Bayırlı/Kammer

;; Author: Taylan Ulrich Bayırlı/Kammer <taylanbayirli@gmail.com>
;; Keywords: ffi struct bytevector bytestructure numeric

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This module defines descriptors for numeric types of specific size, and
;; native or specific endianness, as made possible by the bytevector referencing
;; and assigning procedures in the (rnrs bytevectors) module.
;;
;; If the R6RS bytevector API is supported, all the types are defined; otherwise
;; we can only define uint8.


;;; Code:

(define-syntax define-numeric-types
  (syntax-rules ()
    ((_ (name size ref-proc set-proc) ...)
     (begin
       (define name
         (make-bytestructure-descriptor
          (list bs:simple size ref-proc set-proc)))
       ...))))

(define-numeric-types
  (uint8 1 bytevector-u8-ref bytevector-u8-set!))

(cond-expand
 ((or guile
      (library (rnrs bytevectors))
      (library (r6rs bytevectors)))

  (define-numeric-types
    (float
     4 bytevector-ieee-single-native-ref bytevector-ieee-single-native-set!)
    (double
     8 bytevector-ieee-double-native-ref bytevector-ieee-double-native-set!)
    (int8   1 bytevector-s8-ref bytevector-s8-set!)
    (int16  2 bytevector-s16-native-ref bytevector-s16-native-set!)
    (uint16 2 bytevector-u16-native-ref bytevector-u16-native-set!)
    (int32  4 bytevector-s32-native-ref bytevector-s32-native-set!)
    (uint32 4 bytevector-u32-native-ref bytevector-u32-native-set!)
    (int64  8 bytevector-s64-native-ref bytevector-s64-native-set!)
    (uint64 8 bytevector-u64-native-ref bytevector-u64-native-set!))

  (define-syntax define-with-endianness
    (syntax-rules ()
      ((_ (name native-name size ref-proc set-proc endianness) ...)
       (begin
         (define name
           (if (equal? endianness native-endianness)
               native-name
               (make-bytestructure-descriptor
                (list bs:simple size
                      (lambda (bytevector index)
                        (ref-proc bytevector index endianness))
                      (lambda (bytevector index value)
                        (set-proc
                         bytevector index value endianness))))))
         ...))))

  (define-syntax define-with-endianness*
    (syntax-rules ()
      ((_ (le-name be-name native-name size ref-proc set-proc) ...)
       (begin
         (define-with-endianness
           (le-name native-name size ref-proc set-proc (endianness little))
           (be-name native-name size ref-proc set-proc (endianness big)))
         ...))))

  (define-with-endianness*
    (floatle floatbe
             float 4 bytevector-ieee-single-ref bytevector-ieee-single-set!)
    (doublele doublebe
              double 8 bytevector-ieee-double-ref bytevector-ieee-double-set!)
    (int16le  int16be  int16  2 bytevector-s16-ref bytevector-s16-set!)
    (uint16le uint16be uint16 2 bytevector-u16-ref bytevector-u16-set!)
    (int32le  int32be  int32  4 bytevector-s32-ref bytevector-s32-set!)
    (uint32le uint32be uint32 4 bytevector-u32-ref bytevector-u32-set!)
    (int64le  int64be  int64  8 bytevector-s64-ref bytevector-s64-set!)
    (uint64le uint64be uint64 8 bytevector-u64-ref bytevector-u64-set!))

  )
 (else
  ))

;;; numeric.scm ends here
