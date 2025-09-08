;; RUN: wasm-opt %s.wasm -ism %s.map -osm %t -o %t2
;; Running multiple times is needed here because the output is all on one line.
;; RUN: cat %t | filecheck %s --check-prefix=FILE
;; RUN: cat %t | filecheck %s --check-prefix=SOURCEROOT
;; RUN: cat %t | filecheck %s --check-prefix=CONTENT


;; This wat file is not actually part of the test (the binary file is used),
;; but no comments are allowed in JSON so the RUN and CHECK lines are here.

;; FILE: "file":"foo.wasm",
;; SOURCEROOT: "sourceRoot":"/foo/bar",
;; CONTENT: "sourcesContent":["#include <stdio.h> int main()\n{ printf(\"Gr\u00fc\u00df Gott, Welt!\"); return 0;}"]
(module)
