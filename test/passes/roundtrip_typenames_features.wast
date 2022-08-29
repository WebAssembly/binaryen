;; This test enables two features, then roundtrips through binary. We should
;; preserve the features and type names while doing so.

(module
 (type $ref?|$NamedStruct|_=>_none (func (param (ref null $NamedStruct))))
 (type $NamedStruct (struct ))
 (export "export" (func $0))
 (func $0 (param $0 (ref null $NamedStruct))
  (nop)
 )
)

