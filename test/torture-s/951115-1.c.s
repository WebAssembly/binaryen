	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/951115-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	$drop=, var($pop1), $pop0
	copy_local	$push2=, $0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	$drop=, var($pop1), $pop0
	copy_local	$push2=, $0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	$drop=, var($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	var                     # @var
	.type	var,@object
	.section	.bss.var,"aw",@nobits
	.globl	var
	.p2align	2
var:
	.int32	0                       # 0x0
	.size	var, 4


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
