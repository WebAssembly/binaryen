;; This test enables two features, then roundtrips through binary. We should
;; preserve the features and type names while doing so.

(module
 (type $NamedStruct (struct ))
 (type $ref?|$NamedStruct|_=>_none (func (param (ref null $NamedStruct))))
 (export "export" (func $0))
 (func $0 (param $0 (ref null $NamedStruct))
  (nop)
 )
)
