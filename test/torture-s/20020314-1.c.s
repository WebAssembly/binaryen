	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020314-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, f64
# BB#0:                                 # %entry
	return
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	f64, f64, f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.add 	$push0=, $0, $1
	f64.mul 	$push1=, $2, $3
	f64.mul 	$push2=, $pop0, $pop1
	f64.mul 	$push3=, $pop2, $0
	f64.add 	$push4=, $pop3, $1
	return  	$pop4
.Lfunc_end1:
	.size	g, .Lfunc_end1-g

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end8
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
