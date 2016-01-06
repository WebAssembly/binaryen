	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/vtable.ll"
	.globl	_ZN1A3fooEv
	.type	_ZN1A3fooEv,@function
_ZN1A3fooEv:
	.param  	i32
	i32.const	$push0=, 0
	i32.const	$push1=, 2
	i32.store	$discard=, g($pop0), $pop1
	return
func_end0:
	.size	_ZN1A3fooEv, func_end0-_ZN1A3fooEv

	.globl	_ZN1B3fooEv
	.type	_ZN1B3fooEv,@function
_ZN1B3fooEv:
	.param  	i32
	i32.const	$push0=, 0
	i32.const	$push1=, 4
	i32.store	$discard=, g($pop0), $pop1
	return
func_end1:
	.size	_ZN1B3fooEv, func_end1-_ZN1B3fooEv

	.globl	_ZN1C3fooEv
	.type	_ZN1C3fooEv,@function
_ZN1C3fooEv:
	.param  	i32
	i32.const	$push0=, 0
	i32.const	$push1=, 6
	i32.store	$discard=, g($pop0), $pop1
	return
func_end2:
	.size	_ZN1C3fooEv, func_end2-_ZN1C3fooEv

	.globl	_ZN1D3fooEv
	.type	_ZN1D3fooEv,@function
_ZN1D3fooEv:
	.param  	i32
	i32.const	$push0=, 0
	i32.const	$push1=, 8
	i32.store	$discard=, g($pop0), $pop1
	return
func_end3:
	.size	_ZN1D3fooEv, func_end3-_ZN1D3fooEv

	.weak	_ZN1AD0Ev
	.type	_ZN1AD0Ev,@function
_ZN1AD0Ev:
	.param  	i32
	call    	_ZdlPv, $0
	return
func_end4:
	.size	_ZN1AD0Ev, func_end4-_ZN1AD0Ev

	.weak	_ZN1BD0Ev
	.type	_ZN1BD0Ev,@function
_ZN1BD0Ev:
	.param  	i32
	call    	_ZdlPv, $0
	return
func_end5:
	.size	_ZN1BD0Ev, func_end5-_ZN1BD0Ev

	.weak	_ZN1CD0Ev
	.type	_ZN1CD0Ev,@function
_ZN1CD0Ev:
	.param  	i32
	call    	_ZdlPv, $0
	return
func_end6:
	.size	_ZN1CD0Ev, func_end6-_ZN1CD0Ev

	.weak	_ZN1AD2Ev
	.type	_ZN1AD2Ev,@function
_ZN1AD2Ev:
	.param  	i32
	.result 	i32
	return  	$0
func_end7:
	.size	_ZN1AD2Ev, func_end7-_ZN1AD2Ev

	.weak	_ZN1DD0Ev
	.type	_ZN1DD0Ev,@function
_ZN1DD0Ev:
	.param  	i32
	call    	_ZdlPv, $0
	return
func_end8:
	.size	_ZN1DD0Ev, func_end8-_ZN1DD0Ev

	.type	_ZTS1A,@object
	.section	.rodata,"a",@progbits
	.globl	_ZTS1A
_ZTS1A:
	.asciz	"1A"
	.size	_ZTS1A, 3

	.type	_ZTS1B,@object
	.globl	_ZTS1B
_ZTS1B:
	.asciz	"1B"
	.size	_ZTS1B, 3

	.type	_ZTS1C,@object
	.globl	_ZTS1C
_ZTS1C:
	.asciz	"1C"
	.size	_ZTS1C, 3

	.type	_ZTS1D,@object
	.globl	_ZTS1D
_ZTS1D:
	.asciz	"1D"
	.size	_ZTS1D, 3

	.type	_ZTV1A,@object
	.section	.data.rel.ro,"aw",@progbits
	.globl	_ZTV1A
	.align	2
_ZTV1A:
	.int32	0
	.int32	_ZTI1A
	.int32	_ZN1AD2Ev
	.int32	_ZN1AD0Ev
	.int32	_ZN1A3fooEv
	.size	_ZTV1A, 20

	.type	_ZTV1B,@object
	.globl	_ZTV1B
	.align	2
_ZTV1B:
	.int32	0
	.int32	_ZTI1B
	.int32	_ZN1AD2Ev
	.int32	_ZN1BD0Ev
	.int32	_ZN1B3fooEv
	.size	_ZTV1B, 20

	.type	_ZTV1C,@object
	.globl	_ZTV1C
	.align	2
_ZTV1C:
	.int32	0
	.int32	_ZTI1C
	.int32	_ZN1AD2Ev
	.int32	_ZN1CD0Ev
	.int32	_ZN1C3fooEv
	.size	_ZTV1C, 20

	.type	_ZTV1D,@object
	.globl	_ZTV1D
	.align	2
_ZTV1D:
	.int32	0
	.int32	_ZTI1D
	.int32	_ZN1AD2Ev
	.int32	_ZN1DD0Ev
	.int32	_ZN1D3fooEv
	.size	_ZTV1D, 20

	.type	_ZTI1A,@object
	.globl	_ZTI1A
	.align	3
_ZTI1A:
	.int32	_ZTVN10__cxxabiv117__class_type_infoE+8
	.int32	_ZTS1A
	.size	_ZTI1A, 8

	.type	_ZTI1B,@object
	.globl	_ZTI1B
	.align	3
_ZTI1B:
	.int32	_ZTVN10__cxxabiv120__si_class_type_infoE+8
	.int32	_ZTS1B
	.int32	_ZTI1A
	.size	_ZTI1B, 12

	.type	_ZTI1C,@object
	.globl	_ZTI1C
	.align	3
_ZTI1C:
	.int32	_ZTVN10__cxxabiv120__si_class_type_infoE+8
	.int32	_ZTS1C
	.int32	_ZTI1A
	.size	_ZTI1C, 12

	.type	_ZTI1D,@object
	.globl	_ZTI1D
	.align	3
_ZTI1D:
	.int32	_ZTVN10__cxxabiv120__si_class_type_infoE+8
	.int32	_ZTS1D
	.int32	_ZTI1B
	.size	_ZTI1D, 12

	.type	g,@object
	.bss
	.globl	g
	.align	2
g:
	.int32	0
	.size	g, 4


	.section	".note.GNU-stack","",@progbits
