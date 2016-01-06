	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001017-2.c"
	.globl	fn_4parms
	.type	fn_4parms,@function
fn_4parms:                              # @fn_4parms
	.param  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	BB0_4
	i32.load	$push0=, 0($1)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB0_4
# BB#1:                                 # %lor.lhs.false
	i32.load	$push3=, 0($2)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB0_4
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push6=, 0($3)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, BB0_4
# BB#3:                                 # %if.end
	return
BB0_4:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	fn_4parms, func_end0-fn_4parms

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %fn_4parms.exit
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
