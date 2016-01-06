	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr35456.c"
	.globl	not_fabs
	.type	not_fabs,@function
not_fabs:                               # @not_fabs
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.const	$push0=, 0x0p0
	f64.ge  	$push1=, $0, $pop0
	f64.neg 	$push2=, $0
	f64.select	$push3=, $pop1, $0, $pop2
	return  	$pop3
func_end0:
	.size	not_fabs, func_end0-not_fabs

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_2
	f64.const	$push0=, -0x0p0
	f64.call	$push1=, not_fabs, $pop0
	i64.reinterpret/f64	$push2=, $pop1
	i64.const	$push3=, 0
	i64.ge_s	$push4=, $pop2, $pop3
	br_if   	$pop4, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	return  	$pop5
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
