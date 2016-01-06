	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090527-1.c"
	.globl	new_unit
	.type	new_unit,@function
new_unit:                               # @new_unit
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$2=, 4($0)
	i32.const	$1=, 1
	block   	BB0_2
	i32.ne  	$push0=, $2, $1
	br_if   	$pop0, BB0_2
# BB#1:                                 # %if.then
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i32.const	$push1=, 0
	i32.store	$2=, 0($pop3), $pop1
BB0_2:                                  # %if.end
	block   	BB0_4
	i32.load	$push4=, 0($0)
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, BB0_4
# BB#3:                                 # %if.then3
	i32.const	$push6=, 0
	i32.store	$discard=, 0($0), $pop6
BB0_4:                                  # %if.end5
	block   	BB0_6
	br_if   	$2, BB0_6
# BB#5:                                 # %sw.epilog
	return
BB0_6:                                  # %sw.default
	call    	abort
	unreachable
func_end0:
	.size	new_unit, func_end0-new_unit

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %new_unit.exit
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
