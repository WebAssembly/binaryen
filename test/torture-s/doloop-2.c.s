	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/doloop-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	copy_local	$1=, $0
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.load	$push0=, i($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, i($0), $pop2
	i32.const	$push3=, -1
	i32.add 	$1=, $1, $pop3
	i32.const	$push4=, 65535
	i32.and 	$push5=, $1, $pop4
	br_if   	$pop5, .LBB0_1
.LBB0_2:                                # %do.end
	i32.const	$1=, 0
	block   	.LBB0_4
	i32.load	$push6=, i($1)
	i32.const	$push7=, 65536
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB0_4
# BB#3:                                 # %if.end
	call    	exit@FUNCTION, $1
	unreachable
.LBB0_4:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
