	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/921124-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, f64, f64, f64
	.result 	i32
# BB#0:                                 # %entry
	return  	$0
func_end0:
	.size	f, func_end0-f

	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, f64, f64, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_5
	f64.const	$push0=, 0x1p0
	f64.ne  	$push1=, $2, $pop0
	br_if   	$pop1, BB1_5
# BB#1:                                 # %entry
	f64.const	$push2=, 0x1p1
	f64.ne  	$push3=, $3, $pop2
	br_if   	$pop3, BB1_5
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $4, $pop4
	br_if   	$pop5, BB1_5
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $5, $pop6
	br_if   	$pop7, BB1_5
# BB#4:                                 # %if.end
	return  	$4
BB1_5:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	g, func_end1-g

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %g.exit
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
