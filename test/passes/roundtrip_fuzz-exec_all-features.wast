(module
 (type $A (func (result (ref null $A))))
 (func "foo" (result funcref)
  (ref.null $A)
 )
)

