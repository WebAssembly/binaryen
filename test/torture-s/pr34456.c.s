	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34456.c"
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end0:
	.size	debug, func_end0-debug

	.globl	bad_compare
	.type	bad_compare,@function
bad_compare:                            # @bad_compare
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $0
	return  	$pop1
func_end1:
	.size	bad_compare, func_end1-bad_compare

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, array
	i32.const	$push3=, 2
	i32.const	$push2=, 8
	i32.const	$push0=, compare
	call    	qsort, $pop1, $pop3, $pop2, $pop0
	i32.const	$0=, 0
	i32.load	$push4=, errors($0)
	i32.eq  	$push5=, $pop4, $0
	return  	$pop5
func_end2:
	.size	main, func_end2-main

	.type	compare,@function
compare:                                # @compare
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($1)
	i32.load	$2=, 4($0)
	block   	BB3_3
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, BB3_3
# BB#1:                                 # %land.lhs.true
	i32.load	$push0=, 0($0)
	i32.call_indirect	$push1=, $2, $pop0
	i32.const	$push8=, 0
	i32.eq  	$push9=, $pop1, $pop8
	br_if   	$pop9, BB3_3
# BB#2:                                 # %if.then
	i32.const	$0=, 0
	i32.load	$push2=, errors($0)
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$discard=, errors($0), $pop4
BB3_3:                                  # %if.end
	i32.call_indirect	$push5=, $2, $1
	return  	$pop5
func_end3:
	.size	compare, func_end3-compare

	.type	array,@object           # @array
	.data
	.globl	array
	.align	4
array:
	.int32	1                       # 0x1
	.int32	bad_compare
	.int32	4294967295              # 0xffffffff
	.int32	bad_compare
	.size	array, 16

	.type	errors,@object          # @errors
	.bss
	.globl	errors
	.align	2
errors:
	.int32	0                       # 0x0
	.size	errors, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
