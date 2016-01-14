	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950628-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store8	$discard=, 0($0), $pop0
	i32.const	$push1=, 2
	i32.store8	$discard=, 1($0), $pop1
	i32.const	$push2=, 3
	i32.store8	$discard=, 2($0), $pop2
	i32.const	$push3=, 4
	i32.store16	$discard=, 4($0), $pop3
	return
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store8	$discard=, 0($0), $pop0
	i32.const	$push1=, 2
	i32.store8	$discard=, 1($0), $pop1
	i32.const	$push2=, 3
	i32.store8	$discard=, 2($0), $pop2
	i32.const	$push3=, 4
	i32.store16	$discard=, 4($0), $pop3
	return
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
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
