	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-3c.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, a
	i32.const	$push0=, 3
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$2=, $1, $pop1
	i32.const	$3=, 256
BB0_1:                                  # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i32.const	$push2=, 1
	i32.shr_s	$3=, $3, $pop2
	i32.const	$push3=, 2
	i32.shl 	$push4=, $3, $pop3
	i32.add 	$push5=, $1, $pop4
	i32.store	$discard=, 0($pop5), $2
	i32.const	$push6=, 4
	i32.add 	$0=, $0, $pop6
	i32.const	$push7=, 32
	i32.add 	$2=, $2, $pop7
	i32.const	$push8=, 1073741840
	i32.lt_s	$push9=, $0, $pop8
	br_if   	$pop9, BB0_1
BB0_2:                                  # %do.end
	return  	$0
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end7
	i32.const	$0=, 0
	i32.store	$discard=, a+32($0), $0
	i32.const	$push0=, a
	i32.store	$discard=, a+512($0), $pop0
	i32.const	$push1=, a+32
	i32.store	$discard=, a+256($0), $pop1
	i32.const	$push2=, a+64
	i32.store	$discard=, a+128($0), $pop2
	i32.const	$push3=, a+96
	i32.store	$discard=, a+64($0), $pop3
	call    	exit, $0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	4
a:
	.zero	1020
	.size	a, 1020


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
